require "selenium-webdriver"
require 'dotenv/load'
require_relative 'pushover_api'


driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(timeout: 6)

# Setup
root_url = "https://vac.no-q.info/impfstation-wandsbek/checkins#/3/2021-05-"
dates = [23, 24] # May
matching_text = "An diesem Tag gibt es leider keine verfügbaren Plätze mehr."

def sleep_with_random() 
  random_number = rand(1..4)
  sleep(random_number)
end

def log(message:)
  puts "#{Time.now} #{message}"
end

# Start script

loop do 
  dates.each do |date| 
    final_url = root_url + "#{date}"
    driver.get final_url
    puts driver.current_url
    driver.navigate.refresh

    begin
     check_in_title = wait.until { driver.find_elements(class: "mb-1")[1] }
    rescue
      # When element is not found, the page wasn't loaded properly, restart.
      # Title should be always there if true/false
     next 
    end


    begin 
      element = wait.until { driver.find_elements(class: "py-3")[5] }

      if element.text == matching_text 
        log(message: "No change. :(")
        puts ""
        sleep_with_random()
        next
      end
    rescue
      # When can't find element, something changed in the box
      log(message: "Something changed. PushNotifcation sent to device")
      PushoverApi.send_push_notification(message: "Something changed! Check URL: #{driver.current_url}")
      # to stop
      name = gets.chomp
    end
  end
end



