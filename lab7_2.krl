ruleset lab7_2 {

	meta {
		//b505182x8
		name "lab7_2"
		description << CS462 Lab >>
		author "Dan Hogue" 
		use module a169x701 alias CloudRain
        use module a41x186  alias SquareTag
        key twilio {"account_sid" : "AC9770a88fb9259bff06eaabcbf97bb861",
                    "auth_token"  : "c98cb3550e33c7d453bc65ce44a15cd4"
        }
        use module a8x115 alias twilio with twiliokeys = keys:twilio()
	}
	dispatch {}
	global {
		phone_number = "703-565-3906";
		from_number = "703-436-1426";
	}

	rule location_nearby {
		select when explicit location_nearby
		 pre {
            info = "Event location_nearby fired: dist=" + event:attr("value");
        }
        twilio:send_sms(phone_number, from_number, info);
        fired {
        	set app:info info;
        }
	}

	rule location_far {
		select when explicit location_far
		pre {
            info = "Event location_far fired: dist=" + event:attr("value");
        }
        twilio:send_sms(phone_number, from_number, info);
        fired {
            set app:info info;
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
            CloudRain:createLoadPanel("Lab7_2", {}, my_html);
            replace_inner("#my_div", "" + app:info);
        }
    }

}
