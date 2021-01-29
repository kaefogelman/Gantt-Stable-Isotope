mix.filename <- read.csv("Gantt_mussels.csv")
source.filename <- read.csv("Gantt_sources_notcombined.csv")
discr.filename <- read.csv("Gantt_TDF10.csv")

install.packages("MixSIAR")
library(MixSIAR)

model_filename <- "MixSIAR_model.txt"  
resid_err <- TRUE
process_err <- TRUE

output_options <- list(summary_save = TRUE,                 		
                       summary_name = "summary_statistics", 		
                       sup_post = TRUE,                    		
                       plot_post_save_pdf = TRUE,           		
                       plot_post_name = "posterior_density",		
                       sup_pairs = TRUE,             		
                       plot_pairs_save_pdf = TRUE,    		
                       plot_pairs_name = "pairs_plot",		
                       sup_xy = TRUE,           		
                       plot_xy_save_pdf = FALSE,		
                       plot_xy_name = "xy_plot",		
                       gelman = TRUE,		
                       heidel = FALSE,  		
                       geweke = TRUE,   		
                       diag_save = TRUE,		
                       diag_name = "diagnostics",		
                       indiv_effect = FALSE,       		
                       plot_post_save_png = FALSE, 		
                       plot_pairs_save_png = FALSE,		
                       plot_xy_save_png = FALSE,
                       return_obj = TRUE)	

##NULL MODEL
mix <- load_mix_data(filename="Gantt_mussels.csv", 
                     iso_names=c("d13C","d15N"),
                     factors=NULL, 
                     fac_random=NULL,
                     fac_nested=NULL,
                     cont_effects=NULL)

source <- load_source_data(filename="Gantt_sources_notcombined.csv",
                           source_factors=NULL,
                           conc_dep=FALSE,
                           data_type="means",
                           mix)

source.filename<-read.csv("Gantt_sources_notcombined.csv")

discr <- load_discr_data(filename="Gantt_TDF10.csv", mix)

plot_data(filename="isospace_plot", 	
          plot_save_pdf=FALSE,	
          plot_save_png=FALSE,	
          mix,source,discr)

write_JAGS_model(model_filename, resid_err, process_err, mix, source)

jags.1 <- run_model(run = "test", mix, source, discr, model_filename, 
                    alpha.prior=1, resid_err, process_err)

jags.1 <- run_model(run = "long", mix, source, discr, model_filename, 
                    alpha.prior=1, resid_err, process_err)

diag.null <- output_JAGS(jags.1, mix, source, output_options)

##Species
mix <- load_mix_data(filename="Gantt_mussels.csv", 
                     iso_names=c("d13C","d15N"),
                     factors="Species", 
                     fac_random=FALSE,
                     fac_nested=FALSE,
                     cont_effects=NULL)

source <- load_source_data(filename="Gantt_sources_notcombined.csv",
                           source_factors=NULL,
                           conc_dep=FALSE,
                           data_type="means",
                           mix)

source.filename<-read.csv("Gantt_sources_notcombined.csv")

discr <- load_discr_data(filename="Gantt_TDF10.csv", mix)

plot_data(filename="isospace_plot", 	
          plot_save_pdf=FALSE,	
          plot_save_png=FALSE,	
          mix,source,discr)

write_JAGS_model(model_filename, resid_err, process_err, mix, source)

jags.2 <- run_model(run = "test", mix, source, discr, model_filename, 
                    alpha.prior=1, resid_err, process_err)

jags.2 <- run_model(run = "normal", mix, source, discr, model_filename, 
                    alpha.prior=1, resid_err, process_err)

diag.species <- output_JAGS(jags.2, mix, source, output_options)

##Species - Lit Prior 

lit.prior = c(0.2,0.2,0.6)

jags.3 <- run_model(run = "test", mix, source, discr, model_filename, 
                    alpha.prior=lit.prior, resid_err, process_err)

jags.3 <- run_model(run = "very short", mix, source, discr, model_filename, 
                    alpha.prior=lit.prior, resid_err, process_err)

lit.prior <- output_JAGS(jags.3, mix, source, output_options)

#####################################
###SIMPLIFIED SOURCES - NULL MODEL###
mix <- load_mix_data(filename="Gantt_mussels.csv", 
                     iso_names=c("d13C","d15N"),
                     factors=NULL, 
                     fac_random=NULL,
                     fac_nested=NULL,
                     cont_effects=NULL)

source <- load_source_data(filename="Gantt_sources_combined.csv",
                           source_factors=NULL,
                           conc_dep=FALSE,
                           data_type="means",
                           mix)

test1 <- read.csv(path, header=TRUE)

source.filename <- read.csv("Gantt_sources_notcombined.csv")
source.filename <- read.csv("Gantt_sources_combined2.csv", header = TRUE)

discr <- load_discr_data(filename="Gantt_TDF10.csv", mix)

plot_data(filename="isospace_plot", 	
          plot_save_pdf=FALSE,	
          plot_save_png=FALSE,	
          mix,source,discr)

write_JAGS_model(model_filename, resid_err, process_err, mix, source)

jags.1 <- run_model(run = "test", mix, source, discr, model_filename, 
                    alpha.prior=1, resid_err, process_err)

jags.1 <- run_model(run = "long", mix, source, discr, model_filename, 
                    alpha.prior=1, resid_err, process_err)

diag.null <- output_JAGS(jags.1, mix, source, output_options)