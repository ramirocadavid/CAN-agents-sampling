
# Import agents data ----------------------------------------------------------------

# Connect to google sheets
library(googlesheets)
library(dplyr)
(my_sheets <- gs_ls())

# Connect to Panalo and Panalo data
sheet.panalo <- gs_title("PANALO Data Collection")
sheet.posible <- gs_title("POS!BLE Data Collection")

# Import agents data
panalo.agents <- gs_read(sheet.panalo, ws = "PANALO Agents_Updated", range = "A2:M277")
panalo.agents <- data.frame(panalo.agents, anm = rep("Panalo", nrow(panalo.agents)))
posible.agents <- gs_read(sheet.posible, ws = "POS!BLE Agents", range = "A2:N1290")
posible.agents <- data.frame(posible.agents, anm = rep("Posible", nrow(posible.agents)))
posible.agents <- posible.agents[, c(1:5, 8:14, 6, 15)]

# Rename variables
var.names <- c("Num", "Id", "first.name", "last.name", "gender", "mobile.num",
               "business.name", "business.type", "region", "province", "municipality",
               "barangay", "date.onboarded", "anm")
names(panalo.agents) <- var.names; names(posible.agents) <- var.names

# Merge into single dataset
all.agents <- rbind(panalo.agents, posible.agents)



# Select stratification variables ---------------------------------------------------

# Function to generate frequency tables
tables <- function(x) {data.frame(table(select(all.agents, x), useNA = 'always'))}
# Candidate variables
to.table <- names(all.agents)[c(5, 8:12, 14)]
# Frequency table for candidate variables
for(i in seq_along(to.table)) {
      print(to.table[i])
      print(tables(to.table[i]))
}
# Selected: Province


# Select sample ---------------------------------------------------------------------

# Select sample
source("stratified.R")
sample.agents <- stratified(df = all.agents, group = "anm", 
                            size =  773/nrow(all.agents))

# Export as xlsx file
library(xlsx)
write.xlsx(sample.agents, "can_sample_agents.xlsx", sheetName = "Sample agents")


# Create main and replacement -------------------------------------------------------

# Import sample generated
sample.agents <- read.xlsx("can_sample_agents.xlsx", sheetIndex = 1)
# Subsample of 400 agents
sample.agents.400 <- stratified(sample.agents, group = "anm", 
                                size = 400/nrow(sample.agents))
# Replacement with 373 agents left
sample.agents.replacement <- sample.agents[!(sample.agents$Id %in% sample.agents.400$Id), ]
# Export to xlsx
write.xlsx(sample.agents, "can_sample_agents_2.xlsx", sheetName = "all_sample_773")
write.xlsx(sample.agents.400, "can_sample_agents_2.xlsx", sheetName = "main_400",
           append = TRUE)
write.xlsx(sample.agents.replacement, "can_sample_agents_2.xlsx",
           sheetName = "replacement_373", append = TRUE)
