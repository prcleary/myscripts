import os
import csv
import pandas as pd
import PyPDF2
import docx
import win32com.client  # Required for .doc files

def extract_text(file_path):
    """Extracts text from different file types."""
    try:
        ext = os.path.splitext(file_path)[1].lower()
        if ext == ".pdf":
            with open(file_path, "rb") as f:
                reader = PyPDF2.PdfReader(f)
                text = " ".join([page.extract_text() or "" for page in reader.pages])
        elif ext in [".xls", ".xlsx"]:
            df = pd.read_excel(file_path, nrows=5, dtype=str)  # Read first few rows
            text = " ".join(df.astype(str).values.flatten())
        elif ext in [".csv"]:
            df = pd.read_csv(file_path, nrows=5, dtype=str)
            text = " ".join(df.astype(str).values.flatten())
        elif ext == ".dta":
            df = pd.read_stata(file_path)
            text = " ".join(df.astype(str).values.flatten())
        elif ext == ".docx":
            doc = docx.Document(file_path)
            text = " ".join([para.text for para in doc.paragraphs])
        elif ext == ".doc":
            word = win32com.client.Dispatch("Word.Application")
            word.Visible = False
            doc = word.Documents.Open(file_path)
            text = doc.Content.Text
            doc.Close()
            word.Quit()
        else:
            text = ""
        return text[:100]  # Return first 100 characters
    except Exception as e:
        return f"Error extracting text: {e}"

def scan_directory(start_path, output_csv):
    """Scans directories and writes file details to CSV."""
    file_extensions = {".pdf", ".xls", ".xlsx", ".csv", ".docx", ".doc", ".dta"}
    
    with open(output_csv, "w", newline="") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["File Path", "File Name", "Preview (First 100 chars)"])
        
        for root, _, files in os.walk(start_path):
            for file in files:
                if os.path.splitext(file)[1].lower() in file_extensions:
                    file_path = os.path.join(root, file)
                    preview_text = extract_text(file_path)
                    writer.writerow([file_path, file, preview_text])

if __name__ == "__main__":
    start_directory = input("Enter the directory path to scan: ")
    output_file = "file_report.csv"
    scan_directory(start_directory, output_file)
    print(f"Scan complete. Report saved as {output_file}")
