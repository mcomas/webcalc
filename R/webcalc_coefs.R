
webcalc_coefs <- function(coefs, vars, labels = NULL, title = 'Webcalc', output_dir = 'www') {
  js_x = initialise_variables(vars)
  js_b = sprintf("b = Array(%s);", paste(coefs, collapse = ', '))
  js_lp = linear_prediction(length(coefs), b = 'b', lp = 'lp')
  # list(js_x, js_b, js_lp)

  dir.create(output_dir)
  file.copy(c(system.file('template/app.js', package = 'webcalc'),
              system.file('template/style.css', package = 'webcalc')),
            output_dir, overwrite = TRUE)
  knitr::knit(system.file('template/default_webcalc.Rhtml', package = 'webcalc'),
              output = file.path(output_dir, 'index.html'))
  servr::httd(output_dir)
}
