import { createEngine } from './engine.js';
import * as THREE from 'three';

let engine = null;

export function loadScene(moduleId) {
  if (!engine) engine = createEngine();

  const { scene } = engine;

  // Clear previous scene
  while (scene.children.length > 0) {
    scene.remove(scene.children[0]);
  }

  // Load the module scene
  import(`../scenes/${moduleId}-scene.js`).then(mod => {
    mod.buildScene(scene);
  });
}
