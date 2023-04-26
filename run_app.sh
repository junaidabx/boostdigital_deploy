#!/bin/bash

project_folder=$(pwd)
env_name="my_env"
app_file="top_n_performance.py"
dependencies_file="requirements.txt"

echo "Setting working directory..."
cd "$project_folder"

if [ ! -d "$project_folder/$env_name" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$project_folder/$env_name"
fi

echo "Activating virtual environment..."
source "$project_folder/$env_name/bin/activate"

echo "Checking dependencies..."
all_dependencies_installed=true
while read line; do
    if pip freeze | grep -i "$line" > /dev/null; then
        echo "$line is already installed."
    else
        echo "Installing $line..."
        pip install "$line"
        all_dependencies_installed=false
    fi
done < "$project_folder/$dependencies_file"

echo "Deleting requirements.txt file..."
rm "$project_folder/$dependencies_file"

echo "Running app..."
streamlit run "$project_folder/$app_file"
