https://user-images.githubusercontent.com/60985201/192077284-04172e15-d96b-4d92-94b5-8a74611c2130.mp4
<hr>

```text
https://github.com/WelfzTwingoFurs/godot-raycaster-like
###################################################################################
############ Godot Raycaster-like!!  Written by "Welfz Twingo Furs"... ############
###################################################################################
 [created using Godot Engine v3.3.2-stable Win64, at https://www.godotengine.org/]

FEATURES:
-100% GD-Script;
-Polygon world with Z-height;
-Sprite objects with customizeable amount of rotation frames;
-Collision with flat floors and square walls;
-Flying up & down, looking up & down;
-WIP mouse controls;
-Field of view (FOV), draw distance options;
-Screen resizable to any size, everything is normalized;
-Clipping (vertexes behind camera don't distort);
-WIP Camera-edge culling option (polys outside screen won't render);
-Z_Index sorting (Polygons in front of polygons behind) in 3D;
-Sector darkness & depth shading options, basic horizon fading;
-'Unmoving Plaid' polygon texturing option;
-Basic sprite shadow & reflection effects;
-Feet when you look down;
-Viewbobbing, viewrolling options;
-Scrolling sky texture & stretch options, floor texture;
-All textures changeable to ones of any size;
-Map using draw_line(), 2D & 3D options.

IMPERFECTIONS:
-No sound;
-No slope or diagonal collision (WIP);
-Z-sorting limited to entire polygon, nearby/touching/clipping objects innacurate;
-Camera-edge culling only checks if all vertices are off-screen;
-Extreme texture distortion up-close when UV-mapped;
-Clipping intervenes with UV-mapped texturing;
-Sprite X scaling innacurate to Angles FOV;
-No camera-edge clipping (polygon pieces outside screen still render);
-No world culling (polygons fully behind others still render);
-Draw distance innacurate to value depending on Angles FOV;
-No in-game options (all settings in editor).


###################################################################################

CONTROL KEYS:
-WASD / Arrows:   Move, rotate;
- Shift (hold):         Strafe;
-PGup & PGdown: Look up & down;
-         Home:    Look center;
- Space & Ctrl:  Fly up & down;
- Enter (hold):       View map;
-[, ], s-wheel:      Inventory;
-    Quote ('): Console toggle.


DEBUG KEYS:
-    F:                 Noclip;
- End:              Fly center;
- Scroll-lock (+Move):   Angle;
-   F1:         /2 screen-size;
-   F2:         *2 screen-size;
-   F3:      Reset/Fill screen;
-    +:                Zoom in;
-    -:               Zoom out;
-   F5:            Reset scene;
-   F8:             Close game;
-   F9 (hold):    Time-scale -;
-  F10 (hold):    Time-scale +;
-  F11:          Time-scale =1;
-  F12:          Time-scale =0;
-    P: Pauses some animations.

###################################################################################
SETTINGS

--PLAYER
VARIABLES:
-       Angles: How wide your view is;
-Draw distance: How far you see;
-     Skycolor: Color of the sky;
-   Skystretch: How many times sky fits in screen (0 = texture size);
-        Min Z: How low things can fall if not inside a col-floor;
-  Rotate rate: Turn speed;
-        Speed: Move speed;
-     Vbob Max: Viewbob intensity;
-   Vbob Speed: Viewbob speed;
-  Vroll Multi: (positive or negative) Viewroll intensity;
-     Gunscale: Weapon sprite size;
-   Gunstretch: (toggle) Weapon sprite stretch fits screen horizontally;
-      Gravity: Gravity intensity;
         -Jump: Jump intensity:
-  Head Height: How tall player is;
-     Textures: (toggle) Use textures;
-  Uv Textures: (toggle) UV-map textures (causes distortion);
-      Cull On: (toggle) Don't render if all object-vertices are off-screen (imperfect);
-         Fade: (toggle) If objects are further than max-distance, paint them black;
-      Shading: (toggle) Do vertex shading;
-Sprite Shadow: (toggle) Use sprite-shadow effect;
-     Map Draw: (positive or negative) Map drawing modes.
NODES:
-$PolyContainer: View modulate;
-$View/Feet: Feet texture & modulate;
-$View/Hand: Hand modulate;
-$Background/Sky: Sky texture & modulate;
-$Background/Floor: Floor texture & modulate.

###################################################################################

SPECIAL THANKS:
-JJoeyay/Taffyko, for teaching me Godot and inspiring me to make games;
-3DSage's 'Make Your Own Raycaster' series on YouTube;
-Kofybrek's 'Writing my First Ray Casting Game using C++ and SFML - SFML Tutorial';
-Nic from college, for making me understand the polygon processing logic;
-Karin my friend, for giving me the spark that inspired wall collision!

<3
```
<hr>
<img src="https://media4.giphy.com/media/sOnrCzHT3ndi16DamA/giphy.gif" height=128px align="left">

<b >Old raycaster versions, & others
<br>available at "older-versions".
