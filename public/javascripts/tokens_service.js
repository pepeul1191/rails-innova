const fetchTokensIfMissing = () => {
  // Verificar si los tokens ya existen
  const hasFilesToken = localStorage.getItem('jwtFilesToken');
  const hasAccessToken = localStorage.getItem('jwtAccessToken');
  const hasChatToken = localStorage.getItem('jwtChatToken');

  // Si ambos tokens ya están guardados, no hacer nada
  if (hasFilesToken && hasAccessToken && hasChatToken) {
    console.log('Tokens ya existen en localStorage.');
    return Promise.resolve(); // Salir sin hacer la petición
  }

  // Si alguno falta, hacer el GET a /tokens
  return axios.get('/session')
    .then(response => {
      const tokens = response.data.tokens;
      //console.log(tokens)

      // Guardar ambos tokens en localStorage
      if (tokens.access) {
        localStorage.setItem('jwtAccessToken', tokens.access);
      }

      if (tokens.files) {
        localStorage.setItem('jwtFilesToken', tokens.files);
      }

      if (tokens.chat) {
        localStorage.setItem('jwtChatToken', tokens.chat);
      }

      const user = response.data.user;
      //console.log(user)

      // Guardar ambos tokens en localStorage
      if (user) {
        localStorage.setItem('user_info', JSON.stringify(user));
      }

      console.log('Tokens guardados en localStorage.');
    })
    .catch(error => {
      console.error('Error al obtener tokens:', error);
      return Promise.reject(error);
    });
}

fetchTokensIfMissing()
  .then(() => {
    console.log('Tokens listos para usar.');
  })
  .catch(err => {
    console.error('No se pudieron obtener los tokens:', err);
  });