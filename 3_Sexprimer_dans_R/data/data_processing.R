### Preparing the data for the course
library(dplyr)
library(tidyr)
load(file = "3_Sexprimer_dans_R/data/data_preprocessed.RData")
pop_groupage_df <- mli_censuses %>% 
  filter(source == "RGPH" & !(groupage == "Total") ) %>% 
  select(annee, id, groupage, homme = Homme, femme = Femme, total = Total) %>%
  mutate(groupage = factor(reorder(groupage, id), ordered = TRUE)) %>% 
  select(-c(id))

# Gestion des NA
pop_groupage_df <- pop_groupage_df %>% 
  gather(key = groupe, value = population, homme, femme, total) %>% 
  mutate(population = ifelse(is.na(population), 0, population)) %>% 
  spread(key = groupe, value = population)

# Retour au format data.frame
pop_groupage_df <- as.data.frame(pop_groupage_df)
pop_groupage_list <- list("1976" = pop_groupage_df[pop_groupage_df$annee == 1976, ],
                          "1987" = pop_groupage_df[pop_groupage_df$annee == 1987, ],
                          "1998" = pop_groupage_df[pop_groupage_df$annee == 1998, ],
                          "2009" = pop_groupage_df[pop_groupage_df$annee == 2009, ])

rm(list = c("CREEDB_POPULATION", "mli_censuses", "pop_groupage_df"))

save.image("3_Sexprimer_dans_R/data/data.RData")
