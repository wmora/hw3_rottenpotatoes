# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create! :title => movie['title'], :rating => movie['rating'], :release_date => movie['release_date']
  end

end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(', ')

  ratings.each do |rating|
    field = "ratings_#{rating}"
    if uncheck
      uncheck(field)
    else
      check(field)
    end
  end

end

When /I (un)?check all ratings/ do |uncheck|

  ratings = Movie.all_ratings
  ratings.each do |rating|
    field = "ratings_#{rating}"
    if uncheck
      uncheck(field)
    else
      check(field)
    end
  end

end

Then /I should( not)? see movies with ratings: (.*)/ do |no, rating_list|

  ratings = rating_list.split(', ')
  ratings = Movie.all_ratings - ratings if no
  filtered_movies_count = page.all('table#movies tbody tr').count
  db_count = Movie.all({:conditions => {:rating => ratings}}).size
  assert_equal filtered_movies_count, db_count

end

Then /I should not see any movies/ do

  assert_equal 0, page.all('table#movies tbody tr').count

end

Then /I should see all movies/ do

  filtered_movies_count = page.all('table#movies tbody tr').count
  db_count = Movie.all.size
  assert_equal filtered_movies_count, db_count

end