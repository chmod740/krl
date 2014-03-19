ruleset lab7_1 {

	meta {
        //b505182x7
		name "lab7_1"
		description << CS462 Lab >>
		author "Dan Hogue" 
        use module b505182x5 alias location_data
        use module a169x701 alias CloudRain
        use module a41x186  alias SquareTag
        //https://cs.kobj.net/sky/event/4642ECDC-AFA0-11E3-A914-CE78D61CF0AC/1/location/new_current?_rids=b505182x7&lat=0&lang=0
	}
	dispatch {}
	global {}

    rule nearby {
        select when location new_current
        pre {
            lat = event:attr("lat");
            lang = event:attr("lang");
        }
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
            CloudRain:createLoadPanel("Lab7", {}, my_html);
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
            lat = data.pick("$.lat");
            lng = data.pick("$.lng");
            checkin_data = "Created At: " + createdAt + "<BR>Venue Name: " + venue_name + "<BR> City: " + city + "<BR> Shout: " + shout + "<BR> Lat/lng: " + lat + "/" + lng;
        }
        replace_inner("#my_div", "" + checkin_data );
    }

}
