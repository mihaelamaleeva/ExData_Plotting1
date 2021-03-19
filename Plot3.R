# Calculating the memory needed
# memory required = no. of column * no. of rows * 8 bytes/numeric 
# To convert bytes to gb I divide 3 times with 1024
# First 35 lines are the same for Plot1,Plot2,Plot3,Plot4

n_rows = 2075259
n_columns = 9 
memory_needed = round(n_rows * n_columns * 8 / 1024 / 1024 / 1024, 3)

# Downloading the dataset and importing it into R

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Using tempfile for the zip folder and specifing the parameters for the
# read.table function.I observed that NA in this file are marked with "?"

temp <- tempfile()
download.file(url,temp)
data <- read.table(unz(temp, "household_power_consumption.txt"),
                   sep=";",
                   header = T,
                   na.strings = "?")
unlink(temp)

# Convert the Date and Time variables to Date/Time classes adding a new column
# to the table 

data$DateTime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")
data$Date <- as.Date(data$Date, format ="%d/%m/%Y")

#Subseting the data. The second and third row are used to format the Time data,
#in order to keep the date class. Because by default R uses current data. 

sample_data <- subset(data, DateTime >="2007-02-01" & DateTime < "2007-02-03")
sample_data$Time <- strptime(sample_data$Time, format="%H:%M:%S")
#Constructing Plot 3
png(filename = "Plot 3.png", width = 480, height = 480, bg = "white")
with(sample_data, plot(DateTime,Sub_metering_1,xlab="",ylab="Energy sub metering",
                       type="l",col="black"))
with(sample_data, points(DateTime,Sub_metering_2,type ="l",col="red"))
with(sample_data, points(DateTime,Sub_metering_3,type="l",col="blue"))
legend("topright",lty=1, col = c("black","red","blue"),
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
dev.off()