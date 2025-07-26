class ChatPlugin {
  constructor(options = {}) {
    console.log(options)
    this.ws = null;
    this.receiver = null;
    this.conversationId = null;
    this.tryREST = options.tryREST ?? true;    
    this.socketUrl = options.socketUrl ?? null;
    this.receivers = options.receivers ?? {fetchURL: null, keyId: 'id', keyName: 'name', keyImage: 'image', base_url: ''};
    this.userInfo = options.userInfo;
    this.receiverIdDOM = document.getElementById(options.receiverIdDOM ??  "receiverName");
    this.receiverListDOM = document.getElementById(options.receiverListDOM ?? "receiverList");
    this.btnSendDOM = document.getElementById(options.btnSendDOM ?? "btnSend");
    this.inputMessageDOM = document.getElementById(options.inputMessageDOM ?? 'inputMessage');
    this.messagesListDOM = document.getElementById(options.messagesListDOM ?? 'messages');
    this.jwtChatToken = options.jwtChatToken ?? null;
  }

  init() {
    window.addEventListener("load", () => {
      this.connectWebSocket();
      this.loadReceivers();
      setInterval(() => this.ping(), 30000);
    });

    this.btnSendDOM.addEventListener('keypress', (e) => {
      if (e.key === 'Enter') this.sendMessage();
    });

    this.btnSendDOM.addEventListener('click', () => this.sendMessage());
  }

  ping() {
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify({ type: 'ping' }));
    }
  }

  loadReceivers() {
    if(this.receivers.fetchURL){
      const xhr = new XMLHttpRequest();
      const userInfo = JSON.parse(localStorage.getItem('user_info'));
      xhr.open('GET', this.receivers.fetchURL, true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('Accept', 'application/json');
      xhr.onreadystatechange = () => {
        if (xhr.readyState === 4) {
          if (xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
            //console.log('Respuesta completa:', response);
            this.showReceivers(response);
          } else {
            alert('Error al actualizar el usuario');
          }
        }
      };
      xhr.send();
    }else{
      console.error('No se listarán los receivers porque no hay URL');
    }
  }

  receiverClick(event, receiver) {
    this.receiverIdDOM.innerHTML = receiver[this.receivers.keyName];
    this.receiver = receiver;
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify({
        type: 'load_conversation',
        token: this.jwtChatToken,
        receiver_id: receiver[this.receivers.keyId]
      }));
    }
  }

  showReceivers(response) {
    if (!this.receiverListDOM) return;

    if (Array.isArray(response)) {

      localStorage.setItem('receivers', JSON.stringify(response));

      response.forEach(receiver => {
        const div = document.createElement('div');
        div.classList.add('conversation-item');
        div.dataset.chat = receiver[this.receivers.keyId];
      
        div.addEventListener('click', (e) => this.receiverClick(e, receiver));
      
        div.innerHTML = `
          <div class="conv-img">
            <img height=100 width=100 src="${this.receivers.imageBaseURL}${receiver[this.receivers.keyImage]}" alt="${receiver[this.receivers.keyName]}" />
          </div>
          <div class="conv-content">
            <div class="conv-sender">${receiver[this.receivers.keyName]}</div>
            <div class="conv-preview">¡Hola! ¿En qué puedo ayudarte hoy?</div>
            <div class="conv-time">${new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</div>
          </div>
        `;
      
        this.receiverListDOM.appendChild(div);
      });
    }
    // Casos de objeto simple o valor simple omitidos por brevedad
  }

  sendMessageRest(message) {
    const data = {
      receiver_id: this.receiver.id,
      content: message,
    };

    const xhr = new XMLHttpRequest();
    xhr.open("POST", `http://localhost:8888/api/v1/conversation_id/${this.conversationId}/messages`, true);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.setRequestHeader("Accept", "application/json");
    xhr.setRequestHeader("Authorization", "Bearer " + this.userInfo.token);

    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4) {
        if ([200, 201].includes(xhr.status)) {
          const response = JSON.parse(xhr.responseText);
          console.log("Mensaje enviado correctamente:", response);
          this.addMessage(response);
        } else {
          console.error("Error al enviar mensaje:", xhr.statusText);
        }
      }
    };

    xhr.send(JSON.stringify(data));
  }

  sendMessage() {
    const input = this.inputMessageDOM;
    const message = input.value.trim();

    if (!message) return alert('Escribe un mensaje!');

    if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
      if (this.tryREST) {
        this.sendMessageRest(message);
        return;
      }
      return alert('Primero debes conectar al chat!');
    }

    this.ws.send(JSON.stringify({
      type: 'send_message',
      token: userInfo.token,
      receiver_id: this.receiver.id,
      conversation_id: this.conversationId,
      message
    }));

    input.value = "";
    input.focus();
  }

  showMessages(messages) {
    const ul = this.messagesListDOM;
    ul.innerHTML = "";
    const receivers = JSON.parse(localStorage.getItem('receivers'));

    messages.forEach(msg => this._renderMessage(ul, msg, receivers));
  }

  addMessage(msg) {
    const ul = this.messagesListDOM;
    const receivers = JSON.parse(localStorage.getItem('receivers'));
    this._renderMessage(ul, msg, receivers);
  }

  _renderMessage(ul, msg, receivers) {
    const wrapper = document.createElement('div');
    wrapper.classList.add('message-group');
    
    const isSelf = msg.sender_id == this.userInfo.id;
  
    if (isSelf) {
      wrapper.classList.add('text-end', 'ms-auto', 'me-2'); // Bootstrap alignment
      wrapper.innerHTML = `
        <div class="sender-name">Yo</div>
        <div class="message bg-primary text-white d-inline-block rounded p-2 my-1">${msg.content}</div>
        <div class="message-time text-muted small">${msg.created}</div>
      `;
    } else {
      const match = receivers.find(r => String(r.id) === String(msg.sender_id));
      const name = match ? match.name : 'Unknown';
  
      wrapper.classList.add('text-start', 'me-auto', 'ms-2');
      wrapper.innerHTML = `
        <div class="sender-name">${name}</div>
        <div class="message bg-light d-inline-block rounded p-2 my-1">${msg.content}</div>
        <div class="message-time text-muted small">${msg.created}</div>
      `;
    }
  
    ul.appendChild(wrapper);
  }

  connectWebSocket() {
    if(this.socketUrl){
      this.ws = new WebSocket(this.socketUrl);

      this.ws.onopen = () => console.log('Conectado al WebSocket');
      this.ws.onclose = (e) => console.log('Desconectado del WebSocket', e);
      this.ws.onerror = (err) => console.error('Error WebSocket:', err);

      this.ws.onmessage = (event) => {
        const data = JSON.parse(event.data);
        if (data.type === 'ack') this.addMessage(data);
        if (['old_conversation', 'new_conversation'].includes(data.type)) {
          this.conversationId = data.conversation_id;
          this.showMessages(data.messages);
        }
        if (data.type === 'error') {
          document.getElementById('flash').innerHTML = data.message;
        }
      };
    }else{
      console.error("No hay url para el socket");
    }
  }
}