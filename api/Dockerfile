FROM python:3.9-slim

WORKDIR /api

# Copy only the requirements file first to leverage Docker cache
COPY api/requirements.txt /api/
RUN ls -la /api/requirements.txt
# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /api/

# Expose the application port
EXPOSE 8000

# Command to run the application
CMD ["bash", "run_app.sh"]
