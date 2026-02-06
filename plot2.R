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

# Create DateTime column and parse using DD/MM/YYYY format
data$DateTime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")

# Subset to the relevant two-day period used in the assignment sample (2007-02-01 and 2007-02-02)
start <- as.POSIXct("2007-02-01 00:00:00", tz = "")
end   <- as.POSIXct("2007-02-02 23:59:59", tz = "")
# Ensure DateTime is POSIXct for easy comparisons
data$DateTime_ct <- as.POSIXct(data$DateTime)

sub <- subset(data, !is.na(DateTime_ct) & DateTime_ct >= start & DateTime_ct <= end)

# compute axis tick positions at the start of each day in the range
days <- seq(as.POSIXct("2007-02-01", tz = ""), as.POSIXct("2007-02-03", tz = ""), by = "day")

# Create the plot
png("plot2.png", width = 480, height = 480)

# Plot without x-axis (xaxt="n") so we can add custom weekday ticks like the sample
plot(sub$DateTime_ct, sub$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)",
     xaxt = "n",
     col = "black")

# Add custom x-axis ticks and labels (weekdays)
axis(1, at = days, labels = format(days, "%a"))

dev.off()

cat("✅ plot2.png saved.\n")
