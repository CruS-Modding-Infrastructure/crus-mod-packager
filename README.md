CrusModPackager is a Godot plugin made specifically for exporting Cruelty Squad mods. It streamlines the process of fetching imported files, creating the mod info and exporting the mod, among other things.

CrusModPackager Guide (Also present in the plugin):

First you need to enter:
	- Mod name
	- Author
	- Version
	- Description

Then you need to select the mod folder.
To do this, click on the browse button and navigate to your mod's folder.

If your mod contains an init file, then you need to select it in the "Init File" field.
Otherwise, you can leave the field empty.

If you want the mod to be automatically archived in the mod.zip then you need to check the box next to "Convert mod folder to .zip"
For this option to work, you need to install 7-Zip. (Currently only works on Windows).
If this option is not selected you will have to zip the files manually.

7-Zip path is an optional tab in case you need to manually write the path to 7-Zip.
If mod does not pack automatically after installing 7-Zip, then try to enter the path to 7-Zip manually.

Additional files is an optional tab that will add files in the selected folder to the archive.
You can leave this tab empty if you don't need to add remaps or other files.

"Load CruS after packaging" is responsible for launching the Cruelty Squad after packing the mod.
To do this, you need to select the path where the Cruelty Squad executable file is located.
For example: C:\Program Files (x86)\Steam\steamapps\common\Cruelty Squad

That's all, now you can click the "Pack" button, after which your mod should appear in the mods folder.

Also, to avoid entering all the data every time, you can click on the "Save" button.
After that, you can click the "Load" button to load all the settings. Any saved data should also be automatically loaded when starting Godot.
