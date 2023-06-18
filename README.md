![Unbenannt](https://user-images.githubusercontent.com/75636666/235879079-2aed894e-6573-4670-9d05-187befa12e70.PNG)

![newvr](https://github.com/dario-x/history_seven/assets/75636666/4d46415f-c966-4f78-97e1-f0290e6d97e5)

# HistorySeven: Exploring the 7th District of Vienna's History

HistorySeven is an interactive tool that allows users to explore the rich history of Vienna's 7th district. It offers two options for exploration: a 2D application and a Virtual Reality (VR) experience.

The 7th district of Vienna boasts a cultural and architectural heritage dating back approximately 800 years. Throughout the centuries, it has been home to numerous significant buildings and structures that have evolved over time. To provide a comprehensive overview of the district's history, we have developed two interactive websites featuring 2D and 3D models showcasing the different types of buildings that were typical for each respective time period.

By visiting the HistorySeven website, users can gain insight into the district's evolution from its medieval beginnings to the present day, understanding the factors that contributed to its development over the centuries.

## Interaction Methods for the 2D Application:
- Use the mouse or the provided buttons in the top right corner to zoom in and out.
- Hover over an object to display its name.
- Stop the audio or jump forward to a specific year (although this is not recommended as it disrupts the guided experience).
- The year counter automatically increases by one every second. Users can switch to a specific year by clicking the corresponding button on the right panel.
- Click the "show the legend" button in the right panel to view a description of the symbols used.

## Interaction Methods for the VR Experience:
- Physically move closer to an object to zoom in and out (horizontal perspective).
- Adjust your position (e.g., sit down or go on your knees) to zoom in and out (vertical perspective).
- Change your perspective by looking in different directions.
- Move closer to the legend to read its content.

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

The steps involved in building this application are described in the following graphic:









