ruleset rotten_tomatoes {

	meta {
		name "rotten_tomatoes"
		description << CS462 Lab 4 >>
		author "Dan Hogue" 
	}
	dispatch {}
	global {
		get_movie_info = function(query_string) {
			result = http:get("http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=pjysk3hyuvyurrnfprcde43z",
                    {"q": query_string});
			result.pick("$.content").decode()
		};
	}

	rule checkmyfunction {
		select when pageview url re#.*#
		pre {
			data = get_movie_info("up").pick("$.movies");
		}

		{
			notify("Top Result", data) with sticky = true;
		}

	}

}
