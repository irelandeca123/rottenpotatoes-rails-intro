class Movie < ActiveRecord::Base
    #Defining as class method(Self Ratings), Using distinct method taking each rating , pushing each element to array. 
    def self.ratings
        Movie.select(:rating).distinct.inject([]) { |a, m| a.push m.rating }
    end
 
end
