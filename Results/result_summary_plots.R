
# Load libraries ----

library(dplyr)
library(ggplot2)
library(patchwork)


# Load data ----

df_res <- readxl::read_excel("Results/resultados_IV_concurso_visualizacion_R_final.xlsx", 
                                                           sheet = "Total") %>% 
  janitor::clean_names()

df_dem <- readxl::read_excel("Results/summary_demographics.xlsx")


# Result plot ----

(fig_res1 <- df_res %>% 
  mutate(concursante = gsub("Entrada", "Entry", concursante)) %>% 
  ggplot(aes(reorder(concursante, -total), total, fill = concursante)) +
  geom_col(position = position_dodge(.95),
           color = "gray40",
           alpha = .9) +
  scale_fill_manual(values = colorRamps::primary.colors()[-c(1,2,8,10)]) +
  geom_text(aes(label = total),
            angle = 90,
            hjust = 1.3,
            fontface = "bold") +
  scale_x_discrete(guide = guide_axis(angle = 90)) +
  hrbrthemes::theme_ipsum(base_size = 16) +
  theme(legend.position = "none") +
  labs(x = NULL,
       y = "Sum of jury's scores",
       title = "IV Data Visualization Contest with R",
       subtitle = "Grupo de R de Asturias"))


# Demographic plot ----

(fig_res2 <- df_dem %>% 
  mutate(gender = case_when(gender == "F" ~ "Female",
                            .default = "Male")) %>% 
  distinct(id_person, .keep_all = T) %>% 
  group_by(gender) %>% 
  count() %>% 
  ggplot(aes(n, gender, fill = gender)) +
  geom_col() +
  geom_text(aes(label = n),
            hjust = 2,
            fontface = "bold") +
  # scale_fill_manual()
  hrbrthemes::theme_ipsum(base_size = 16) +
  theme(legend.position = "none") +
  labs(x = "# of participants",
       y = "Gender"))
  

# Combine plots ----

(fig_final <- fig_res1 / fig_res2 +
  plot_layout(heights = c(6, 1)))

# Export

# ggsave(filename = "Results/Results_IV_Data_Visualization_Contest_R.png",
#        plot = fig_final,
#        width = 7,
#        height = 9)
