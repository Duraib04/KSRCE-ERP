// ================================
// Dexaura UI - Interactive JavaScript
// ================================

let isOnline = false;
let ws = null;
let isListening = false;
let animationFrame = null;
let babyVideo = null;
let speechSynthesis = window.speechSynthesis;
let dexauraVoice = null;
let cameraStream = null;
let cameraVideoEl = null;
let autoAnalyzeEnabled = false;
let autoAnalyzeIntervalId = null;
let autoAnalyzeLastSignature = null;
let realtimeObjectsEnabled = false;
let realtimeObjectsIntervalId = null;
let realtimeObjectsBusy = false;

// Baby video states
const BABY_VIDEOS = {
    IDLE: 'Video_Generation_for_Babysitting_and_Playing.mp4',
    ANSWERING: 'Baby_Standing_and_Answering_Video.mp4',
    UNKNOWN: 'Video_Generation_Request_Fulfilled.mp4'
};

// Initialize voice
function initializeVoice() {
    const voices = speechSynthesis.getVoices();
    // Try to find a good voice for Dexaura (prefer UK English male voices)
    dexauraVoice = voices.find(voice => 
        voice.name.includes('Google UK English Male') || 
        voice.name.includes('Microsoft David') ||
        voice.lang.includes('en-GB')
    ) || voices[0];
}

// Voice settings
let voiceEnabled = true;

// Music Player
let musicPlayer = null;
let isPlaying = false;
let currentSongIndex = 0;
let playlist = [
    { title: 'Dexaura Theme', url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3' },
    { title: 'Cyberpunk Beats', url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3' },
    { title: 'AI Symphony', url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3' },
    { title: 'Digital Dreams', url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3' },
    { title: 'Neural Network', url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3' }
];

// Toggle voice on/off
function toggleVoiceMode() {
    voiceEnabled = !voiceEnabled;
    const btn = document.getElementById('voiceToggle');
    if (btn) {
        btn.textContent = voiceEnabled ? '🔊 Voice ON' : '🔇 Voice OFF';
    }
    if (!voiceEnabled) {
        speechSynthesis.cancel();
    }
}

// Speak response
function speak(text) {
    if (!speechSynthesis || !voiceEnabled) return;
    
    // Stop any ongoing speech
    speechSynthesis.cancel();
    
    // Remove markdown and HTML tags
    const cleanText = text.replace(/[#*_`\[\]()]/g, '')
                         .replace(/<[^>]*>/g, '')
                         .replace(/[📚🔍💡✓✅❌🍼🔄📋📊🤔😊✨👋]/g, '');
    
    const utterance = new SpeechSynthesisUtterance(cleanText);
    utterance.voice = dexauraVoice;
    utterance.rate = 1.0;
    utterance.pitch = 0.9;
    utterance.volume = 1.0;
    
    speechSynthesis.speak(utterance);
}

// ================================
// MUSIC PLAYER
// ================================

function initializeMusicPlayer() {
    musicPlayer = new Audio();
    musicPlayer.volume = 0.3;
    
    musicPlayer.addEventListener('ended', () => {
        nextSong();
    });
    
    musicPlayer.addEventListener('play', () => {
        isPlaying = true;
        updatePlayButton();
        renderPlaylist();
        setBabyState('ANSWERING');
    });
    
    musicPlayer.addEventListener('pause', () => {
        isPlaying = false;
        updatePlayButton();
        renderPlaylist();
        setBabyState('IDLE');
    });
    
    musicPlayer.addEventListener('timeupdate', () => {
        updateProgress();
    });
    
    musicPlayer.addEventListener('loadedmetadata', () => {
        updateProgress();
    });
    
    musicPlayer.addEventListener('error', (e) => {
        console.error('Music player error:', e);
        addMessage('system', '❌ Error loading song. Skipping to next...');
        nextSong();
    });
    
    renderPlaylist();
}

function togglePlayPause() {
    if (!musicPlayer) return;
    
    if (isPlaying) {
        musicPlayer.pause();
        addMessage('system', '⏸️ Music paused');
    } else {
        if (!musicPlayer.src) {
            loadSong(currentSongIndex);
        }
        musicPlayer.play().catch(err => {
            console.error('Play error:', err);
            addMessage('system', '❌ Cannot play music. Please interact with the page first.');
        });
        const song = playlist[currentSongIndex];
        addMessage('system', `🎵 Now playing: ${song.title}`);
        speak(`Now playing ${song.title}`);
    }
}

function nextSong() {
    currentSongIndex = (currentSongIndex + 1) % playlist.length;
    loadSong(currentSongIndex);
    if (isPlaying || !musicPlayer.paused) {
        musicPlayer.play();
    }
    const song = playlist[currentSongIndex];
    addMessage('system', `⏭️ Next song: ${song.title}`);
    speak(`Next song: ${song.title}`);
    renderPlaylist();
}

function previousSong() {
    currentSongIndex = (currentSongIndex - 1 + playlist.length) % playlist.length;
    loadSong(currentSongIndex);
    if (isPlaying || !musicPlayer.paused) {
        musicPlayer.play();
    }
    const song = playlist[currentSongIndex];
    addMessage('system', `⏮️ Previous song: ${song.title}`);
    speak(`Previous song: ${song.title}`);
    renderPlaylist();
}

function loadSong(index) {
    if (index < 0 || index >= playlist.length) return;
    
    const song = playlist[index];
    musicPlayer.src = song.url;
    musicPlayer.load();
    updateSongDisplay();
}

function updateSongDisplay() {
    const songName = document.getElementById('currentSongName');
    if (songName) {
        const song = playlist[currentSongIndex];
        songName.textContent = song.title;
    }
    renderPlaylist();
}

function updatePlayButton() {
    const btn = document.getElementById('playPauseBtn');
    if (btn) {
        btn.textContent = isPlaying ? '⏸️' : '▶️';
        btn.title = isPlaying ? 'Pause' : 'Play';
    }
    updateSongDisplay();
}

function toggleMusicPlayer() {
    const panel = document.getElementById('musicPlayerPanel');
    const btn = document.getElementById('playlistToggleBtn');
    if (panel.style.display === 'none') {
        panel.style.display = 'block';
        btn.classList.add('active');
        renderPlaylist();
    } else {
        panel.style.display = 'none';
        btn.classList.remove('active');
    }
}

function renderPlaylist() {
    const container = document.getElementById('playlistItems');
    const countEl = document.getElementById('playlistCount');
    
    if (!container) return;
    
    container.innerHTML = '';
    countEl.textContent = playlist.length;
    
    playlist.forEach((song, index) => {
        const item = document.createElement('div');
        item.className = 'playlist-item' + (index === currentSongIndex ? ' active' : '');
        item.onclick = () => playSongAtIndex(index);
        
        item.innerHTML = `
            <div class="playlist-item-number">${index + 1}</div>
            <div class="playlist-item-info">
                <div class="playlist-item-title">${song.title}</div>
            </div>
            <div class="playlist-item-icon">${index === currentSongIndex && isPlaying ? '🔊' : '🎵'}</div>
        `;
        
        container.appendChild(item);
    });
}

function playSongAtIndex(index) {
    currentSongIndex = index;
    loadSong(index);
    musicPlayer.play();
    renderPlaylist();
}

function changeVolume(value) {
    if (musicPlayer) {
        musicPlayer.volume = value / 100;
    }
}

function seekSong(event) {
    if (!musicPlayer || !musicPlayer.duration) return;
    
    const bar = event.currentTarget;
    const rect = bar.getBoundingClientRect();
    const percent = (event.clientX - rect.left) / rect.width;
    musicPlayer.currentTime = percent * musicPlayer.duration;
}

function updateProgress() {
    if (!musicPlayer || !musicPlayer.duration) return;
    
    const percent = (musicPlayer.currentTime / musicPlayer.duration) * 100;
    const progressBar = document.getElementById('progressBar');
    const timeEl = document.getElementById('songTime');
    
    if (progressBar) {
        progressBar.style.width = percent + '%';
    }
    
    if (timeEl) {
        const current = formatTime(musicPlayer.currentTime);
        const total = formatTime(musicPlayer.duration);
        timeEl.textContent = `${current} / ${total}`;
    }
}

function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
}

async function uploadSongs(files) {
    if (!files || files.length === 0) return;
    
    const formData = new FormData();
    let uploadCount = 0;
    
    for (let i = 0; i < files.length; i++) {
        const file = files[i];
        if (file.type.startsWith('audio/')) {
            formData.append('songs', file);
            uploadCount++;
        }
    }
    
    if (uploadCount === 0) {
        addMessage('system', '❌ No valid audio files selected');
        return;
    }
    
    addMessage('system', `📤 Uploading ${uploadCount} song(s)...`);
    
    try {
        const response = await fetch('/api/upload-songs', {
            method: 'POST',
            body: formData
        });
        
        const result = await response.json();
        
        if (result.success) {
            // Add uploaded songs to playlist
            result.songs.forEach(song => {
                playlist.push({
                    title: song.title,
                    url: `/songs/${song.filename}`
                });
            });
            
            addMessage('system', `✅ ${result.songs.length} song(s) uploaded successfully!`);
            speak(`${result.songs.length} songs added to playlist`);
            
            // Show song names
            const songList = result.songs.map(s => s.title).join(', ');
            addMessage('system', `🎵 Added: ${songList}`);
            
            // Refresh playlist view
            renderPlaylist();
        } else {
            addMessage('system', `❌ Upload failed: ${result.error}`);
        }
    } catch (error) {
        addMessage('system', '❌ Error uploading songs: ' + error.message);
    }
}

function showPlaylist() {
    let playlistHTML = '<p><strong>🎵 Current Playlist:</strong></p>';
    playlist.forEach((song, index) => {
        const playing = index === currentSongIndex && isPlaying;
        playlistHTML += `<p>${playing ? '🔊' : '🎵'} ${index + 1}. ${song.title}</p>`;
    });
    addMessage('system', playlistHTML);
}

function toggleMusicPlayer() {
    const panel = document.getElementById('musicPlayerPanel');
    const btn = document.getElementById('musicToggleBtn');
    if (panel.style.display === 'none') {
        panel.style.display = 'block';
        btn.style.background = 'linear-gradient(135deg, var(--primary-color), var(--secondary-color))';
        renderPlaylist();
    } else {
        panel.style.display = 'none';
        btn.style.background = '';
    }
}

function renderPlaylist() {
    const container = document.getElementById('playlistItems');
    const countEl = document.getElementById('playlistCount');
    
    if (!container) return;
    
    container.innerHTML = '';
    countEl.textContent = playlist.length;
    
    playlist.forEach((song, index) => {
        const item = document.createElement('div');
        item.className = 'playlist-item' + (index === currentSongIndex ? ' active' : '');
        item.onclick = () => playSongAtIndex(index);
        
        item.innerHTML = `
            <div class="playlist-item-number">${index + 1}</div>
            <div class="playlist-item-info">
                <div class="playlist-item-title">${song.title}</div>
            </div>
            <div class="playlist-item-icon">${index === currentSongIndex && isPlaying ? '🔊' : '🎵'}</div>
        `;
        
        container.appendChild(item);
    });
}

function playSongAtIndex(index) {
    currentSongIndex = index;
    loadSong(index);
    musicPlayer.play();
    renderPlaylist();
    const song = playlist[index];
    addMessage('system', `🎵 Now playing: ${song.title}`);
    speak(`Now playing ${song.title}`);
}

function changeVolume(value) {
    if (musicPlayer) {
        musicPlayer.volume = value / 100;
    }
}

function seekSong(event) {
    if (!musicPlayer || !musicPlayer.duration) return;
    
    const bar = event.currentTarget;
    const rect = bar.getBoundingClientRect();
    const percent = (event.clientX - rect.left) / rect.width;
    musicPlayer.currentTime = percent * musicPlayer.duration;
}

function updateProgress() {
    if (!musicPlayer || !musicPlayer.duration) return;
    
    const percent = (musicPlayer.currentTime / musicPlayer.duration) * 100;
    const progressBar = document.getElementById('progressBar');
    const timeEl = document.getElementById('songTime');
    
    if (progressBar) {
        progressBar.style.width = percent + '%';
    }
    
    if (timeEl) {
        const current = formatTime(musicPlayer.currentTime);
        const total = formatTime(musicPlayer.duration);
        timeEl.textContent = `${current} / ${total}`;
    }
}

function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
}

// ================================
// Initialization
// ================================

document.addEventListener('DOMContentLoaded', () => {
    initializeWaveAnimation();
    updateStatus();
    focusInput();
    loadHints();
    
    // Initialize voice
    if (speechSynthesis) {
        speechSynthesis.onvoiceschanged = initializeVoice;
        initializeVoice();
    }
    
    // Initialize music player
    initializeMusicPlayer();
    
    // Initialize baby video
    babyVideo = document.getElementById('babyVideo');
    if (babyVideo) {
        babyVideo.addEventListener('loadeddata', () => {
            console.log('Video loaded successfully');
            babyVideo.play().catch(err => console.log('Auto-play prevented:', err));
        });
        babyVideo.addEventListener('error', (e) => {
            console.error('Video error:', e);
            console.log('Make sure video files are in ui/ folder');
        });
        setBabyState('IDLE');
    }
    
    // Initialize visualizer video
    const visualizerVideo = document.getElementById('visualizerVideo');
    if (visualizerVideo) {
        visualizerVideo.addEventListener('loadeddata', () => {
            console.log('Visualizer video loaded successfully');
            visualizerVideo.play().catch(err => {
                console.log('Visualizer auto-play prevented:', err);
                // Try to play on user interaction
                document.addEventListener('click', () => {
                    visualizerVideo.play().catch(e => console.log('Play failed:', e));
                }, { once: true });
            });
        });
        visualizerVideo.addEventListener('error', (e) => {
            console.error('Visualizer video error:', e);
        });
    }

    // Initialize camera elements
    cameraVideoEl = document.getElementById('cameraVideo');
    if (cameraVideoEl) {
        updateCameraOverlay('Camera is off');
    }
});

// ================================
// Wave Animation
// ================================

function initializeWaveAnimation() {
    const canvas = document.getElementById('waveCanvas');
    const ctx = canvas.getContext('2d');
    let time = 0;

    function drawWave() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        // Draw multiple wave layers
        drawWaveLayer(ctx, time, 100, 'rgba(0, 212, 255, 0.3)', 1);
        drawWaveLayer(ctx, time + 50, 100, 'rgba(0, 149, 255, 0.2)', 1.5);
        drawWaveLayer(ctx, time + 100, 100, 'rgba(0, 255, 255, 0.1)', 2);
        
        time += 0.5;
        animationFrame = requestAnimationFrame(drawWave);
    }

    function drawWaveLayer(ctx, offset, amplitude, color, frequency) {
        ctx.beginPath();
        ctx.strokeStyle = color;
        ctx.lineWidth = 2;
        
        for (let x = 0; x < canvas.width; x++) {
            const y = canvas.height / 2 + 
                     Math.sin((x + offset) * 0.01 * frequency) * amplitude +
                     Math.sin((x + offset * 2) * 0.005 * frequency) * (amplitude / 2);
            
            if (x === 0) {
                ctx.moveTo(x, y);
            } else {
                ctx.lineTo(x, y);
            }
        }
        
        ctx.stroke();
    }

    drawWave();
}

// ================================
// Message Handling
// ================================

function sendMessage() {
    const input = document.getElementById('userInput');
    const message = input.value.trim();
    
    if (!message) return;
    
    // Add user message to chat
    addMessage('user', message);
    
    // Clear input
    input.value = '';
    
    // Show loading
    showLoading();
    
    // Set baby to answering state
    setBabyState('ANSWERING');
    
    // Process command
    processCommand(message);
}

function addMessage(sender, content, data = null) {
    const chatContainer = document.getElementById('chatContainer');
    const messageWrapper = document.createElement('div');
    messageWrapper.className = `message-wrapper ${sender}-message`;
    
    const timestamp = new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
    
    let messageHTML = `
        <div class="message">
            <div class="message-header">
                <span class="message-sender">${sender === 'user' ? 'You' : 'Dexaura'}</span>
                <span class="message-time">${timestamp}</span>
            </div>
            <div class="message-content">
                ${formatMessageContent(content, data)}
            </div>
        </div>
    `;
    
    messageWrapper.innerHTML = messageHTML;
    chatContainer.appendChild(messageWrapper);
    chatContainer.scrollTop = chatContainer.scrollHeight;
    
    // Speak Dexaura responses
    if (sender === 'system' && typeof content === 'string') {
        speak(content);
    }
}

function formatMessageContent(content, data) {
    // Start with content as HTML
    let html = '';
    
    if (typeof content === 'string') {
        html += `<p>${content}</p>`;
    }
    
    // Format structured data
    if (data && data.understanding) {
        const u = data.understanding;
        html += `<p><strong>🎯 Intent:</strong> ${u.intent} (${(u.confidence * 100).toFixed(0)}%)</p>`;
        html += `<p><strong>⭐ Quality:</strong> ${u.understanding_quality}</p>`;
        html += `<p><strong>💭 Sentiment:</strong> ${u.sentiment}</p>`;
        
        if (u.entities && Object.keys(u.entities).length > 0) {
            html += `<p><strong>📦 Entities:</strong> ${JSON.stringify(u.entities)}</p>`;
        }
    }
    
    // Format image generation result - THIS IS THE IMPORTANT PART
    if (data && data.image_url) {
        html += `<div class="generated-image" style="margin-top: 15px;">`;
        html += `<img src="${data.image_url}" alt="Generated image" style="max-width: 100%; border-radius: 10px; border: 2px solid var(--primary-color); box-shadow: 0 0 20px rgba(0, 212, 255, 0.3);"/>`;
        html += `<p style="font-size: 0.85em; color: var(--text-secondary); margin-top: 8px; font-style: italic;">📝 Prompt: ${data.prompt}</p>`;
        html += `</div>`;
    }
    
    return html;
}

// ================================
// Camera Controls
// ================================

function updateCameraOverlay(message, isActive = false) {
    const overlay = document.getElementById('cameraOverlay');
    if (!overlay) return;
    overlay.textContent = message;
    overlay.style.opacity = isActive ? '0' : '1';
    overlay.style.pointerEvents = isActive ? 'none' : 'auto';
}

async function startCamera() {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        addMessage('system', '❌ Camera access not supported in this browser');
        return false;
    }

    if (!cameraVideoEl) {
        cameraVideoEl = document.getElementById('cameraVideo');
    }

    if (!cameraVideoEl) {
        addMessage('system', '❌ Camera element not found in UI');
        return false;
    }

    if (cameraStream) {
        addMessage('system', '✅ Camera is already active');
        updateCameraOverlay('Camera is on', true);
        return true;
    }

    updateCameraOverlay('Requesting camera permission...');

    try {
        cameraStream = await navigator.mediaDevices.getUserMedia({
            video: { width: { ideal: 1280 }, height: { ideal: 720 } },
            audio: false
        });
        cameraVideoEl.srcObject = cameraStream;
        await cameraVideoEl.play();
        updateCameraOverlay('Camera is on', true);
        addMessage('system', '✅ Camera started');
        startRealtimeObjects();
        return true;
    } catch (err) {
        updateCameraOverlay('Camera is off');
        addMessage('system', `❌ Camera access denied or failed: ${err.message}`);
        return false;
    }
}

function stopCamera() {
    if (!cameraStream) {
        updateCameraOverlay('Camera is off');
        addMessage('system', 'ℹ️ Camera is already off');
        return;
    }

    cameraStream.getTracks().forEach(track => track.stop());
    cameraStream = null;

    if (cameraVideoEl) {
        cameraVideoEl.srcObject = null;
    }

    updateCameraOverlay('Camera is off');
    addMessage('system', '🛑 Camera stopped');

    stopAutoAnalyze();
    stopRealtimeObjects();
}

function toggleCamera() {
    if (cameraStream) {
        stopCamera();
    } else {
        startCamera();
    }
}

function captureSnapshot() {
    if (!cameraStream || !cameraVideoEl) {
        addMessage('system', '❌ Camera is not active. Start the camera first.');
        return;
    }

    const canvas = document.getElementById('cameraCanvas');
    if (!canvas) {
        addMessage('system', '❌ Snapshot canvas not found');
        return;
    }

    const width = cameraVideoEl.videoWidth || 1280;
    const height = cameraVideoEl.videoHeight || 720;
    canvas.width = width;
    canvas.height = height;

    const ctx = canvas.getContext('2d');
    ctx.drawImage(cameraVideoEl, 0, 0, width, height);

    const dataUrl = canvas.toDataURL('image/png');
    addMessage('system', '📸 Snapshot captured', {
        image_url: dataUrl,
        prompt: 'Camera snapshot'
    });
}

async function analyzeMoodFromCamera() {
    const started = cameraStream ? true : await startCamera();
    if (!started || !cameraVideoEl) {
        addMessage('system', '❌ Cannot analyze mood without camera access');
        return;
    }

    const canvas = document.getElementById('cameraCanvas');
    if (!canvas) {
        addMessage('system', '❌ Snapshot canvas not found');
        return;
    }

    const width = cameraVideoEl.videoWidth || 1280;
    const height = cameraVideoEl.videoHeight || 720;
    canvas.width = width;
    canvas.height = height;

    const ctx = canvas.getContext('2d');
    ctx.drawImage(cameraVideoEl, 0, 0, width, height);

    const dataUrl = canvas.toDataURL('image/png');

    addMessage('system', '🧠 Analyzing mood from camera...');

    try {
        const response = await fetch('/api/mood', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ image: dataUrl })
        });

        const result = await response.json();

        if (result.success) {
            // Map mood to emoji
            const moodEmojis = {
                'happy': '😊',
                'neutral': '😐',
                'focused': '🤔',
                'contemplative': '🤐',
                'unknown': '❓'
            };
            
            const mood = result.mood ? result.mood.toLowerCase() : 'unknown';
            const emoji = moodEmojis[mood] || '😶';
            const moodText = mood.charAt(0).toUpperCase() + mood.slice(1);
            const confidence = result.confidence ? `${Math.round(result.confidence * 100)}%` : 'N/A';
            
            let message = `${emoji} Mood: ${moodText} | Confidence: ${confidence}`;
            if (result.face_count) {
                message += ` | Faces: ${result.face_count}`;
            }
            if (result.smile_count) {
                message += ` | Smiles: ${result.smile_count}`;
            }
            if (result.message) {
                message += ` | ${result.message}`;
            }
            
            addMessage('system', message);
        } else {
            addMessage('system', `❌ ${result.error || 'Mood analysis failed'}`);
        }
    } catch (error) {
        addMessage('system', `❌ Mood analysis error: ${error.message}`);
    }
}

async function analyzeHandGestures() {
    const started = cameraStream ? true : await startCamera();
    if (!started || !cameraVideoEl) {
        addMessage('system', '❌ Cannot detect gestures without camera access');
        return;
    }

    const canvas = document.getElementById('cameraCanvas');
    if (!canvas) {
        addMessage('system', '❌ Snapshot canvas not found');
        return;
    }

    const width = cameraVideoEl.videoWidth || 1280;
    const height = cameraVideoEl.videoHeight || 720;
    canvas.width = width;
    canvas.height = height;

    const ctx = canvas.getContext('2d');
    ctx.drawImage(cameraVideoEl, 0, 0, width, height);

    const dataUrl = canvas.toDataURL('image/png');

    addMessage('system', '🤖 Scanning for hand gestures...');

    try {
        const response = await fetch('/api/gestures', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ image: dataUrl })
        });

        const result = await response.json();

        if (result.success) {
            // Map gestures to emojis
            const gestureEmojis = {
                'peace': '✌️',
                'thumbs_up': '👍',
                'thumbs_down': '👎',
                'ok_sign': '👌',
                'pointing': '☝️',
                'open_palm': '✋',
                'rock_sign': '🤘',
                'call_me': '🤙',
                'fist': '✊',
                'neutral_hand': '👋',
                'unknown': '❓'
            };
            
            if (result.hand_count === 0) {
                addMessage('system', '❌ No hands detected. Please show your hand to the camera.');
            } else {
                let gestureReport = `✋ Detected ${result.hand_count} hand(s):\n`;
                
                result.gestures.forEach(gesture => {
                    const emoji = gestureEmojis[gesture.gesture] || '👋';
                    const gestureText = gesture.gesture.replace(/_/g, ' ').toUpperCase();
                    const confidence = `${Math.round(gesture.confidence * 100)}%`;
                    gestureReport += `\n${emoji} ${gesture.hand}: ${gestureText} (${confidence})`;
                });
                
                if (result.message) {
                    gestureReport += `\n📍 ${result.message}`;
                }
                
                addMessage('system', gestureReport);
            }
        } else {
            addMessage('system', `❌ ${result.error || 'Gesture detection failed'}`);
        }
    } catch (error) {
        addMessage('system', `❌ Gesture detection error: ${error.message}`);
    }
}

async function detectObjects() {
    const started = cameraStream ? true : await startCamera();
    if (!started || !cameraVideoEl) {
        addMessage('system', '❌ Cannot detect objects without camera access');
        return;
    }
    
    try {
        addMessage('user', '🔍 Detecting objects...');
        
        // Capture frame from video
        const canvas = document.getElementById('cameraCanvas');
        canvas.width = cameraVideoEl.videoWidth;
        canvas.height = cameraVideoEl.videoHeight;
        const ctx = canvas.getContext('2d');
        ctx.drawImage(cameraVideoEl, 0, 0);
        const imageData = canvas.toDataURL('image/jpeg', 0.95);
        
        const response = await fetch('/api/detect-objects', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ image: imageData, min_confidence: 0.35 })
        });
        
        const result = await response.json();
        
        if (result.error) {
            addMessage('system', `❌ Error: ${result.error}${result.message ? '\n' + result.message : ''}`);
            return;
        }
        
        // Display annotated image
        if (result.annotated_image) {
            const imgHtml = `<img src="${result.annotated_image}" style="max-width: 100%; border-radius: 8px; margin-top: 10px;" />`;
            addMessage('assistant', imgHtml, true);
        }
        
        // Create summary message
        let message = `🔍 Found ${result.count} object${result.count !== 1 ? 's' : ''}`;
        
        if (result.objects && result.objects.length > 0) {
            // Group objects by class
            const grouped = {};
            result.objects.forEach(obj => {
                if (!grouped[obj.class]) {
                    grouped[obj.class] = [];
                }
                grouped[obj.class].push(obj.confidence);
            });
            
            // Create summary
            const summary = Object.entries(grouped)
                .map(([className, confidences]) => {
                    const count = confidences.length;
                    const avgConf = (confidences.reduce((a, b) => a + b, 0) / count * 100).toFixed(1);
                    return `  • ${count}x ${className} (${avgConf}% confidence)`;
                })
                .join('\n');
            
            message += ':\n\n' + summary;
        } else {
            message = '🔍 No objects detected in the image.';
        }
        
        addMessage('assistant', message);
        
    } catch (error) {
        console.error('Error detecting objects:', error);
        addMessage('system', `❌ Object detection error: ${error.message}`);
    }
}

function getCameraAnalysisPreviewEl() {
    return document.getElementById('cameraAnalysisPreview');
}

function updateRealtimeObjectsButton() {
    const button = document.getElementById('realtimeObjectsToggle');
    if (!button) return;
    const label = realtimeObjectsEnabled ? 'Stop Live Analysis' : 'Live Analysis';
    const icon = realtimeObjectsEnabled ? '⏸️' : '⚡';
    button.querySelector('.btn-icon').textContent = icon;
    button.querySelector('span:last-child').textContent = label;
}

async function runRealtimeObjectsOnce() {
    if (realtimeObjectsBusy || !cameraVideoEl || !cameraStream) return;
    const preview = getCameraAnalysisPreviewEl();
    if (!preview) return;

    realtimeObjectsBusy = true;
    try {
        const canvas = document.getElementById('cameraCanvas');
        canvas.width = cameraVideoEl.videoWidth;
        canvas.height = cameraVideoEl.videoHeight;
        const ctx = canvas.getContext('2d');
        ctx.drawImage(cameraVideoEl, 0, 0);
        const imageData = canvas.toDataURL('image/jpeg', 0.9);

        const response = await fetch('/api/detect-objects', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ image: imageData, min_confidence: 0.35 })
        });

        const result = await response.json();
        if (result.annotated_image) {
            preview.src = result.annotated_image;
            preview.style.display = 'block';
        }
    } catch (error) {
        console.error('Real-time object detection error:', error);
    } finally {
        realtimeObjectsBusy = false;
    }
}

async function startRealtimeObjects(intervalMs = 1500) {
    const started = cameraStream ? true : await startCamera();
    if (!started || !cameraVideoEl) {
        addMessage('system', '❌ Cannot start live analysis without camera access');
        return;
    }

    if (realtimeObjectsEnabled) return;
    realtimeObjectsEnabled = true;
    updateRealtimeObjectsButton();

    const preview = getCameraAnalysisPreviewEl();
    if (preview) {
        preview.style.display = 'block';
    }

    await runRealtimeObjectsOnce();
    realtimeObjectsIntervalId = setInterval(runRealtimeObjectsOnce, intervalMs);
}

function stopRealtimeObjects() {
    if (!realtimeObjectsEnabled) return;
    realtimeObjectsEnabled = false;
    updateRealtimeObjectsButton();

    if (realtimeObjectsIntervalId) {
        clearInterval(realtimeObjectsIntervalId);
        realtimeObjectsIntervalId = null;
    }

    const preview = getCameraAnalysisPreviewEl();
    if (preview) {
        preview.style.display = 'none';
        preview.src = '';
    }
}

function toggleRealtimeObjects() {
    if (realtimeObjectsEnabled) {
        stopRealtimeObjects();
    } else {
        startRealtimeObjects();
    }
}

async function analyzeSnapshotDetails(options = {}) {
    const { silent = false, source = 'manual' } = options;
    const started = cameraStream ? true : await startCamera();
    if (!started || !cameraVideoEl) {
        if (!silent) {
            addMessage('system', '❌ Cannot analyze snapshot without camera access');
        }
        return;
    }

    const canvas = document.getElementById('cameraCanvas');
    if (!canvas) {
        addMessage('system', '❌ Snapshot canvas not found');
        return;
    }

    const width = cameraVideoEl.videoWidth || 1280;
    const height = cameraVideoEl.videoHeight || 720;
    canvas.width = width;
    canvas.height = height;

    const ctx = canvas.getContext('2d');
    ctx.drawImage(cameraVideoEl, 0, 0, width, height);

    const dataUrl = canvas.toDataURL('image/png');
    if (!silent) {
        addMessage('system', '🧠 Analyzing snapshot for faces, mood, and names...');
    }

    try {
        const response = await fetch('/api/snap-analyze', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ image: dataUrl })
        });

        const result = await response.json();

        if (result.success) {
            const people = result.people_count ?? 0;
            const mood = result.mood ? result.mood.toUpperCase() : 'UNKNOWN';
            const moodConfidence = result.mood_confidence ? `${Math.round(result.mood_confidence * 100)}%` : 'N/A';
            const names = (result.names || []).filter(Boolean).join(', ') || 'Unknown';

            const signature = `${people}|${mood}|${names}`;
            const shouldPost = !silent || signature !== autoAnalyzeLastSignature;
            autoAnalyzeLastSignature = signature;

            if (shouldPost) {
                const label = source === 'auto' ? 'Auto Snapshot' : 'Snapshot analysis';
                addMessage('system', `📸 ${label} | People: ${people} | Mood: ${mood} (${moodConfidence}) | Names: ${names}`, {
                    image_url: result.image_url || dataUrl,
                    prompt: label
                });
            }
        } else {
            if (!silent) {
                addMessage('system', `❌ ${result.error || 'Snapshot analysis failed'}`);
            }
        }
    } catch (error) {
        if (!silent) {
            addMessage('system', `❌ Snapshot analysis error: ${error.message}`);
        }
    }
}

function startAutoAnalyze(intervalSeconds) {
    const seconds = Math.max(2, Number(intervalSeconds) || 5);
    stopAutoAnalyze();
    autoAnalyzeEnabled = true;
    autoAnalyzeIntervalId = setInterval(() => {
        analyzeSnapshotDetails({ silent: true, source: 'auto' });
    }, seconds * 1000);
    updateAutoAnalyzeButton();
    addMessage('system', `▶️ Auto analysis enabled every ${seconds}s`);
}

function stopAutoAnalyze() {
    if (autoAnalyzeIntervalId) {
        clearInterval(autoAnalyzeIntervalId);
        autoAnalyzeIntervalId = null;
    }
    if (autoAnalyzeEnabled) {
        autoAnalyzeEnabled = false;
        updateAutoAnalyzeButton();
        addMessage('system', '⏹️ Auto analysis stopped');
    }
}

function toggleAutoAnalyze() {
    if (autoAnalyzeEnabled) {
        stopAutoAnalyze();
        return;
    }
    const input = document.getElementById('autoAnalyzeInterval');
    const intervalSeconds = input ? input.value : 5;
    startAutoAnalyze(intervalSeconds);
}

function updateAutoAnalyzeButton() {
    const btn = document.getElementById('autoAnalyzeToggle');
    if (!btn) {
        return;
    }
    const label = btn.querySelector('span:last-child');
    if (label) {
        label.textContent = autoAnalyzeEnabled ? 'Stop Auto' : 'Auto Analyze';
    }
}

async function registerPersonFromCamera(nameOverride = '') {
    const started = cameraStream ? true : await startCamera();
    if (!started || !cameraVideoEl) {
        addMessage('system', '❌ Cannot register person without camera access');
        return;
    }

    const inputEl = document.getElementById('personNameInput');
    const name = (nameOverride || (inputEl ? inputEl.value : '')).trim();

    if (!name) {
        addMessage('system', '❌ Please enter a person name first');
        return;
    }

    const canvas = document.getElementById('cameraCanvas');
    if (!canvas) {
        addMessage('system', '❌ Snapshot canvas not found');
        return;
    }

    const width = cameraVideoEl.videoWidth || 1280;
    const height = cameraVideoEl.videoHeight || 720;
    canvas.width = width;
    canvas.height = height;

    const ctx = canvas.getContext('2d');
    ctx.drawImage(cameraVideoEl, 0, 0, width, height);

    const dataUrl = canvas.toDataURL('image/png');
    addMessage('system', `🧑‍💾 Saving ${name}...`);

    try {
        const response = await fetch('/api/register-person', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ image: dataUrl, name })
        });

        const result = await response.json();

        if (result.success) {
            addMessage('system', `✅ ${name} saved. ${result.message || 'Face registered'}`);
            if (inputEl) {
                inputEl.value = '';
            }
        } else {
            addMessage('system', `❌ ${result.error || 'Failed to save person'}`);
        }
    } catch (error) {
        addMessage('system', `❌ Register person error: ${error.message}`);
    }
}

async function registerPersonFromUpload() {
    const inputEl = document.getElementById('personNameInput');
    const fileEl = document.getElementById('personImageUpload');
    const name = (inputEl ? inputEl.value : '').trim();

    if (!name) {
        addMessage('system', '❌ Please enter a person name first');
        return;
    }
    if (!fileEl || !fileEl.files || fileEl.files.length === 0) {
        addMessage('system', '❌ Please choose one or more image files');
        return;
    }

    const files = Array.from(fileEl.files);
    addMessage('system', `🖼️ Uploading ${files.length} photo(s) for ${name}...`);

    let successCount = 0;
    const failed = [];

    for (const file of files) {
        const formData = new FormData();
        formData.append('name', name);
        formData.append('image', file);

        try {
            const response = await fetch('/api/register-person-file', {
                method: 'POST',
                body: formData
            });

            const result = await response.json();
            if (result.success) {
                successCount += 1;
            } else {
                failed.push(`${file.name}: ${result.error || 'Failed to save person'}`);
            }
        } catch (error) {
            failed.push(`${file.name}: ${error.message}`);
        }
    }

    if (successCount > 0) {
        addMessage('system', `✅ Saved ${successCount}/${files.length} photo(s) for ${name}.`);

        const shouldRetrain = window.confirm(
            `Saved ${successCount} photo(s) for ${name}. Retrain face model now for best accuracy?`
        );

        if (shouldRetrain) {
            await retrainFaceModel();
        } else {
            addMessage('system', 'ℹ️ Skipped manual retrain. Per-image auto-train already ran during upload.');
        }
    }

    if (failed.length > 0) {
        const maxToShow = 3;
        const preview = failed.slice(0, maxToShow).join(' | ');
        const extra = failed.length > maxToShow ? ` (+${failed.length - maxToShow} more)` : '';
        addMessage('system', `⚠️ Some uploads failed: ${preview}${extra}`);
    }

    if (fileEl) {
        fileEl.value = '';
    }
}

async function retrainFaceModel() {
    addMessage('system', '🧠 Retraining face model from saved images...');

    try {
        const response = await fetch('/api/retrain-faces', {
            method: 'POST'
        });

        const result = await response.json();
        if (result.success) {
            const samples = Number.isFinite(result.samples) ? result.samples : 'n/a';
            const identities = Number.isFinite(result.identities) ? result.identities : 'n/a';
            addMessage('system', `✅ Retrain complete. Samples: ${samples}, identities: ${identities}.`);
        } else {
            addMessage('system', `❌ Retrain failed: ${result.error || 'Unknown error'}`);
        }
    } catch (error) {
        addMessage('system', `❌ Retrain request failed: ${error.message}`);
    }
}

// ================================
// Command Processing
// ================================

function processCommand(command) {
    // Simulate API call to Dexaura backend
    setTimeout(() => {
        hideLoading();
        
        // Parse command
        const cmd = command.toLowerCase().trim();
        
        if (cmd === 'help') {
            showHelpResponse();
            setTimeout(() => {
                setBabyState('ANSWERING');
                setTimeout(() => setBabyState('IDLE'), 3000);
            }, 500);
        } else if (cmd.startsWith('understand ')) {
            const text = cmd.replace('understand ', '');
            analyzeUnderstanding(text);
            setTimeout(() => {
                setBabyState('ANSWERING');
                setTimeout(() => setBabyState('IDLE'), 3000);
            }, 500);
        } else if (cmd.startsWith('debug ')) {
            const text = cmd.replace('debug ', '');
            showDebugInfo(text);
            setTimeout(() => {
                setBabyState('ANSWERING');
                setTimeout(() => setBabyState('IDLE'), 3000);
            }, 500);
        } else if (cmd === 'understanding-stats') {
            showStats();
            setTimeout(() => {
                setBabyState('ANSWERING');
                setTimeout(() => setBabyState('IDLE'), 3000);
            }, 500);
        } else if (cmd.startsWith('teach ')) {
            handleTeach(cmd);
            setTimeout(() => {
                setBabyState('ANSWERING');
                setTimeout(() => setBabyState('IDLE'), 3000);
            }, 500);
        } else if (cmd === 'play' || cmd === 'music') {
            togglePlayPause();
            setTimeout(() => setBabyState('IDLE'), 2000);
        } else if (cmd === 'pause' || cmd === 'stop') {
            if (musicPlayer && isPlaying) {
                togglePlayPause();
            } else {
                addMessage('system', '⏸️ No music playing');
            }
            setTimeout(() => setBabyState('IDLE'), 2000);
        } else if (cmd === 'next' || cmd === 'skip' || cmd.includes('next song')) {
            nextSong();
            setTimeout(() => setBabyState('IDLE'), 2000);
        } else if (cmd === 'previous' || cmd === 'prev' || cmd === 'back' || cmd.includes('previous song')) {
            previousSong();
            setTimeout(() => setBabyState('IDLE'), 2000);
        } else if (cmd === 'songs' || cmd === 'playlist' || cmd === 'show playlist' || cmd === 'view playlist' || cmd === 'music') {
            toggleMusicPlayer();
            setTimeout(() => setBabyState('IDLE'), 2000);
        } else if (cmd === 'upload song' || cmd === 'upload music' || cmd === 'add song') {
            document.getElementById('songUpload').click();
            addMessage('system', '📤 Select audio files to upload...');
            setTimeout(() => setBabyState('IDLE'), 2000);
        } else if (cmd.startsWith('generate ') || cmd.startsWith('create-image ') || cmd.startsWith('draw ')) {
            const prompt = command.replace(/^(generate|create-image|draw)\s+/i, '');
            generateImage(prompt);
            setTimeout(() => {
                setBabyState('ANSWERING');
                setTimeout(() => setBabyState('IDLE'), 3000);
            }, 500);
        } else if (cmd.startsWith('knowledge ')) {
            const query = cmd.replace('knowledge ', '');
            searchKnowledge(query);
            setTimeout(() => {
                setBabyState('ANSWERING');
                setTimeout(() => setBabyState('IDLE'), 3000);
            }, 500);
        } else if (cmd === 'mode') {
            toggleMode();
            setTimeout(() => {
                setBabyState('ANSWERING');
                setTimeout(() => setBabyState('IDLE'), 3000);
            }, 500);
        } else {
            // General query
            handleGeneralQuery(command);
        }
        
        // Update stats
        updateStats();
    }, 1000);
}

function showHelpResponse() {
    const helpText = `
        <p><strong>🤖 Dexaura Commands:</strong></p>
        <p>• <code>understand &lt;text&gt;</code> - Analyze text understanding</p>
        <p>• <code>debug &lt;text&gt;</code> - Deep debugging information</p>
        <p>• <code>understanding-stats</code> - View performance statistics</p>
        <p>• <code>knowledge &lt;query&gt;</code> - Search knowledge base</p>
        <p>• <code>teach &lt;question&gt; = &lt;answer&gt;</code> - Teach Dexaura</p>
        <p>• <code>generate &lt;description&gt;</code> - 🎨 Generate AI image</p>
        <p>• <code>open camera</code> / <code>stop camera</code> - 📷 Control device camera</p>
        <p>• <code>analyze mood</code> - 😊 Detect mood from camera</p>
        <p>• <code>songs</code> or click 🎵 in Quick Actions - Open music player</p>
        <p>• <code>play</code> / <code>pause</code> / <code>next</code> / <code>previous</code> - Control music</p>
        <p>• <code>upload song</code> - 📤 Upload music files</p>
        <p>• <code>mode</code> - Toggle online/offline mode</p>
        <p>• Or just chat naturally! I understand 25+ intent types.</p>
    `;
    addMessage('system', helpText);
}

async function generateImage(prompt) {
    try {
        const response = await fetch('/api/generate-image', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ prompt })
        });
        
        const result = await response.json();
        
        if (result.success) {
            addMessage('system', result.message, { 
                image_url: result.image_url,
                prompt: result.prompt 
            });
        } else {
            addMessage('system', result.message || 'Failed to generate image');
        }
    } catch (error) {
        addMessage('system', '❌ Error generating image: ' + error.message);
    }
}

function analyzeInputInRealTime(text) {
    // Real-time analysis as user types
    if (!text || text.trim().length < 3) {
        // Show default state for short inputs
        const display = document.getElementById('understandingDisplay');
        display.innerHTML = `
            <div class="no-data">
                <svg viewBox="0 0 100 100" width="60" height="60">
                    <circle cx="50" cy="50" r="40" fill="none" stroke="currentColor" stroke-width="3"/>
                    <path d="M 35 40 Q 35 35 40 35 Q 45 35 45 40" fill="none" stroke="currentColor" stroke-width="3"/>
                    <path d="M 55 40 Q 55 35 60 35 Q 65 35 65 40" fill="none" stroke="currentColor" stroke-width="3"/>
                    <path d="M 35 60 Q 50 70 65 60" fill="none" stroke="currentColor" stroke-width="3"/>
                </svg>
                <p>Type to analyze...</p>
            </div>
        `;
        return;
    }
    
    const understanding = {
        intent: detectIntent(text),
        confidence: 0.85 + Math.random() * 0.1,
        understanding_quality: text.length > 20 ? 'good' : 'fair',
        sentiment: detectSentiment(text),
        entities: extractEntities(text)
    };
    
    updateUnderstandingDisplay(understanding);
    updateSuggestions(understanding);
    updateEntitiesDisplay(understanding.entities);
    
    // Update confidence in header
    document.getElementById('confidence').textContent = `${(understanding.confidence * 100).toFixed(0)}%`;
}

function analyzeUnderstanding(text) {
    // Full analysis with message output
    const understanding = {
        intent: detectIntent(text),
        confidence: 0.85 + Math.random() * 0.1,
        understanding_quality: 'good',
        sentiment: detectSentiment(text),
        entities: extractEntities(text)
    };
    
    updateUnderstandingDisplay(understanding);
    updateIntentList(understanding.intent);
    updateSuggestions(understanding);
    updateEntitiesDisplay(understanding.entities);
    
    const response = `
        <p><strong>🧠 Understanding Analysis:</strong></p>
        <p>• <strong>Intent:</strong> ${understanding.intent} (${(understanding.confidence * 100).toFixed(0)}%)</p>
        <p>• <strong>Quality:</strong> ${understanding.understanding_quality}</p>
        <p>• <strong>Sentiment:</strong> ${understanding.sentiment}</p>
        ${Object.keys(understanding.entities).length > 0 ? 
          `<p>• <strong>Entities:</strong> ${JSON.stringify(understanding.entities)}</p>` : ''}
    `;
    
    addMessage('system', response);
    
    // Update confidence in header
    document.getElementById('confidence').textContent = `${(understanding.confidence * 100).toFixed(0)}%`;
}

function detectSentiment(text) {
    const lower = text.toLowerCase();
    const positive = ['good', 'great', 'awesome', 'love', 'like', 'thanks', 'happy', 'excellent'];
    const negative = ['bad', 'hate', 'terrible', 'awful', 'angry', 'sad', 'problem', 'error'];
    
    const posCount = positive.filter(word => lower.includes(word)).length;
    const negCount = negative.filter(word => lower.includes(word)).length;
    
    if (posCount > negCount) return 'positive';
    if (negCount > posCount) return 'negative';
    return 'neutral';
}

function detectIntent(text) {
    const lower = text.toLowerCase();
    
    if (lower.includes('who is') || lower.includes('identify') || lower.includes('recognize') || lower.includes('scan people') || lower.includes('detect people')) {
        return 'person_identify';
    } else if (lower.includes('save person') || lower.includes('remember person') || lower.includes('register person') || lower.includes('save name')) {
        return 'register_person';
    } else if (lower.includes('gesture') || lower.includes('hand') || lower.includes('sign')) {
        return 'gesture_detection';
    } else if (lower.includes('detect object') || lower.includes('find object') || lower.includes('what object') || 
               lower.includes('identify object') || lower.includes('scan object') || 
               lower.includes('what is this') || lower.includes('what do you see')) {
        return 'object_detection';
    } else if (lower.includes('mood') || lower.includes('emotion') || lower.includes('feeling')) {
        return 'mood_detection';
    } else if (lower.includes('camera') || lower.includes('webcam') || lower.includes('cam')) {
        return 'camera_control';
    } else if (lower.includes('open') || lower.includes('launch') || lower.includes('start')) {
        return 'open_application';
    } else if (lower.includes('search') || lower.includes('find') || lower.includes('google')) {
        return 'web_search';
    } else if (lower.includes('what') || lower.includes('how') || lower.includes('why')) {
        return 'question';
    } else if (lower.includes('teach') || lower.includes('learn') || lower.includes('explain')) {
        return 'learning_query';
    } else if (lower.includes('play') || lower.includes('music') || lower.includes('song')) {
        return 'music_control';
    } else if (lower.includes('remind') || lower.includes('reminder')) {
        return 'reminder';
    } else if (lower.includes('file') || lower.includes('folder')) {
        return 'file_operation';
    } else if (lower.includes('hi') || lower.includes('hello') || lower.includes('hey')) {
        return 'greeting';
    } else if (lower.includes('thank')) {
        return 'thanks';
    } else if (text.length < 3 || /^[^\w\s]+$/.test(text)) {
        return 'unknown';
    } else {
        return 'general_query';
    }
}

function extractEntities(text) {
    const entities = {};
    
    // Simple entity extraction
    const words = text.split(' ');
    
    // Look for applications
    const apps = ['chrome', 'firefox', 'notepad', 'word', 'excel', 'spotify', 'vscode'];
    apps.forEach(app => {
        if (text.toLowerCase().includes(app)) {
            entities.application = app;
        }
    });
    
    // Look for file paths
    const pathMatch = text.match(/[A-Za-z]:\\[^\s]+/);
    if (pathMatch) {
        entities.file_path = pathMatch[0];
    }
    
    // Look for URLs
    const urlMatch = text.match(/https?:\/\/[^\s]+/);
    if (urlMatch) {
        entities.url = urlMatch[0];
    }
    
    // Look for numbers
    const numberMatch = text.match(/\b\d+\b/);
    if (numberMatch) {
        entities.number = numberMatch[0];
    }
    
    return entities;
}

function showDebugInfo(text) {
    const understanding = {
        intent: detectIntent(text),
        confidence: 0.85 + Math.random() * 0.1,
        entities: extractEntities(text)
    };
    
    const response = `
        <p><strong>🐛 Debug Information:</strong></p>
        <p>• <strong>Original:</strong> ${text}</p>
        <p>• <strong>Intent:</strong> ${understanding.intent}</p>
        <p>• <strong>Confidence:</strong> ${(understanding.confidence * 100).toFixed(1)}%</p>
        <p>• <strong>Pattern Match:</strong> yes</p>
        <p>• <strong>Phrase Match:</strong> ${Math.random() > 0.5 ? 'yes' : 'no'}</p>
        <p>• <strong>Learned Match:</strong> ${Math.random() > 0.7 ? 'yes' : 'no'}</p>
        <p>• <strong>Entities:</strong> ${JSON.stringify(understanding.entities)}</p>
    `;
    
    addMessage('system', response);
}

function showStats() {
    const stats = {
        interactions: parseInt(document.getElementById('interactions').textContent) || 0,
        successRate: '87%',
        learnedItems: parseInt(document.getElementById('learned-items').textContent) || 0,
        documents: parseInt(document.getElementById('documents').textContent) || 0
    };
    
    const response = `
        <p><strong>📊 Understanding Statistics:</strong></p>
        <p>• <strong>Total Interactions:</strong> ${stats.interactions}</p>
        <p>• <strong>Success Rate:</strong> ${stats.successRate}</p>
        <p>• <strong>Learned Items:</strong> ${stats.learnedItems}</p>
        <p>• <strong>Documents Processed:</strong> ${stats.documents}</p>
        <p>• <strong>Most Common Intent:</strong> learning_query</p>
        <p>• <strong>Average Confidence:</strong> 89%</p>
    `;
    
    addMessage('system', response);
}

function handleTeach(command) {
    if (command.includes('=')) {
        const parts = command.split('=');
        const question = parts[0].replace('teach', '').trim();
        const answer = parts[1].trim();
        
        addMessage('system', `✅ Thank you! I've learned that: ${question} → ${answer}`);
        
        // Update learned items count
        const learnedEl = document.getElementById('learned-items');
        learnedEl.textContent = parseInt(learnedEl.textContent) + 1;
    } else {
        addMessage('system', '❌ Please use format: teach &lt;question&gt; = &lt;answer&gt;');
    }
}

function searchKnowledge(query) {
    const response = `
        <p><strong>📚 Knowledge Search Results for "${query}":</strong></p>
        <p>🔍 Searching Java knowledge base...</p>
        <p>🔍 Searching user-taught knowledge...</p>
        <p>💡 Found relevant information! Here's what I know:</p>
        <p>${query} is a powerful concept used in software development...</p>
    `;
    
    addMessage('system', response);
}

function handleGeneralQuery(query) {
    const intent = detectIntent(query);
    
    let babyState = 'ANSWERING';
    let showProcessing = true;
    
    // For certain intents, show immediate feedback while processing
    if (intent === 'open_application') {
        addMessage('system', '✅ Opening application...');
        // Extract application name from query
        let appName = query.toLowerCase().replace(/open\s+/, '').trim();
        sendCommandToBackend(`open ${appName}`);
        showProcessing = false;
    }
    else if (intent === 'register_person') {
        const match = query.match(/(?:save|remember|register)\s+(?:person|name)?\s*(.+)/i);
        const name = match && match[1] ? match[1].trim() : '';
        registerPersonFromCamera(name);
        showProcessing = false;
    }
    else if (intent === 'person_identify') {
        analyzeSnapshotDetails();
        showProcessing = false;
    }
    else if (intent === 'gesture_detection') {
        analyzeHandGestures();
        showProcessing = false;
    }
    else if (intent === 'object_detection') {
        detectObjects();
        showProcessing = false;
    }
    else if (intent === 'mood_detection') {
        analyzeMoodFromCamera();
        showProcessing = false;
    }
    else if (intent === 'camera_control') {
        const lower = query.toLowerCase();
        if (lower.includes('stop') || lower.includes('close') || lower.includes('off')) {
            stopCamera();
        } else {
            startCamera();
        }
        showProcessing = false;
    }
    else if (intent === 'web_search') {
        addMessage('system', '🔍 Searching the web...');
        // Extract search query
        let searchQuery = query.toLowerCase()
            .replace(/search\s+for\s+/, '')
            .replace(/search\s+/, '')
            .replace(/look\s+for\s+/, '')
            .trim();
        sendCommandToBackend(`search ${searchQuery}`);
        showProcessing = false;
    }
    else if (intent === 'greeting') {
        addMessage('system', '👋 Hello! How can I assist you today?');
        showProcessing = false;
    }
    else if (intent === 'thanks') {
        addMessage('system', '😊 You\'re welcome! Happy to help!');
        showProcessing = false;
    }
    else if (intent === 'question') {
        addMessage('system', `🤔 Let me help you with that...`);
        sendCommandToBackend(`understand ${query}`);
        showProcessing = false;
    }
    else if (intent === 'unknown') {
        addMessage('system', `❓ I'm not sure about that. Could you rephrase or ask something else?`);
        babyState = 'UNKNOWN';
        showProcessing = false;
    }
    else {
        // For any other intent, try to send as a command to backend
        addMessage('system', `💭 Processing your request...`);
        sendCommandToBackend(query);
        showProcessing = false;
    }
    
    // Set baby video state based on response
    setTimeout(() => {
        setBabyState(babyState);
        // Return to idle after 3 seconds
        setTimeout(() => setBabyState('IDLE'), 3000);
    }, 500);
}

// ================================
// Backend API Communication
// ================================

function sendCommandToBackend(command) {
    /**
     * Send a command to the backend /api/command endpoint
     * This function handles the actual execution through the agent
     */
    fetch('/api/command', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            command: command
        })
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            // Handle successful response
            if (data.response) {
                addMessage('system', data.response);
            }
            
            // Handle special action types
            if (data.action === 'play_music') {
                if (musicPlayer && playlist.length > 0) {
                    musicPlayer.src = playlist[currentSongIndex].url;
                    musicPlayer.play();
                }
            }
            else if (data.action === 'pause_music') {
                if (musicPlayer) {
                    musicPlayer.pause();
                }
            }
            else if (data.action === 'next_song') {
                nextSong();
            }
            else if (data.action === 'previous_song') {
                previousSong();
            }
            else if (data.action === 'show_playlist') {
                togglePlaylist();
            }
            else if (data.action === 'upload_song') {
                // This would be handled by file upload interface
            }
            
            // Handle special response types with additional data
            if (data.type === 'image_generation' && data.image_url) {
                // Display generated image if available
                addMessage('system', data.response);
                // Could display image in a modal or special area
            }
        } 
        else if (data.error) {
            addMessage('system', `❌ Error: ${data.error}`);
        }
        else if (data.response) {
            // Handle responses even if success is false (for non-critical failures)
            addMessage('system', data.response);
        }
        else {
            addMessage('system', `❓ Unexpected response from backend`);
        }
    })
    .catch(error => {
        console.error('Backend communication error:', error);
        addMessage('system', `❌ Could not connect to backend: ${error.message}`);
    });
}

// ================================
// UI Updates
// ================================

function updateUnderstandingDisplay(understanding) {
    const display = document.getElementById('understandingDisplay');
    
    display.innerHTML = `
        <div class="understanding-item">
            <div class="understanding-label">Intent</div>
            <div class="understanding-value">${understanding.intent}</div>
        </div>
        <div class="understanding-item">
            <div class="understanding-label">Confidence</div>
            <div class="understanding-value">${(understanding.confidence * 100).toFixed(0)}%</div>
        </div>
        <div class="understanding-item">
            <div class="understanding-label">Quality</div>
            <div class="understanding-value">${understanding.understanding_quality}</div>
        </div>
        <div class="understanding-item">
            <div class="understanding-label">Sentiment</div>
            <div class="understanding-value">${understanding.sentiment}</div>
        </div>
    `;
}

function updateIntentList(intent) {
    const intentList = document.getElementById('intent-list');
    
    const intentItem = document.createElement('div');
    intentItem.className = 'intent-item';
    intentItem.textContent = intent;
    intentItem.style.animation = 'messageSlide 0.3s ease-out';
    
    intentList.insertBefore(intentItem, intentList.firstChild);
    
    // Keep only last 5 intents
    while (intentList.children.length > 5) {
        intentList.removeChild(intentList.lastChild);
    }
}

function updateSuggestions(understanding) {
    const suggestions = document.getElementById('suggestions');
    
    const suggestionTexts = [
        '💡 Try: "search for [topic]"',
        '📚 Use "knowledge [query]" to search',
        '🔍 Ask questions naturally',
        '📖 Use "teach" to add knowledge'
    ];
    
    suggestions.innerHTML = suggestionTexts.map(text => 
        `<div class="suggestion-item">${text}</div>`
    ).join('');
}

function updateEntitiesDisplay(entities) {
    const entitiesEl = document.getElementById('entities');
    
    if (Object.keys(entities).length === 0) {
        entitiesEl.innerHTML = '<div class="entity-item">No entities detected</div>';
        return;
    }
    
    entitiesEl.innerHTML = Object.entries(entities).map(([key, value]) =>
        `<div class="entity-item"><strong>${key}:</strong> ${value}</div>`
    ).join('');
}

function updateStats() {
    const interactionsEl = document.getElementById('interactions');
    interactionsEl.textContent = parseInt(interactionsEl.textContent) + 1;
    
    // Animate the update
    interactionsEl.style.transform = 'scale(1.2)';
    setTimeout(() => {
        interactionsEl.style.transform = 'scale(1)';
    }, 200);
}

function updateStatus() {
    const statusEl = document.getElementById('status');
    statusEl.textContent = 'Online';
    statusEl.style.color = 'var(--success-color)';
}

// ================================
// Quick Actions
// ================================

function sendCommand(command) {
    document.getElementById('userInput').value = command;
    sendMessage();
}

function toggleMode() {
    isOnline = !isOnline;
    const modeEl = document.getElementById('mode');
    modeEl.textContent = isOnline ? 'Online' : 'Offline';
    
    addMessage('system', `🔄 Switched to ${isOnline ? 'Online' : 'Offline'} mode`);
}

// ================================
// Voice Control
// ================================

function toggleVoice() {
    isListening = !isListening;
    const voiceBtn = document.getElementById('voiceBtn');
    
    if (isListening) {
        voiceBtn.classList.add('active');
        startListening();
    } else {
        voiceBtn.classList.remove('active');
        stopListening();
    }
}

function startListening() {
    // Check if browser supports speech recognition
    if (!('webkitSpeechRecognition' in window)) {
        addMessage('system', '❌ Speech recognition not supported in this browser');
        return;
    }
    
    const recognition = new webkitSpeechRecognition();
    recognition.continuous = false;
    recognition.interimResults = false;
    
    recognition.onresult = (event) => {
        const transcript = event.results[0][0].transcript;
        document.getElementById('userInput').value = transcript;
        addMessage('system', `🎤 Heard: "${transcript}"`);
    };
    
    recognition.onerror = (event) => {
        console.error('Speech recognition error:', event.error);
        stopListening();
    };
    
    recognition.onend = () => {
        stopListening();
    };
    
    recognition.start();
}

function stopListening() {
    isListening = false;
    document.getElementById('voiceBtn').classList.remove('active');
}

// ================================
// Utility Functions
// ================================

function showLoading() {
    document.getElementById('loadingOverlay').classList.add('active');
}

function hideLoading() {
    document.getElementById('loadingOverlay').classList.remove('active');
}

function focusInput() {
    document.getElementById('userInput').focus();
}

function handleKeyPress(event) {
    if (event.key === 'Enter') {
        sendMessage();
    }
}

function loadHints() {
    const hints = document.querySelectorAll('.hint');
    hints.forEach(hint => {
        hint.addEventListener('click', () => {
            document.getElementById('userInput').value = hint.textContent.replace('Try: ', '').replace(/"/g, '');
            focusInput();
        });
    });
}

// ================================
// WebSocket Connection (for real backend)
// ================================

function connectToBackend() {
    // Example WebSocket connection
    // ws = new WebSocket('ws://localhost:8000/ws');
    
    // ws.onopen = () => {
    //     console.log('Connected to Dexaura backend');
    //     updateStatus();
    // };
    
    // ws.onmessage = (event) => {
    //     const data = JSON.parse(event.data);
    //     handleBackendResponse(data);
    // };
    
    // ws.onerror = (error) => {
    //     console.error('WebSocket error:', error);
    // };
    
    // ws.onclose = () => {
    //     console.log('Disconnected from Dexaura backend');
    //     document.getElementById('status').textContent = 'Offline';
    // };
}

function sendToBackend(message) {
    if (ws && ws.readyState === WebSocket.OPEN) {
        ws.send(JSON.stringify({ message }));
    } else {
        console.log('WebSocket not connected, using demo mode');
    }
}

// ================================
// Baby Video State Management
// ================================

function setBabyState(state) {
    if (!babyVideo) {
        console.log('Baby video element not found');
        return;
    }
    
    const videoSrc = BABY_VIDEOS[state];
    console.log('Setting baby state to:', state, 'Video:', videoSrc);
    
    if (babyVideo.src.indexOf(videoSrc) === -1) {
        babyVideo.src = videoSrc;
        babyVideo.load();
        babyVideo.play().catch(err => {
            console.error('Video play error:', err);
        });
    }
}

// ================================
// Initialize on Load
// ================================

// Uncomment to connect to real backend
// connectToBackend();
