ruleset Lab3App {

  meta {
    name "Lab3App"
    description <<
      Lab 3
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


  rule show_form is active {
    select when pageview url re#.*#
    pre {
      username = ent:username;
      my_divs = << <div id="my_div">
        <form id="my_form" onsubmit="return false">
        <input type="text" name="first"/>
        <input type="text" name="last"/>
        <input id="submit" type="submit" value="submit">
        </form>
      </div>
      <div id="my_other_div"></div> >>;
    }
    { 
      replace_html("#main", my_divs);
      replace_inner("#my_other_div", "Hello " + username);
    }
  }

  rule watch_submit is active {
    select when pageview ".*" setting ()
      {
        watch("#my_form", "submit");
      }
    }
     
  rule clicked_submit is active {
    select when web click "#submit"
      pre {
        username = "there " + event:attr("first") + " " + event:attr("last");
      }
      replace_inner("#my_other_div", "Hello " + username);
      fired {
        set ent:username username;
      }
  }

  rule respond_submit is active {
    select when web submit "#my_form"
    pre {
      username = event:attr("first") + " " + event:attr("last");
    }
    notify("Form", "Hello " + username);
  }

  rule clear_name is active {
    select when pageview ".*" setting ()
      pre {
          username = ent:username;
          getClear = function(query) {
            (query.match(re/\bclear=/)) => query.extract(re/\bclear=(\w+)/) | ["false"]
          };
          clear_var = getClear(page:url("query"));
      }
      if clear_var[0] eq "1" then
        {notify("Notice", "Clearing name");
        replace_inner("#my_other_div", " ");}
      fired { 
        clear ent:username;
      } else {
      }
  }


}
