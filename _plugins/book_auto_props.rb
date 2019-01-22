Jekyll::Hooks.register :site, :post_read do |site|

  site.collections['book'].docs.each do |book|

    if book.data['series']
      book.data['name_full'] = book.data['series']['name'] + ' #' + book.data['series']['number'].to_s
    else
      book.data['name_full'] = book.data['title']
    end

    for read in book.data['read']
      if read['end'] 
        book.data['last_read'] = read['end']
        break
      end
    end
  end

end