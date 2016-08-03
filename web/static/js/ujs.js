function getCsrf() {
  return $("meta[name=csrf]").prop('content');
}

function buildForm({
  href,
  method
}) {
  return $($.parseHTML(`<form action='${href}' method=POST><input name="_csrf_token" type="hidden" value="${getCsrf()}"><input type=hidden name=_method value=${method} ></form>`))
}


function ujs() {
  $("[data-method]").on("click", function(e) {
    e.preventDefault()
    buildForm({
        href: $(this).prop("href"),
        method: $(this).data("method")
      }).appendTo("body")
      .submit()
  })
}

export default ujs
