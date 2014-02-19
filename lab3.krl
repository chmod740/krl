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

  rule Lab3 is active {
    select when pageview ".*" setting ()
        {notify("Box 1", "This is a simple rule.");
        notify("Box 2", "This is another sample rule.");}
  }


}
