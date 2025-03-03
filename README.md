# 2023 Turkish Presidential Elections

This script is designed to retrieve, process, and visualize election data for television broadcasts. It fetches real-time data from a database and presents it through an intuitive user interface for efficient visualization and display.

## Features

- **Data Retrieval:** Fetches the latest election data from a remote database.
- **Election Results Display:** Shows the election results for various political alliances and individual parties.
- **Winning Provinces Calculation:** Automatically calculates and displays the number of winning provinces for each alliance.
- **Broadcast-Ready Visualization:** Provides visualization options tailored for broadcasting, including customizable display levels and data presentation formats.

## Usage

### 1. **Initialization**
Run the `InitForm` subroutine to initialize the script. This prepares the environment for data retrieval and visualization.

### 2. **Updating Data**
Click the **Verileri Güncelle** (Update Data) button to fetch the latest election data from the database.

### 3. **Visualizing Data**
- Click **Yayından Al** (Take off Air) to clear the visualization stage.
- Click **Load Scene** to display the election results in a visually formatted scene.

### 4. **Sending to Viz**
Once your data is ready, click **Send to Viz** to send the election data to the visualization system for broadcasting.

## Requirements

- **VBScript Compatibility:** This script is written in VBScript and requires an environment capable of executing VBScript.
- **Database Access:** You must have access to a database containing the latest election results to fetch real-time data.
- **Broadcast Visualization Equipment:** The script outputs data in a specific format compatible with your broadcast equipment. Ensure that your visualization system is configured to handle this format.

## Screenshots

### 1. **User Interface Overview**
![User Interface Overview](https://github.com/onurmertanarat/secim-2023/blob/main/parlamento/FOX/parlamento0.PNG)

### 2. **Election Results Visualization**
![Election Results Visualization](https://github.com/onurmertanarat/secim-2023/blob/main/parlamento/FOX/parlamento1.PNG)

**Note:** This repository currently contains only the parliamentary election data scripts. It does not include scripts or data related to other election categories (such as presidential elections).
