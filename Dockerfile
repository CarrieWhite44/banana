# Use lightweight Python image
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Copy requirements first
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Flask environment variables
ENV FLASK_APP=app/banana.py
ENV FLASK_ENV=development

# Expose Flask port
EXPOSE 5000

# Run app
CMD ["python", "app/banana.py"]