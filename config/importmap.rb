# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-timeago", to: "https://ga.jspm.io/npm:stimulus-timeago@4.1.0/dist/stimulus-timeago.mjs"
pin "@babel/runtime/helpers/esm/assertThisInitialized", to: "https://ga.jspm.io/npm:@babel/runtime@7.23.9/helpers/esm/assertThisInitialized.js"
pin "@babel/runtime/helpers/esm/classCallCheck", to: "https://ga.jspm.io/npm:@babel/runtime@7.23.9/helpers/esm/classCallCheck.js"
pin "@babel/runtime/helpers/esm/createClass", to: "https://ga.jspm.io/npm:@babel/runtime@7.23.9/helpers/esm/createClass.js"
pin "@babel/runtime/helpers/esm/createForOfIteratorHelper", to: "https://ga.jspm.io/npm:@babel/runtime@7.23.9/helpers/esm/createForOfIteratorHelper.js"
pin "@babel/runtime/helpers/esm/createSuper", to: "https://ga.jspm.io/npm:@babel/runtime@7.23.9/helpers/esm/createSuper.js"
pin "@babel/runtime/helpers/esm/defineProperty", to: "https://ga.jspm.io/npm:@babel/runtime@7.23.9/helpers/esm/defineProperty.js"
pin "@babel/runtime/helpers/esm/inherits", to: "https://ga.jspm.io/npm:@babel/runtime@7.23.9/helpers/esm/inherits.js"
pin "@babel/runtime/helpers/esm/typeof", to: "https://ga.jspm.io/npm:@babel/runtime@7.23.9/helpers/esm/typeof.js"
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.2.2/dist/stimulus.js"
pin "date-fns", to: "https://ga.jspm.io/npm:date-fns@2.30.0/esm/index.js"
