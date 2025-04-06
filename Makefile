# Define variables
APP_NAME=fastapi-cicd
DOCKER_IMAGE=yourdockerhub/$(APP_NAME)
PYTHONPATH=.

# Run FastAPI app locally
run:
	uvicorn app.main:app --reload

# Run tests with PYTHONPATH set
test:
	PYTHONPATH=$(PYTHONPATH) pytest tests/

# Install Python dependencies
install:
	pip install -r requirements.txt

# Build Docker image
docker-build:
	docker build -t $(DOCKER_IMAGE):latest .

# Run Docker container
docker-run:
	docker run -p 8000:80 $(DOCKER_IMAGE):latest

# Clean __pycache__ and Docker images (optional)
clean:
	find . -type d -name "__pycache__" -exec rm -r {} +
	find . -type d -name ".pytest_cache" -exec rm -r {} +
	#docker system prune -f

.PHONY: run test install docker-build docker-run clean


# make run — run the FastAPI server locally

# make test — run your unit tests with PYTHONPATH=. set

# make install — install required dependencies

# make docker-build — build the Docker image

# make docker-run — run your Docker container locally

# make clean — clean up pycache and Docker images