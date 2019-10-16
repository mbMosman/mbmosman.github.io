Jekyll::Hooks.register :site, :post_read do |site|

  site.collections['vizmedia'].docs.each do |media|

    # Add 'last_seen' if it is not an episode of a show
    if media.data['type'] != 'episode' and media.data['view_history']
      for date in media.data['view_history']
        if date['end'] 
          media.data['last_seen'] = date['end']
          break
        end
      end
    end

    # add 'sortable_title' to downcase title for sort filter in Liquid
    media.data['sortable_title'] = media.data['title'].downcase
  end

end

