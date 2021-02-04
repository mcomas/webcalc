initialise_variables = function(vars, x = 'x'){
  ndf = sum(sapply(vars, getElement, 'df'))

  in_range = function(x, lo = -Inf, hi = Inf, lo_c = TRUE, hi_c = TRUE){
    if(lo_c & hi_c) res = sprintf("%f <= %s && %s <= %f", lo, x, x, hi)
    else if(lo_c) res = sprintf("%f <= %s && %s < %f", lo, x, x, hi)
    else if(hi_c) res = sprintf("%f < %s && %s <= %f", lo, x, x, hi)
    else res = sprintf("%f < %s && %s < %f", lo, x, x, hi)
    sprintf("Number(%s)", sub("Inf", "Infinity", res, ignore.case = FALSE))
  }

  i = 0
  js_vars = sprintf("%s = Array(%d);", x, ndf);
  for(I in 1:length(vars)){
    X = vars[[I]]
    Xname = names(vars[I])
    if(X$type == 'constant'){
      js_vars = paste(js_vars,
                      sprintf("%s[%d] = %f;", x, i, X$value),
                      sep = '\n')
      i = i + 1
    }
    if(X$type == 'numeric'){
      js_vars = paste(js_vars,
                      sprintf("%s = Number($('#%s_value').val());", Xname, Xname),
                      sep = '\n')

      if('cat' %in% names(X)){
        for(pars in X$cat){
          js_vars = paste(js_vars,
                          sprintf("%s[%d] = %s;", x, i, do.call('in_range', c(x = Xname, pars))),
                          sep = '\n')
          i = i + 1
        }
      }else{
        js_vars = paste(js_vars,
                        sprintf("%s[%d] = %s;", x, i, Xname),
                        sep = '\n')
        i = i + 1
      }
    }
    if(X$type == 'categoric'){
      if('cat' %in% names(X)){
        js_vars = paste(js_vars,
                        sprintf("%s = '%s';", Xname, setdiff(X$levels, sapply(X$cat, getElement, 'level'))),
                        sep = '\n')
        for(lvl in X$cat){
          js_vars = paste(js_vars,
                          sprintf("%s = ($('#%s_%s').prop('checked') ? '%s' : %s);", Xname, Xname, lvl, lvl, Xname),
                          sep = '\n')
          js_vars = paste(js_vars,
                          sprintf("%s[%d] = Number(%s == '%s');", x, i, Xname, lvl),
                          sep = '\n')
          i = i + 1
        }
      }
    }
  }
  js_vars
}
linear_prediction = function(ndf, lp = 'lp', b = 'b', x = 'x'){
  i = (1:ndf) - 1
  sprintf("%s = %s;", lp, paste(sprintf("%s[%d] * %s[%d]", b, i, x, i), collapse = ' + '))
}

constant_div = function(var){
  div = '<input type="hidden" id="constant_value" name="constant_value" value="1" />'
  div
}

numeric_div = function(var){
  vname = names(var)
  div = '<div id="div_id_%s" class="form-group required">
\t<label class="control-label col-md-7  requiredField"><div id="l_%s">l_%s</div></label>
\t<div class="controls col-md-5 ">
\t\t<input class="input-md  textinput textInput form-control" id="%s_value" name="%s_value" placeholder="placeholder" style="margin-bottom: 10px" type="text" />
\t</div>
</div>'
  sprintf(div, vname, vname, vname, vname, vname)
}

categoric_div = function(var){
  vname = names(var)
  div = '<div id="div_id_%s" class="form-group required">
\t<label class="control-label col-md-7  requiredField"><div id="l_%s">l_%s</div></label>
\t<div class="controls col-md-5 "  style="margin-bottom: 10px">
%s
\t</div>
</div>'

  sprintf(div, vname, vname, vname,
          paste(sapply(var[[1]]$levels, function(lvl){
            sprintf('\t\t<label class="radio-inline"><input type="radio" name="%s" id="%s_%s" style="margin-bottom: 10px"><div id="l_%s_%s">l_%s_%s</div></label><br />',
                    vname, vname, lvl, vname, lvl, vname, lvl)
          }), collapse='\n'))
}
