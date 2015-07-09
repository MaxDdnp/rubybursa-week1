require 'active_support/all'
require 'pry'

require_relative 'author.rb'
require_relative 'book.rb'
require_relative 'published_book.rb'
require_relative 'reader.rb'
require_relative 'reader_with_book.rb'

class LibraryManager

  attr_accessor :readers, :books, :readers_with_books

  def initialize readers = [], books = [], readers_with_books = []
    @readers = readers
    @books = books
    @reader_with_books = readers_with_books
    @statistics = {}
   # populate_statistics!
  end

  def new_book author, title, price, pages_quantity, published_at

  end

  def new_reader  name, reading_speed

  end

  def give_book_to_reader reader_name, book_title

  end

  def read_the_book reader_name, duration
      ReaderWithBook.find_reader_and_update_current_page(@readers_with_books, reader_name, duration)
  end

  def reader_notification(name)
      params = reader_notification_params(name)
      <<-TEXT
Dear #{params["name"]}!

You should return a book \"#{params["book"]}\" authored by #{params["author"]} in #{params["hours_to_deadline"]} hours.
Otherwise you will be charged \$#{params["penalty_per_hour"]} per hour.
By the way, you are on #{params["current_page"]} page now and you need #{params["reading_hours"]} hours to finish reading \"#{params["book"]}\"
TEXT
  end

  def librarian_notification
      <<-TEXT
        Hello,\n
        There are #{librarian_notification_params[:number_of_books]} published books in the library.\n
        There are #{librarian_notification_params[:number_of_readers]} readers and #{librarian_notification_params[:number_of_readers_with_book]} of them are reading the books.\n
      TEXT
    @reader_with_books.each do |r|
      puts (r.reader.name.to_s +  " is reading \"" + r.amazing_book.title + "\" - should return on " + r.return_date.strftime("%Y/%m/%d at %I:%M%p").to_s + " - " + r.time_to_finish.round(2).to_s + " hours of reading is needed to finish.")
    end 
      
  end

  def statistics_notification

  end

  private

  def reader_notification_params(name)
        a = Hash.new
         @reader_with_books.each do |r|
          if r.reader.name == name
            a.store("name", r.reader.name)
            a.store("book", r.amazing_book.title)
            a.store("author", r.amazing_book.author.name)
            a.store("hours_to_deadline", ((r.return_date.to_i - DateTime.now.to_i)/3600).round(2))
            a.store("penalty_per_hour", r.amazing_book.penalty_per_hour().round(1))
            a.store("current_page", r.current_page)
            a.store("reading_hours", r.reading_hours)
            end
          end
          a
  end

  def librarian_notification_params
      { :number_of_books => "#{@books.length}", :number_of_readers => "#{@readers.length}", :number_of_readers_with_book => "#{@reader_with_books.length}"}
  end

  def statistics_notification_params

  end

  # def populate_statistics!
  #   readers_with_books.each do |r|
  #     @statistics["readers"][r.reader.name] ||= {"pages" => 0, "books" => 0, "authors" => []}
  #     @statistics["readers"][r.reader.name]["pages"] += r.current_page
  #     @statistics["readers"][r.reader.name]["authors"] |= [r.amazing_book.author.name]
  #     @statistics["readers"][r.reader.name]["books"] += 1
  #     @statistics["book_titles"][r.amazing_book.title] ||= {
  #         "author" => "", "reding_hours" => 0, "readers" => []}
  #     @statistics["book_titles"][r.amazing_book.title]["author"] = r.amazing_book.author.name
  #     @statistics["book_titles"][r.amazing_book.title]["reading_hours"] += r.reading_hours
  #     @statistics["book_titles"][r.amazing_book.title]["readers" ] |= [r.reader.name]
  #     @statistics["authors"][r.name] ||= {"pages" => 0, "books" => 0, "authors" => 0}
  #     @statistics["authors"][r.name]["pages"] += r.current_page
  #     @statistics["authors"][r.name]["authors"] |= [r.amazing_book.author.name]
  #     @statistics["authors"][r.name]["books"] += 1
  #   end
  #   @statistics
  # end

  def statiscs_sample
    {
        "readers" => {
            "Ivan Testenko" => {
                "pages" => 1040,
                "books" => 3,
                "authors" => ["David A. Black", "Leo Tolstoy"]
            }
        },
        "book_titles" => {
            "The Well-Grounded Rubyist" => {
                "author" => "David A. Black",
                "reading_hours" => 123,
                "readers" => ["Ivan Testenko"]
            }
        },
        "authors" => {
            "Leo Tolstoy" => {
                "pages" => 123,
                "readers" => 4,
                "books" => 3
            }
        }
    }
  end

end
