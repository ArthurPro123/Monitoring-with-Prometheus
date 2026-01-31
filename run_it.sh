# Pull down the bitnami/node-exporter image from
# Docker Hub that you will use to simulate three
# servers being monitored:
docker pull bitnami/node-exporter:latest

# Pull the Prometheus docker image:
docker pull bitnami/prometheus:latest

# Create a network called 'monitoring_net' within which we
# will run all of the docker containers:
docker network create monitoring_net

# Start 3 instances of node exporter on the monitoring_net
docker run -d --name node-exporter1 -p 9101:9100 --network monitoring_net bitnami/node-exporter:latest
docker run -d --name node-exporter2 -p 9102:9100 --network monitoring_net bitnami/node-exporter:latest
docker run -d --name node-exporter3 -p 9103:9100 --network monitoring_net bitnami/node-exporter:latest

# Check if all the instances of node exporter are running:
docker ps | grep node-exporter


# Build a Docker image for the service:
docker build -t pythonserver .

# Run the pythonserver Docker container on the 'monitoring_net' network exposing port
# 5000 so that Prometheus will have access to it:

docker run -d --name pythonserver -p 5001:5000 --network monitoring_net pythonserver


# Launch the Prometheus monitor 
docker run -d --name prometheus -p 9090:9090 --network monitoring_net \
	-v $(pwd)/prometheus.yml:/opt/bitnami/prometheus/conf/prometheus.yml \
		bitnami/prometheus:latest


# App endpoints:
# localhost:5001/
# localhost:5001/contact
# localhost:5001/about


cat <<'EOF'

### How to Check Flask App Metrics

1. Verify Flask Metrics Endpoint
Run this command to confirm the Flask app is exposing Prometheus metrics:
curl http://localhost:5001/metrics

2. Query Metrics in Prometheus
Open: http://localhost:9090/graph
In the query box, enter: flask_http_request_total
Click "Execute" to visualize the data.

EOF

