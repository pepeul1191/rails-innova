const uploadFile = ({ fileInput, folder, tokenStorageId, saveURL, afterUploadCallback }) => {
  if (!fileInput) {
    alert('Por favor, selecciona un archivo');
    return;
  }

  if (!folder) {
    alert('La carpeta destino no está definida');
    return;
  }

  const token = localStorage.getItem(tokenStorageId);

  if (!token) {
    alert('No se encontró el token de autenticación.');
    return;
  }

  const formData = new FormData();
  formData.append('file', fileInput);
  formData.append('folder', folder);

  const config = {
    headers: {
      Authorization: `Bearer ${token}`
    }
  };

  // Mostrar un estado de carga (opcional)
  const loadingMessage = 'Subiendo archivo...';
  console.log(loadingMessage);

  axios.post(saveURL, formData, config)
    .then(response => {
      console.log('✅ Archivo subido con éxito:', response.data);

      if (typeof afterUploadCallback === 'function') {
        afterUploadCallback(response.data);
      }
    })
    .catch(error => {
      let errorMessage = 'Hubo un error al subir el archivo.';

      if (error.response) {
        // El servidor respondió con un código de estado fuera de 2xx
        errorMessage = `Error del servidor: ${error.response.data.message || error.response.statusText}`;
      } else if (error.request) {
        // La petición fue hecha pero no hubo respuesta
        errorMessage = 'No hubo respuesta del servidor.';
      } else {
        // Otro error
        errorMessage = error.message;
      }

      console.error('❌ Error al subir archivo:', errorMessage);
      alert(errorMessage);
    });
};