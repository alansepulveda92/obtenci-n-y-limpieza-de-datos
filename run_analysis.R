## configuación
library("tidyr")
library("dplyr")
setwd("C:/Users/Alan/Desktop/Data Science/getting and cleaning data/Proyecto Final")
## configuración

##Lectura de datos "test"
tabla_1 = read.table("X_test.txt")
activity_1 = read.table("y_test.txt")
subject_1 = read.table("subject_test.txt")

##Lectura de datos "train"
tabla_2 = read.table("X_train.txt")
activity_2 = read.table("y_train.txt")
subject_2 = read.table("subject_train.txt")

nombres = read.table("features.txt")

## se agregan etiquetas a las columnas de ambos data.frame
colnames(tabla_1) = as.character(nombres[,2])
colnames(tabla_2) = as.character(nombres[,2])

##selección y fusión
tabla_1 = select(tabla_1, contains("mean") | contains("std"))
tabla_2 = select(tabla_2, contains("mean") | contains("std"))

tabla_1 = cbind(activity_1, tabla_1)
tabla_1 = rename(tabla_1, actividad = V1)
tabla_1 = cbind(subject_1, tabla_1)
tabla_1 = rename(tabla_1, sujeto = V1)

tabla_2 = cbind(activity_2, tabla_2)
tabla_2 = rename(tabla_2, actividad = V1)
tabla_2 = cbind(subject_2, tabla_2)
tabla_2 = rename(tabla_2, sujeto = V1)

union = rbind(tabla_2, tabla_1)
union$actividad = as.factor(union$actividad)
union$actividad = factor(union$actividad, c(1,2,3,4,5,6), 
                  c("Walking", "Walking upstairs",
                    "walking downstairs", "sitting","standing","laying"))

## promedios
mean_group = group_by(union, actividad, sujeto)
new = summarise_all(mean_group, funs(mean))
new

## guardar el conjunto de datos
write.table(new, file = "datos_ordenados.txt", row.names = FALSE)
