module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, ("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  def to_ampm(hr, min)
    if hr < 12
      if hr == 0
        hr = 12
      else
        hr = hr
      end
      ampm = "am"
    else
      if hr == 12
        hr = hr
      else
        hr = hr - 12
      end
      ampm = "pm"
    end
    formatted_time = "#{hr}:#{'%02d' % min}#{ampm}"
    return formatted_time
  end

=begin
  def to_military_time(hr, min)
    return "#{'%02d' % hr}#{'%02d' % min}"
  end
=end

  def days_array
    [
      ["sun", 0],
      ["mon", 1],
      ["tue", 2],
      ["wed", 3],
      ["thu", 4],
      ["fri", 5],
      ["sat", 6]
    ].freeze
  end

  def month_hash
    {
      1 => "Jan",
      2 => "Feb",
      3 => "Mar",
      4 => "Apr",
      5 => "May",
      6 => "Jun",
      7 => "Jul",
      8 => "Aug",
      9 => "Sep",
      10 => "Oct",
      11 => "Nov",
      12 => "Dec",
    }.freeze
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
=begin
  def broadcast(channel, status)
    message = {:channel => channel, :data => status, :ext => {:auth_token => FAYE_TOKEN}}
    #message = {:channel => channel, :data => status}
    uri = URI.parse("#{FAYE_BASE_URL}/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
=end
=begin
  def google_analytics_js
    content_tag(:script, :type => 'text/javascript') do
      "var _gaq = _gaq || [];_gaq.push([\"_setAccount\", \"UA-8850748-2\"]);_gaq.push([\"_setDomainName\", \"chowbrowser.com\"]);_gaq.push([\"_trackPageview\"]);(function() {var ga = document.createElement(\"script\");ga.type = \"text/javascript\";ga.async = true;ga.src = (\"https:\" == document.location.protocol ? \"https://ssl\" : \"http://www\") + \".google-analytics.com/ga.js\";var s = document.getElementsByTagName(\"script\")[0];s.parentNode.insertBefore(ga, s);})();"
    end if Rails.env.production?
  end
=end
end
