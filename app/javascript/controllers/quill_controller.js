import { Controller } from "@hotwired/stimulus"
import Quill from "quill"

export default class extends Controller {
  connect() {
    var editor = new Quill('#editor', {
      modules: { toolbar: '#toolbar' },
      theme: 'snow'
    });
  }
}
