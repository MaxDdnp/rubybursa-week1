class ReaderWithBook
  attr_accessor :amazing_book, :current_page, :reader, :return_date

  def initialize  amazing_book, reader, current_page = 0, return_date = (Time.now + 2.weeks)
    @amazing_book = amazing_book
    @reader = reader
    @return_date = return_date
    @current_page = current_page
  end

  def time_to_finish
    (amazing_book.pages_quantity - current_page) / reading_speed
  end

  def penalty
    amazing_book.penalty_per_hour * hours_overdue
  end

  def hours_overdue
    (Time.now.to_i - issue_datetime.to_time.to_i) / 3600.0
  end

  def days_to_buy
      h = 0 
      loop do
        penalty = h * (amazing_book.penalty_per_hour())
        break if penalty > amazing_book.price() 
        h += 1
      end 
      days = (h/24).to_i
  end

  def read_the_book! duration
      #что должно быть?
      reader.reading_speed = amazing_book.pages_quantity.to_i/duration.to_i
  end

  def penalty_to_finish
      timeOld = dateTimeParser(@issue_datetime)
      timeNow = dateTimeNow
      timeToFullyRead = timeNow + (@reader_with_book.time_to_finish/24.0)
      bill = 0
     if timeToRead > timeOld 
        bill = (timeToFullyRead - timeOld).to_i * 24 * centsPerHour() 
     end
      bill.to_i
  end

end
