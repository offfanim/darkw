import { Controller } from "@hotwired/stimulus"
import Buffer from "buffer"
import Quill from "quill"

export default class extends Controller {
  static targets = [ "editor", "article" ]

  // fill hidden form before submit
  fill() {
    this.articleTarget.value = document.querySelector('.ql-editor').innerHTML
  }

  connect() {
    // Quill settings
    let toolbarOptions = [
      [{ 'header': 1 }],
      ['code-block'],
      ['italic', 'underline', 'strike'],
      ['link'],
      ['image']
    ];

    let container = this.editorTarget;

    let quill = new Quill(container, {
      theme: 'bubble',
      placeholder: 'Write',
      modules: {
        toolbar: toolbarOptions
      }
    });

    // change the link placeholder
    let tooltip = quill.theme.tooltip;
    let input = tooltip.root.querySelector("input[data-link]");
    input.dataset.link = 'add link and press Enter';

    // fix relative path of links in Quill
    let Link = Quill.import('formats/link');
    class CustomLink extends Link {
      static sanitize(url) {
        let value = super.sanitize(url);
        if (value) {
          for (let i = 0; i < this.PROTOCOL_WHITELIST.length; i++)
            if(value.startsWith(this.PROTOCOL_WHITELIST[i]))
              return value;
            return `http://${value}`
        }
        return value;
      }
    }
    Quill.register(CustomLink);

    // fill Quill editor from article value in edit viev
    document.querySelector('.ql-editor').innerHTML = this.articleTarget.value;

    // focus on textarea after load page
    quill.focus();
  }
}
