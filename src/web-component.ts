import "glint-environment-gxt";
import "decorator-transforms/globals";

import styleText from "./style.css?inline";

import { renderComponent, runDestructors, type ComponentReturnType } from "@lifeart/gxt";
// @ts-ignore unknown module import
import App from "./App.gts";

if (import.meta.env.DEV) {
  // @ts-ignore wrong dts
  await import('@lifeart/gxt/ember-inspector');
}
class DocHash extends HTMLElement {
  static observedAttributes = [];
  instance: ComponentReturnType | null =  null
  constructor() {
    // Always call super first in constructor
    super();
  }

  async connectedCallback() {
    const root = this.attachShadow({
      mode: 'closed'
    });
    this.instance = renderComponent(
      new App({}) as unknown as ComponentReturnType,
      root
    );
    const style = document.createElement('style');
    style.textContent = styleText;
    root.appendChild(style);
  }

  disconnectedCallback() {
    if (!this.instance) {
      return;
    }
    runDestructors(this.instance.ctx!, []);
  }
}

customElements.define("doc-hash", DocHash);

