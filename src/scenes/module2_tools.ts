import * as THREE from 'three';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';

export class Module2ToolsScene {
  private container: HTMLElement;
  private scene: THREE.Scene;
  private camera: THREE.PerspectiveCamera;
  private renderer: THREE.WebGLRenderer;
  private controls: OrbitControls;
  private clock: THREE.Clock;
  private raycaster: THREE.Raycaster;
  private mouse: THREE.Vector2;

  private mixers: THREE.AnimationMixer[] = [];
  private tools: {
    name: string;
    model: THREE.Object3D;
    mixer: THREE.AnimationMixer | null;
    animations: THREE.AnimationClip[];
  }[] = [];

  private loader = new GLTFLoader();

  constructor(container: HTMLElement) {
    this.container = container;

    this.scene = new THREE.Scene();
    this.scene.background = new THREE.Color(0x0f0f12);

    const width = container.clientWidth;
    const height = container.clientHeight;

    this.camera = new THREE.PerspectiveCamera(45, width / height, 0.1, 100);
    this.camera.position.set(0, 1.5, 4);

    this.renderer = new THREE.WebGLRenderer({ antialias: true });
    this.renderer.setSize(width, height);
    this.renderer.outputEncoding = THREE.sRGBEncoding;
    container.appendChild(this.renderer.domElement);

    this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    this.controls.enableDamping = true;

    this.clock = new THREE.Clock();
    this.raycaster = new THREE.Raycaster();
    this.mouse = new THREE.Vector2();

    this.addLights();
    this.addFloor();
    this.registerEvents();
  }

  private addLights() {
    const hemi = new THREE.HemisphereLight(0xffffff, 0x222233, 0.7);
    this.scene.add(hemi);

    const key = new THREE.DirectionalLight(0xffffff, 1.0);
    key.position.set(3, 5, 4);
    key.castShadow = true;
    this.scene.add(key);
  }

  private addFloor() {
    const geo = new THREE.PlaneGeometry(10, 10);
    const mat = new THREE.MeshStandardMaterial({ color: 0x181820 });
    const mesh = new THREE.Mesh(geo, mat);
    mesh.rotation.x = -Math.PI / 2;
    mesh.receiveShadow = true;
    this.scene.add(mesh);
  }

  async init() {
    await Promise.all([
      this.loadTool('pipe_wrench', '/assets/models/tools/pipe_wrench.glb', -1.5),
      this.loadTool('pipe_cutter', '/assets/models/tools/pipe_cutter.glb', -0.9),
      this.loadTool('propane_torch', '/assets/models/tools/propane_torch.glb', -0.3),
      this.loadTool('press_tool', '/assets/models/tools/press_tool.glb', 0.3),
      this.loadTool('pex_crimp_tool', '/assets/models/tools/pex_crimp_tool.glb', 0.9),
      this.loadTool('deburring_tool', '/assets/models/tools/deburring_tool.glb', 1.5),
    ]);
  }

  private async loadTool(name: string, path: string, x: number) {
    return new Promise<void>((resolve, reject) => {
      this.loader.load(
        path,
        (gltf) => {
          const model = gltf.scene;
          model.name = name;
          model.position.set(x, 0, 0);

          model.traverse((child: any) => {
            if (child.isMesh) {
              child.castShadow = true;
              child.receiveShadow = true;
            }
          });

          this.scene.add(model);

          let mixer: THREE.AnimationMixer | null = null;
          if (gltf.animations.length > 0) {
            mixer = new THREE.AnimationMixer(model);
            const action = mixer.clipAction(gltf.animations[0]);
            action.loop = THREE.LoopOnce;
            action.clampWhenFinished = true;
          }

          this.tools.push({ name, model, mixer, animations: gltf.animations });
          if (mixer) this.mixers.push(mixer);

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

      this.handleSelection();
    });
  }

  private handleSelection() {
    this.raycaster.setFromCamera(this.mouse, this.camera);

    const objects = this.tools.map((t) => t.model);
    const hits = this.raycaster.intersectObjects(objects, true);
    if (hits.length === 0) return;

    const root = this.findRoot(hits[0].object);
    if (!root) return;

    const tool = this.tools.find((t) => t.model === root);
    if (!tool) return;

    this.playAnimation(tool);
    this.flashHighlight(tool);
  }

  private findRoot(obj: THREE.Object3D): THREE.Object3D | null {
    let current: THREE.Object3D | null = obj;
    while (current && !this.tools.some((t) => t.model === current)) {
      current = current.parent;
    }
    return current;
  }

  private playAnimation(tool: any) {
    if (!tool.mixer || tool.animations.length === 0) return;
    const action = tool.mixer.clipAction(tool.animations[0]);
    action.reset();
    action.play();
  }

  private flashHighlight(tool: any) {
    tool.model.traverse((child: any) => {
      if (child.isMesh) {
        child.userData._orig = child.material.emissive?.clone?.() ?? new THREE.Color(0x000000);
        if (child.material.emissive) child.material.emissive.setHex(0x2266ff);
      }
    });

    setTimeout(() => {
      tool.model.traverse((child: any) => {
        if (child.isMesh && child.userData._orig) {
          child.material.emissive.copy(child.userData._orig);
        }
      });
    }, 350);
  }

  resize() {
    const width = this.container.clientWidth;
    const height = this.container.clientHeight;
    this.camera.aspect = width / height;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(width, height);
  }

  update() {
    const delta = this.clock.getDelta();
    this.mixers.forEach((m) => m.update(delta));
    this.controls.update();
    this.renderer.render(this.scene, this.camera);
  }

  dispose() {
    this.renderer.dispose();
    this.controls.dispose();
  }
}
