getwd()
setwd("C:/Users/Maisarah Abdul Ghani/Documents/certified data analytics program")

# Load data
data <- read.csv("Complete3.csv")

# Ensure they are factors
data$Gender <- as.factor(data$Gender)
data$Category <- as.factor(data$Category)

# Create contingency table
table_data <- table(data$Gender, data$Category)

# Run Chi-squared test
chisq_result <- chisq.test(table_data)

# View results
chisq_result

# Load datasets
complete <- read.csv("Complete3.csv")
rfm <- read.csv("RFM_Cleaned.csv")

# Merge to get Region + Monetary together
merged_data <- merge(rfm, complete[, c("CustomerID", "Region")],
                     by = "CustomerID", all.x = TRUE)

# Check result
head(merged_data)

# Make sure Region is categorical
merged_data$Region <- as.factor(merged_data$Region)

# ANOVA test
anova_result <- aov(Monetary ~ Region, data = merged_data)
summary(anova_result)

TukeyHSD(anova_result)

# Load RFM data
rfm <- read.csv("RFM_Cleaned.csv")

# Select only numeric RFM columns
rfm_num <- rfm[, c("Recency", "Frequency", "Monetary")]

# Scale the data (important for k-means)
rfm_scaled <- scale(rfm_num)

set.seed(123)  # for reproducibility
kmeans_result <- kmeans(rfm_scaled, centers = 3, nstart = 25)

# Add cluster labels back to RFM data
rfm$Cluster <- kmeans_result$cluster

write.csv(rfm, "RFM_with_Clusters.csv", row.names = FALSE)

library(ggplot2)

ggplot(rfm, aes(x = Recency, y = Monetary, color = factor(Cluster))) +
  geom_point(size = 3) +
  labs(title = "Customer Segments from K-means", color = "Cluster")

# Load both datasets
churn <- read.csv("RFM_with_Churn.csv")
clusters <- read.csv("RFM_with_Clusters.csv")

# Merge on CustomerID
final_data <- merge(churn, clusters[, c("CustomerID", "Cluster")], 
                    by = "CustomerID", all.x = TRUE)

# Save final dataset
write.csv(final_data, "Customer_Churn_and_Clusters.csv", row.names = FALSE)




