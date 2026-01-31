FROM python:3.11-slim
RUN pip install Flask prometheus-flask-exporter
WORKDIR /app
COPY pythonserver.py .
EXPOSE 5000
CMD ["python", "pythonserver.py"]
