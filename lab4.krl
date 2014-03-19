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
		pick_info = function(info, query_string) {
			(info.pick(query_string) eq "") => "<i>Not available</i>" | info.pick(query_string);
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
			.main-img {margin:20px;}
			.graphite-flat-button {
			  position: relative;
			  vertical-align: top;
			  width: 80px;
			  height: 30px;
			  padding: 5;
			  font-size: 20px;
			  color:white;
			  text-align: center;
			  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.25);
			  background: #454545;
			  border: 0;
			  border-bottom: 2px solid #2f2e2e;
			  cursor: pointer;
			  -webkit-box-shadow: inset 0 -2px #2f2e2e;
			  box-shadow: inset 0 -2px #2f2e2e;
			}
			.graphite-flat-button:active {
			  top: 1px;
			  outline: none;
			  -webkit-box-shadow: none;
			  box-shadow: none;
			}
			</style>
			<link rel="stylesheet" type="text/css" href="mystyle.css">
			<div id="my_div">
	        <form id="my_form" onsubmit="return false">
	        <input type="text" name="query"/>
	        <input id="submit" type="submit" value="submit" class="graphite-flat-button">
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
			profile = pick_info(info, "$..profile");
			title = pick_info(info, "$.title");
			release_year = pick_info(info, "$.year");
			rating = pick_info(info, "$.mpaa_rating");
			synopsis = pick_info(info, "$.synopsis");
			critics_rating = pick_info(info, "$..critics_rating");
			consensus = pick_info(info, "$.critics_consensus");
			new_html = "
				<h2>Top Result: <i>"+title+"</i></h2>
				<img class=\"main-img\" src=\"" + profile + "\"></img>  
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
