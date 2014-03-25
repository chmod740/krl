ruleset lab7_1 {

	meta {
        //b505182x7
		name "lab7_1"
		description << CS462 Lab >>
		author "Dan Hogue" 
        use module b505182x5 alias location_data
        use module a169x701 alias CloudRain
        use module a41x186  alias SquareTag
        //https://cs.kobj.net/sky/event/4642ECDC-AFA0-11E3-A914-CE78D61CF0AC/1/location/new_current?_rids=b505182x7&lat=0&lng=0
	}
	dispatch {}
	global {
        r90   = math:pi()/2;      
        rEk   = 6378;         // radius of the Earth in km
    }

    rule nearby {
        select when location new_current
        pre {
            lat = event:attr("lat");
            lng = event:attr("lng");
            data = location_data:get_location_data("fs_checkin");
            city = data.pick("$.city");
            lat2 = data.pick("$.lat");
            lng2 = data.pick("$.lng");
            info = "Event lat/lng: " + lat.as('str') + " / " + lng.as('str') + "<BR>Your lat/lng: " + lat2 + " / " + lng2;
             
            rlata = math:deg2rad(lat);
            rlnga = math:deg2rad(lng);
            rlatb = math:deg2rad(lat2);
            rlngb = math:deg2rad(lng2);
             
            // distance between two co-ordinates in kilometers
            dist = math:great_circle_distance(rlnga, r90 - rlata, rlngb, r90 - rlatb, rEk);
        }
        if (dist >= 5) then
            noop();
        fired { 
            set app:info info;
            raise explicit event location_far with key = "location_far" and value = dist.as('str');
        } else {
            set app:info info;
            raise explicit event location_nearby with key = "location_nearby" and value = dist.as('str');
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
            replace_inner("#my_div", "" + app:info);
        }
    }

}
