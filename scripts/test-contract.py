#!/usr/bin/env python3
"""Testes locais Flask; não substituem rede/proxy Docker."""
import importlib.util
from pathlib import Path
import unittest
ROOT = Path(__file__).resolve().parents[1]
class Contract(unittest.TestCase):
    def test_all_flask_implementations(self):
        for path in ROOT.rglob('app.py'):
            if 'node_modules' in path.parts: continue
            with self.subTest(path=str(path.relative_to(ROOT))):
                spec = importlib.util.spec_from_file_location('echo_api', path)
                module = importlib.util.module_from_spec(spec)
                spec.loader.exec_module(module)
                client = module.app.test_client()
                health = client.get('/health')
                self.assertEqual(health.status_code, 200)
                self.assertEqual(health.json, {'status':'ok','service':'api'})
                for message in ['Hello Docker', '  mensagem  ', 'Olá 🐳']:
                    response = client.post('/echo', json={'message':message})
                    self.assertEqual(response.status_code, 200)
                    self.assertEqual(response.json, {'message':message})
                for body in ['', '{', 'null', '[]', '{}', '{"message":""}', '{"message":"  "}', '{"message":42}', '{"message":null}', '{"message":"ok"} {}']:
                    response = client.post('/echo', data=body, content_type='application/json')
                    self.assertEqual(response.status_code, 400, body)
                    self.assertIsInstance(response.json['error'], str)
                self.assertEqual(client.post('/echo').status_code, 400)
if __name__ == '__main__': unittest.main()
