# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

pin "quill", to: "https://ga.jspm.io/npm:quill@1.3.7/dist/quill.js"
pin "buffer", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.13/nodelibs/browser/buffer.js"
