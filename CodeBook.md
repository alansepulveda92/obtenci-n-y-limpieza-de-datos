---
title: "CodeBook"
author: "Alan Sepúlveda Jiménez"
date: "01-09-2020"
output: 
  html_document: 
    keep_md: yes
---



## Descripción de las variables
Este archivo describe los promedios de cada una de las variables seleccionadas por contenido mean() y sdt() para las tres señales triaxiales "XYZ"

Se incluye la variable "sujeto", que representa los 30 sujetos que participaron del experimento en cada una de las actividades señaladas.

Por último, se agrega la variable "actividad", que agrupa cada una de las 6 actividades realizadas por los participantes: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.

Las unidades de medida se mantienen igual que en los archivos originales sin procesar.

## Paquetes

se cargan los paquetes necesarios para poder realizar el trabajo:


```r
library("tidyr")
```

```
## Warning: package 'tidyr' was built under R version 4.0.2
```

```r
library("dplyr")
```

```
## Warning: package 'dplyr' was built under R version 4.0.2
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

## Lectura de archivos

Se leen y cargan los archivos:


```r
tabla_1 = read.table("X_test.txt")
dim(tabla_1)
```

```
## [1] 2947  561
```

```r
activity_1 = read.table("y_test.txt")
dim(activity_1)
```

```
## [1] 2947    1
```

```r
subject_1 = read.table("subject_test.txt")
dim(subject_1)
```

```
## [1] 2947    1
```

```r
##Lectura de datos "train"
tabla_2 = read.table("X_train.txt")
dim(tabla_2)
```

```
## [1] 7352  561
```

```r
activity_2 = read.table("y_train.txt")
dim(activity_2)
```

```
## [1] 7352    1
```

```r
subject_2 = read.table("subject_train.txt")
dim(subject_2)
```

```
## [1] 7352    1
```

```r
nombres = read.table("features.txt")
dim(nombres)
```

```
## [1] 561   2
```

##Asignación de nombres a cada variable:

Los data.frame tienen dimensiones que se ajustan perfectamente para ser fusionados. Primero, se agregan nombres a cada una de las columnas de los data.frame "tabla_1" y "tabla_2":


```r
colnames(tabla_1) = as.character(nombres[,2])
colnames(tabla_2) = as.character(nombres[,2])
```

## Selección de variables:
Luego, se seleccionan sólo las columnas que contienen las siguientes palabras "mean" y "std":


```r
tabla_1 = select(tabla_1, contains("mean") | contains("std"))
tabla_2 = select(tabla_2, contains("mean") | contains("std"))
```

## Fusión
se agregan las columnas "actividad" y "sujeto", que corresponden a la actividad realizada y cada unos de los participantes:


```r
tabla_1 = cbind(activity_1, tabla_1)
tabla_1 = rename(tabla_1, actividad = V1)
tabla_1 = cbind(subject_1, tabla_1)
tabla_1 = rename(tabla_1, sujeto = V1)

tabla_2 = cbind(activity_2, tabla_2)
tabla_2 = rename(tabla_2, actividad = V1)
tabla_2 = cbind(subject_2, tabla_2)
tabla_2 = rename(tabla_2, sujeto = V1)
```

## Creación de un sólo conjunto de datos
A partir de "tabla_1" y "tabla_2" se crea un sólo conjunto de datos:


```r
union = rbind(tabla_2, tabla_1)
union$actividad = as.factor(union$actividad)
union$actividad = factor(union$actividad, c(1,2,3,4,5,6), 
                  c("Walking", "Walking upstairs",
                    "walking downstairs", "sitting","standing","laying"))
```

## Creación de un nuevo conjunto de datos
Por último, una vez creado el conjunto de datos "union", se procede a realizar la agrupación de los datos por "actividad" y "sujeto", y se realiza un resumen de todas las variables mostrando el promedio de cada una de ellas agrupados por "actividad y "promedio":


```r
mean_group = group_by(union, actividad, sujeto)
new = summarise_all(mean_group, funs(mean))
```

```
## Warning: `funs()` is deprecated as of dplyr 0.8.0.
## Please use a list of either functions or lambdas: 
## 
##   # Simple named list: 
##   list(mean = mean, median = median)
## 
##   # Auto named with `tibble::lst()`: 
##   tibble::lst(mean, median)
## 
##   # Using lambdas
##   list(~ mean(., trim = .2), ~ median(., na.rm = TRUE))
## This warning is displayed once every 8 hours.
## Call `lifecycle::last_warnings()` to see where this warning was generated.
```

```r
new
```

```
## # A tibble: 180 x 88
## # Groups:   actividad [6]
##    actividad sujeto `tBodyAcc-mean(~ `tBodyAcc-mean(~ `tBodyAcc-mean(~
##    <fct>      <int>            <dbl>            <dbl>            <dbl>
##  1 Walking        1            0.277          -0.0174           -0.111
##  2 Walking        2            0.276          -0.0186           -0.106
##  3 Walking        3            0.276          -0.0172           -0.113
##  4 Walking        4            0.279          -0.0148           -0.111
##  5 Walking        5            0.278          -0.0173           -0.108
##  6 Walking        6            0.284          -0.0169           -0.110
##  7 Walking        7            0.276          -0.0187           -0.111
##  8 Walking        8            0.275          -0.0187           -0.107
##  9 Walking        9            0.279          -0.0181           -0.111
## 10 Walking       10            0.279          -0.0170           -0.109
## # ... with 170 more rows, and 83 more variables: `tGravityAcc-mean()-X` <dbl>,
## #   `tGravityAcc-mean()-Y` <dbl>, `tGravityAcc-mean()-Z` <dbl>,
## #   `tBodyAccJerk-mean()-X` <dbl>, `tBodyAccJerk-mean()-Y` <dbl>,
## #   `tBodyAccJerk-mean()-Z` <dbl>, `tBodyGyro-mean()-X` <dbl>,
## #   `tBodyGyro-mean()-Y` <dbl>, `tBodyGyro-mean()-Z` <dbl>,
## #   `tBodyGyroJerk-mean()-X` <dbl>, `tBodyGyroJerk-mean()-Y` <dbl>,
## #   `tBodyGyroJerk-mean()-Z` <dbl>, `tBodyAccMag-mean()` <dbl>,
## #   `tGravityAccMag-mean()` <dbl>, `tBodyAccJerkMag-mean()` <dbl>,
## #   `tBodyGyroMag-mean()` <dbl>, `tBodyGyroJerkMag-mean()` <dbl>,
## #   `fBodyAcc-mean()-X` <dbl>, `fBodyAcc-mean()-Y` <dbl>,
## #   `fBodyAcc-mean()-Z` <dbl>, `fBodyAcc-meanFreq()-X` <dbl>,
## #   `fBodyAcc-meanFreq()-Y` <dbl>, `fBodyAcc-meanFreq()-Z` <dbl>,
## #   `fBodyAccJerk-mean()-X` <dbl>, `fBodyAccJerk-mean()-Y` <dbl>,
## #   `fBodyAccJerk-mean()-Z` <dbl>, `fBodyAccJerk-meanFreq()-X` <dbl>,
## #   `fBodyAccJerk-meanFreq()-Y` <dbl>, `fBodyAccJerk-meanFreq()-Z` <dbl>,
## #   `fBodyGyro-mean()-X` <dbl>, `fBodyGyro-mean()-Y` <dbl>,
## #   `fBodyGyro-mean()-Z` <dbl>, `fBodyGyro-meanFreq()-X` <dbl>,
## #   `fBodyGyro-meanFreq()-Y` <dbl>, `fBodyGyro-meanFreq()-Z` <dbl>,
## #   `fBodyAccMag-mean()` <dbl>, `fBodyAccMag-meanFreq()` <dbl>,
## #   `fBodyBodyAccJerkMag-mean()` <dbl>, `fBodyBodyAccJerkMag-meanFreq()` <dbl>,
## #   `fBodyBodyGyroMag-mean()` <dbl>, `fBodyBodyGyroMag-meanFreq()` <dbl>,
## #   `fBodyBodyGyroJerkMag-mean()` <dbl>,
## #   `fBodyBodyGyroJerkMag-meanFreq()` <dbl>,
## #   `angle(tBodyAccMean,gravity)` <dbl>,
## #   `angle(tBodyAccJerkMean),gravityMean)` <dbl>,
## #   `angle(tBodyGyroMean,gravityMean)` <dbl>,
## #   `angle(tBodyGyroJerkMean,gravityMean)` <dbl>, `angle(X,gravityMean)` <dbl>,
## #   `angle(Y,gravityMean)` <dbl>, `angle(Z,gravityMean)` <dbl>,
## #   `tBodyAcc-std()-X` <dbl>, `tBodyAcc-std()-Y` <dbl>,
## #   `tBodyAcc-std()-Z` <dbl>, `tGravityAcc-std()-X` <dbl>,
## #   `tGravityAcc-std()-Y` <dbl>, `tGravityAcc-std()-Z` <dbl>,
## #   `tBodyAccJerk-std()-X` <dbl>, `tBodyAccJerk-std()-Y` <dbl>,
## #   `tBodyAccJerk-std()-Z` <dbl>, `tBodyGyro-std()-X` <dbl>,
## #   `tBodyGyro-std()-Y` <dbl>, `tBodyGyro-std()-Z` <dbl>,
## #   `tBodyGyroJerk-std()-X` <dbl>, `tBodyGyroJerk-std()-Y` <dbl>,
## #   `tBodyGyroJerk-std()-Z` <dbl>, `tBodyAccMag-std()` <dbl>,
## #   `tGravityAccMag-std()` <dbl>, `tBodyAccJerkMag-std()` <dbl>,
## #   `tBodyGyroMag-std()` <dbl>, `tBodyGyroJerkMag-std()` <dbl>,
## #   `fBodyAcc-std()-X` <dbl>, `fBodyAcc-std()-Y` <dbl>,
## #   `fBodyAcc-std()-Z` <dbl>, `fBodyAccJerk-std()-X` <dbl>,
## #   `fBodyAccJerk-std()-Y` <dbl>, `fBodyAccJerk-std()-Z` <dbl>,
## #   `fBodyGyro-std()-X` <dbl>, `fBodyGyro-std()-Y` <dbl>,
## #   `fBodyGyro-std()-Z` <dbl>, `fBodyAccMag-std()` <dbl>,
## #   `fBodyBodyAccJerkMag-std()` <dbl>, `fBodyBodyGyroMag-std()` <dbl>,
## #   `fBodyBodyGyroJerkMag-std()` <dbl>
```

## Guardar archivo

Se guarda el archivo en formato ".txt"


```r
write.table(new, file = "datos_ordenados.txt", row.names = FALSE)
```



