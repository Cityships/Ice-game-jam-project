# Ice game jam project
Hi there this is alex, I've gotten a 2d adventure game skeleton. I hope this helps in level creation.
Preface, Godot may not let you open this project if you aren't using the .net version; download site: 
https://godotengine.org/download/windows/
I'm currently trying out github desktop: https://desktop.github.com/
And I followed this tutorial to share this project: https://www.youtube.com/watch?v=5H4A74FIEtg

I've set up a few example "playgrounds" with a mix of some polygonal colliders and some tilemap colliders.
Drawcollisionpolygon.gd is just a short script that fills in a polygonal collider with color.
To use drawcollisionpolygon.gd just add it to a collisionpolygon2d and then add a child polygon2d to the collisionpolygon2d.

For creating a new tilemap, just add a new tilemap. Then find either the "walltile.tres" or "floortile.tres" into the tile set in the inspector.
I don't know why but copying and pasting the "map physics geometry" node into different scenes, deletes it from the previous scene. 
You may get like 100+ errors in the debugger after that happens. To fix this just check the tileset and setup (far right of debugger logs).
There should be 3 vertical dots, select "Remove tiles outside the texture".
