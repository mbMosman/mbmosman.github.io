Jekyll::Hooks.register :site, :post_read do |site|

  site.collections['book'].docs.each do |book|

    # Set name_full
    if book.data['series']
      book.data['name_full'] = book.data['series']['name'] + ' #' + book.data['series']['number'].to_s
    else
      book.data['name_full'] = book.data['title']
    end

    # Set last_read
    if book.data['read']
      # Note: `read` should be an array of objects with `start` & `end` dates
      # Get only read dates with end dates set
      completions = book.data['read'].select{ |read| read['end'] }
      finishedDates = completions.map { |read| read['end'] }

      # if the book was finished at least once...
      if finishedDates.length > 0

        # Set the `last_read` property to the last date read
        sortedDates = finishedDates.sort
        book.data['last_read'] = sortedDates.last
      end
    end
  end

end