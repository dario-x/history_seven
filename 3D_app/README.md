# Explore the history of the 7th district of Vienna in 3D


The 7th district of Vienna boasts a rich cultural and architectural heritage dating back almost 800 years. 
Throughout the centuries, this district has played host to numerous important buildings and structures that have evolved over time.
To provide a comprehensive overview of the district's history, 
an interactive website has been developed that features 3D models showcasing the different types of buildings
that were typical for each respective time period. 
These models are represented using glTF models and appear or disappear based on the year that is displayed in the counter.

While exploring the website, visitors can learn about the district's evolution from its medieval beginnings to the present day, gaining insight into the factors that contributed to its development over the centuries.

This HTML file is an A-Frame scene that displays 3D models on a 3D map. 
The JavaScript file "counter.js" is also included in the HTML file, and it creates a counter in the scene that indicates the. 
The scene is built using several A-Frame components and external libraries, which are included as script tags in the HTML file.

### Libraries

-   [A-Frame](https://aframe.io/): A web framework for building VR experiences and 3D scenes on the web.
-   [A-Frame Environment Component]([https://unpkg.com/aframe-environment-component](https://github.com/supermedium/aframe-environment-component)): A component for adding environment elements to an A-Frame scene, such as sky, ground, and lighting.
-   [A-Frame Event Set Component](https://github.com/amitwaghmare/aframe-event-set-component): A component for defining sets of events and actions to be performed in response to those events.
-   [A-Frame Ground Component](https://github.com/kfarr/aframe-ground-component): A component for adding a ground plane to an A-Frame scene.
-   [SuperHands](https://github.com/c-frame/aframe-super-hands-component): A component for adding hand-tracking and interaction to an A-Frame scene.


Built with [A-Frame](https://aframe.io), a web framework for building virtual reality experiences.
Make WebVR with HTML and Entity-Component. Works on Vive, Rift, Quest, desktop, mobile platforms.
Click and drag on desktop. Open it on a smartphone and use the device motion sensors. Or [plug in a VR headset](https://aframe.io/docs/0.8.0/introduction/vr-headsets-and-webvr-browsers.html)!


### Assets

Several 3D models and textures are included in the scene as A-Frame assets. These include:

-   "church.gltf"
-   "farm.gltf"
-   "settlement.gltf"
-   "building.gltf"
-   "cinema.gltf"
-   "coffee_house.gltf"
-   "health_institution.gltf"
-   "ns_institution.gltf"
-   "park.gltf"
-   "school.gltf"
-   "statue.gltf"
-   "theatre.gltf"
-   "map.png"
-   "Sand2c.jpg"
-   "Sand2cN.jpg"

### Scene Elements

The scene consists of a camera, an environment with a ground plane and lighting, a 3D counter, and several 3D models that are positioned on the map using the `gltf-model` entity. The `a-plane` entity is used to create the ground texture and the `a-image` entity is used to display the 2D map on the ground. The `counter.js` file is used to create the 3D counter, which is an `a-entity` element that uses the `counter` component to display a number in 3D space.

### Running the Scene

To view the scene, open the HTML file in a web browser that supports A-Frame and WebGL. Alternatively, the scene can be viewed in VR using a compatible headset and browser.
