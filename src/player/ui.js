import { goToModule } from '../router.js';

export function initUI() {
  const container = document.createElement('div');
  container.id = 'ui';
  container.style.position = 'absolute';
  container.style.top = '10px';
  container.style.left = '10px';
  container.style.zIndex = '10';

  const modules = [
    'module1','module2','module3','module4',
    'module5','module6','module7','module8'
  ];

  modules.forEach(m => {
    const btn = document.createElement('button');
    btn.innerText = m;
    btn.style.marginRight = '5px';
    btn.onclick = () => goToModule(m);
    container.appendChild(btn);
  });

  document.body.appendChild(container);
}
