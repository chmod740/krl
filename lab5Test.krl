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
        subscription_map = { 
            "cid1":"1171FF48-B464-11E3-8FF1-87E9E058E56E",
            "cid2":"0AB70766-B464-11E3-BB02-D5B3E71C24E1"
        };
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
    		data = event:attr("checkin").decode();
    		createdAt = data.pick("$.createdAt");
    		venue = data.pick("$.venue");
    		venue_name = venue.pick("$.name");
    		city = data.pick("$..city");
    		shout = data.pick("$.shout");
            lat = data.pick("$..lat");
            lng = data.pick("$..lng");
    		checkin_data =  event:attr("checkin") + "<BR><BR>" + createdAt + "<BR>" + venue_name + "<BR>" + city + "<BR>" + shout + "<BR> Lat/lng: " + lat.as("str") + "/" + lng.as("str");
    	}
        send_directive(venue_name) with key = "checkin" and value = venue_name;
    	fired {
                set ent:checkin_data checkin_data;
                raise pds event new_location_data with key = "fs_checkin" and value = {"lat": lat, "lng": lng, "venue": venue, "city": city, "shout": shout, "createdAt": createdAt};
        }
	}

    rule dispatcher_rule {
        select when foursquare checkin foreach subscription_map setting (k,v)
        pre {
            //value = v;
        }
        {
            notify("hello","there" + k);
            event:send(v, "location", "notification");
        }    
    }

}












