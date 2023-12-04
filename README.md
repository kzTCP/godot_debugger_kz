# godot_debugger_kz (plugin)
godot `3.5` debugger that allows you to track in which file and line a `console.out([]);` function was called  

## How To Use
> [!TIP]
> `console.out([...args]);`

## Examples
### console.out([ "text" ]); 
> output = text
### console.out([ "text", 5, 12.0, 'c' ]); 
> output = text, 5, 12.0, c 
### console.out([ "text", ["list", 5] ]);  
> output = text, ["list", 5] 
### console.out([ "text", {"list": 5, 5: "list"} ]); 
> output = text, {"list": 5, 5: "list"}
