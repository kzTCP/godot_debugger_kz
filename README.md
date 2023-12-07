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


## Icons Meaning
| icon | meaning |
|-----:|-----------|
|<picture> <img alt="resize image" src="./addons/kz_debugger/assets/resize.png" width="50" > </picture>|  popupable window|
|<picture> <img alt="resize image" src="./addons/kz_debugger/assets/save.png" width="50" > </picture>| save (position and size)|
|<picture> <img alt="resize image" src="./addons/kz_debugger/assets/window.png" width="50" > </picture>| resize (to last save)|
|<picture> <img alt="resize image" src="./addons/kz_debugger/assets/smaller.png" width="50" > </picture>| dock|
|<picture> <img alt="resize image" src="./addons/kz_debugger/assets/clean.png" width="50" > </picture>|  clear text|
|<picture> <img alt="resize image" src="./addons/kz_debugger/assets/settings.png" width="50" > </picture>| settings|
|<picture> <img alt="resize image" src="./addons/kz_debugger/assets/refresh.png" width="50" > </picture>|  refresh|
|<picture> <img alt="resize image" src="./addons/kz_debugger/assets/heart_1_size-removebg-preview.png" width="50" > </picture>|  sponsor|

