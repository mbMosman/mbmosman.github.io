Jekyll::Hooks.register :site, :post_read do |site|

  site.collections['vizmedia'].docs.each do |media|

    if media.data['view_history']
      for date in media.data['view_history']
        if date['end'] 
          media.data['last_seen'] = date['end']
          break
        end
      end
    end
  end

end

