function get_text(field, sub){
  return dictio[dictio.active][field][sub];
}
function get_instructions(){
  return dictio[dictio.active]['instructions'];
}

var state = [];
var intervention = [];

translate_labels = function(){
  labs = dictio[dictio.active]
  for(var i in labs){
    console.log(i);
    if (labs.hasOwnProperty(i)){
      for(var j in labs[i]){
        if (labs[i].hasOwnProperty(j) & j.substring(0, 2) == 'l_'){
          console.log(j);
          $('*[id*=' + j +']').each(function() {
	          $(this).html(get_text(i, j));
	        });
        }
      }
    }
  }
}

function refresh_covariates(){
  return '-1';
}

function refreshUI(){
  var state = [];
  state['covariates'] = refresh_covariates();
}

function iniUI(){
  $('#result').hide();
  var tabs = ['dictionary'];
  for(var i=0;i<tabs.length;i++){
    $("#l_" + tabs[i]).html(get_text(tabs[i], 'title'));
  }

  translate_labels();
  $('.lang_class a').click(function(){
	LANG=this.id.replace('lang_','');
        console.log(dictio.active);
        dictio.active = LANG;
        console.log(dictio.active);
	translate_labels();
	$('.lang_class').removeClass("current");
	$(this).parent().addClass("current")
	return false});

  $('#calculate_value').click(function() {
    $('#result').show();
    $('#result').css("background-color", "white");
    $([document.documentElement, document.body]).animate({
        scrollTop: $("#result").offset().top
    }, 500);
    all_ok = check_form();
    if(!all_ok){
      console.log("error detected");
      return;
    }
    console.log("calculate risk");
    current_risk = (100*calculate_value()).toPrecision(2);
    message = '<h1>Calculator 1</h1><hr>Probability: <b>' + current_risk + ' %</b>.<br />';

    $('#result').html(message);
  });

  $('#clean_button').click(function() {
    $('#result').hide();
    console.log("clicked");
    uncheck_form();
  });

  $('#cv_history_yes').change(refreshUI);
  $('#cv_history_no').change(refreshUI);
  $('#panel-result').hide();
  refreshUI();
  $("#info_instructions").click(function(){
    $('#result').show();
    $([document.documentElement, document.body]).animate({
        scrollTop: $("#result").offset().top
    }, 500);
    $('#result').css("background-color", "#fcf0ad");
		$('#result').html(get_instructions());
	});
}

$(document).ready(iniUI);
