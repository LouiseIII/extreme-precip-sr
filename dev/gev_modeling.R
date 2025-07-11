setwd("~/Documents/PJTS/ECCE/data/0_cluster/TOT_PR")

# --------------------------
# 1. High Resolution
# --------------------------
data <- read.csv('data2_summer_future_HR_v1.csv')

# 1.1. Example 
lat <- sample(unique(data$rlat), 1)
lon <- sample(unique(data$rlon), 1)

data_local <- data[(data$rlat == lat & data$rlon == lon), ]
fit <- gev.fit(data_local[, 'TOT_PR'], maxit = 50000, show = FALSE)

mle <- fit$mle
loc_mle <- mle[1]
scale_mle <- mle[2]
shape_mle <- mle[3]

se <- fit$se
loc_se <- se[1]
scale_se <- se[2]
shape_se <- se[3]

confidence_level <- 0.95
z <- qnorm(1 - (1 - confidence_level) / 2)
loc_ci <- loc_mle + c(-1, 1) * z * loc_se
scale_ci <- scale_mle + c(-1, 1) * z * scale_se
shape_ci <- shape_mle + c(-1, 1) * z * shape_se


# 1.2. For each grid point : GEV Model Fitting

# Initialization

liste_rlat <- numeric(0)
liste_rlon <- numeric(0)
liste_loc <- numeric(0)
liste_scale <- numeric(0)
liste_shape <- numeric(0)
liste_conv <- numeric(0)
liste_pvalue <- numeric(0)
liste_pb_rlat <- numeric(0)
liste_pb_rlon <- numeric(0)

for (lat in unique(data$rlat)) {  for(lon in unique(data$rlon)){
  
  data_local <- data[data$rlat == lat, ]
  data_local <- data_local[data_local$rlon == lon,]
  
  result <- tryCatch({
    gev_estim <- gev.fit(data_local[, 'TOT_PR'], maxit = 50000, show = FALSE)
    ks_test <- ks.test(data_local[, 'TOT_PR'], "pgev", loc = gev_estim$mle[1], scale = gev_estim$mle[2], shape = gev_estim$mle[3])
    
    if (is.nan(gev_estim$mle[1])){
      print('PB MLE : ')
      print(lat)
      print(lon)
    }else {
      
      liste_rlat <- c(liste_rlat, lat)
      liste_rlon <- c(liste_rlon, lon)
      liste_pvalue <- c(liste_pvalue, ks_test$p.value)
      liste_conv <- c(liste_conv, gev_estim$conv)
      
      if (gev_estim$conv == 1){
          print('PB convergence : ')
          print(lat)
          print(lon)}
      if (ks_test$p.value < 0.05){
          print('PB KS test : ')
          print(lat)
          print(lon)}
      
      liste_loc <- c(liste_loc, gev_estim$mle[1])
      liste_scale <- c(liste_scale, gev_estim$mle[2])
      liste_shape <- c(liste_shape, gev_estim$mle[3])
      data[(data$rlat == lat) & (data$rlon == lon), 'to_change'] = 0
      
    }}, error = function(e) {
      print('Error')
      print(lat)
      print(lon)
      liste_pb_rlat <- c(liste_pb_rlat, lat)
      liste_pb_rlon <- c(liste_pb_rlon, lon)
      
    })
}}

# Finalization and Results Saving

data_set <- data.frame(rlat = liste_rlat,
                       rlon = liste_rlon,
                       loc = liste_loc,
                       scale = liste_scale,
                       shape = liste_shape)


write.csv(data_set, file = "gev2_param_true_future.csv", row.names = FALSE)

# Results Analysis 

print(sum(liste_conv))
print(sum(liste_pvalue<0.05))

# --------------------------
# 2. Low Resolution
# --------------------------

# Initialization 

setwd("~/Documents/PJTS/ECCE/data/0_cluster/TOT_PR")
data <- read.csv('data2_summer_future_LR24_v1.csv')

liste_block <- numeric(0)
liste_loc <- numeric(0)
liste_scale <- numeric(0)
liste_shape <- numeric(0)
liste_conv <- numeric(0)
liste_pvalue <- numeric(0)

# For each block : GEV Model Fitting

for (block in unique(data$block)) {
  
  data_local <- data[data$block == block, ]
  
  result <- tryCatch({
    
    gev_estim <- gev.fit(data_local[, 'TOT_PR'], maxit = 50000, show = FALSE)
    ks_test <- ks.test(data_local[, 'TOT_PR'], "pgev", loc = gev_estim$mle[1], scale = gev_estim$mle[2], shape = gev_estim$mle[3])
    
    if (is.nan(gev_estim$mle[1])){
      print('PB MLE : ')
      print(block)
    }else {
      
      liste_conv <- c(liste_conv, gev_estim$conv)
      liste_block <- c(liste_block, block)
      liste_pvalue <- c(liste_pvalue, ks_test$p.value)
      
      if (gev_estim$conv == 1){print('PB convergence : ')
        print(block)}
      if (ks_test$p.value < 0.05){print('PB KS test : ')
        print(block)}
      
      liste_loc <- c(liste_loc, gev_estim$mle[1])
      liste_scale <- c(liste_scale, gev_estim$mle[2])
      liste_shape <- c(liste_shape, gev_estim$mle[3])
      
    }}, error = function(e) {
      
      print('Error')
      print(block)
    })
}

# Finalization and Results Saving

data_set <- data.frame(block = liste_block, 
                       loc = liste_loc,
                       scale = liste_scale,
                       shape = liste_shape)


write.csv(data_set, file = "gev2_param_true_present24.csv", row.names = FALSE)

# Results Analysis 
print(sum(liste_conv))
print(sum(liste_pvalue<0.05))
