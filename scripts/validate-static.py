#!/usr/bin/env python3
"""Valida links, modelos Compose e limites da estrutura, sem acessar daemon."""
import json
from pathlib import Path
import re
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]

def files(pattern):
    return [p for p in ROOT.rglob(pattern) if not {'node_modules', '.git', 'dist'} & set(p.parts)]

for path in files('*.md'):
    for target in re.findall(r'\]\(([^)]+)\)', path.read_text()):
        if '://' in target or target.startswith('#'):
            continue
        assert (path.parent / target.split('#')[0]).exists(), (path, target)

composes = files('compose*.yaml')
if shutil.which('docker'):
    subprocess.run(['docker', 'compose', 'version'], check=True)
    for path in composes:
        model = json.loads(subprocess.check_output(
            ['docker', 'compose', '-f', str(path), 'config', '--format', 'json'], text=True))
        for name, service in (model.get('services') or {}).items():
            if name == 'api' and '06-api-published' not in path.parts:
                assert not service.get('ports'), path
            assert 'container_name' not in service, path
            if 'build' in service and 'templates' not in path.parts:
                context = Path(service['build']['context'])
                if '07-build-context' not in path.parts:
                    assert (context / 'Dockerfile').is_file(), context
    print(f'Compose config: {len(composes)} modelos válidos (inclui placeholders e defeitos deliberados).')
else:
    print('Docker ausente: validação Compose não executada.')

for folder in ['examples', 'exercises', 'reference-solutions', 'templates', 'docs', 'scripts']:
    for path in (ROOT / folder).rglob('*'):
        if {'node_modules', 'dist', '__pycache__'} & set(path.parts):
            continue
        if path.is_dir():
            assert any(path.iterdir()), path
for path in (ROOT / 'scripts').glob('*.sh'):
    assert path.stat().st_mode & 0o111, path
    subprocess.run(['bash', '-n', str(path)], check=True)
print('Links, diretórios, permissões e sintaxe Bash: OK.')
