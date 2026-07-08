import sys
import os
import json
import redis
from flask import Flask, jsonify

# Добавляем текущую директорию в sys.path
sys.path.insert(0, '/home/homecompany')

app = Flask(__name__)

# Подключение к Redis
try:
    redis_client = redis.Redis(
        host=os.getenv('REDIS_HOST', 'redis'),
        port=int(os.getenv('REDIS_PORT', 6379)),
        db=int(os.getenv('REDIS_DB', 0)),
        decode_responses=True
    )
    redis_client.ping()
    print("Redis connected successfully!")
except Exception as e:
    print(f"Warning: Redis connection failed: {e}")
    redis_client = None

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

def get_cache_key(pattern, *args):
    """Generate unique cache key"""
    return f"homecompany:{pattern}:{':'.join(map(str, args))}"

@app.route('/')
def home():
    return jsonify({
        'status': 'running',
        'message': 'HomeCompany API with Redis caching is working!',
        'python': os.sys.version,
        'path': sys.path,
        'agents_count': len(AGENTS),
        'redis_connected': redis_client is not None
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

@app.route('/agents')
def agents():
    cache_key = get_cache_key('agents')
    
    # Try to get from cache
    if redis_client:
        cached_data = redis_client.get(cache_key)
        if cached_data:
            return jsonify(json.loads(cached_data))
    
    # Cache the result
    result = {
        'agents': AGENTS,
        'total': len(AGENTS)
    }
    
    if redis_client:
        redis_client.setex(cache_key, 300, json.dumps(result))  # Cache for 5 minutes
    
    return jsonify(result)

@app.route('/agents/<int:agent_id>')
def agent_detail(agent_id):
    cache_key = get_cache_key('agent', agent_id)
    
    # Try to get from cache
    if redis_client:
        cached_data = redis_client.get(cache_key)
        if cached_data:
            return jsonify(json.loads(cached_data))
    
    # Find agent
    agent = next((a for a in AGENTS if a['id'] == agent_id), None)
    if agent:
        result = {'agent': agent}
        if redis_client:
            redis_client.setex(cache_key, 300, json.dumps(result))
        return jsonify(result)
    else:
        return jsonify({'error': 'Agent not found'}), 404

@app.route('/agents/pending')
def pending_agents():
    cache_key = get_cache_key('pending')
    
    # Try to get from cache
    if redis_client:
        cached_data = redis_client.get(cache_key)
        if cached_data:
            return jsonify(json.loads(cached_data))
    
    # Filter pending agents
    pending = [a for a in AGENTS if a['status'] == 'pending']
    result = {
        'pending_agents': pending,
        'total_pending': len(pending)
    }
    
    if redis_client:
        redis_client.setex(cache_key, 300, json.dumps(result))
    
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
