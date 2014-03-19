ruleset examine_location {

	meta {
        //b505182x6
		name "examine_location"
		description << CS462 Lab 6 >>
		author "Dan Hogue" 
        use module a169x701 alias CloudRain
        use module a41x186  alias SquareTag
        use module b505182x5 alias location_data
	}
	dispatch {}
	global {

	}

    rule set_up {
        select when web cloudAppSelected
        pre {
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
            CloudRain:createLoadPanel("Lab6", {}, my_html);
        }
    }

    rule show_fs_location {
        select when web cloudAppSelected
        pre {
            data = location_data:get_location_data("fs_checkin");
            createdAt = data.pick("$.createdAt");
            venue = data.pick("$.venue");
            venue_name = venue.pick("$.name");
            city = data.pick("$.city");
            shout = data.pick("$.shout");
            checkin_data = "Created At: " + createdAt + "<BR>Venue Name: " + venue_name + "<BR> City: " + city + "<BR> Shout: " + shout;
        }
        replace_inner("#my_div", "" + checkin_data );
    }

}