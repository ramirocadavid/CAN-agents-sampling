
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

# Drop variables that won't be used
posible.agents <- select(posible.agents, -one_of("DATE.ONBOARDED..MM.DD.YYYY.",
                                            "CURRENT.DEVICE.ID"))

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
to.table <- names(all.agents)[c(5, 8:12)]
# Frequency table for candidate variables
for(i in seq_along(to.table)) {
      print(to.table[i])
      print(tables(to.table[i]))
}
# Selected: Province


# Select sample ---------------------------------------------------------------------


