ruleset rotten_tomatoes {

	meta {
		name "rotten_tomatoes"
		description << CS462 Lab 4 >>
		author "Dan Hogue" 
		use module a169x701 alias CloudRain
    	use module a41x186  alias SquareTag
	}
	dispatch {}
	global {
		get_movie_info = function(query_string) {
			result = http:get("http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=pjysk3hyuvyurrnfprcde43z",
                    {"q": query_string});
			result.pick("$.content").decode()
		};
	}

	rule set_up {
    	select when web cloudAppSelected
    	pre {
      		my_html = << <div id="my_div">
				         <form id="my_form" onsubmit="return false">
				         <input type="text" name="query"/>
				         <input id="submit" type="submit" value="submit">
				         </form>
				      	 </div>
				     	 <div id="my_other_div">What up? How about searching for a movie?</div> 
				      >>;
    	}

    	{
      		SquareTag:inject_styling();
      		CloudRain:createLoadPanel("Movie lookup...", {}, my_html);
      		watch("#my_form", "submit");
    	}
  	}

    rule clicked_submit {
    	select when web submit "#my_form"
      	pre {
        	query_string = event:attr("query");
        	data = get_movie_info(query_string);
			movies = data.pick("$.movies");
			movie = movies[0];
			thumbnail = "thumbnail";
			title = movie.pick("$.title");
			release_year = "release_year";
			synopsys = "synopsys";
			ratings = "ratings";
			other_data = "other_data";
      	}

      	{
      		replace_inner("#my_other_div", "Title: " + title );
      	}
    }


}
