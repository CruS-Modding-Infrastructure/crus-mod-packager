# CruS Mod Packager V1.4 for Cruelty Squad
CruS Mod Packager is a Godot plugin made specifically for exporting Cruelty Squad mods. It streamlines the process of fetching imported files, creating the mod info and exporting the mod, among other useful things.

## Installation
Click Code > Download ZIP and extract into your Cruelty Squad project's addons folder. For a guide on how to get the Cruelty Squad project files (requirement for making mods), see [here.](https://hackmd.io/@OsM6oUcXSwG3mLNvTlPMZg/rk56jogV_)

## 7-Zip
This plugin uses parts of 7-Zip, 7-Zip is licensed under the GNU LGPL license.  
7-Zip and the source code can be found at https://www.7-zip.org

## CruS Mod Packager Guide (Also present in the plugin)

- This guide is WIP and subject to change. The fields that describe folder/file paths are required for the mod to function unless specified as optional.
- The mods are designed to be loaded with [Cruelty Squad Mod Loader](https://crus.cc/mod/cruelty_squad_mod_loader/) and [Cruelty Squad Mod Base](https://crus.cc/mod/crus_mod_base/)
- Packaged mods are sent to AppData\Roaming\Godot\app_userdata\Cruelty Squad\mods\.
- The plugin was made on Windows and likely will run into issues on other operating systems.
- Ask in the #modifications channel of the Cruelty Squad discord if you need help with anything or want to learn how to make a mod.

### Mod Setup Tab

Mod Info: This section let's you set the required information about your mod.
- Mod name: The name you have chosen for the mod
- Author: Your name and any contributors
- Version: The current version of the mod, which you should increment when you create updated versions of the mod.
- Description: Give a short summary of what the mod does.

Mod Paths: This section is for selecting the paths that your mod's data is stored in.
- Mod Folder: The root folder of your mod. mod folders should be place in a folder named "MOD_CONTENT" for example res://MOD_CONTENT/MyEpicMod. This path is required otherwise you will be unable to build your mod.
- Init File: (Optional) The script used to perform set up for your mod. Init files are added to the scene tree in Godot, allowing you to execute code as needed.
- Additional Files: (Optional) You can specify another directory to be bundled with your mod.

Game:
- Load CruS after packaging: Check the box to attempt to launch Cruelty Squad with the mod deployed next time you pack the mod. (Any other installed mods will also be loaded, the directory is the same)
- Detect CruS: Checks if CruS is installed at the default Steam location, fills in the path if found.
- CruS Path: The folder path that contains your crueltysquad.exe. Set it manually if the above button does not work for you.

Buttons:
- Pack: Attempts to pack the specified mod files into an archive, send them to a subfolder in the mods folder and launch Cruelty Squad if specified.
- Save: Saves the changes made in the plugin to be loaded next time Godot is launched.
- Load: Manual button for loading any saved plugin data from previous sessions.
- Open Data Folder: Button that takes you to the Cruelty Squad data folder, where you can access the folder where mods are deployed or the plugin data folder (mods and mod_config respectively).
- Help: Opens a guide containing this information.

### Advanced Options Tab

Archive:
- Convert mod folder to .zip: Packs the contents of the mod into a zip file, required for the mod to be loaded with CruS Modloader.
- 7-Zip Path: (Optional) The folder path to the 7-Zip executable. 7-Zip is also bundled with this plugin, but if for some reason it doesnt work you can overwrite it here.
- Move mod folder to recycle bin: Cleans up the mod folder created by the plugin (not the one in godot) after zipping it.

### About Tab

Version number and credits.
