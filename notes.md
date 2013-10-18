Group Agreements
Kanban
Stand-up  2-3 times/day
Good git-hub practices
pushing to Heroku
TDD

### Friday, Oct 18, matt's suggestions:

fairly raw:

document
html
    head
        json/ajax - get origional
        json/ajax - get changes
        js - build  page from origional, body = $(origional);
        js - modify it with changes
        js - someone/somewhere make it accessable for the user to add/delete chages
        wikipedia's head files
        js - would load our changes via current_user.chages.on.this.page
           - then it would
        css
    /head
    body
        wikipedia's body
    /body
/html

  back end should
  

  front end should

  full respons
  need a page that has capacity to load a wikipedai page and modify it
   both with new stuff and old stuff
  also this page should be able to accept new changes
  
  some raw code: 
  
  ```ruby
    def wiki
       current_user.changes_for(params[:page])
    uri = URI.parse("http://en.wikipedia.org/wiki/#{params[:page]}")

    content = Net::HTTP.get_response(uri).body
    content.force_encoding("UTF-8")

    data = { content: content }
    render json: content
  end
  ```

### Thurs, Oct 17

Questions
- balance between
  - “canned” changes
  - dynamic
  - consider how much user set up VS “click”
- media choices = restrict to: ?
  - wikipedia
  - IMDB
  - wolframalpha
- google results
- any page

- replace text with using jquery
http://stackoverflow.com/questions/4886319/replace-text-in-html-page-with-jquery

Roadblocks → JSONP and CORS to enable cross-origin-resource-sharing for ajax/jquery to display a website other than the original URL
- http://www.youtube.com/watch?v=vTCgJo4phso
- http://anyorigin.com/



  
  
  
  
  

  
