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
			data = result.pick("$.content").decode();
			movies = data.pick("$.movies");
			movies[0]
		};
	}

	rule set_up {
    	select when web cloudAppSelected
    	pre {
      		my_html = << 
			<style>
			p, h2, form {
				margin-left:20px;
				color:black;
			}
			img {margin:20px;}
			</style>
			<link rel="stylesheet" type="text/css" href="mystyle.css">
			<div id="my_div">
	        <form id="my_form" onsubmit="return false">
	        <input type="text" name="query"/>
	        <input id="submit" type="submit" value="submit">
	        </form>
	      	</div>
	     	<div id="my_other_div"><p>What up? How about searching for a movie?</p></div> 
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
        	info = get_movie_info(event:attr("query"));
			thumbnail = "http://content7.flixster.com/movie/10/89/43/10894361_pro.jpg";
			title = info.pick("$.title");
			release_year = info.pick("$.year");
			rating = "Not yet";
			synopsys = info.pick("$.synopsis");
			critics_rating = "Not yet...";
			consensus = info.pick("$.critics_consensus");

			new_html = "
				<h2>Top Result: Up</h2>
				<img src=\"" + thumbnail + "\"></img>  
				<p><b>Release Year: </b>"+release_year+" <b>Rating: </b>"+rating+"</p>
				<p><b>Critics Rating: </b>"+critics_rating+"</p>
				<p><b>Critics Consensus: </b>"+consensus+"</p> 
				<p><b>Synopsis: </b>"+synopsis+"<p>
			"
      	}

      	{
      		replace_inner("#my_other_div", "" + new_html);
      	}
    }


}
