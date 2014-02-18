ruleset HelloWorldApp {
  meta {
    name "Hello World"
    description <<
      Hello World
    >>
    author ""
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch {
  }
  global {
  }

  rule HelloWorld is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Hello There world!</h5>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Hello World!", {}, my_html);
    }
  }

  rule Lab2 is active {
    select when pageview ".*" setting ()
        {notify("Box 1", "This is a simple rule.");
        notify("Box 2", "This is another sample rule.");}
  }

  rule AnotherLab2Rule is active {
    select when pageview ".*" setting ()
        pre {
	     count = ent:page_count;
             getName = function(query) {
                (query.match(re/\bname=/)) => query.extract(re/\bname=(\w+)/) | ["Monkey"]
             };
             name = getName(page:url("query"));
	}
        if count <= 5 then
           notify("Hello", "Hello " + name[0] + " " + count)
  }

  rule YetAnotherLab2Rule is active {
    select when pageview ".*" setting ()
        pre {
	     count = ent:page_count;
             getClear = function(query) {
                (query.match(re/\bclear=/)) => query.extract(re/\bclear=(\w+)/) | ["false"]
             };
             clear_var = getClear(page:url("query"));
	}

        if clear_var[0] eq "true" then
             noop() 
        fired { 
              clear ent:page_count;
        } else {
            ent:page_count += 1 from 1;
        }
  }

}
