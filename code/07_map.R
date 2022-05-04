
library(sf)
library(spData)
library(ggplot2)
library(googleway)
library(ggmap)
library(ggrepel)
# register_google(key = '')  you put your API key here.



#Thanks to Masumbuko Semba for publishing the main code used below (https://semba-blog.netlify.app/10/20/2018/genetic-connectivity-in-western-indian-ocean-region/), and Dominic Woolf on Stack Overflow for the degree symbol workaround (https://stackoverflow.com/a/57468208/15181607)

hospitals_deduped_w_latlon_clean <- fread("./data/hospitals_deduped_w_latlon_clean.csv")

sf_point <- hospitals_deduped_w_latlon_clean %>% 
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(4326)

xlabs = c(80, 120)
ylabs = c(20, 40)

china_map <- ggplot() + 
  geom_sf(data = spData::world, col = 1, fill = "ivory") +
  coord_sf(xlim = c(70,140), ylim = c(15,50)) +
  geom_point(data = hospitals_deduped_w_latlon_clean, aes(x = lon, y = lat), size = 2.5, color = "red", shape = "circle") +
  ggrepel::geom_text_repel(data = hospitals_deduped_w_latlon_clean, aes(x = lon, y = lat, label = NA), nudge_y = 1.5, nudge_x = 5) +
  theme_bw() +
  theme(axis.text = element_text(size = 11, colour = 1),
        panel.background = element_rect(fill = "lightblue"), axis.title = element_blank(),
        panel.grid = element_line(colour = NA)) +
  scale_x_continuous(breaks = xlabs, labels = paste0(xlabs,'°E')) +
  scale_y_continuous(breaks = ylabs, labels = paste0(ylabs,'°N')) +
  theme(axis.text = element_text(size=16)) +
  labs(x = NULL, y = NULL)

ggsave("./figures/Fig2.png")
