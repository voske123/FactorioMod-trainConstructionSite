# Introduction
Dear player,

Here you can find some basic information about the setup and workings of the construction site. The construction site is build around three entities:
  - The Traindepot,
  - The Trainbuilder,
  - The Trainbuilder controller.

You can find this information by opening the ingame manual as well.

![Preview image](https://github.com/voske123/FactorioMod-trainConstructionSite/blob/master/graphics/screenshots/introduction-preview.png)

If you find any bugs or find anything unclear, feel free to contact us on the mod portal, in the discussion section or make a bug report on github.

Kind regards and have fun playing,\nLovely_santa and Voske_123

# Traindepot
### Usability
The depot is used to store freshly made trains. Ofcourse you can also send other trains that are out of use to these stations.
![Preview depot](https://github.com/voske123/FactorioMod-trainConstructionSite/blob/master/graphics/screenshots/traindepot-creation.png)

When you are in need for more train, you can take trains out of the depot and put them to use. You can even do this from the mapview without needing to be close to the depot!

### Depot statistics
When you open the depot entity, you can see some basic information about the depot.
  - Depot name: The name this depot has. By pressing the edit button or switching tabs, you can change the depot name to anything you want, similar to how you change the name of a train stop. Ofcourse you can also use the copy paste tool for renaming purposes.
  - Available depot spots: The amount of depot spots that are available. This is shown as "available/total" station count. Building more stations with the same name extends the total amount of trains that stay in the depot.

### Depot configuration settings
  - Requested amount: In the depot menu you can set the amount of trains you want to have in the depot. When the amount of trains that is present in the depot is lower than the requested amount, the connected builders will create more trains until the request is fullfilled.
  - Connected trainbuilders: The trainbuilders that are connected to this depot to fullfill the requests. This also shows a list of all the controllers which you can access from here.



# Trainbuilder
### Functionality
The Trainbuilder will assemble the trainparts together to functional train wagons. You put the ingredients inside the building like you do for an assembling machine. After that, it will start producing finished trains. However, without a traincontroller attached, it won't place the train on the track.

### Building requirements
You can't place trains everywhere, they must be placed on rails. This means the building must also be placed on (straight) rails. This way, the building will assemble the trains onto the tracks directly.
![Placement preview](https://github.com/voske123/FactorioMod-trainConstructionSite/blob/master/graphics/screenshots/trainassembly-placement.png)

Trains are 6 tiles wide, with one tile inbetween each train. The building is also 6 tiles wide, the same length of trains themself. In order to link multiple Trainbuilders together, the buildings must be spaced one tile apart.

Assembling a train requires heavy duty tools, so you must provide some power to the building. They are quite power hungry, but they support Efficiency moduless to be put inside. Because of safety reasons we cannot allow Speed modules and obviously Productivity modules make no sence.

### Recipe requirements
Each train requires parts to be build. These parts can be seperatly be made with the same ingredients as you would make a train without this mod present.

The train needs to be able to drive away, which means the locomotives require fuel. As we didn't want to limit your fuel options, we chose to make a generic fuel item that can be made out of all other fueling items.

The Trainbuilder has a blue arrow, showing the direction of the building. This is usefull when building trains carriages where the orientation matters (for example the Locomotive or Artillery Wagon).
![Direction preview](https://github.com/voske123/FactorioMod-trainConstructionSite/blob/master/graphics/screenshots/trainassembly-direction.png)
In the picture above, the Trainbuilder will create a train (left to right) that is made of:
  - Locomotive facing west
  - Cargo wagon facing west (direction doesn't matter)
  - Cargo wagon facing west
  - Cargo wagon facing east
  - Cargo wagon facing east
  - Locomotive facing east

For those that like to express trainconfigurations as numbers, this would be a 1-4-1 train (1 locomotive facing the front, 4 carriages, 1 locomotive facing the rear).



# Trainbuilder controller
### Placement requirements
The controller must be placed in front of the Trainbuilders so it can control them. They are placed in the same way a Train stop is placed:
  - On the right side of the track
  - In the direction the train will approach it (yellow arrows).
![Placement preview](https://github.com/voske123/FactorioMod-trainConstructionSite/blob/master/graphics/screenshots/traincontroller-placement.png)

Because the train exits automaticaly, at least one locomotive must be facing this direction so the train can drive away. In order to make sure your train can go somewhere, we force you to place at least one Traindepot on your map, before you can place any controller.

### Controller statistics
When you open the controller entity, you can see some basic information about the builder.
  - Connected depot name: The name of the depot this controller is working for. By pressing the edit button or switching tabs, you can change the name to any depot that is currently present, similar to how you change the name of a train stop. Ofcourse you can also use the copy paste tool for renaming purposes.
  - Depot request status: The amount of trains the depot is requesting. This is shown as "current/requested" occupation in the depot. If the current amount is lower than the requested amount, the controller will send a train to the depot. If you want to change the requested amount, you have to do that inside the depot.
  - Builder status: The current status of this depot. This can be:
    - Constructing a train
    - Waiting for a request
    - Dispatching the train
  The controller will start placing carriages on the tracks as soon as one is done building. When the train is traveling to the depot, the builder will instantly start creating a new train.

### Trainbuilder interface
The traincontroller also has some features about the trainbuilder configuration as shown in the image below.
![Configuration preview](https://github.com/voske123/FactorioMod-trainConstructionSite/blob/master/graphics/screenshots/traincontroller-configuration.png)

Instead of having to go around and rotate your Trainbuilder entities manualy, you can do this inside the interface by pressing the arrow buttons to change the orientation. For Locomotives you can also choose the color in the color picker menu by pressing the color picker button.

# Changelog
### Future development
This mod is still in development, changes may occur and bugs will be fixed.
### Latest release
See [ingame changelog](https://mods.factorio.com/mod/trainConstructionSite/changelog) or find it [here on github](https://github.com/voske123/FactorioMod-trainConstructionSite/blob/master/changelog.txt).
