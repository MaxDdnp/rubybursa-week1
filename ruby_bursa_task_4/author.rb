module Library
	class Author
  		attr_accessor :year_of_birth, :year_of_death, :name, :comments_counter
     	 @@comments_counter = 0
     	 @comments = []
  		def initialize year_of_birth, year_of_death, name
    		@year_of_birth = year_of_birth
    		@year_of_death = year_of_death
    		@name = name
  		end

  		def self.comments_quantity
  			comments_counter
  		end

  		def add_comment(comment)
        	comments << comment
        	Library::Author.comments_counter+=1
        	Library::Commentable.total_comments_counter+=1
     	 end

     	 def comments
        	comments
     	 end

	end
end
