# Makefile for Exam Project Environment Setup

# Define the default goal. If 'make' is run without arguments, it will execute 'all'.
.DEFAULT_GOAL := all

# Target 'all': Sets up the entire environment.
# This is the default target executed when you run 'make'.
all: criaDiretorios build run
	@echo "---------------------------------------------------------------------"
	@echo "✅ Environment Setup Complete!"
	@echo "   - Local directories 'rendu' and 'subjects' created."
	@echo "   - Docker image 'exam-project' built."
	@echo "   - Docker container 'exam-container' started in the background."
	@echo "   - Your local './rendu' folder is linked to '/app/rendu' inside the container."
	@echo "   - Your local './subjects' folder is linked to '/app/subjects' inside the container."
	@echo ""
	@echo "➡️ Next Step: To start the actual exam process inside the container, run:"
	@echo "   make startExam"
	@echo "---------------------------------------------------------------------"
	@echo "Other useful commands:"
	@echo "   make clean      - Stop the container and remove local 'rendu'/'subjects' directories (WARNING: DELETES WORK)."
	@echo "   make re         - Clean the environment and set it up again."
	@echo "   docker exec -it exam-container zsh - Manually access the container's shell."
	@echo "---------------------------------------------------------------------"

# Target 'criaDiretorios': Creates necessary local directories.
criaDiretorios:
	@echo "--- Task: Creating Local Directories ---"
	@echo "Creating 'rendu' directory (for your work) and 'subjects' directory (for exam files)..."
	@mkdir -p rendu subjects
	@echo "Directories 'rendu' and 'subjects' ensured to exist."

# Target 'build': Builds the Docker image for the exam environment.
build:
	@echo "--- Task: Building Docker Image ---"
	@echo "Building the Docker image named 'exam-project' using the Dockerfile in the current directory..."
	@echo "(This might take a few moments, especially on the first run.)"
	@docker build -t exam-project .
	@echo "Docker image 'exam-project' built successfully."

# Target 'run': Starts the Docker container from the built image.
run:
	@echo "--- Task: Starting Docker Container ---"
	@echo "Starting a Docker container named 'exam-container' from the 'exam-project' image..."
	@echo " - Running in detached mode (-d): Container runs in the background."
	@echo " - Automatically removing container on exit (--rm): Ensures cleanup when stopped."
	@echo " - Mounting local './rendu' to '/app/rendu' inside container (-v): Your work is saved locally."
	@echo " - Mounting local './subjects' to '/app/subjects' inside container (-v): Access exam subjects locally."
	@docker run -dit --rm --name exam-container -v "$(PWD)/rendu:/app/rendu" -v "$(PWD)/subjects:/app/subjects" exam-project
	@echo "Container 'exam-container' started successfully in the background."
	@echo "You can manually access the container's shell anytime using: docker exec -it exam-container zsh"

# Target 'clean': Stops the container and removes local directories.
clean:
	@echo "--- Task: Cleaning Up Environment ---"
	@echo "Stopping the Docker container 'exam-container' (if it's running)..."
	@docker stop exam-container || echo "Container 'exam-container' was not running or already stopped."
	@echo "Removing local 'rendu' and 'subjects' directories..."
	@echo "⚠️ WARNING: This will permanently delete all files within the local 'rendu' and 'subjects' directories!"
	@rm -rf rendu subjects
	@echo "Cleanup complete. Container stopped and local directories removed."

# Target 'startExam': Executes the exam start command inside the container.
startExam:
	@echo "--- Task: Starting Exam Process ---"
	@echo "Connecting to the running 'exam-container'..."
	@echo "Executing the 'make' command inside the container to begin the exam setup..."
	@docker exec -it exam-container make
	@echo "Exam process initiated. Follow any instructions displayed above."

# Target 're': Rebuilds the environment (clean + run).
re: clean all
	@echo "--- Task: Recreating Environment ---"
	@echo "Environment has been cleaned and rebuilt."
	@echo "➡️ Remember to run 'make startExam' again if needed."

# Declare targets that are not files.
.PHONY: all criaDiretorios build run clean startExam re