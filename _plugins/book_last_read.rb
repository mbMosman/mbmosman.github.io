Jekyll::Hooks.register :site, :post_read do |site|

  site.collections['book'].docs.each do |book|
    for read in book.data['read']
      if read['end'] 
        book.data['last_read'] = read['end']
        break
      end
    end
  end

end