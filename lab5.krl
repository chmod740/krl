ruleset lab5 {

	meta {
		name "lab5"
		description << CS462 Lab 5 >>
		author "Dan Hogue" 
		use module a169x701 alias CloudRain
    	use module a41x186  alias SquareTag
	}
	dispatch {}
	global {

	}

	rule set_up {
    	select when web cloudAppSelected
    	pre {
    		data = ent:checkin_data;
      		my_html = << 
			<style>
			p, h2 {
				margin-left:20px;
				color:black;
			}
			</style>
	     	<div id="my_div"><p>What up?</p></div> 
	      >>;
    	}

    	{
      		SquareTag:inject_styling();
      		CloudRain:createLoadPanel("Lab5", {}, my_html);
      		replace_inner("#my_div", "" + data);
    	}
  	}

    rule process_fs_checkin {
    	select when foursquare checkin
    	pre {
    		//venue_name, city, shout, and createdAt
    		//data = event:attr("checkin").decode();
    		//createdAt = data.pick("$.createdAt");
    		//venue = data.pick("$.venue");
    		//venue_name = venue.pick("$.name");
    		//city = data.pick("$..city");
    		//shout = data.pick("$.shout");
    		//checkin_data = createdAt + "<BR>" + venue_name + "<BR>" + city + "<BR>";
    	}
    	fired {
        	set ent:checkin_data "hello";//checkin_data;
        }
	}

}
