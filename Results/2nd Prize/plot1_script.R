##
## Data visualization contest with R: fourth edition
##


# Load necessary libraries
library(leaflet)         # For interactive maps
library(dplyr)           # For data manipulation
library(readr)           # For reading data files
library(htmlwidgets)     # For saving interactive maps
library(collegeScorecard) # For accessing the dataset
library(ggplot2)        # For plots
library(plotly)         # For interactive plots
library(sf)             # For spatial data manipulation
library(tigris)         # For obtaining US shapefiles
library(base64enc)      # For encoding images in base64

# Load the dataset
data(school, package = "collegeScorecard")

# Filter data: remove entries without coordinates
data_filtered <- school %>%
  filter(!is.na(latitude), !is.na(longitude))

# Count colleges by state
state_counts <- data_filtered %>%
  group_by(state) %>%
  summarise(count = n())

# Get US states shapefile
usa_states <- states(cb = TRUE) %>%
  rename(state = STUSPS) 
usa_states <- usa_states %>%
  left_join(state_counts, by = "state")

# Create color palette for states based on college count
state_palette <- colorNumeric(
  palette = "YlOrRd",
  domain = usa_states$count,
  na.color = "gray"
)

# Define colors based on college type
color_palette <- colorFactor(
  palette = c("blue", "red", "green"),  # Colors (Public, Nonprofit, For-profit)
  domain = data_filtered$control
)

# Function to generate bar chart
usa_states$img_base64 <- NA_character_
for (i in 1:nrow(usa_states)) {
  state_name <- usa_states$state[i] 
  state_data <- data_filtered %>% filter(state == state_name)
  
  if (nrow(state_data) > 0) {
    plot <- ggplot(state_data, aes(x = control, fill = control)) +
      geom_bar() +
      scale_fill_manual(values = c("Public" = "blue", "Nonprofit" = "red", "For-profit" = "green")) +
      labs(title = paste("Colleges in", state_name), x = "Institution Type", y = "Count") +
      theme_minimal()
    file_path <- tempfile(fileext = ".png")
    ggsave(file_path, plot, width = 5, height = 4, dpi = 100)
    usa_states$img_base64[i] <- base64enc::dataURI(file = file_path, mime = "image/png")
  }
}

# Create interactive map
map <- leaflet(usa_states) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~state_palette(count),
    weight = 1,
    opacity = 1,
    color = "white",
    fillOpacity = 0.7,
    highlight = highlightOptions(weight = 3, bringToFront = TRUE, fillOpacity = 1),
    label = ~paste0("State: ", state, " - Colleges: ", ifelse(is.na(count), 0, count)),
    popup = ~paste0(
      "<b>State:</b> ", state, "<br>",
      "<b>Total Colleges:</b> ", ifelse(is.na(count), 0, count), "<br>",
      ifelse(!is.na(img_base64), paste0("<img src='", img_base64, "' width='300' height='200'>"), "")
    ),
    group = "States"
  )

# Add colleges markers visible by default
map <- map %>%
  addCircleMarkers(
    data = data_filtered,
    ~longitude, ~latitude,
    color = ~color_palette(control),
    radius = 4,
    stroke = FALSE,
    fillOpacity = 0.7,
    group = "Colleges",
    popup = ~paste(
      "<b>", name, "</b><br>",
      "City: ", city, "<br>",
      "State: ", state, "<br>",
      "Type: ", control, "<br>",
      "<a href='", url, "' target='_blank'>Website</a>"
    )
  ) %>%
  addLayersControl(
    baseGroups = c("States", "Colleges"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  addLegend(
    "bottomright", 
    pal = state_palette, 
    values = ~count, 
    title = "Number of Colleges per State",
    opacity = 1,
    group = "States"
  ) %>%
  addLegend(
    "bottomright", 
    pal = color_palette, 
    values = data_filtered$control, 
    title = "College Type",
    opacity = 1,
    group = "Colleges"
  )

# Save map as HTML
saveWidget(map, file = "plot1.html", selfcontained = TRUE)



## This program creates an interactive map that allows users to explore 
##colleges in the United States by state or institution type. States are 
##color-coded based on the number of colleges, while individual colleges
##are marked with different colors according to their type (public, nonprofit, 
##or for-profit). Users can switch between viewing states or colleges using 
##a layer control. Clicking on a state displays a popup with the total number of
##colleges and an embedded bar chart showing the distribution of college
##types. Clicking on a college shows its details, including name, city, state,
##type, and website link.