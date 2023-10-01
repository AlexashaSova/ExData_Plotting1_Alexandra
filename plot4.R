# reading data with the needed formats is the same part for all of the files 

dt_path <- "household_power_consumption.txt"

# for faster processing using data.table instead of data.frame
dt <- data.table::as.data.table(read.table(dt_path,
                                           header = T,
                                           sep = ";",
                                           dec = ".",
                                           na.strings = "?"))
# check the formats
# sapply(dt, class)

# convert to valid formats
dt$Date <- as.Date(dt$Date, "%d/%m/%Y")
dt$Time <- hms::as.hms(dt$Time)
# the other values have to be numeric
col_names <- c("Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity",
               "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
dt[, (col_names) := lapply(.SD, as.numeric), .SDcols = col_names]

# subsetting the date
dt_date <- dplyr::filter(dt, Date %in% c("2007-02-01", "2007-02-02"))
#head(dt_date)


# PLOTTING - PLOT #4
# we have to combine date and time within one column
dt_date$date_time <- as.POSIXct(paste(dt_date$Date, dt_date$Time))
# 4 plots (2*2 matrix)
par(mfrow = c(2,2), oma = c(1, 1, 1, 1))
# calling the basic plot function that calls different plot functions to build the 4 plots that form the graph
with(dt_date,{
        plot(dt_date$date_time, 
             dt_date$Global_active_power, 
             type = "l", 
             xlab = "",
             ylab = "Global Active Power")  
        plot(dt_date$date_time,
             dt_date$Voltage, 
             type = "l",
             xlab = "datetime",
             ylab = "Voltage")
        plot(dt_date$date_time,
             dt_date$Sub_metering_1,
             type = "n",
             xlab = "",
             ylab = "Energy sub metering")
        with(dt_date,lines(Time, Sub_metering_1))
        with(dt_date,lines(Time, Sub_metering_2),col = "red")
        with(dt_date,lines(Time, Sub_metering_3),col = "blue")
        legend("topright", 
               lty = 1, 
               col = c("black","red","blue"),
               legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
               cex = 0.4)
        plot(dt_date$Time,
             dt_date$Global_reactive_power,
             type = "l",
             xlab = "datetime",
             ylab = "Global_reactive_power")
})
title(main = "Plotting on the household power consumption data", outer = T)
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()