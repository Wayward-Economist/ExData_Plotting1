##############################################################################################################
# Author:        Wayward Economist
# Description:   This script downloads the pre-draft player ranking data from the ESPN website. 
# Notes:         See the data readme document for a more detailed description of the data collection.
# Last Modified: 7/10/14
##############################################################################################################

# Download and unzip the data from the Stanford Machine Learning Directory.
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
unzip(temp)
unlink(temp)
rm(temp)

# Read the data into R; note the possibility of memory issues.
data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";")

# Convert the Date and Time columns into POSIXlt  format.
data$Time <- paste(as.character(data$Date), as.character(data$Time))
data$Date <- strptime(as.character(data$Date), format = "%d/%m/%Y")
data$Time <- strptime(data$Time, format = "%d/%m/%Y %T")

# Transform the factor variables to numeric format; note that Sub_metering_3 is already a numeric.
data$Global_active_power   <- as.numeric(levels(data$Global_active_power))[data$Global_active_power]
data$Global_reactive_power <- as.numeric(levels(data$Global_reactive_power))[data$Global_reactive_power]
data$Voltage               <- as.numeric(levels(data$Voltage))[data$Voltage]
data$Global_intensity      <- as.numeric(levels(data$Global_intensity))[data$Global_intensity]
data$Sub_metering_1        <- as.numeric(levels(data$Sub_metering_1))[data$Sub_metering_1]
data$Sub_metering_2        <- as.numeric(levels(data$Sub_metering_2))[data$Sub_metering_2]

# Subset the data to the first and second of Febraury 2007.
start.time <- strptime("01-02-2007", format = "%d-%m-%Y")
stop.time  <- strptime("02-02-2007", format = "%d-%m-%Y")
condition1 <- as.character(data$Date) >= start.time
condition2 <- as.character(data$Date) <= stop.time
data       <- data[(condition1 & condition2) , ]
rm(condition1, condition2, start.time, stop.time)

# Print plot no 4.
par(mfrow = c(2, 2))
plot(data$Time, data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
plot(data$Time, data$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")
plot(data$Time, data$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "")
lines(data$Time, data$Sub_metering_2, col = "red")
lines(data$Time, data$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), lty = 1, inset = 0.11, cex = 0.7, bty = "n",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(data$Time, data$Global_reactive_power, type = "l", ylab = "Global_reactive_power", xlab = "datetime")
dev.copy(png, file = "plot4.png") # Note that the defults are 480 pixels x 480 pixels so no additional options are needed to satisfy the assignment requirements.
dev.off()