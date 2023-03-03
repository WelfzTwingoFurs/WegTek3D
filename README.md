<i>NOTE: Low color & FPS recording (game runs Real Smoof™!)</i><br>
<img src="https://raw.githubusercontent.com/WelfzTwingoFurs/godot-raycaster/main/icon.png" title="ello there dude">
<img src="https://github.com/WelfzTwingoFurs/godot-raycaster-like/blob/main/readmegif.gif?raw=true" height=350>
<img src="https://raw.githubusercontent.com/WelfzTwingoFurs/godot-raycaster/main/icon.png" title="whats good chap">
<hr>


```text
https://github.com/WelfzTwingoFurs/godot-raycaster-like
###################################################################################
########### Godot raycaster-like engine!! ... WEGTEK Engine, Version 13 ###########
###################### written by Welfz Twingo Furs, aka Weg ######################
###################################################################################
 [created using Godot Engine v3.3.2-stable Win64, at https://www.godotengine.org/]

FEATURES:
-Polygon world with height;
-Moving up & down, looking up & down;
-Field of view (FOV), draw distance options;
-Clipping (vertices behind camera don't distort);
-Z_Index sorting (Polygons in front of polygons behind);
-One-sided polygon option;
-Mono sound system;
-Depth-shading;
-Polygons are colorable, 'darkable', texturable as unmoving-plaid or UV;
-WIP Whole-polygon culling (if entirely outside screen, don't render) option;
-Sprite objects with height, & any amount of rotation frames;
-Sprite ground-shadows/reflections;
-Basic 'dynamic' darkness system for sprites, darken as floor is;
-Floor & flat wall collision;
-Mouse & keyboard control;
-Viewbobbing, viewrolling options;
-Screen resizable to any size without stretching;
-Scrolling sky sprite & stretch options, floor sprite;
-Animated weapon & feet sprites;
-All changeable textures support any resolution;
-Map using draw_line, 2D & 3D options, zoom option;
-Convenient map-making options;
-Basic weapon inventory;
-Driveable cars, dynamic suspension, customizeable base, first and third person cameras;
-Basic pedestrians that wander, get hurt, fight back or run away, and die.

IMPERFECTIONS:
-No diagonal wall collision;
-No shared vertices;
-Heavy texture distortion up-close;
-Clipping intervenes with UV-texturing;
-No camera-edge clipping (polys pieces outside screen still render);
-No screen clipping (polygons pieces behind others still render);
-Cull on + "Both bad neighbours" deletes polygon if index over 0 (comparing to resized instead of original?);
-Draw distance innacurate to value depending on Angles FOV;
-Floor-sprite position slightly innacurate to aspect ratio;
-Mouselook different sensitivity for X and Y;
-No in-game options (all settings in editor);
-The car is partially infinitely tall;
-NPCs can't dodge things, only follow targets.


###################################################################################

CONTROL KEYS:
-WASD / Arrows:   Move, rotate;
- Shift (hold):         Strafe;
-PGup & PGdown: Look up & down;
- Space & Ctrl:  Fly up & down;
-            L:   Mouse toggle;
-     [/], O/P:  Weapon select;
-     Mouse1/2:   Shoot weapon;
-            F: Enter/exit car;
-            C:  Change camera:
-          Q/E:   Look, in car;
-   Alt (hold):       View map;
-    Alt & +/-:       Zoom map;
-            X:  Noclip toggle;
-    Quote ('): Console toggle;

DEBUG KEYS:
- Scroll-lock (+Move):   Angle;
- Home:            Look center;
-  End:             Fly center;
-   F1:         /2 screen-size;
-   F2:         *2 screen-size;
-   F3:      Reset/Fill screen;
-   F4:        Pixelize screen;
-    +:                Zoom in;
-    -:               Zoom out;
-   F5:            Reset scene;
-   F8:             Close game;
-   F9 (hold):    Time-scale -;
-  F10 (hold):    Time-scale +;
-  F11:          Time-scale =1;
-  F12:          Time-scale =0.

###################################################################################

SPECIAL THANKS:
-JJoeyay, for teaching me Godot and inspiring me to make games;
-3DSage's 'Make Your Own Raycaster' series on YouTube;
-Kofybrek's 'Writing my First Ray Casting Game using C++ and SFML - SFML Tutorial';
-javidx9's 'Code-It-Yourself! 3D Graphics Engine' series on YouTube;
-Nic from college, for helping understand the polygon processing logic;
-Theraot from Stackoverflow, for making the slope collision for me.

8)
```
<hr>
<img src="https://media4.giphy.com/media/sOnrCzHT3ndi16DamA/giphy.gif" height=128px align="left">

<b >Old raycaster versions, & others
<br>available at "older-versions".
