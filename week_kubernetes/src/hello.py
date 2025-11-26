from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    app_mode = os.getenv("APP_MODE", "not set")
    return f"Hello from K8s! App mode: {app_mode}"

@app.route('/env')
def show_env():
    vars = {k: v for k, v in os.environ.items() if k in ['APP_MODE', 'LOG_LEVEL', 'WELCOME_MESSAGE', 'DB_PASSWORD']}
    return "<h3>Environment Variables:</h3>" + "".join(f"<p>{k}: {v}</p>" for k, v in vars.items())

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

