import os
import subprocess
import shutil

def open_pdf_and_manage(directory, destination_folder):
    # List all PDF files in the directory
    pdf_files = [f for f in os.listdir(directory) if f.endswith('.pdf')]
    
    if not pdf_files:
        print("No PDF files found in the specified directory.")
        return

    # Open each PDF file one by one
    for pdf_file in pdf_files:
        pdf_path = os.path.join(directory, pdf_file)
        
        # Open the PDF file in Document Viewer
        subprocess.run(['xdg-open', pdf_path])

        # Wait for the user to close the viewer
        input(f"Press Enter after closing the document '{pdf_file}'...")

        # Ask user if they want to delete or move the file
        action = input("Do you want to (d)elete the file or (m)ove it? (d/m): ").strip().lower()
        
        if action == 'd':
            os.remove(pdf_path)
            print(f"Deleted: {pdf_file}")
        elif action == 'm':
            if not os.path.exists(destination_folder):
                os.makedirs(destination_folder)
            shutil.move(pdf_path, os.path.join(destination_folder, pdf_file))
            print(f"Moved: {pdf_file} to {destination_folder}")
        else:
            print("Invalid option. Skipping the file.")

# Example usage
if __name__ == "__main__":
    # Set your directory and destination folder here
    directory_path = "/home/paul/pdfs_to_review"
    destination_folder = "/home/paul/pdfs_to_keep"
    
    open_pdf_and_manage(directory_path, destination_folder)
