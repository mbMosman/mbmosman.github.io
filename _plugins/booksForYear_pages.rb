module Jekyll
  class BooksForYearPageGenerator < Generator
    safe true

    # This will, go through each book page, looking for read 'end' dates
    # using the year, it will set the `last_read` date property for each book
    # and it will add the book to a page generated for each year in which that
    # book was read. 
    def generate(site)
      yearPages = Hash.new()
      bookPages = site.collections['book'].docs
      bookPages.each do |book|

        # We only care about book with read dates
        if book.data['read']
          # Note: `read` should be an array of objects with `start` & `end` dates
          # Get only read dates with end dates set
          completions = book.data['read'].select{ |read| read['end'] }
          finishedDates = completions.map { |read| read['end'] }

          # if the book was finished at least once...
          if finishedDates.length > 0

            for endDate in finishedDates
              # get page for year finished
              year = endDate.year.to_s
              if !yearPages.has_key?(year)
                puts('creating page for ' + year)
                yearPages[year] = BookYearPage.new(site, site.source, 'books', year) 
                site.pages << yearPages[year]
              end
              page = yearPages[year]
              # Add book to page's `books` array
              page.data['books'].push(book)
            end
          end
        end
      end # do each book
    end # generate

  end # class

  # A Page subclass used in the `BooksForYearPageGenerator`
  class BookYearPage < Page
    def initialize(site, base, dir, year)
      @site = site
      @base = base
      @dir  = dir
      @name = year + ".html"
      @layout = 'books_year'
      
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "#{@layout}.html")
      self.data['title'] = "Books Read in #{year.to_s}"
      self.data['books'] = []
      self.data['year'] = year.to_i
      self.data['category'] = 'Books For Year'
      self.data['permalink'] = "#{@dir}/#{@name}"
    end # initialize
  end # class

end # module