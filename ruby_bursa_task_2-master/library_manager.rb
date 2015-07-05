require 'active_support/all'
require 'pry'

require './author.rb'
require './book.rb'
require './published_book.rb'
require './reader.rb'
require './reader_with_book.rb'

class LibraryManager

  attr_accessor :reader_with_book, :issue_datetime

  def initialize reader_with_book, issue_datetime
    @reader_with_book = reader_with_book
    @issue_datetime = issue_datetime
  end

  def dateTimeParser(dateTimeVal)
      parsedDateTime = DateTime.parse(dateTimeVal).new_offset(0)
  end

  def dateTimeNow
      DateTime.now.new_offset(0)
  end

  def price
    price = @reader_with_book.book.price.to_f
  end

  def publishedAt
      publishedAt = @reader_with_book.book.published_at.to_i
  end

  def pagesQuantity
      pagesQuantity = @reader_with_book.book.pages_quantity.to_i
  end

  def centsPerHour
      centsPerHour = price() * publishedAt() * 0.00007 + price() * pagesQuantity() * 0.000003 + price() * 0.0005
  end

  def penalty
      timeOld = dateTimeParser(self.issue_datetime)
      timeNow = dateTimeNow
      expired = (timeNow - timeOld).to_i * 24
      penalty = (expired * (centsPerHour())).to_i
  end

  def could_meet_each_other? first_author, second_author
     first_author.can_meet? second_author
  end

  def days_to_buy
      h = 0 
      loop do
        penalty = h * (centsPerHour())
        h += 1
        break if penalty > price() 
      end 
      days = (h/24).to_i
  end

  def transliterate author
      finChar = Array.new()
      i = 0
      letters = { "а" => "a", "б" => "b", "в" => "v", "г" => "h", "ґ" => "g", "д" => "d", "е" => "e","є" => "ie", "ж" => "zh",
      "з" => "z", "и" => "y", "і" => "i", "ї" => "i", "й" => "i", "к" => "k", "л" => "l", "м" => "m", "н" => "n",
      "о" => "o", "п" => "p", "р" => "r", "с" => "s", "т" => "t", "у" => "u", "ф" => "f", "х" => "h", "ц" => "ts",
      "ч" => "ch", "ш" => "sh", "щ" => "shch", "ю" => "iu", "я" => "ia", "\s" => "\s", "А" => "A", "Б" => "B", "В" => "V", "Г" => "H", "Ґ" => "G", "Д" => "D", "Е" => "E","Є" => "Ye", "Ж" => "Zh",
      "З" => "Z", "И" => "Y", "І" => "I", "Ї" => "Yi", "Й" => "Y", "К" => "K", "Л" => "L", "М" => "M", "Н" => "N",
      "О" => "O", "П" => "P", "Р" => "R", "С" => "S", "Т" => "T", "У" => "U", "Ф" => "F", "Х" => "H", "Ц" => "Ts",
      "Ч" => "Ch", "Ш" => "Sh", "Щ" => "Shch", "Ю" => "Yu", "Я" => "Ya"} 
      lettersArray = author.name.chars.to_a
      lettersArray.each{|char| finChar[i] = letters[char] 
      i +=1}
      finChar.join
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

  def email_notification_params
      {
        name:    "#{@reader_with_book.name}",
        book:    "#{@reader_with_book.book.title}",
        author:  "#{@reader_with_book.book.author}",
        penalty_per_hour:  "#{centsPerHour()}",
        penalty:           "#{penalty()}",
        hours_to_deadline: "#{(self.dateTimeParser(issue_datetime) - self.dateTimeNow).round * 24}"
      }
  end

  def email_notification
    <<-TEXT
      Hello, #{email_notification_params[:name]}!\n
      #{ if email_notification_params[:hours_to_deadline].to_i <= 0
            "You must return the book \"#{email_notification_params[:book]}\" authored by #{email_notification_params[:author]} as soon as possible!\n
      You already owe the library $#{sprintf('%.2f', email_notification_params[:penalty].to_f / 100.0)} (¢#{email_notification_params[:penalty]}) and you are charged ¢#{email_notification_params[:penalty_per_hour]} every hour.\n
      Your overdue for the moment is #{-email_notification_params[:hours_to_deadline].to_i} hours."
         else 
            "You should return the book \"#{email_notification_params[:book]}\" authored by #{email_notification_params[:author]} in #{email_notification_params[:hours_to_deadline]} hours.\n
      Otherwise you will be charged ¢#{email_notification_params[:penalty_per_hour]} per hour."
         end
      }
    TEXT
  end

end
