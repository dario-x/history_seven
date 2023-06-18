![Unbenannt](https://user-images.githubusercontent.com/75636666/235879079-2aed894e-6573-4670-9d05-187befa12e70.PNG)

![newvr](https://github.com/dario-x/history_seven/assets/75636666/4d46415f-c966-4f78-97e1-f0290e6d97e5)

# HistorySeven: 
Exploring the History of Vienna's 7th District 

HistorySeven is an interactive tool that allows users to explore the rich history of Vienna's 7th district. It offers two options for exploration: a 2D application and a Virtual Reality (VR) experience.

The 7th district of Vienna boasts a cultural and architectural heritage dating back approximately 800 years. Throughout the centuries, it has been home to numerous significant buildings and structures that have evolved over time. To provide a comprehensive overview of the district's history, we have developed two interactive websites featuring 2D and 3D models showcasing the different types of buildings that were typical for each respective time period.

By visiting the HistorySeven website, users can gain insight into the district's evolution from its medieval beginnings to the present day, understanding the factors that contributed to its development over the centuries.

## 2D App

https://dario-x.shinyapps.io/history7/

## 3D App

https://history-7.glitch.me/

## Functionality for the 2D Application:
- 🔍 `Zoom In/Out`: Use the mouse scroll wheel or the zoom buttons in the top right corner.
- ℹ️ `Object Info`: Hover over an object to display its name.
- ⏯️ `Audio `: The audio starts automatically - but you can Pause/Resume the audio or jump forward to a specific section.
- ⏰ `Year Counter`: The year counter automatically increases by one every second. Switch to a specific year by triple-clicking on a year on the slider
- 🗺️ `Legend`: Click the "Show the Legend" button in the right panel to view a description of the symbols used.

## Functionality for the VR Experience:
- 👣🔍 `Zoom In/Out (Horizontal Perspective)`: Physically move closer to an object.
- 👀🔍 `Zoom In/Out (Vertical Perspective)`: Physically lower your position (e.g., sit down or go on your knees).
- 👀🔀 `Change Perspective`: Look in different directions.
- 📖👣 `Legend`: Move closer to the legend to read its content.
- ⏯️ `Audio `: The audio starts automatically. 
- ⏰ `Year Counter`: The year counter automatically increases by one every second. 


# Repository Structure

The repository documenting the code for HistorySeven follows the folder structure outlined below:

    ├── 2D_APP/                   # Contains the code for the developed R Shiny app.
    │   ├── app.R                 # Main script of the developed app.
    │   ├── hoster.R              # Script to host the application online.
    │   ├── icons/                # Stores image files used for 2D symbols.
    │   └── www/                  # Stores audio content and graphics for information.
    │
    ├── 3D_app/                   # Holds the code for the developed A-Frame VR app.
    │   ├── index.html            # Main HTML file of the app.
    │   ├── counter.js            # Provides functionality for the year counter.
    │   └── assets/               # Contains data for GLTF models and graphics (e.g., ground texture).
    │
    ├── preprocessing/            # Contains code for preprocessing steps performed before building the app.
    │   ├── preprocessing.ipynb   # Main preprocessing script for the dataset.
    │   ├── Code_Generator.ipynb  # Converts data into the format used for A-Frame.
    │   └── plots/                # Stores graphics describing the dataset.
    │
    ├── analysis/                 # Holds code used to evaluate the user study and conduct statistical tests.
    │   ├── analysis.R            # Main script for analysis and statistical data.
    │   ├── Analysis.ipynb        # Additional analysis (e.g., tag clouds).
    │   ├── group_assignment.R    # Generates group assignments for the user study (2D or VR first).
    │   ├── plots/                # Stores graphics output from the analysis.
    │   └── data/                 # Contains data collected during the user study.
    │
    └── data/                     # Contains the main data used to build the HistorySeven application.

# Code Structure

The steps involved in building the applications are described in the following graphic:

![codestructure](https://github.com/dario-x/history_seven/assets/75636666/06203631-dd42-405e-b86e-2554dacbb8e6)








