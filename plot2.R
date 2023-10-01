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


# PLOTTING - PLOT #2
# we have to combine date and time within one column
dt_date$date_time <- as.POSIXct(paste(dt_date$Date, dt_date$Time))
plot(dt_date$date_time, 
     dt_date$Global_active_power,
     xlab = "",
     ylab = "Global Active Power (kilowatts)",
     type = "l",
     main = "Global Active Power consumption in time")
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()


