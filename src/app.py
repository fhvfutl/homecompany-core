import sys
import os

# Добавляем текущую директорию в sys.path
sys.path.insert(0, '/home/homecompany')

from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        'status': 'running',
        'message': 'HomeCompany API is working!',
        'python': os.sys.version,
        'path': sys.path
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

@app.route('/agents')
def agents():
    return jsonify({
        'agents': ['Leader', 'BIM', 'Ubuntu', 'Developers', 'Secretary', 'KB Operator']
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
