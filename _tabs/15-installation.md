---
title: Installation
layout: page
icon: fas fa-file-import
permalink: installation
---

# Installing the Game

<div class="alert alert-warning" role="alert">
    <i class="fa fa-exclamation-triangle"></i> 
    You will require the game <a href="https://store.steampowered.com/app/286160/Tabletop_Simulator/" target="_blank">Tabletop Simulator</a> to play this mod
</div>

## Quick install

Installing the game is very straightforward. Simply head to the Steam Workshop page and click the Subscribe button. The game will then be available in the Workshop section of the Games window in Tabletop Simulator.


<a href="https://steamcommunity.com/sharedfiles/filedetails/?id=2386624320" class="btn btn-primary btn-lg" role="button">
    <span class="text-white">
        <i class="fab fa-steam mr-2"></i>
        <span class="font-weight-bold">
            Subscribe on Steam
        </span>
    </span>
</a>

---

## Manual install

This should only be done if you wish to modify or contribute to the game.

1) Clone the main repository to a folder on your local drive

2) Create a symlink in your TTS saves folder to the `tts-saves` folder contained in this project. Examples:    
Default save location:
~~~
mklink /D "C:\Users\Richard\Documents\My Games\Tabletop Simulator\Saves\Castle Wars" "H:\Unity Projects\tts-castle-wars\Assets\tts-saves"
~~~
{: .language-bash}

Custom save location:
~~~
mklink /D "S:\tts-saves\Saves\Castle Wars" "C:\projects\tts-castle-wars\Assets\tts-saves"
~~~
{: .language-bash}

3) Update your editor plugin with a reference to the parent folder you cloned the project into. For the examples shown above, using the [VSCode plugin](https://marketplace.visualstudio.com/items?itemName=rolandostar.tabletopsimulator-lua), this would mean editing the *TTSLua: Include Other Files Paths* setting to include the following paths:

  * C:\projects
  * H:\Unity Projects

4) Load the game in Tabletop Simulator