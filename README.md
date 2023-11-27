# godot_debugger_kz
a  debugger that allows you to track in which file and line a print function was used  console.out(["text"]);\n

HOW YO USE\n
1- single arguments\n
  console.out([ "text" ]); # output = text
2- multi arguments
  console.out([ "text",5, 12.0, 'c' ]); # output = text, 5, 12.0, c 
3- list
  console.out([ "text", ["list", 5] ]); # output = text, ["list", 5] 
4- object
  console.out([ "text", {"list": 5, 5: "list"} ]); # output = text, {"list": 5, 5: "list"}
