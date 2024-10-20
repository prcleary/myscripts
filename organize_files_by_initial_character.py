import os
import shutil

def organize_files_by_initial_character(source_folder):
    # Ensure the source folder exists
    if not os.path.exists(source_folder):
        print(f"The specified folder does not exist: {source_folder}")
        return

    # Iterate over all files in the source folder
    for filename in os.listdir(source_folder):
        # Check if it is a file
        if os.path.isfile(os.path.join(source_folder, filename)):
            # Get the first character of the filename
            initial_character = filename[0].lower()  # Convert to lower case for consistency
            
            # Create a new folder based on the initial character
            target_folder = os.path.join(source_folder, initial_character)
            if not os.path.exists(target_folder):
                os.makedirs(target_folder)

            # Move the file to the corresponding folder
            shutil.move(os.path.join(source_folder, filename), os.path.join(target_folder, filename))

    print("Files have been organized.")

# Specify the folder you want to organize
source_folder_path = '/home/paul/pdfs'  # Change this to your folder path
organize_files_by_initial_character(source_folder_path)
