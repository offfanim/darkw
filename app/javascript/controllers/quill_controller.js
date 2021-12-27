import { Controller } from "@hotwired/stimulus"
import Quill from "quill"

export default class extends Controller {
  static targets = [ "editor" ]

  fill() {
    document.getElementById('article_body').value = document.querySelector('.ql-editor').innerHTML
  }

  connect() {
    // Quill settings
    var toolbarOptions = [
      [{ 'header': 1 }],
      ['code-block'],
      ['italic', 'underline', 'strike'],
      ['link'],
      ['image']
    ];

    var container = document.getElementById('editor');

    var quill = new Quill(container, {
      theme: 'bubble',
      placeholder: 'Write',
      modules: {
        toolbar: toolbarOptions
      }
    });

    // fill Quill editor from article value in edit viev
    document.querySelector('.ql-editor').innerHTML = document.getElementById('article_body').value;

  }
}
