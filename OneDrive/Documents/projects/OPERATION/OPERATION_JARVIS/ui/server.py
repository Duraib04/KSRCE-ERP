"""
Flask Web Server for Dexaura UI
Connects the web interface to the Dexaura agent backend
"""

from flask import Flask, render_template, request, jsonify, send_from_directory
import sys
from pathlib import Path
import json
from datetime import datetime
import os
import base64
from werkzeug.utils import secure_filename

# Add parent directory to path
sys.path.append(str(Path(__file__).parent.parent))

try:
    from src.agent.device_controller import AgentController
    from src.agent.response_generator import ResponseGenerator
    AGENT_IMPORT_ERROR = None
except Exception as e:
    AGENT_IMPORT_ERROR = e
    print(f"Warning: full agent stack unavailable, using fallback mode: {e}")

    class _FallbackUnderstanding:
        def understand(self, text):
            return {
                'intent': 'general',
                'confidence': 0.5,
                'sentiment': 'neutral',
                'entities': {},
                'understanding_quality': 'fallback',
                'alternatives': [],
                'suggestions': [
                    'Core command engine is running in fallback mode on cloud runtime.'
                ],
                'temporal_context': {}
            }

        def get_understanding_stats(self):
            return {'mode': 'fallback', 'status': 'limited'}

        def learn_from_user(self, question, answer):
            return 'Learning is unavailable in fallback mode.'

        def get_knowledge_answer(self, query):
            return ''

        def debug_understanding(self, text):
            return {
                'mode': 'fallback',
                'input': text,
                'note': 'Detailed NLP debug is unavailable in cloud fallback mode.'
            }

    class _FallbackImageGenerator:
        def get_supported_styles(self):
            return ['default']

        def get_supported_sizes(self):
            return ['1024x1024']

        def get_history(self, limit=20):
            return []

    class _FallbackDocumentIngestion:
        def list_documents(self):
            return []

    class _FallbackFileHandler:
        def _unsupported(self, action):
            return False, f"{action} is unavailable in cloud fallback mode."

        def open_file(self, *_args, **_kwargs):
            return self._unsupported('Open file')

        def open_folder(self, *_args, **_kwargs):
            return self._unsupported('Open folder')

        def launch_application(self, *_args, **_kwargs):
            return self._unsupported('Launch application')

        def create_file(self, *_args, **_kwargs):
            return self._unsupported('Create file')

        def read_file(self, *_args, **_kwargs):
            return self._unsupported('Read file')

        def edit_file(self, *_args, **_kwargs):
            return self._unsupported('Edit file')

        def delete_file(self, *_args, **_kwargs):
            return self._unsupported('Delete file')

        def delete_folder(self, *_args, **_kwargs):
            return self._unsupported('Delete folder')

        def list_files(self, *_args, **_kwargs):
            return self._unsupported('List files')

        def list_applications(self, *_args, **_kwargs):
            return self._unsupported('List applications')

        def launch_random_application(self, *_args, **_kwargs):
            return self._unsupported('Random app launch')

    class AgentController:
        def __init__(self, *_args, **_kwargs):
            self.understanding = _FallbackUnderstanding()
            self.image_generator = _FallbackImageGenerator()
            self.document_ingestion = _FallbackDocumentIngestion()
            self.file_handler = _FallbackFileHandler()
            self.is_online = True

        def toggle_mode(self):
            self.is_online = not self.is_online

        def get_stats(self):
            return {
                'mode': 'fallback',
                'agent_import_error': str(AGENT_IMPORT_ERROR)
            }

        def generate_image(self, prompt, style='default', size='1024x1024'):
            return {
                'success': False,
                'prompt': prompt,
                'message': 'Image generation is unavailable in cloud fallback mode.',
                'image_url': None,
                'style': style,
                'size': size
            }

    class ResponseGenerator:
        pass

# Import web search module
try:
    from src.agent.web_search import web_search, search_for_price
except ImportError as e:
    print(f"Warning: Could not import web_search module: {e}")
    web_search = None
    search_for_price = None

# Optional OpenCV for mood detection
try:
    import cv2
    import numpy as np
    HAS_CV2 = True
except Exception as e:
    print(f"Warning: OpenCV not available for mood detection: {e}")
    cv2 = None
    np = None
    HAS_CV2 = False

# Optional MediaPipe for hand gesture recognition (lazy import)
HAS_MEDIAPIPE = False
mp = None

def _get_mediapipe():
    """Lazy-load MediaPipe to avoid startup crashes and heavy imports."""
    global mp, HAS_MEDIAPIPE
    if mp is not None and HAS_MEDIAPIPE:
        return mp
    try:
        os.environ.setdefault("MPLCONFIGDIR", os.path.join(UI_DIR, ".mplconfig"))
        import mediapipe as _mp
        mp = _mp
        HAS_MEDIAPIPE = True
        return mp
    except Exception as e:
        print(f"Warning: MediaPipe not available for gesture detection: {e}")
        mp = None
        HAS_MEDIAPIPE = False
        return None

# Get the directory where this file is located
UI_DIR = os.path.dirname(os.path.abspath(__file__))
SONGS_DIR = os.path.join(UI_DIR, 'songs')
BASE_DIR = str(Path(__file__).parent.parent)
FACE_DB_DIR = os.path.join(BASE_DIR, 'data', 'faces')
FACE_DB_FILE = os.path.join(FACE_DB_DIR, 'face_labels.json')
FACE_MODEL_FILE = os.path.join(FACE_DB_DIR, 'face_model.yml')

# Object detection paths
OBJECT_MODEL_DIR = os.path.join(BASE_DIR, 'data', 'models')
OBJECT_MODEL_CONFIG = os.path.join(OBJECT_MODEL_DIR, 'ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt')
OBJECT_MODEL_WEIGHTS = os.path.join(OBJECT_MODEL_DIR, 'frozen_inference_graph.pb')
OBJECT_CLASSES_FILE = os.path.join(OBJECT_MODEL_DIR, 'coco_classes.txt')

# Object detection model cache
_object_net = None
_object_classes = None

# Create songs directory if it doesn't exist
os.makedirs(SONGS_DIR, exist_ok=True)
os.makedirs(FACE_DB_DIR, exist_ok=True)
os.makedirs(OBJECT_MODEL_DIR, exist_ok=True)

# Allowed audio extensions
ALLOWED_EXTENSIONS = {'mp3', 'wav', 'ogg', 'flac', 'm4a', 'aac', 'wma'}

def _decode_image_from_data_url(data_url: str):
    """Decode base64 data URL into an OpenCV image."""
    if not data_url:
        return None
    try:
        if ',' in data_url:
            _, b64_data = data_url.split(',', 1)
        else:
            b64_data = data_url
        image_bytes = base64.b64decode(b64_data)
        if not HAS_CV2 or cv2 is None or np is None:
            return None
        np_arr = np.frombuffer(image_bytes, np.uint8)
        return cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
    except Exception as e:
        print(f"Image decode error: {e}")
        return None

def _decode_image_from_bytes(image_bytes: bytes):
    """Decode raw image bytes into an OpenCV image."""
    if not image_bytes or not HAS_CV2 or cv2 is None or np is None:
        return None
    try:
        np_arr = np.frombuffer(image_bytes, np.uint8)
        return cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
    except Exception as e:
        print(f"Image bytes decode error: {e}")
        return None

def _encode_image_to_data_url(image_bgr) -> str:
    """Encode OpenCV BGR image into a base64 data URL."""
    try:
        success, buffer = cv2.imencode('.jpg', image_bgr)
        if not success:
            return ''
        b64 = base64.b64encode(buffer.tobytes()).decode('utf-8')
        return f"data:image/jpeg;base64,{b64}"
    except Exception as e:
        print(f"Image encode error: {e}")
        return ''

def _load_face_labels():
    if os.path.exists(FACE_DB_FILE):
        try:
            with open(FACE_DB_FILE, 'r', encoding='utf-8') as f:
                data = json.load(f)
                if 'labels' in data and 'next_id' in data:
                    data.setdefault('display', {})
                    return data
        except Exception as e:
            print(f"Face DB load error: {e}")
    return {'next_id': 1, 'labels': {}, 'display': {}}

def _save_face_labels(data: dict):
    try:
        with open(FACE_DB_FILE, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2)
    except Exception as e:
        print(f"Face DB save error: {e}")

def _get_object_detection_model():
    """Lazy load object detection model and classes."""
    global _object_net, _object_classes
    
    if _object_net is None:
        try:
            # Check if model files exist
            if not os.path.exists(OBJECT_MODEL_WEIGHTS) or not os.path.exists(OBJECT_MODEL_CONFIG):
                print("⚠️ Object detection model files not found. Downloading...")
                
                # Download model files
                import urllib.request
                
                # Download config
                config_url = "https://gist.githubusercontent.com/dkurt/54a8e8b51beb3bd3f770b79e56927bd7/raw/2a20064a9d33b893dd95d2567da126d0ecd03e85/ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt"
                print(f"Downloading config from {config_url}...")
                urllib.request.urlretrieve(config_url, OBJECT_MODEL_CONFIG)
                
                # Download weights (this is a large file ~20MB)
                weights_url = "http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v3_large_coco_2020_01_14.tar.gz"
                print(f"Downloading model weights from {weights_url}...")
                tar_path = os.path.join(OBJECT_MODEL_DIR, 'model.tar.gz')
                urllib.request.urlretrieve(weights_url, tar_path)
                
                # Extract the model
                import tarfile
                with tarfile.open(tar_path, 'r:gz') as tar:
                    for member in tar.getmembers():
                        if 'frozen_inference_graph.pb' in member.name:
                            member.name = 'frozen_inference_graph.pb'
                            tar.extract(member, OBJECT_MODEL_DIR)
                            break
                
                os.remove(tar_path)
                print("✓ Model downloaded successfully")
            
            # Load the model
            _object_net = cv2.dnn.readNetFromTensorflow(OBJECT_MODEL_WEIGHTS, OBJECT_MODEL_CONFIG)
            
            # Load class names
            if os.path.exists(OBJECT_CLASSES_FILE):
                with open(OBJECT_CLASSES_FILE, 'r') as f:
                    _object_classes = [line.strip() for line in f.readlines()]
            else:
                # Default COCO classes
                _object_classes = [
                    'person', 'bicycle', 'car', 'motorcycle', 'airplane', 'bus', 'train', 'truck', 'boat',
                    'traffic light', 'fire hydrant', 'stop sign', 'parking meter', 'bench', 'bird', 'cat',
                    'dog', 'horse', 'sheep', 'cow', 'elephant', 'bear', 'zebra', 'giraffe', 'backpack',
                    'umbrella', 'handbag', 'tie', 'suitcase', 'frisbee', 'skis', 'snowboard', 'sports ball',
                    'kite', 'baseball bat', 'baseball glove', 'skateboard', 'surfboard', 'tennis racket',
                    'bottle', 'wine glass', 'cup', 'fork', 'knife', 'spoon', 'bowl', 'banana', 'apple',
                    'sandwich', 'orange', 'broccoli', 'carrot', 'hot dog', 'pizza', 'donut', 'cake',
                    'chair', 'couch', 'potted plant', 'bed', 'dining table', 'toilet', 'tv', 'laptop',
                    'mouse', 'remote', 'keyboard', 'cell phone', 'microwave', 'oven', 'toaster', 'sink',
                    'refrigerator', 'book', 'clock', 'vase', 'scissors', 'teddy bear', 'hair drier', 'toothbrush'
                ]
            
            print("✓ Object detection model loaded")
        except Exception as e:
            print(f"⚠️ Failed to load object detection model: {e}")
            return None, None
    
    return _object_net, _object_classes

def _normalize_name(name: str) -> str:
    return (name or '').strip().lower()

def _get_label_id(name: str):
    data = _load_face_labels()
    key = _normalize_name(name)
    if not key:
        return None, data
    if key in data['labels']:
        return data['labels'][key], data
    label_id = int(data.get('next_id', 1))
    data['labels'][key] = label_id
    data.setdefault('display', {})[str(label_id)] = name.strip()
    data['next_id'] = label_id + 1
    _save_face_labels(data)
    return label_id, data

def _get_label_name(label_id: int, data: dict) -> str:
    display = data.get('display', {})
    name = display.get(str(label_id))
    if name:
        return name
    for key, val in data.get('labels', {}).items():
        if val == label_id:
            return key.title()
    return 'Unknown'

def _collect_training_data():
    faces = []
    labels = []
    if not os.path.exists(FACE_DB_DIR):
        return faces, labels
    for fname in os.listdir(FACE_DB_DIR):
        if not fname.lower().endswith('.jpg'):
            continue
        parts = fname.split('_', 1)
        if not parts or not parts[0].isdigit():
            continue
        label_id = int(parts[0])
        fpath = os.path.join(FACE_DB_DIR, fname)
        img = cv2.imread(fpath, cv2.IMREAD_GRAYSCALE)
        if img is None:
            continue
        faces.append(img)
        labels.append(label_id)
    return faces, labels

def _train_face_model():
    if not HAS_CV2 or cv2 is None:
        return False, 'OpenCV not available'
    if not hasattr(cv2, 'face') or not hasattr(cv2.face, 'LBPHFaceRecognizer_create'):
        return False, 'OpenCV face module not available (opencv-contrib-python required)'
    faces, labels = _collect_training_data()
    if len(faces) == 0:
        return False, 'No training data'
    recognizer = cv2.face.LBPHFaceRecognizer_create()
    recognizer.train(faces, np.array(labels))
    recognizer.save(FACE_MODEL_FILE)
    return True, 'Model trained'

def _load_face_model():
    if not HAS_CV2 or cv2 is None:
        return None
    if not hasattr(cv2, 'face') or not hasattr(cv2.face, 'LBPHFaceRecognizer_create'):
        return None
    if not os.path.exists(FACE_MODEL_FILE):
        return None
    recognizer = cv2.face.LBPHFaceRecognizer_create()
    recognizer.read(FACE_MODEL_FILE)
    return recognizer

def _predict_face(face_gray):
    recognizer = _load_face_model()
    if recognizer is None:
        return 'Unknown', 0.0
    try:
        label_id, confidence = recognizer.predict(face_gray)
        data = _load_face_labels()
        name = _get_label_name(label_id, data)
        # LBPH: lower confidence is better
        if confidence > 80:
            return 'Unknown', round(float(1.0 - min(confidence / 120.0, 1.0)), 2)
        return name, round(float(1.0 - min(confidence / 120.0, 1.0)), 2)
    except Exception as e:
        print(f"Face predict error: {e}")
        return 'Unknown', 0.0

def _register_face_from_image(img, name: str):
    """Register a face from an image and train the model."""
    try:
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        face_cascade = cv2.CascadeClassifier(
            cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'
        )
        faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(60, 60))

        if len(faces) == 0:
            return ({'success': False, 'error': 'No face detected. Please use a clear face image.'}, 400)

        faces = sorted(faces, key=lambda f: f[2] * f[3], reverse=True)
        x, y, w, h = faces[0]
        face_roi = gray[y:y + h, x:x + w]
        face_roi = cv2.resize(face_roi, (200, 200))

        label_id, _ = _get_label_id(name)
        if label_id is None:
            return ({'success': False, 'error': 'Invalid name'}, 400)

        safe_name = secure_filename(name).replace('-', '_') or 'person'
        timestamp = datetime.utcnow().strftime('%Y%m%d%H%M%S')
        filename = f"{label_id}_{safe_name}_{timestamp}.jpg"
        filepath = os.path.join(FACE_DB_DIR, filename)
        cv2.imwrite(filepath, face_roi)

        trained, train_msg = _train_face_model()

        return ({
            'success': True,
            'name': name,
            'label_id': int(label_id),
            'faces_detected': int(len(faces)),
            'model_trained': trained,
            'message': train_msg if trained else f"Saved face. {train_msg}"
        }, 200)
    except Exception as e:
        print(f"Register face helper error: {e}")
        return ({'success': False, 'error': str(e)}, 500)

def init_tracing(flask_app: Flask) -> bool:
    """Initialize OpenTelemetry tracing for the web server."""
    try:
        from opentelemetry import trace
        from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
        from opentelemetry.instrumentation.flask import FlaskInstrumentor
        from opentelemetry.sdk.resources import Resource
        from opentelemetry.sdk.trace import TracerProvider
        from opentelemetry.sdk.trace.export import BatchSpanProcessor
        import importlib

        RequestsInstrumentor = importlib.import_module(
            "opentelemetry.instrumentation.requests"
        ).RequestsInstrumentor

        endpoint = os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "http://localhost:4318")
        service_name = os.getenv("OTEL_SERVICE_NAME", "dexaura-ui")

        resource = Resource.create({"service.name": service_name})
        provider = TracerProvider(resource=resource)
        trace.set_tracer_provider(provider)

        exporter = OTLPSpanExporter(endpoint=endpoint)
        provider.add_span_processor(BatchSpanProcessor(exporter))

        FlaskInstrumentor().instrument_app(flask_app)
        RequestsInstrumentor().instrument()
        return True
    except Exception as e:
        print(f"Warning: tracing disabled: {e}")
        return False

app = Flask(__name__, 
            static_folder=UI_DIR,
            static_url_path='',
            template_folder=UI_DIR)
app.config['SECRET_KEY'] = 'dexaura-secret-key'

tracing_enabled = init_tracing(app)

# Enable CORS manually
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type')
    response.headers.add('Access-Control-Allow-Methods', 'GET,POST,OPTIONS')
    return response

# Initialize Dexaura agent and response generator
agent = AgentController()
response_gen = ResponseGenerator()

# Store session data
sessions = {}

@app.route('/')
def index():
    """Serve the main UI"""
    return send_from_directory(UI_DIR, 'index.html')

@app.route('/<path:filename>')
def serve_static(filename):
    """Serve static files (CSS, JS, videos, etc.)"""
    return send_from_directory(UI_DIR, filename)

@app.route('/api/command', methods=['POST'])
def process_command():
    """Process a command from the UI"""
    try:
        data = request.json
        command = data.get('command', '')
        
        if not command:
            return jsonify({'error': 'No command provided'}), 400
        
        # Process the command
        result = execute_command(command)
        
        return jsonify(result)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/understand', methods=['POST'])
def analyze_understanding():
    """Analyze text understanding"""
    try:
        data = request.json
        text = data.get('text', '')
        
        if not text:
            return jsonify({'error': 'No text provided'}), 400
        
        # Get understanding analysis
        understanding = agent.understanding.understand(text)
        
        # Convert to serializable format
        result = {
            'intent': understanding['intent'],
            'confidence': float(understanding['confidence']),
            'sentiment': understanding['sentiment'],
            'entities': understanding.get('entities', {}),
            'understanding_quality': understanding.get('understanding_quality', 'unknown'),
            'alternatives': understanding.get('alternatives', [])[:3],
            'suggestions': understanding.get('suggestions', []),
            'temporal_context': understanding.get('temporal_context', {}),
        }
        
        return jsonify(result)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/stats', methods=['GET'])
def get_stats():
    """Get system statistics"""
    try:
        stats = agent.understanding.get_understanding_stats()
        
        # Get additional stats
        learning_stats = agent.get_stats()
        
        result = {
            'understanding': stats,
            'learning': learning_stats,
            'timestamp': datetime.now().isoformat()
        }
        
        return jsonify(result)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/teach', methods=['POST'])
def teach():
    """Teach JARVIS new knowledge"""
    try:
        data = request.json
        question = data.get('question', '')
        answer = data.get('answer', '')
        
        if not question or not answer:
            return jsonify({'error': 'Question and answer required'}), 400
        
        result = agent.understanding.learn_from_user(question, answer)
        
        return jsonify({'success': True, 'message': result})
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/knowledge', methods=['POST'])
def search_knowledge():
    """Search knowledge base with web search fallback for real-time queries"""
    try:
        data = request.json
        query = data.get('query', '')
        
        if not query:
            return jsonify({'error': 'Query required'}), 400
        
        # Try knowledge base first
        answer = agent.understanding.get_knowledge_answer(query)
        source = 'knowledge_base'
        
        # If no knowledge found and web_search is available, try web search
        if not answer and web_search and search_for_price:
            query_lower = query.lower()
            
            # Check if it's a price query
            if any(x in query_lower for x in ['price', 'cost', 'how much', 'gold', 'stock', 'crypto', 'bitcoin', 'ethereum']):
                try:
                    web_result = search_for_price(query)
                    if web_result.get('success'):
                        if 'price' in web_result:
                            answer = f"Current Price: {web_result['price']} {web_result.get('unit', '')}. Source: {web_result.get('source', 'Web Search')}"
                        elif 'rate' in web_result:
                            answer = f"Exchange Rate: 1 {web_result['from']} = {web_result['rate']} {web_result['to']}. Source: {web_result.get('source', 'Web Search')}"
                        source = 'web_search'
                except Exception as web_err:
                    print(f"Web search error: {web_err}")
            
            # Try general web search if not a price query or price search failed
            if not answer:
                try:
                    web_result = web_search.search_general(query)
                    if web_result.get('success'):
                        results = web_result.get('results', [])
                        if results:
                            answer = "\n".join(results[:2])  # First 2 results
                            source = 'web_search'
                except Exception as web_err:
                    print(f"Web search error: {web_err}")
        
        return jsonify({
            'success': True,
            'answer': answer if answer else 'No information found. Try teaching me this knowledge.',
            'source': source
        })
    
    except Exception as e:
        print(f"Knowledge endpoint error: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

@app.route('/api/mood', methods=['POST'])
def analyze_mood():
    """Analyze user mood from a camera snapshot using advanced emotion detection."""
    try:
        if not HAS_CV2:
            return jsonify({
                'success': False,
                'error': 'Mood detection requires OpenCV. Please install opencv-python.'
            }), 400

        data = request.json or {}
        image_data = data.get('image')
        if not image_data:
            return jsonify({'success': False, 'error': 'Image data required'}), 400

        img = _decode_image_from_data_url(image_data)
        if img is None:
            return jsonify({'success': False, 'error': 'Invalid image data'}), 400

        # Enhance image quality
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        # Apply histogram equalization for better face detection
        gray = cv2.equalizeHist(gray)
        
        # Load multiple cascade classifiers for robust detection
        face_cascade = cv2.CascadeClassifier(
            cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'
        )
        alt_face_cascade = cv2.CascadeClassifier(
            cv2.data.haarcascades + 'haarcascade_frontalface_alt.xml'
        )
        smile_cascade = cv2.CascadeClassifier(
            cv2.data.haarcascades + 'haarcascade_smile.xml'
        )
        eye_cascade = cv2.CascadeClassifier(
            cv2.data.haarcascades + 'haarcascade_eye.xml'
        )

        # Try multiple face detection strategies
        faces = face_cascade.detectMultiScale(gray, scaleFactor=1.15, minNeighbors=4, minSize=(50, 50))
        if len(faces) == 0:
            faces = alt_face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(60, 60))

        if len(faces) == 0:
            return jsonify({
                'success': True,
                'mood': 'unknown',
                'confidence': 0.0,
                'face_count': 0,
                'smile_count': 0,
                'eye_count': 0,
                'message': 'No face detected. Please ensure good lighting and face the camera.'
            })

        smile_count = 0
        eye_count = 0
        face_metrics = []
        
        for (x, y, w, h) in faces:
            roi_gray = gray[y:y + h, x:x + w]
            roi_color = img[y:y + h, x:x + w]
            
            # Detect smiles
            smiles = smile_cascade.detectMultiScale(roi_gray, scaleFactor=1.8, minNeighbors=20, minSize=(25, 25))
            if len(smiles) > 0:
                smile_count += len(smiles)
            
            # Detect eyes for additional context
            eyes = eye_cascade.detectMultiScale(roi_gray, scaleFactor=1.1, minNeighbors=5, minSize=(15, 15))
            if len(eyes) > 0:
                eye_count += len(eyes)
            
            # Analyze brightness in face region for additional mood hints
            face_brightness = np.mean(roi_gray)
            face_metrics.append({
                'brightness': face_brightness,
                'smiles': len(smiles),
                'eyes': len(eyes)
            })

        # Advanced mood determination
        mood = 'neutral'
        confidence = 0.55
        
        if smile_count > 0:
            mood = 'happy'
            # Higher confidence with multiple smile detections
            confidence = min(0.95, 0.65 + 0.15 * min(smile_count / len(faces), 2))
        elif eye_count >= len(faces) * 2:
            # Eyes detected but no smile - could be focused/concentrating
            mood = 'focused'
            confidence = 0.70
        else:
            # Check if face is visible but neutral
            avg_brightness = np.mean([m['brightness'] for m in face_metrics])
            if avg_brightness < 80:
                mood = 'contemplative'
                confidence = 0.60
            else:
                mood = 'neutral'
                confidence = 0.55

        return jsonify({
            'success': True,
            'mood': mood,
            'confidence': round(confidence, 2),
            'face_count': int(len(faces)),
            'smile_count': int(smile_count),
            'eye_count': int(eye_count),
            'message': f'{mood.capitalize()} expression detected'
        })

    except Exception as e:
        print(f"Mood analysis error: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({'success': False, 'error': str(e)}), 500

def _detect_hand_gesture(hand_landmarks, handedness_str):
    """
    Detect hand gestures from MediaPipe landmarks.
    Returns gesture type and confidence.
    """
    if not hand_landmarks or not hasattr(hand_landmarks, 'landmark'):
        return 'unknown', 0.0
    
    lm = hand_landmarks.landmark
    
    # Helper function to check if finger is extended
    def is_finger_extended(pip, dip):
        return lm[pip].y < lm[dip].y
    
    # Get finger extension states
    thumb_extended = lm[3].x < lm[4].x if handedness_str == "Right" else lm[3].x > lm[4].x
    index_extended = is_finger_extended(6, 7)
    middle_extended = is_finger_extended(10, 11)
    ring_extended = is_finger_extended(14, 15)
    pinky_extended = is_finger_extended(18, 19)
    
    # Hand center
    palm_center = np.array([lm[9].x, lm[9].y])
    
    # Thumb tip position
    thumb_tip = np.array([lm[4].x, lm[4].y])
    
    # Index tip position
    index_tip = np.array([lm[8].x, lm[8].y])
    
    # Peace sign: Index and middle extended, others folded
    if index_extended and middle_extended and not ring_extended and not pinky_extended:
        return 'peace', 0.85
    
    # Thumbs up: Thumb extended upward, others folded
    if thumb_extended and not index_extended and not middle_extended and not ring_extended and not pinky_extended:
        if lm[4].y < lm[3].y:  # Thumb pointing up
            return 'thumbs_up', 0.85
    
    # Thumbs down: Thumb extended downward
    if thumb_extended and not index_extended and not middle_extended and not ring_extended and not pinky_extended:
        if lm[4].y > lm[3].y:  # Thumb pointing down
            return 'thumbs_down', 0.85
    
    # OK sign: Thumb and index close together, others extended
    thumb_index_dist = np.linalg.norm(thumb_tip - index_tip)
    if thumb_index_dist < 0.05 and middle_extended and ring_extended and pinky_extended:
        return 'ok_sign', 0.80
    
    # Pointing: Index extended, others folded
    if index_extended and not middle_extended and not ring_extended and not pinky_extended:
        return 'pointing', 0.85
    
    # Open palm: All fingers extended
    if index_extended and middle_extended and ring_extended and pinky_extended and thumb_extended:
        return 'open_palm', 0.80
    
    # Rock sign: Index and pinky extended, middle and ring folded
    if index_extended and pinky_extended and not middle_extended and not ring_extended:
        return 'rock_sign', 0.85
    
    # Call me: Pinky and thumb extended, others folded
    if pinky_extended and thumb_extended and not index_extended and not middle_extended and not ring_extended:
        return 'call_me', 0.80
    
    # Fist: All fingers folded
    if not index_extended and not middle_extended and not ring_extended and not pinky_extended and not thumb_extended:
        return 'fist', 0.85
    
    return 'neutral_hand', 0.60

@app.route('/api/gestures', methods=['POST'])
def detect_gestures():
    """Detect hand gestures from camera snapshot using MediaPipe."""
    try:
        if not HAS_CV2:
            return jsonify({
                'success': False,
                'error': 'Gesture detection requires OpenCV. Please install opencv-python.'
            }), 400

        mp_local = _get_mediapipe()
        if not mp_local:
            return jsonify({
                'success': False,
                'error': 'Gesture detection requires MediaPipe. Please install mediapipe.'
            }), 400

        data = request.json or {}
        image_data = data.get('image')
        if not image_data:
            return jsonify({'success': False, 'error': 'Image data required'}), 400

        img = _decode_image_from_data_url(image_data)
        if img is None:
            return jsonify({'success': False, 'error': 'Invalid image data'}), 400

        # Initialize MediaPipe Hands
        mp_hands = mp_local.solutions.hands
        hands = mp_hands.Hands(
            static_image_mode=True,
            max_num_hands=2,
            min_detection_confidence=0.5,
            min_tracking_confidence=0.5
        )

        # Convert BGR to RGB for MediaPipe
        rgb_img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        results = hands.process(rgb_img)

        hands.close()

        if not results.multi_hand_landmarks:
            return jsonify({
                'success': True,
                'hand_count': 0,
                'gestures': [],
                'message': 'No hands detected. Please position your hand in front of the camera.'
            })

        gestures = []
        for hand_landmarks, handedness in zip(results.multi_hand_landmarks, results.multi_handedness):
            handedness_str = handedness.classification[0].label
            gesture_type, confidence = _detect_hand_gesture(hand_landmarks, handedness_str)
            
            gestures.append({
                'hand': handedness_str,
                'gesture': gesture_type,
                'confidence': round(confidence, 2)
            })

        return jsonify({
            'success': True,
            'hand_count': len(gestures),
            'gestures': gestures,
            'message': f'{len(gestures)} hand(s) detected with gesture(s) identified'
        })

    except Exception as e:
        print(f"Gesture detection error: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/register-person', methods=['POST'])
def register_person():
    """Register a person's face with a name for future recognition."""
    try:
        if not HAS_CV2:
            return jsonify({
                'success': False,
                'error': 'Face registration requires OpenCV. Please install opencv-python.'
            }), 400

        data = request.json or {}
        image_data = data.get('image')
        name = (data.get('name') or '').strip()

        if not name:
            return jsonify({'success': False, 'error': 'Name is required'}), 400
        if not image_data:
            return jsonify({'success': False, 'error': 'Image data required'}), 400

        img = _decode_image_from_data_url(image_data)
        if img is None:
            return jsonify({'success': False, 'error': 'Invalid image data'}), 400

        result, status = _register_face_from_image(img, name)
        return jsonify(result), status

    except Exception as e:
        print(f"Register person error: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/register-person-file', methods=['POST'])
def register_person_file():
    """Register a person's face using an uploaded image file."""
    try:
        if not HAS_CV2:
            return jsonify({
                'success': False,
                'error': 'Face registration requires OpenCV. Please install opencv-python.'
            }), 400

        name = (request.form.get('name') or '').strip()
        if not name:
            return jsonify({'success': False, 'error': 'Name is required'}), 400

        if 'image' not in request.files:
            return jsonify({'success': False, 'error': 'Image file required'}), 400

        file = request.files['image']
        if not file or file.filename == '':
            return jsonify({'success': False, 'error': 'Empty file'}), 400

        img = _decode_image_from_bytes(file.read())
        if img is None:
            return jsonify({'success': False, 'error': 'Invalid image file'}), 400

        result, status = _register_face_from_image(img, name)
        return jsonify(result), status

    except Exception as e:
        print(f"Register person file error: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/retrain-faces', methods=['POST'])
def retrain_faces():
    """Retrain face recognition model from all stored face images."""
    try:
        if not HAS_CV2:
            return jsonify({
                'success': False,
                'error': 'Face training requires OpenCV. Please install opencv-python.'
            }), 400

        trained, message = _train_face_model()
        if not trained:
            return jsonify({'success': False, 'error': message}), 400

        faces, labels = _collect_training_data()
        return jsonify({
            'success': True,
            'message': message,
            'samples': int(len(faces)),
            'identities': int(len(set(labels)))
        })

    except Exception as e:
        print(f"Retrain faces error: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/detect-objects', methods=['POST'])
def detect_objects():
    """Detect objects in an image using MobileNet SSD."""
    try:
        data = request.get_json()
        if not data or 'image' not in data:
            return jsonify({'error': 'No image data provided'}), 400
        
        # Decode the image
        img = _decode_image_from_data_url(data['image'])
        if img is None:
            return jsonify({'error': 'Failed to decode image'}), 400
        
        # Get object detection model
        net, classes = _get_object_detection_model()
        if net is None or classes is None:
            return jsonify({
                'error': 'Object detection model not available',
                'message': 'Please download the model files. See server logs for instructions.'
            }), 503
        
        # Prepare image for detection
        height, width = img.shape[:2]
        blob = cv2.dnn.blobFromImage(img, size=(300, 300), swapRB=True, crop=False)
        
        # Run detection
        net.setInput(blob)
        detections = net.forward()
        
        # Process detections
        detected_objects = []
        annotated_img = img.copy()
        
        min_confidence = 0.35
        try:
            if 'min_confidence' in data:
                min_confidence = float(data.get('min_confidence', min_confidence))
        except Exception:
            min_confidence = 0.35
        min_confidence = max(0.1, min(0.95, min_confidence))

        for i in range(detections.shape[2]):
            confidence = detections[0, 0, i, 2]
            
            class_id = int(detections[0, 0, i, 1])
            class_name = classes[class_id - 1] if class_id > 0 and class_id <= len(classes) else f"Class {class_id}"
            
            # Lower threshold for person detection (more sensitive for humans)
            threshold = 0.25 if class_name == 'person' else min_confidence
            
            # Filter by confidence
            if confidence > threshold:
                
                # Get bounding box coordinates
                box = detections[0, 0, i, 3:7] * np.array([width, height, width, height])
                x1, y1, x2, y2 = box.astype(int)
                
                # Add to detected objects list
                detected_objects.append({
                    'class': class_name,
                    'confidence': float(confidence),
                    'bbox': [int(x1), int(y1), int(x2), int(y2)]
                })
                
                # Use different colors: cyan for person, green for others
                color = (255, 255, 0) if class_name == 'person' else (0, 255, 0)  # Cyan for person, Green for others
                thickness = 3 if class_name == 'person' else 2  # Thicker box for person
                cv2.rectangle(annotated_img, (x1, y1), (x2, y2), color, thickness)
                
                # Draw label with background
                label = f"{class_name}: {confidence*100:.1f}%"
                label_size, baseline = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.5, 1)
                y1_label = max(y1, label_size[1] + 10)
                cv2.rectangle(annotated_img, (x1, y1_label - label_size[1] - 10),
                            (x1 + label_size[0], y1_label + baseline - 10), color, cv2.FILLED)
                cv2.putText(annotated_img, label, (x1, y1_label - 7),
                           cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0), 1)
        
        # Convert annotated image to data URL
        annotated_data_url = _encode_image_to_data_url(annotated_img)
        
        return jsonify({
            'objects': detected_objects,
            'count': len(detected_objects),
            'annotated_image': annotated_data_url
        })
    
    except Exception as e:
        print(f"Error in detect_objects: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

@app.route('/api/snap-analyze', methods=['POST'])
def snap_analyze():
    """Return a Snapchat-style annotated image with faces, mood, people count, and names."""
    try:
        if not HAS_CV2:
            return jsonify({
                'success': False,
                'error': 'Snapshot analysis requires OpenCV. Please install opencv-python.'
            }), 400

        data = request.json or {}
        image_data = data.get('image')
        if not image_data:
            return jsonify({'success': False, 'error': 'Image data required'}), 400

        img = _decode_image_from_data_url(image_data)
        if img is None:
            return jsonify({'success': False, 'error': 'Invalid image data'}), 400

        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        gray = cv2.equalizeHist(gray)

        face_cascade = cv2.CascadeClassifier(
            cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'
        )
        smile_cascade = cv2.CascadeClassifier(
            cv2.data.haarcascades + 'haarcascade_smile.xml'
        )

        faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(60, 60))

        annotated = img.copy()
        people_count = int(len(faces))

        smile_count = 0
        recognized_names = []
        face_details = []

        for (x, y, w, h) in faces:
            roi_gray = gray[y:y + h, x:x + w]
            roi_gray_resized = cv2.resize(roi_gray, (200, 200))

            smiles = smile_cascade.detectMultiScale(roi_gray, scaleFactor=1.7, minNeighbors=20)
            if len(smiles) > 0:
                smile_count += len(smiles)

            name, conf = _predict_face(roi_gray_resized)
            recognized_names.append(name)

            label = f"{name}"
            if conf > 0:
                label += f" ({int(conf * 100)}%)"

            cv2.rectangle(annotated, (x, y), (x + w, y + h), (0, 255, 255), 2)
            cv2.putText(
                annotated,
                label,
                (x, y - 8 if y - 8 > 10 else y + h + 20),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.6,
                (0, 255, 255),
                2
            )

            face_details.append({
                'box': [int(x), int(y), int(w), int(h)],
                'name': name,
                'confidence': conf
            })

        if people_count == 0:
            mood = 'unknown'
            mood_confidence = 0.0
        elif smile_count > 0:
            mood = 'happy'
            mood_confidence = min(0.95, 0.65 + 0.1 * min(smile_count, 3))
        else:
            mood = 'neutral'
            mood_confidence = 0.55

        overlay_text = f"People: {people_count} | Mood: {mood.title()} ({int(mood_confidence * 100)}%)"
        cv2.rectangle(annotated, (10, 10), (10 + 520, 50), (0, 0, 0), -1)
        cv2.putText(
            annotated,
            overlay_text,
            (20, 40),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.7,
            (0, 255, 255),
            2
        )

        image_url = _encode_image_to_data_url(annotated)

        return jsonify({
            'success': True,
            'image_url': image_url,
            'faces': face_details,
            'people_count': people_count,
            'mood': mood,
            'mood_confidence': round(mood_confidence, 2),
            'names': recognized_names
        })

    except Exception as e:
        print(f"Snapshot analysis error: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/mode', methods=['POST'])
def toggle_mode():
    """Toggle online/offline mode"""
    try:
        agent.toggle_mode()
        mode = 'online' if agent.is_online else 'offline'
        
        return jsonify({'success': True, 'mode': mode})
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/generate-image', methods=['POST'])
def generate_image_endpoint():
    """Generate an AI image from text prompt"""
    try:
        print(f"[IMAGE] Received generate request")
        data = request.json
        prompt = data.get('prompt', '')
        style = data.get('style', 'default')
        size = data.get('size', '1024x1024')
        
        print(f"[IMAGE] Prompt: {prompt}, Style: {style}, Size: {size}")
        
        if not prompt:
            print("[IMAGE] ERROR: No prompt provided")
            return jsonify({'error': 'Prompt required'}), 400
        
        print("[IMAGE] Calling agent.generate_image()...")
        result = agent.generate_image(prompt, style, size)
        
        print(f"[IMAGE] Result: {result}")
        return jsonify(result)
    
    except Exception as e:
        print(f"[IMAGE] ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e), 'success': False}), 500

@app.route('/api/image-styles', methods=['GET'])
def get_image_styles():
    """Get list of supported image styles"""
    try:
        styles = agent.image_generator.get_supported_styles()
        sizes = agent.image_generator.get_supported_sizes()
        
        return jsonify({
            'success': True,
            'styles': styles,
            'sizes': sizes
        })
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/image-history', methods=['GET'])
def get_image_history():
    """Get image generation history"""
    try:
        limit = int(request.args.get('limit', 10))
        history = agent.image_generator.get_history(limit)
        
        return jsonify({
            'success': True,
            'history': history
        })
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

def allowed_file(filename):
    """Check if file extension is allowed"""
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/api/upload-songs', methods=['POST'])
def upload_songs():
    """Upload custom songs to JARVIS"""
    try:
        if 'songs' not in request.files:
            return jsonify({'error': 'No songs provided'}), 400
        
        files = request.files.getlist('songs')
        uploaded_songs = []
        
        for file in files:
            if file and file.filename and allowed_file(file.filename):
                # Secure the filename
                filename = secure_filename(file.filename)
                
                # Save the file
                filepath = os.path.join(SONGS_DIR, filename)
                file.save(filepath)
                
                # Get song title (filename without extension)
                title = os.path.splitext(filename)[0].replace('_', ' ').title()
                
                uploaded_songs.append({
                    'title': title,
                    'filename': filename
                })
        
        if not uploaded_songs:
            return jsonify({'error': 'No valid audio files uploaded'}), 400
        
        return jsonify({
            'success': True,
            'songs': uploaded_songs,
            'message': f'{len(uploaded_songs)} song(s) uploaded successfully'
        })
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/songs/<filename>')
def serve_song(filename):
    """Serve uploaded song files"""
    return send_from_directory(SONGS_DIR, filename)

def execute_chained_commands(command):
    """Execute multiple commands separated by 'and'"""
    # Split by 'and' (case-insensitive)
    import re
    cmd_list = re.split(r'\s+and\s+', command, flags=re.IGNORECASE)
    
    if not cmd_list or len(cmd_list) < 2:
        # No valid chain found, treat as single command
        return execute_single_command(command)
    
    results = []
    messages = []
    all_success = True
    
    # Execute each command in sequence
    for i, cmd in enumerate(cmd_list, 1):
        cmd = cmd.strip()
        if not cmd:
            continue
        
        result = execute_single_command(cmd)
        results.append(result)
        
        # Track success/failure
        if not result.get('success', True):
            all_success = False
            messages.append(f"❌ Step {i} failed: {result.get('response', 'Unknown error')}")
        else:
            messages.append(f"✅ Step {i}: {result.get('response', 'Completed')}")
    
    # Combine all results
    combined_response = "\n".join(messages)
    
    return {
        'success': all_success,
        'response': combined_response,
        'steps': len(results),
        'results': results,
        'type': 'chained_command'
    }

def execute_single_command(command):
    """Execute a single command (helper for chained execution)"""
    parts = command.strip().split()
    
    if not parts:
        return {'error': 'Empty command', 'success': False}
    
    cmd = parts[0].lower()
    args = parts[1:]
    
    # Call the main execution logic with this specific command
    # We'll refactor to use a helper that doesn't recursively call execute_command
    return _execute_cmd_logic(cmd, args, command)

def execute_command(command):
    """Execute a JARVIS command and return the result"""
    # Check for chained commands (commands separated by "and")
    if ' and ' in command.lower():
        return execute_chained_commands(command)
    
    return _execute_cmd_logic(None, None, command)

def _execute_cmd_logic(cmd, args, full_command):
    """Core command execution logic"""
    # If cmd/args not provided, parse from full_command
    if cmd is None or args is None:
        parts = full_command.strip().split()
        if not parts:
            return {'error': 'Empty command'}
        cmd = parts[0].lower()
        args = parts[1:]
    
    try:
        if cmd == 'help':
            return {
                'success': True,
                'response': get_help_text(),
                'type': 'help'
            }
        
        elif cmd == 'understand':
            text = ' '.join(args)
            understanding = agent.understanding.understand(text)
            return {
                'success': True,
                'understanding': {
                    'intent': understanding['intent'],
                    'confidence': float(understanding['confidence']),
                    'sentiment': understanding['sentiment'],
                    'entities': understanding.get('entities', {}),
                    'quality': understanding.get('understanding_quality', 'unknown')
                },
                'response': format_understanding_response(understanding),
                'type': 'understanding'
            }
        
        elif cmd == 'debug':
            text = ' '.join(args)
            debug_info = agent.understanding.debug_understanding(text)
            return {
                'success': True,
                'debug': debug_info,
                'response': format_debug_response(debug_info),
                'type': 'debug'
            }
        
        elif cmd == 'understanding-stats':
            stats = agent.understanding.get_understanding_stats()
            return {
                'success': True,
                'stats': stats,
                'response': format_stats_response(stats),
                'type': 'stats'
            }
        
        elif cmd == 'teach':
            if '=' not in full_command:
                return {'error': 'Use format: teach <question> = <answer>', 'success': False}
            
            parts = full_command.split('=', 1)
            question = parts[0].replace('teach', '').strip()
            answer = parts[1].strip()
            result = agent.understanding.learn_from_user(question, answer)
            
            return {
                'success': True,
                'response': f'✅ {result}',
                'type': 'teach'
            }
        
        elif cmd == 'knowledge':
            query = ' '.join(args)
            answer = agent.understanding.get_knowledge_answer(query)
            source = 'knowledge_base'
            
            # If no knowledge found and web_search is available, try web search
            if not answer and web_search and search_for_price:
                query_lower = query.lower()
                
                # Check if it's a price query
                if any(x in query_lower for x in ['price', 'cost', 'gold', 'stock', 'crypto', 'bitcoin']):
                    try:
                        web_result = search_for_price(query)
                        if web_result.get('success'):
                            if 'price' in web_result:
                                answer = f"Current Price: {web_result['price']} {web_result.get('unit', '')} | Source: {web_result.get('source', 'Web')}"
                            elif 'rate' in web_result:
                                answer = f"Rate: 1 {web_result['from']} = {web_result['rate']} {web_result['to']} | Source: {web_result.get('source', 'Web')}"
                            source = 'web_search'
                    except Exception as e:
                        print(f"Price search error: {e}")
            
            # Try general search if still no answer
            if not answer and web_search:
                try:
                    web_result = web_search.search_general(query)
                    if web_result.get('success'):
                        results = web_result.get('results', [])
                        if results:
                            answer = results[0]  # First result
                            source = 'web_search'
                except Exception as e:
                    print(f"General search error: {e}")
            
            return {
                'success': True,
                'response': answer if answer else 'No information found. Try teaching me this knowledge.',
                'source': source,
                'type': 'knowledge'
            }
        
        elif cmd == 'mode':
            agent.toggle_mode()
            mode = 'online' if agent.is_online else 'offline'
            return {
                'success': True,
                'response': f'🔄 Switched to {mode} mode',
                'mode': mode,
                'type': 'mode'
            }
        
        elif cmd == 'stats':
            stats = agent.get_stats()
            return {
                'success': True,
                'stats': stats,
                'response': format_learning_stats(stats),
                'type': 'learning_stats'
            }
        
        elif cmd == 'docs':
            docs = agent.document_ingestion.list_documents()
            return {
                'success': True,
                'documents': docs,
                'response': f'📚 Found {len(docs)} documents',
                'type': 'documents'
            }
        
        elif cmd == 'generate' or cmd == 'create-image' or cmd == 'draw':
            prompt = ' '.join(args)
            if not prompt:
                return {'error': 'Please provide a description. Usage: generate <description>'}
            
            result = agent.generate_image(prompt)
            if result['success']:
                return {
                    'success': True,
                    'response': result['message'],
                    'image_url': result['image_url'],
                    'prompt': result['prompt'],
                    'type': 'image_generation'
                }
            else:
                return {
                    'success': False,
                    'response': result['message'],
                    'type': 'error'
                }
        
        elif cmd == 'play' or cmd == 'music':
            return {
                'success': True,
                'response': '🎵 Playing music...',
                'action': 'play_music',
                'type': 'music_control'
            }
        
        elif cmd == 'pause':
            return {
                'success': True,
                'response': '⏸️ Music paused',
                'action': 'pause_music',
                'type': 'music_control'
            }
        
        elif cmd == 'next' or cmd == 'skip':
            return {
                'success': True,
                'response': '⏭️ Next song',
                'action': 'next_song',
                'type': 'music_control'
            }
        
        elif cmd == 'previous' or cmd == 'prev' or cmd == 'back':
            return {
                'success': True,
                'response': '⏮️ Previous song',
                'action': 'previous_song',
                'type': 'music_control'
            }
        
        elif cmd == 'songs' or cmd == 'playlist' or cmd == 'music' or (cmd == 'show' and ('playlist' in full_command.lower() or 'songs' in full_command.lower())):
            return {
                'success': True,
                'response': '🎵 Opening songs...',
                'action': 'show_playlist',
                'type': 'music_control'
            }
        
        elif cmd == 'upload' or (cmd == 'add' and ('song' in full_command.lower() or 'music' in full_command.lower())):
            return {
                'success': True,
                'response': '📤 Click the upload button to add songs...',
                'action': 'upload_song',
                'type': 'music_control'
            }
        
        elif cmd == 'stop':
            return {
                'success': True,
                'response': '⏹️ Music stopped',
                'action': 'pause_music',
                'type': 'music_control'
            }
        
        elif cmd == 'open':
            # Open file, folder, or application
            file_path = ' '.join(args) if args else ''
            
            if not file_path or file_path.lower() in ['filemanager', 'file manager', 'explorer', 'files']:
                # Open file manager/explorer
                import os
                import subprocess
                import platform
                
                try:
                    if platform.system() == 'Windows':
                        subprocess.Popen('explorer')
                    elif platform.system() == 'Darwin':  # macOS
                        subprocess.Popen(['open', '.'])
                    else:  # Linux
                        subprocess.Popen(['xdg-open', '.'])
                    
                    return {
                        'success': True,
                        'response': '📂 Opening file manager...',
                        'type': 'file_open'
                    }
                except Exception as e:
                    return {
                        'success': False,
                        'response': f'❌ Could not open file manager: {str(e)}',
                        'type': 'file_error'
                    }
            else:
                # Check if it looks like a file (contains . or / or \)
                if '.' in file_path or '/' in file_path or '\\' in file_path:
                    # Try to open as file
                    success, message = agent.file_handler.open_file(file_path)
                    return {
                        'success': success,
                        'response': message,
                        'type': 'file_open'
                    }
                else:
                    # Try to launch as application
                    success, message = agent.file_handler.launch_application(file_path)
                    return {
                        'success': success,
                        'response': message,
                        'type': 'app_launch'
                    }
        
        elif cmd == 'create':
            # Create a new file - usage: create <filepath> [<content>]
            if not args:
                return {'error': 'Please provide a file path. Usage: create <filepath> [content...]'}
            
            file_path = args[0]
            content = ' '.join(args[1:]) if len(args) > 1 else ''
            
            success, message = agent.file_handler.create_file(file_path, content)
            return {
                'success': success,
                'response': message,
                'type': 'file_create'
            }
        
        elif cmd == 'read':
            # Read file contents - usage: read <filepath>
            if not args:
                return {'error': 'Please provide a file path. Usage: read <filepath>'}
            
            file_path = ' '.join(args)
            success, content = agent.file_handler.read_file(file_path)
            
            if success:
                # Limit content display if too long
                if len(content) > 5000:
                    content = content[:5000] + f"\n\n... (truncated, {len(content) - 5000} more characters)"
                
                return {
                    'success': True,
                    'response': f'📖 File contents:\n\n```\n{content}\n```',
                    'type': 'file_read'
                }
            else:
                return {
                    'success': False,
                    'response': content,  # Error message from read_file
                    'type': 'file_error'
                }
        
        elif cmd == 'edit':
            # Edit file - usage: edit <filepath> <operation> [args]
            if len(args) < 2:
                return {'error': 'Usage: edit <filepath> <operation> [args]'}
            
            file_path = args[0]
            operation = args[1]
            operation_args = args[2:]
            
            success, message = agent.file_handler.edit_file(
                file_path, 
                operation,
                content=' '.join(operation_args) if operation_args else None
            )
            
            return {
                'success': success,
                'response': message,
                'type': 'file_edit'
            }
        
        elif cmd == 'delete':
            # Delete file or folder - usage: delete <filepath>
            if not args:
                return {'error': 'Please provide a file path. Usage: delete <filepath>'}
            
            file_path = ' '.join(args)
            
            # Try file first, then folder
            success, message = agent.file_handler.delete_file(file_path)
            if not success and 'not a file' in message.lower():
                success, message = agent.file_handler.delete_folder(file_path)
            
            return {
                'success': success,
                'response': message,
                'type': 'file_delete'
            }
        
        elif cmd == 'list':
            # List files in a directory - usage: list [directory] [--recursive]
            directory = args[0] if args else '.'
            recursive = '--recursive' in args or '-r' in args
            
            success, files = agent.file_handler.list_files(directory, recursive)
            
            if success:
                file_list = '\n'.join([f'📄 {f}' for f in files[:50]])
                if len(files) > 50:
                    file_list += f'\n\n... and {len(files) - 50} more files'
                
                return {
                    'success': True,
                    'response': f'📁 Files in {directory}:\n\n{file_list}',
                    'type': 'file_list'
                }
            else:
                return {
                    'success': False,
                    'response': files,  # Error message
                    'type': 'file_error'
                }
        
        elif cmd == 'apps' or cmd == 'applications' or cmd == 'list-apps':
            # List all available applications on the system
            success, apps = agent.file_handler.list_applications()
            
            if success and apps:
                # Format app list (show first 20)
                app_list = '\n'.join([f"🚀 {app['name']}" for app in apps[:20]])
                remaining = len(apps) - 20
                if remaining > 0:
                    app_list += f"\n\n... and {remaining} more applications"
                
                return {
                    'success': True,
                    'response': f"📱 Installed Applications ({len(apps)} found):\n\n{app_list}",
                    'apps_count': len(apps),
                    'apps': apps,
                    'type': 'applications_list'
                }
            else:
                return {
                    'success': False,
                    'response': '❌ Could not retrieve applications list',
                    'type': 'error'
                }
        
        elif cmd == 'launch' or cmd == 'run':
            # Launch a specific application - usage: launch <app_name>
            if not args:
                return {
                    'error': 'Please specify app name. Usage: launch <app_name>'
                }
            
            app_name = ' '.join(args)
            success, message = agent.file_handler.launch_application(app_name)
            
            return {
                'success': success,
                'response': message,
                'app_name': app_name,
                'type': 'app_launch'
            }
        
        elif cmd == 'random-app' or cmd == 'random' or cmd == 'surprise-me':
            # Launch a random application
            success, message = agent.file_handler.launch_random_application()
            
            return {
                'success': success,
                'response': message,
                'type': 'random_app'
            }
        
        elif cmd == 'search':
            # Web search - delegate to understanding module
            query = ' '.join(args)
            if not query:
                return {'error': 'Please provide a search query'}
            
            # Use understanding module to perform search
            result = agent.understanding.understand(f'search for {query}')
            return {
                'success': True,
                'response': f'🔍 Search results for "{query}":\n(Connect to browser for live results)',
                'understanding': result,
                'type': 'web_search'
            }
        
        else:
            # Natural language processing
            understanding = agent.understanding.understand(full_command)
            intent = understanding.get('intent', 'unknown')
            confidence = understanding.get('confidence', 0.0)
            
            # Generate contextual response
            response = response_gen.generate_contextual_response(understanding)
            
            # Try to get knowledge answer for questions
            if intent in ['question', 'learning_query', 'web_search']:
                knowledge_answer = agent.understanding.get_knowledge_answer(full_command)
                if knowledge_answer:
                    response = response_gen.generate_response('question', {
                        'type': 'technical' if 'java' in full_command.lower() or 'code' in full_command.lower() else 'general',
                        'answer': knowledge_answer
                    })
                    return {
                        'success': True,
                        'response': response,
                        'understanding': understanding,
                        'type': 'knowledge_answer'
                    }
            
            # Check if low confidence - baby mode
            if confidence < 0.5:
                response += "\n\n💡 Tip: You can teach me by typing: teach <question> = <answer>"
                return {
                    'success': True,
                    'response': response,
                    'understanding': understanding,
                    'type': 'low_confidence'
                }
            
            # Enhance response with personality
            response = response_gen.enhance_response_with_personality(response, understanding)
            
            # Default response
            return {
                'success': True,
                'response': f"💭 I understand you want to: {understanding['intent']}",
                'understanding': understanding,
                'type': 'general'
            }
    
    except Exception as e:
        return {
            'success': False,
            'error': str(e),
            'type': 'error'
        }

def get_help_text():
    """Get formatted help text"""
    return """
🤖 <strong>JARVIS Commands:</strong>

<strong>File & Application Operations:</strong>
• <code>open &lt;file/folder&gt;</code> - Open files or file manager
• <code>create &lt;file&gt;</code> - Create new file
• <code>read &lt;file&gt;</code> - Read file contents
• <code>edit &lt;file&gt;</code> - Edit file
• <code>delete &lt;file&gt;</code> - Delete file
• <code>list [folder]</code> - List directory contents
• <code>apps</code> - List installed applications
• <code>launch &lt;app&gt;</code> - Launch an application
• <code>random-app</code> - Launch random application

<strong>Understanding & Intelligence:</strong>
• <code>understand &lt;text&gt;</code> - Analyze text understanding
• <code>debug &lt;text&gt;</code> - Deep debugging information
• <code>understanding-stats</code> - Performance statistics

<strong>Knowledge Management:</strong>
• <code>knowledge &lt;query&gt;</code> - Search knowledge base
• <code>teach &lt;question&gt; = &lt;answer&gt;</code> - Teach JARVIS
• <code>docs</code> - List documents

<strong>Learning & Memory:</strong>
• <code>stats</code> - Self-learning statistics
• <code>mode</code> - Toggle online/offline

<strong>Or just chat naturally! I understand 25+ intent types.</strong>
"""

def format_understanding_response(u):
    """Format understanding analysis"""
    response = f"""
🧠 <strong>Understanding Analysis:</strong>

• <strong>Intent:</strong> {u['intent']} ({u['confidence']:.0%})
• <strong>Quality:</strong> {u.get('understanding_quality', 'unknown')}
• <strong>Sentiment:</strong> {u['sentiment']}
"""
    
    if u.get('entities'):
        response += f"\n• <strong>Entities:</strong> {json.dumps(u['entities'])}"
    
    if u.get('alternatives'):
        alts = ', '.join([f"{a['intent']} ({a['confidence']:.0%})" for a in u['alternatives'][:3]])
        response += f"\n• <strong>Alternatives:</strong> {alts}"
    
    return response

def format_debug_response(debug):
    """Format debug information"""
    return f"""
🐛 <strong>Debug Information:</strong>

• <strong>Original:</strong> {debug.get('original_input', '')}
• <strong>Intent:</strong> {debug.get('detected_intent', '')}
• <strong>Confidence:</strong> {debug.get('confidence', 0):.1%}
• <strong>Pattern Match:</strong> {debug.get('confidence_breakdown', {}).get('pattern_match', 'no')}
• <strong>Quality:</strong> {debug.get('understanding_quality', 'unknown')}
"""

def format_stats_response(stats):
    """Format statistics"""
    if 'message' in stats:
        return stats['message']
    
    response = f"""
📊 <strong>Understanding Statistics:</strong>

• <strong>Total Interactions:</strong> {stats.get('total_interactions', 0)}
• <strong>Success Rate:</strong> {stats.get('success_rate', '0%')}
• <strong>Successful:</strong> {stats.get('successful_interpretations', 0)}
• <strong>Failed:</strong> {stats.get('failed_interpretations', 0)}
"""
    
    if stats.get('most_common_intents'):
        intents = ', '.join([f"{k} ({v})" for k, v in list(stats['most_common_intents'].items())[:3]])
        response += f"\n• <strong>Common Intents:</strong> {intents}"
    
    return response

def format_learning_stats(stats):
    """Format learning statistics"""
    return f"""
📈 <strong>Learning Statistics:</strong>

• <strong>Total Interactions:</strong> {stats.get('total_interactions', 0)}
• <strong>Commands Learned:</strong> {stats.get('total_learned', 0)}
• <strong>Aliases:</strong> {stats.get('alias_count', 0)}
"""

if __name__ == '__main__':
    print("=" * 70)
    print("🤖 Dexaura Web Server Starting...")
    print("=" * 70)
    print(f"✓ Agent initialized")
    print(f"✓ Understanding engine loaded")
    print(f"✓ Web UI ready")
    print("\n🌐 Open your browser: http://localhost:5000")
    print("=" * 70)
    
    app.run(host='0.0.0.0', port=5000, debug=True)
