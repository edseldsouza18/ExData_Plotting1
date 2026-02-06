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
data$Global_reactive_power <- as.numeric(data$Global_reactive_power)
data$Voltage <- as.numeric(data$Voltage)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

# Parse DateTime (DD/MM/YYYY HH:MM:SS)
data$DateTime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")
data$DateTime_ct <- as.POSIXct(data$DateTime)

# Subset to 2007-02-01 and 2007-02-02 (inclusive)
start <- as.POSIXct("2007-02-01 00:00:00", tz = "")
end   <- as.POSIXct("2007-02-02 23:59:59", tz = "")
sub <- subset(data, !is.na(DateTime_ct) & DateTime_ct >= start & DateTime_ct <= end)

# Define axis tick positions for weekdays (start of days)
days <- seq(as.POSIXct("2007-02-01", tz = ""), as.POSIXct("2007-02-03", tz = ""), by = "day")

# Create the 2x2 plot and save to PNG
png("plot4.png", width = 480, height = 480)

# 2 rows, 2 columns
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1)) # adjust margins if needed

# Top-left: Global Active Power
plot(sub$DateTime_ct, sub$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power",
     xaxt = "n")
axis(1, at = days, labels = format(days, "%a"))

# Top-right: Voltage
plot(sub$DateTime_ct, sub$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage",
     xaxt = "n")
axis(1, at = days, labels = format(days, "%a"))

# Bottom-left: Energy sub metering (three lines)
plot(sub$DateTime_ct, sub$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy sub metering",
     col = "black",
     xaxt = "n")
lines(sub$DateTime_ct, sub$Sub_metering_2, col = "red")
lines(sub$DateTime_ct, sub$Sub_metering_3, col = "blue")
axis(1, at = days, labels = format(days, "%a"))
legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1,
       bty = "n",
       cex = 0.9)

# Bottom-right: Global Reactive Power
plot(sub$DateTime_ct, sub$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power",
     xaxt = "n")
axis(1, at = days, labels = format(days, "%a"))

dev.off()

cat("✅ plot4.png saved.\n")
