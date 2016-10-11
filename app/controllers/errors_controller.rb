class ErrorsController < ApplicationController
  skip_before_filter :authenticate_user!

  def four_zero_four
    @page_title = "The page you were looking for doesn't exist (404)"
  end

  def four_two_two
    @page_title = "The change you wanted was rejected (422)"
  end

  def five_zero_zero
    @page_title = "We're sorry, but something went wrong (500)"
  end
end
