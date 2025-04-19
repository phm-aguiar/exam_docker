# Makefile for Exam Project Environment Setup

# Define the default goal. If 'make' is run without arguments, it will execute 'all'.
.DEFAULT_GOAL := all

# Define image name variable for easier maintenance
DOCKER_IMAGE_NAME := exam-project
DOCKER_CONTAINER_NAME := exam-container

# Target 'all': Sets up the entire environment.
# This is the default target executed when you run 'make'.
all: criaDiretorios build run
	@echo "---------------------------------------------------------------------"
	@echo "✅ Environment Setup Complete!"
	@echo "   - Local directories 'rendu', 'subjects', 'traces' created."
	@echo "   - Docker image '$(DOCKER_IMAGE_NAME)' is ready."
	@echo "   - Docker container '$(DOCKER_CONTAINER_NAME)' started in the background."
	@echo "   - Your local './rendu' folder is linked to '/app/rendu' inside the container."
	@echo "   - Your local './subjects' folder is linked to '/app/subjects' inside the container."
	@echo "   - Your local './traces' folder is linked to '/app/traces' inside the container."
	@echo ""
	@echo "➡️ Next Step: To start the actual exam process inside the container, run:"
	@echo "   make startExam"
	@echo "---------------------------------------------------------------------"
	@echo "Other useful commands:"
	@echo "   make clean      - Stop the container and remove local 'rendu'/'subjects'/'traces' directories (WARNING: DELETES WORK)."
	@echo "   make re         - Clean the environment and set it up again."
	@echo "   docker exec -it $(DOCKER_CONTAINER_NAME) zsh - Manually access the container's shell."
	@echo "---------------------------------------------------------------------"

# Target 'criaDiretorios': Creates necessary local directories.
criaDiretorios:
	@echo "--- Task: Creating Local Directories ---"
	@echo "Creating 'rendu', 'subjects', and 'traces' directories..."
	@mkdir -p rendu subjects traces
	@echo "Directories 'rendu', 'subjects', and 'traces' ensured to exist."

# Target 'build': Builds the Docker image if it doesn't exist.
build:
	@echo "--- Task: Ensuring Docker Image Exists ---"
	@echo "Checking for Docker image '$(DOCKER_IMAGE_NAME)'..."
	@# Check if image exists (inspect returns non-zero if not found, > /dev/null 2>&1 hides output/error)
	@if ! docker image inspect $(DOCKER_IMAGE_NAME) > /dev/null 2>&1; then \
		echo "Image '$(DOCKER_IMAGE_NAME)' not found. Building..."; \
		echo "(This might take a few moments.)"; \
		docker build -t $(DOCKER_IMAGE_NAME) .; \
		echo "Docker image '$(DOCKER_IMAGE_NAME)' built successfully."; \
	else \
		echo "Docker image '$(DOCKER_IMAGE_NAME)' already exists. Skipping build."; \
	fi
	@echo "Docker image '$(DOCKER_IMAGE_NAME)' is ready."

# Target 'run': Starts the Docker container from the built image.
# Ensures the container isn't already running before attempting to start.
run:
	@echo "--- Task: Starting Docker Container ---"
	@# Stop and remove container if it exists, ignoring errors if it doesn't
	@-docker stop $(DOCKER_CONTAINER_NAME) > /dev/null 2>&1 || true
	@-docker rm $(DOCKER_CONTAINER_NAME) > /dev/null 2>&1 || true
	@echo "Starting a new Docker container named '$(DOCKER_CONTAINER_NAME)' from the '$(DOCKER_IMAGE_NAME)' image..."
	@echo " - Running in detached mode (-dit)."
	@echo " - Automatically removing container on exit (--rm is implied by stop/rm above, but explicit run adds clarity for restart)."
	@echo " - Mounting local './rendu' to '/app/rendu' (-v)."
	@echo " - Mounting local './subjects' to '/app/subjects' (-v)."
	@echo " - Mounting local './traces' to '/app/traces' (-v)."
	@docker run -dit --name $(DOCKER_CONTAINER_NAME) \
		-v "$(PWD)/rendu:/app/rendu" \
		-v "$(PWD)/subjects:/app/subjects" \
		-v "$(PWD)/traces:/app/traces" \
		$(DOCKER_IMAGE_NAME)
	@echo "Container '$(DOCKER_CONTAINER_NAME)' started successfully in the background."
	@echo "You can manually access the container's shell anytime using: docker exec -it $(DOCKER_CONTAINER_NAME) zsh"

# Target 'clean': Stops the container and removes local directories.
clean:
	@echo "--- Task: Cleaning Up Environment ---"
	@echo "Stopping and removing the Docker container '$(DOCKER_CONTAINER_NAME)' (if it exists)..."
	@-docker stop $(DOCKER_CONTAINER_NAME) > /dev/null 2>&1 || echo "Container '$(DOCKER_CONTAINER_NAME)' was not running or already stopped."
	@-docker rm $(DOCKER_CONTAINER_NAME) > /dev/null 2>&1 || echo "Container '$(DOCKER_CONTAINER_NAME)' was already removed."
	@echo "Removing local 'rendu', 'subjects', and 'traces' directories..."
	@echo "⚠️ WARNING: This will permanently delete all files within the local 'rendu', 'subjects', and 'traces' directories!"
	@rm -rf rendu subjects traces
	@echo "Cleanup complete. Container stopped/removed and local directories removed."

# Target 'startExam': Executes the exam start command inside the container.
startExam:
	@echo "--- Task: Starting Exam Process ---"
	@echo "Connecting to the running '$(DOCKER_CONTAINER_NAME)'..."
	@echo "Executing the 'make' command inside the container to begin the exam setup..."
	@docker exec -it $(DOCKER_CONTAINER_NAME) make
	@echo "Exam process initiated. Follow any instructions displayed above."

# Target 're': Rebuilds the environment (clean + all).
re: clean all
	@echo "--- Task: Recreating Environment ---"
	@echo "Environment has been cleaned and rebuilt."
	@echo "➡️ Remember to run 'make startExam' again if needed."

# Declare targets that are not files.
.PHONY: all criaDiretorios build run clean startExam re