// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

bool _scriptInjected = false;
bool _runtimeScriptInjected = false;

Widget? buildPet3DWeb({
  required String modelUrl,
  required String animationName,
  required String fallbackLabel,
  required double borderRadius,
  bool runtimeAttach = false,
  String? hatAssetUrl,
  String? outfitAssetUrl,
  String? bgAssetUrl,
}) {
  if (runtimeAttach) {
    _ensureRuntimeAttachScript();
    final viewType = 'pet-runtime-attach-${DateTime.now().microsecondsSinceEpoch}';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final container = html.DivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.borderRadius = '${borderRadius}px'
        ..style.overflow = 'hidden'
        ..style.position = 'relative'
        ..classes.add('runpet-runtime-3d')
        ..setAttribute('data-base-url', modelUrl)
        ..setAttribute('data-animation', animationName)
        ..setAttribute('data-hat-url', hatAssetUrl ?? '')
        ..setAttribute('data-outfit-url', outfitAssetUrl ?? '')
        ..setAttribute('data-bg-url', bgAssetUrl ?? '');
      return container;
    });
    return HtmlElementView(viewType: viewType);
  }

  if (!_scriptInjected) {
    _scriptInjected = true;
    final script = html.ScriptElement()
      ..type = 'module'
      ..src = 'https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js';
    html.document.head?.append(script);
  }

  final viewType = 'pet-model-viewer-${DateTime.now().microsecondsSinceEpoch}';
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final container = html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.borderRadius = '${borderRadius}px'
      ..style.overflow = 'hidden';

    final modelViewer = html.Element.tag('model-viewer')
      ..setAttribute('src', modelUrl)
      ..setAttribute('alt', fallbackLabel)
      ..setAttribute('auto-rotate', '')
      ..setAttribute('camera-controls', '')
      ..setAttribute('disable-zoom', '')
      ..setAttribute('animation-name', animationName)
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.backgroundColor = 'transparent';

    container.children.add(modelViewer);
    return container;
  });

  return HtmlElementView(viewType: viewType);
}

void _ensureRuntimeAttachScript() {
  if (_runtimeScriptInjected) return;
  _runtimeScriptInjected = true;
  final runtimeScript = html.ScriptElement()
    ..type = 'module'
    ..text = '''
import * as THREE from 'https://unpkg.com/three@0.161.0/build/three.module.js';
import { GLTFLoader } from 'https://unpkg.com/three@0.161.0/examples/jsm/loaders/GLTFLoader.js';
import { OrbitControls } from 'https://unpkg.com/three@0.161.0/examples/jsm/controls/OrbitControls.js';

const mounts = new WeakMap();
const loader = new GLTFLoader();

function fitCamera(camera, object) {
  const box = new THREE.Box3().setFromObject(object);
  const size = box.getSize(new THREE.Vector3());
  const center = box.getCenter(new THREE.Vector3());
  const maxDim = Math.max(size.x, size.y, size.z) || 1;
  const fov = camera.fov * Math.PI / 180;
  const distance = maxDim / (2 * Math.tan(fov / 2));
  camera.position.set(center.x, center.y + maxDim * 0.15, center.z + distance * 1.35);
  camera.near = 0.01;
  camera.far = distance * 20;
  camera.lookAt(center);
  camera.updateProjectionMatrix();
}

async function loadIntoAnchor(slotRoot, slotName, url) {
  if (!slotRoot || !url) return;
  const gltf = await loader.loadAsync(url);
  const obj = gltf.scene || gltf.scenes?.[0];
  if (!obj) return;
  obj.name = 'runpet-slot-' + slotName;
  const prev = slotRoot.getObjectByName(obj.name);
  if (prev) slotRoot.remove(prev);
  slotRoot.add(obj);
}

async function mount(el) {
  if (mounts.has(el)) return;
  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(35, 1, 0.01, 200);
  const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderer.setPixelRatio(window.devicePixelRatio || 1);
  renderer.setClearColor(0x000000, 0);
  renderer.outputColorSpace = THREE.SRGBColorSpace;
  renderer.toneMapping = THREE.ACESFilmicToneMapping;
  renderer.toneMappingExposure = 1.1;
  el.appendChild(renderer.domElement);

  const controls = new OrbitControls(camera, renderer.domElement);
  controls.enablePan = false;
  controls.enableZoom = false;
  controls.minPolarAngle = Math.PI * 0.35;
  controls.maxPolarAngle = Math.PI * 0.6;
  controls.target.set(0, 0.8, 0);

  const hemi = new THREE.HemisphereLight(0xffffff, 0x444466, 0.95);
  scene.add(hemi);
  const key = new THREE.DirectionalLight(0xffffff, 1.0);
  key.position.set(2.5, 3.0, 2.0);
  scene.add(key);
  const rim = new THREE.DirectionalLight(0xb0c8ff, 0.6);
  rim.position.set(-2.0, 2.0, -2.0);
  scene.add(rim);

  const resize = () => {
    const width = Math.max(1, el.clientWidth || 1);
    const height = Math.max(1, el.clientHeight || 1);
    renderer.setSize(width, height, false);
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
  };
  resize();
  const ro = new ResizeObserver(resize);
  ro.observe(el);

  const root = new THREE.Group();
  scene.add(root);
  let mixer = null;

  try {
    const base = await loader.loadAsync(el.dataset.baseUrl || '');
    const baseRoot = base.scene || base.scenes?.[0];
    if (baseRoot) {
      root.add(baseRoot);
      fitCamera(camera, baseRoot);

      if (base.animations && base.animations.length > 0) {
        mixer = new THREE.AnimationMixer(baseRoot);
        const target = (el.dataset.animation || '').toLowerCase();
        const clip = base.animations.find(a => a.name.toLowerCase() === target) || base.animations[0];
        mixer.clipAction(clip).play();
      }

      const slotHat = baseRoot.getObjectByName('slot_hat');
      const slotOutfit = baseRoot.getObjectByName('slot_outfit');
      const slotBg = baseRoot.getObjectByName('slot_bg_anchor');
      await Promise.all([
        loadIntoAnchor(slotHat, 'hat', el.dataset.hatUrl || ''),
        loadIntoAnchor(slotOutfit, 'outfit', el.dataset.outfitUrl || ''),
        loadIntoAnchor(slotBg, 'bg', el.dataset.bgUrl || ''),
      ]);
    }
  } catch (e) {
    console.error('runpet runtime-attach mount failed', e);
  }

  const clock = new THREE.Clock();
  let disposed = false;
  const tick = () => {
    if (disposed) return;
    const dt = Math.min(clock.getDelta(), 0.033);
    if (mixer) mixer.update(dt);
    controls.update();
    renderer.render(scene, camera);
    requestAnimationFrame(tick);
  };
  tick();

  mounts.set(el, () => {
    disposed = true;
    ro.disconnect();
    controls.dispose();
    renderer.dispose();
    if (renderer.domElement && renderer.domElement.parentNode === el) {
      el.removeChild(renderer.domElement);
    }
  });
}

function unmount(el) {
  const dispose = mounts.get(el);
  if (dispose) {
    dispose();
    mounts.delete(el);
  }
}

function scan(root) {
  root.querySelectorAll?.('.runpet-runtime-3d').forEach(mount);
}
scan(document);

const mo = new MutationObserver((records) => {
  for (const record of records) {
    record.addedNodes.forEach((node) => {
      if (!(node instanceof HTMLElement)) return;
      if (node.classList?.contains('runpet-runtime-3d')) mount(node);
      scan(node);
    });
    record.removedNodes.forEach((node) => {
      if (!(node instanceof HTMLElement)) return;
      if (node.classList?.contains('runpet-runtime-3d')) unmount(node);
      node.querySelectorAll?.('.runpet-runtime-3d').forEach(unmount);
    });
  }
});
mo.observe(document.body, { childList: true, subtree: true });
''';
  html.document.head?.append(runtimeScript);
}
