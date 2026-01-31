
from flask import Flask
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)

metrics = PrometheusMetrics.for_app_factory()
metrics.init_app(app)

# Custom metric to track requests by endpoint
from flask import request
@metrics.do_not_track()  # This decorator prevents the metrics from tracking this request.
@app.before_request
def before_request():
    """Add the endpoint name to the Prometheus metrics."""
    metrics.counter('flask_http_requests', 'Number of HTTP requests', labels={'path': request.path}).inc()

@app.route('/')
def home():
    return 'Home Page!'

@app.route('/about')
def about():
    return 'About us!'

@app.route('/contact')
def contact():
    return 'Contact us!'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
