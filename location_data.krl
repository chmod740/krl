ruleset location_data {

	meta {
        //b505182x5
		name "location_data"
		description << CS462 Lab 6 >>
		author "Dan Hogue" 
        use module a169x701 alias CloudRain
        use module a41x186  alias SquareTag
        provides get_location_data
	}
	dispatch {}
	global {
        get_location_data = function(key){
            data = app:location_data.pick(key.encode());
            data
        };

	}

    rule add_location_item {
        select when pds new_location_data
        // when fired store the key and value from the event in an entity variable
        pre {
            key = event:attr("key");
            value = event:attr("value");
        }
        send_directive(event:attr("key")) 
            with key = event:attr("key")
            and value = event:attr("value");
        fired {
            set app:location_data {key.encode(): value};
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
            CloudRain:createLoadPanel("Lab6", {}, my_html);
            replace_inner("#my_div", app:location_data.encode());
        }
    }

}
