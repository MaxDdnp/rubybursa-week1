module Library
    class PublishedBook < Book
      attr_accessor :price, :pages_quantity, :published_at, :comments_counter
      @@comments_counter = 0
      @comments = []
      def initialize author, title, price, pages_quantity, published_at
        @price = price
        @pages_quantity = pages_quantity
        @published_at = published_at
        super author, title
      end

      def self.comments_quantity
        comments_counter
      end

      def add_comment(comment)
        comments << comment
        Library::PublishedBook.comments_counter+=1
        Library::Commentable.total_comments_counter+=1
      end

      def comments
        comments
      end

      def age
        age = Time.now.year - published_at + 1
      end

      def penalty_per_hour
        price_penalty = price * 0.0005
        pages_penalty = 0.000003 * price * pages_quantity
        age_penalty = 0.00007 * price * age

        price_penalty + pages_penalty + age_penalty
      end

    end
end
