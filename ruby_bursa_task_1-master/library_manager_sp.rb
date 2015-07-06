require './library_manager.rb'
require 'active_support/all'
require 'pry'

describe LibraryManager do

  context '#penalty' do

    
    it 'return penalty, with expiration which happend yet' do
      twenty_days_from_now = DateTime.now.new_offset(0) - 1.hours
      price_in_cent = 1400
      pages_quantity = 100
      current_page = 50
      reading_speed = 10

      res = LibraryManager.new.penalty_to_finish(price_in_cent, twenty_days_from_now, pages_quantity, current_page, reading_speed)

      expect(res).to eq 8
    end

    it 'return penalty, without expiration, book will be returned in time ' do
      twenty_days_from_now = DateTime.now.new_offset(0) + 5.hours
      price_in_cent = 1400
      pages_quantity = 100
      current_page = 50
      reading_speed = 10

      res = LibraryManager.new.penalty_to_finish(price_in_cent, twenty_days_from_now, pages_quantity, current_page, reading_speed)

      expect(res).to eq 0
    end


  end

end
