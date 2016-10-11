class Public::DeliveryAddressesController < PublicController
  load_and_authorize_resource

  def show
    @delivery_address = DeliveryAddress.select("address, city, zip").
      find(params[:id])
    #@cart.update_attribute(:delivery_address_id, params[:id])

    respond_to do |format|
      format.json { render json: @delivery_address }
    end
  end

  def distance
    @address = "#{params[:address]}, Lubbock, TX"
    @uri = URI('https://maps.googleapis.com/maps/api/distancematrix/json')
    @uri_params = {
      :sensor => false, :origins => params[:lat_lon],
      :destinations => "33.5485,-101.913|#{@address}", :mode => "driving",
      :units => "imperial", :callback => "?"
    }
    @uri.query = URI.encode_www_form(@uri_params)
# Get the google maps distance matrix api ####################################
    @google_distance_matrix = Net::HTTP.start(@uri.host, use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
        http.get @uri.request_uri
      end
    case @google_distance_matrix
      when Net::HTTPRedirection
# repeat the request using response['Location'] ##############################
      when Net::HTTPSuccess
        @google_distance_matrix = JSON.parse(@google_distance_matrix.body)
      else
# response code isn't a 200; raise an exception ##############################
        pp @google_distance_matrix.error!
      end

    @duplicate_address = DeliveryAddress.select("MAX(id) as id, address").
      group("address, id").where(:address => params[:address]).last

    if @duplicate_address
      @cart.update_attribute(:delivery_address_id, @duplicate_address.id)
    else
      @cart.update_attribute(:delivery_address_id, nil)
    end

    respond_to do |format|
      format.json { render json: @google_distance_matrix }
    end
  end

  def update_distance
    @cart.update_attributes({
      :delivery_distance => params[:delivery_distance],
      :delivery_duration => params[:delivery_duration]
    })
    respond_to do |format|
      format.json { render json: @cart }
    end
  end
end
