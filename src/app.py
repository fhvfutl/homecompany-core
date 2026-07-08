import sys
import os

# Добавляем текущую директорию в sys.path
sys.path.insert(0, '/home/homecompany')

from flask import Flask, jsonify

app = Flask(__name__)

# Расширенный список агентов
AGENTS = [
    {'id': 1, 'name': 'Leader', 'role': 'Project Manager', 'status': 'active'},
    {'id': 2, 'name': 'BIM', 'role': 'Building Information Modeling', 'status': 'active'},
    {'id': 3, 'name': 'Ubuntu', 'role': 'Linux System Administrator', 'status': 'active'},
    {'id': 4, 'name': 'Developers', 'role': 'Software Developers', 'status': 'active'},
    {'id': 5, 'name': 'Secretary', 'role': 'Administrative Assistant', 'status': 'active'},
    {'id': 6, 'name': 'KB Operator', 'role': 'Knowledge Base Operator', 'status': 'active'},
    {'id': 7, 'name': 'QA Engineer', 'role': 'Quality Assurance Engineer', 'status': 'pending'},
    {'id': 8, 'name': 'DevOps', 'role': 'DevOps Engineer', 'status': 'pending'},
    {'id': 9, 'name': 'Data Analyst', 'role': 'Data Analyst', 'status': 'pending'},
    {'id': 10, 'name': 'Security Specialist', 'role': 'Security Specialist', 'status': 'pending'},
]

@app.route('/')
def home():
    return jsonify({
        'status': 'running',
        'message': 'HomeCompany API is working!',
        'python': os.sys.version,
        'path': sys.path,
        'agents_count': len(AGENTS)
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

@app.route('/agents')
def agents():
    return jsonify({
        'agents': AGENTS,
        'total': len(AGENTS)
    })

@app.route('/agents/<int:agent_id>')
def agent_detail(agent_id):
    agent = next((a for a in AGENTS if a['id'] == agent_id), None)
    if agent:
        return jsonify({'agent': agent})
    else:
        return jsonify({'error': 'Agent not found'}), 404

@app.route('/agents/pending')
def pending_agents():
    pending = [a for a in AGENTS if a['status'] == 'pending']
    return jsonify({
        'pending_agents': pending,
        'total_pending': len(pending)
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
