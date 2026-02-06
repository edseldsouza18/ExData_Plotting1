# Set working directory to the project root
setwd(".")

# Read the data
data <- read.table("data/household_power_consumption.txt",
                   header = TRUE,
                   sep = ";",
                   na.strings = "?",
                   stringsAsFactors = FALSE)

# Convert relevant columns to numeric
data$Global_active_power <- as.numeric(data$Global_active_power)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

# Create DateTime column and parse using DD/MM/YYYY format
data$DateTime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")

# Subset to the relevant two-day period for consistency with plot2 (Thu, Fri, Sat)
start <- as.POSIXct("2007-02-01", tz = "")
end   <- as.POSIXct("2007-02-03", tz = "")
data$DateTime_ct <- as.POSIXct(data$DateTime)
sub <- subset(data, !is.na(DateTime_ct) & DateTime_ct >= start & DateTime_ct < end)

# Define axis tick positions for weekdays
days <- seq(as.POSIXct("2007-02-01", tz = ""), as.POSIXct("2007-02-03", tz = ""), by = "day")

# Create the plot
png("plot3.png", width = 480, height = 480)

# Plot the first sub-metering (black)
plot(sub$DateTime_ct, sub$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy sub metering",
     col = "black",
     xaxt = "n") # Hide default x-axis to add custom one later

# Add the second sub-metering (red)
lines(sub$DateTime_ct, sub$Sub_metering_2, col = "red")

# Add the third sub-metering (blue)
lines(sub$DateTime_ct, sub$Sub_metering_3, col = "blue")

# Add custom x-axis ticks and labels
axis(1, at = days, labels = format(days, "%a"))

# Add the legend
legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1, # Line type 1 is solid
       cex = 0.8) # Adjust legend text size if needed

dev.off()

cat("✅ plot3.png saved.\n")
