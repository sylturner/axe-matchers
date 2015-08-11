require_relative 'env'
require 'watir-webdriver'

Before do
  @browser = Watir::Browser.new $browser
  define_singleton_method :visit do |url|
    @browser.goto url
  end
end

After do
  @browser.close
end
