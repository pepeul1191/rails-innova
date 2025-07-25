class ChatPlugin {
  constructor(options = {}) {
    this.ws = null;
    this.receiver = null;
    this.conversationId = null;
    this.tryREST = options.tryREST ?? true;    
    this.socketUrl = options.socketUrl ?? null;
    this.userInfo = options.userInfo;
    this.receiverIdDOM = document.getElementById(options.receiverIdDOM ??  "receiverName");
    this.receiverListDOM = document.getElementById(options.receiverListDOM ?? "receiverList");
    this.btnSendDOM = document.getElementById(options.btnSendDOM ?? "btnSend");
    this.inputMessageDOM = document.getElementById(options.inputMessageDOM ?? 'inputMessage');
    this.messagesListDOM = document.getElementById(options.messagesListDOM ?? 'messages');
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
    const xhr = new XMLHttpRequest();
    const userInfo = JSON.parse(localStorage.getItem('user_info'));
    xhr.open('GET', `http://localhost:7000/api/v1/users/${userInfo.user_id}/recipients`, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          const response = JSON.parse(xhr.responseText);
          console.log('Respuesta completa:', response);
          this.showReceivers(response);
        } else {
          alert('Error al actualizar el usuario');
        }
      }
    };
    xhr.send();
  }

  receiverClick(event, item) {
    this.receiverIdDOM.innerHTML = item.name;
    this.receiver = item;
 
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify({
        type: 'load_conversation',
        token: this.userInfo.token,
        receiver_id: item.id
      }));
    }
  }

  showReceivers(response) {
    if (!this.receiverListDOM) return;

    if (Array.isArray(response)) {

      localStorage.setItem('receivers', JSON.stringify(response));

      response.forEach(receiver => {
        const li = document.createElement('li');
        li.classList.add('item');
        li.addEventListener('click', (e) => this.receiverClick(e, receiver));
        li.innerHTML = `
          <img src="${receiver.image_url}" height=20 width=20 />
          <strong>${receiver.id} - ${receiver.name}</strong>
        `;
        this.receiverListDOM.appendChild(li);
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
    const li = document.createElement('li');
    if (msg.sender_id == this.userInfo.user_id) {
      li.innerHTML = `Yo dije: <br><small class="created">${msg.created}</small><br>${msg.content}`;
      li.classList.add('float-right');
    } else {
      const match = receivers.find(r => String(r.id) === String(msg.sender_id));
      li.innerHTML = `${match ? match.name : 'Unknow'} dijo: <br><small class="created">${msg.created}</small><br>${msg.content}`;
    }
    ul.appendChild(li);
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