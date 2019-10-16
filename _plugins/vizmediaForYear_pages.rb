module Jekyll
  class VizmeiaForYearPageGenerator < Generator
    safe true

    # This will, go through vizmedia pages, looking for view_history 'end' dates
    # using the year, it will add the vizmedia item to a page generated for each 
    # year in which that item was watched. 
    def generate(site)
      yearPages = Hash.new()
      pages = site.collections['vizmedia'].docs
      pages.each do |item|

        # We only care about ones with view_history
        if item.data['view_history'] && item.data['type'] != 'episode'
          # Note: `view_history` should be an array of objects with `start` & `end` dates
          # Get only the ones dates with end dates set
          completions = item.data['view_history'].select{ |history| history['end'] }
          finishedDates = completions.map { |history| history['end'] }

          # if the item was finished at least once...
          if finishedDates.length > 0

            lastYear = ''
            for endDate in finishedDates
              # get page for year finished
              year = endDate.year.to_s
              if year != lastYear
                if !yearPages.has_key?(year)
                  puts('creating VizMedia page for ' + year)
                  yearPages[year] = VizmediaYearPage.new(site, site.source, File.join('vizmedia', year), year) 
                  site.pages << yearPages[year]
                end
                page = yearPages[year]
                # Add item to page's `vizmedia` array
                page.data['vizmedia'].push(item)

                for tag in item.data['tags']
                  if tag == year + '-favorite'
                    page.data['favorites'].push(item)
                  end
                end
              end
              lastYear = year
            end
          end
        end
      end # do each item
    end # generate

  end # class

  # A Page subclass used in the `VizmediaForYearPageGenerator`
  class VizmediaYearPage < Page
    def initialize(site, base, dir, year)
      @site = site
      @base = base
      @dir  = dir
      @name = "index.html"
      @layout = 'vizmedia_year'
      
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "#{@layout}.html")
      self.data['title'] = "Watched in #{year.to_s}"
      self.data['vizmedia'] = []
      self.data['favorites'] = []
      self.data['year'] = year.to_i
      self.data['category'] = 'Vizmedia For Year'
    end # initialize
  end # class

end # module