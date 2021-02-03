---
title: Notes
icon: fas fa-code
permalink: notes
---

# Development guide

If you wish to contribute to the project here's a loose guide to getting a development environment setup.

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

4) Load the game in TtS