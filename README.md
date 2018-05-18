# Solus Stunts

![Screenshot](/source/images/screen.jpg?raw=true)

This is the "official" repository of the Solus Stunts Project (made with Godot 3.0).

It features a simple car racing game with three maps.

#### Clone
```
git clone https://github.com/godotengine/godot.git
git clone --recursive https://github.com/HugeGameArtGD/Solus-Stunts.git
cd Solus-Stunts
git submodule foreach --recursive git pull origin master
cd -
```
#### Update
```
cd godot
git pull
cd -
cd Solus-Stunts
git submodule foreach --recursive git pull origin master
git pull origin master
cd -
```
#### Compile
```
cd godot
scons p=x11 target=release_debug bits=64 -j 8
scons p=x11 tools=no target=release_debug bits=64 -j 8
mv bin/godot.x11.opt.debug.64 bin/linux_x11_64_debug
mv bin/linux_x11_64_debug /home/[user]/.local/share/godot/templates/3.1.dev.mono
cd -
godot/bin/godot.x11.opt.tools.64 --path Solus-Stunts/source --export "Linux/X11" Solus-Stunts.64
```
#### Run
Editor: ```godot/bin/godot.x11.opt.tools.64```

Game: ```./Solus-Stunts.64```
