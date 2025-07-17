document.addEventListener('DOMContentLoaded', () => {
  console.log('Hola desde Rollup + Rails');
  // Hacer una petición GET a http://localhost:3000/tickets
  fetch('http://localhost:3000/tickets')
  .then(response => {
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }
    return response.json(); // Convierte la respuesta a JSON
  })
  .then(data => {
    console.log('Datos recibidos:', data);
    renderTable(data); // Renderiza la tabla con los datos
  })
  .catch(error => {
    console.error('Hubo un error al obtener los tickets:', error);
    document.getElementById('tickets-table').innerHTML = '<p>Error al cargar los tickets.</p>';
  });
});

function renderTable(tickets) {
  const tbody = document.querySelector('#tickets-table tbody');
  tbody.innerHTML = ''; // Limpiar el contenido existente

  // Iterar sobre cada ticket y agregar una fila a la tabla
  tickets.forEach(ticket => {
    const row = document.createElement('tr');

    // Columna ID
    const idCell = document.createElement('td');
    idCell.textContent = ticket.id;
    row.appendChild(idCell);

    // Columna Nombre
    const nameCell = document.createElement('td');
    nameCell.textContent = ticket.name;
    row.appendChild(nameCell);

    // Columna Creado
    const createdCell = document.createElement('td');
    createdCell.textContent = ticket.created;
    row.appendChild(createdCell);

    // Columna Actualizado
    const updatedCell = document.createElement('td');
    updatedCell.textContent = ticket.updated;
    row.appendChild(updatedCell);

    // Agregar la fila completa a la tabla
    tbody.appendChild(row);
  });
}