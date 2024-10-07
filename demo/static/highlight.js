import hljs from "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.9.0/build/es/highlight.min.js";
import gleam from "https://cdn.jsdelivr.net/npm/@gleam-lang/highlight.js-gleam@1.5.0/+esm";
hljs.registerLanguage("gleam", gleam);

const template = document.createElement("template");
template.innerHTML = `
  <style>
      pre {
          font-family: "JetBrains Mono", monospace;
          font-optical-sizing: auto;
          font-weight: normal;
          font-style: normal;
          box-sizing: border-box;
          margin: 0;
      }

      .hljs {
          color: #00f;
          background: #fff;
      }
      .hljs-comment {
          color: green;
      }
      .hljs-tag {
          color: #444a;
      }
      .hljs-tag .hljs-attr,
      .hljs-tag .hljs-name {
          color: #444;
      }
      .hljs-attribute,
      .hljs-doctag,
      .hljs-function,
      .hljs-keyword,
      .hljs-name,
      .hljs-punctuation,
      .hljs-selector-tag {
          color: red;
      }
      .hljs-params,
      .hljs-type {
          color: #00f;
      }
      .hljs-deletion,
      .hljs-number,
      .hljs-quote,
      .hljs-selector-class,
      .hljs-selector-id,
      .hljs-string,
      .hljs-symbol,
      .hljs-template-tag {
          color: #000;
      }
      .hljs-section,
      .hljs-title {
          color: #00f;
      }
      .hljs-link,
      .hljs-operator,
      .hljs-regexp,
      .hljs-selector-attr,
      .hljs-selector-pseudo,
      .hljs-template-variable,
      .hljs-variable {
          color: #ab5656;
      }
      .hljs-literal {
          color: red;
      }
      .hljs-addition,
      .hljs-built_in,
      .hljs-bullet,
      .hljs-code {
          color: #00f;
      }
      .hljs-meta,
      .hljs-meta .hljs-keyword,
      .hljs-meta .hljs-string {
          color: #963200;
      }
      .hljs-emphasis {
          font-style: italic;
      }
      .hljs-strong {
          font-weight: 700;
      }
  </style>
`;

class HighlightedCode extends HTMLElement {
  static observedAttributes = ["code"];

  constructor() {
    super();
    this.pre = document.createElement("pre");
    this.shadow = this.attachShadow({ mode: "open" });
    this.shadow.appendChild(template.content.cloneNode(true));
    this.shadow.appendChild(this.pre);
  }

  attributeChangedCallback(name, _oldValue, newValue) {
    if (name === "code") {
      this.pre.innerHTML = hljs.highlight(newValue, {
        language: "gleam",
        ignoreIllegals: true,
      }).value;
    }
  }
}

window.customElements.define("highlighted-code", HighlightedCode);
