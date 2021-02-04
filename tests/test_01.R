library(webcalc)
vars = list(
  'constant' = list('type' = 'constant', value = 1, df = 1),
  'sex' = list('type' = 'categoric', df = 1, cat = list(
    list(level = 'men')
  ), levels = c('woman', 'man')),
  'age' = list('type' = 'numeric', df = 1),
  'hba1c' = list('type' = 'numeric', df = 1),
  'smoking' = list('type' = 'categoric', df = 1, cat = list(
    list(level = 'yes')
  ), levels = c('no', 'yes')),
  'waist_tg' = list('type' = 'numeric', df = 1),
  'retinopathy' = list('type' = 'categoric', df = 1, cat = list(
    list(level = 'yes')
  ), levels = c('no', 'yes'))
)

coefs = c(log(0.0000524),
          log(3.00),      # men
          log(1.14),      # age            # 50
          log(1.20),      # hbA1c          #  8
          log(1.34),      # smoking
          log(1.05),      # waist_tg       # 95 * 1.129 = 107.255  waist (cm) x triglycerides (mmol/L)
          log(2.39))      # retinopathy

labels = list('l_main_title' = list('eng' = 'Subclinical atherosclerosis'),
              'l_main_subtitle' = list('eng' = ''),
              'l_instructions' = list('eng' = 'Instructions'),
              'l_covariates' = list('eng' = 'Covariates'),
              'l_calculate_value' = list('eng' = 'Get probability'),
              'l_clean_button' = list('eng' = 'Clean form'),
              'l_sex' = list('eng' = 'Sex'),
              'l_sex_man' = list('eng' = 'Man'),
              'l_sex_woman' = list('eng' = 'Woman'),
              'l_age' = list('eng' = 'Age'),
              'l_hba1c' = list('eng' = 'HbA1c'),
              'l_smoking' = list('eng' = 'Tobacco exposure'),
              'l_smoking_no' = list('eng' = 'No'),
              'l_smoking_yes' = list('eng' = 'Yes'),
              'l_waist_tg' = list('eng'= 'Waist-trygliceride index'),
              'l_retinopathy' = list('eng' = 'Retinopathy'),
              'l_retinopathy_no' = list('eng' = 'No'),
              'l_retinopathy_yes' = list('eng' = 'Yes'))

webcalc_coefs(coefs, vars, labels, title = 'Subclinical atherosclerosis')
