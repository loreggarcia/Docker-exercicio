import React, {useState} from 'react';
import {createRoot} from 'react-dom/client';
import './style.css';
function App() {
  const [message, setMessage] = useState('Hello Docker');
  const [state, setState] = useState('idle');
  const [result, setResult] = useState('');
  async function submit(event) {
    event.preventDefault(); setState('loading'); setResult('');
    try {
      const response = await fetch('/api/echo', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({message})});
      const data = await response.json();
      if (!response.ok) throw new Error(data.error || `HTTP ${response.status}`);
      setResult(JSON.stringify(data, null, 2)); setState('success');
    } catch (error) {setResult(error.message); setState('error');}
  }
  const labels = {idle:'Pronto para enviar', loading:'Enviando…', success:'Resposta recebida', error:'Falha na requisição'};
  return <main><h1>Echo App</h1><p>Envie uma mensagem para a API.</p><form onSubmit={submit}><label htmlFor="message">Mensagem</label><input id="message" value={message} onChange={e => setMessage(e.target.value)}/><button disabled={state === 'loading'}>Enviar</button></form><p role="status" data-state={state}>{labels[state]}</p><pre>{result}</pre></main>;
}
createRoot(document.getElementById('root')).render(<App/>);
