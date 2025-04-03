
import subprocess
import time
from datetime import datetime

def is_connected():
    """Check internet connectivity by pinging a reliable server."""
    try:
        subprocess.check_output(["ping", "-c", "1", "8.8.8.8"], stderr=subprocess.STDOUT)
        return True
    except subprocess.CalledProcessError:
        return False

def log_event(message):
    """Append a message to the log file in Markdown format."""
    with open("connection_log.md", "a") as log_file:
        log_file.write(f"{message}\n")

def main():
    was_connected = True
    start_time = None

    while True:
        if is_connected():
            if not was_connected:
                # Connection was lost and is now restored
                end_time = datetime.now()
                log_event(f"## Connection Restored\n- Start: {start_time}\n- End: {end_time}\n")
                was_connected = True
        else:
            if was_connected:
                # Connection is lost
                start_time = datetime.now()
                log_event(f"## Connection Lost\n- Start: {start_time}\n")
                was_connected = False

        time.sleep(5)  # Check every 5 seconds

if __name__ == "__main__":
    main()
