import * as THREE from 'three';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';

export class Module2DeburringTool {
  private container: HTMLElement;
  private scene = new THREE.Scene();
  private camera: THREE.PerspectiveCamera;
  private renderer: THREE.WebGLRenderer;
  private controls: OrbitControls;
  private loader = new GLTFLoader();
  private mixer: THREE.AnimationMixer | null = null;
  private clock = new THREE.Clock();
  private raycaster = new THREE.Raycaster();
  private mouse = new THREE.Vector2();
  private overlay: HTMLDivElement;

  constructor(container: HTMLElement) {
    this.container = container;

    this.scene.background = new THREE.Color(0x0f0f12);

    const w = container.clientWidth;
    const h = container.clientHeight;

    this.camera = new THREE.PerspectiveCamera(45, w / h, 0.1, 100);
    this.camera.position.set(0, 1, 3);

    this.renderer = new THREE.WebGLRenderer({ antialias: true });
    this.renderer.setSize(w, h);
    this.renderer.outputEncoding = THREE.sRGBEncoding;
    container.appendChild(this.renderer.domElement);

    this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    this.controls.enableDamping = true;

    this.addLights();
    this.addOverlay();
    this.registerEvents();
  }

  private addLights() {
    const hemi = new THREE.HemisphereLight(0xffffff, 0x222233, 0.7);
    this.scene.add(hemi);

    const key = new THREE.DirectionalLight(0xffffff, 1.0);
    key.position.set(3, 5, 4);
    this.scene.add(key);
  }

  private addOverlay() {
    this.overlay = document.createElement('div');
    this.overlay.style.position = 'absolute';
    this.overlay.style.top = '20px';
    this.overlay.style.left = '20px';
    this.overlay.style.color = 'white';
    this.overlay.style.fontSize = '20px';
    this.overlay.style.fontFamily = 'sans-serif';
    this.overlay.style.maxWidth = '300px';
    this.overlay.innerHTML = `
      <b>Deburring Tool</b><br><br>
      • Tap to rotate the deburring blade<br>
      • Used to clean inside/outside of cut pipe<br>
      • Removes sharp edges before fitting installation<br>
    `;
    this.container.appendChild(this.overlay);
  }

  async init() {
    await this.loadModel('/assets/models/tools/deburring_tool.glb');
  }

  private async loadModel(path: string) {
    return new Promise<void>((resolve, reject) => {
      this.loader.load(
        path,
        (gltf) => {
          const model = gltf.scene;
          model.position.set(0, 0, 0);

          model.traverse((child: any) => {
            if (child.isMesh) {
              child.castShadow = true;
              child.receiveShadow = true;
            }
          });

          this.scene.add(model);

          if (gltf.animations.length > 0) {
            this.mixer = new THREE.AnimationMixer(model);
            const action = this.mixer.clipAction(gltf.animations[0]);
            action.loop = THREE.LoopOnce;
            action.clampWhenFinished = true;
          }

          resolve();
        },
        undefined,
        reject
      );
    });
  }

  private registerEvents() {
    this.renderer.domElement.addEventListener('pointerdown', (event) => {
      const rect = this.renderer.domElement.getBoundingClientRect();
      this.mouse.x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
      this.mouse.y = -((event.clientY - rect.top) / rect.height) * 2 + 1;

      this.handleTap();
    });
  }

  private handleTap() {
    this.raycaster.setFromCamera(this.mouse, this.camera);
    const hits = this.raycaster.intersectObjects(this.scene.children, true);
    if (hits.length === 0) return;

    if (this.mixer) {
      const action = this.mixer.clipAction(this.mixer.getRoot().animations?.[0]);
      action.reset();
      action.play();
    }
  }

  resize() {
    const w = this.container.clientWidth;
    const h = this.container.clientHeight;
    this.camera.aspect = w / h;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(w, h);
  }

  update() {
    const delta = this.clock.getDelta();
    if (this.mixer) this.mixer.update(delta);
    this.controls.update();
    this.renderer.render(this.scene, this.camera);
  }

  dispose() {
    this.renderer.dispose();
    this.controls.dispose();
    this.overlay.remove();
  }
}
