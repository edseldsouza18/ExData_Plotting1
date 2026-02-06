# Set working directory to the project root
setwd(".")

# Read the data
data <- read.table("data/household_power_consumption.txt",
                   header = TRUE,
                   sep = ";",
                   na.strings = "?",
                   stringsAsFactors = FALSE)

# Convert Global_active_power to numeric
data$Global_active_power <- as.numeric(data$Global_active_power)

# Create the histogram
png("plot1.png", width = 480, height = 480)
hist(data$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency",
     col = "red")
dev.off()

print("✅ plot1.png has been saved successfully.")
