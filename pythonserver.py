
from flask import Flask
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)

metrics = PrometheusMetrics.for_app_factory()
metrics.init_app(app, group_by='endpoint')


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