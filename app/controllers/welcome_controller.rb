class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    @page_title = "Welcome to ChowBrowser"
  end
end
