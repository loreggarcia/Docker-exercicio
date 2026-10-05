const form = document.querySelector('form');
form.addEventListener('submit', async (event) => {
  event.preventDefault();
  const button = form.querySelector('button');
  const status = document.querySelector('#status');
  const result = document.querySelector('#result');
  button.disabled = true; status.dataset.state = 'loading'; status.textContent = 'Enviando…'; result.textContent = '';
  try {
    const response = await fetch('/api/echo', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({message:document.querySelector('#message').value})});
    const data = await response.json();
    if (!response.ok) throw new Error(data.error || `HTTP ${response.status}`);
    result.textContent = JSON.stringify(data, null, 2); status.dataset.state = 'success'; status.textContent = 'Resposta recebida';
  } catch (error) {status.dataset.state = 'error'; status.textContent = 'Falha na requisição'; result.textContent = error.message;}
  finally {button.disabled = false;}
});
