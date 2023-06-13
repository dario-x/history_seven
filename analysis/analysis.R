# Load the required libraries
library(readr)
library(ggplot2)
library(xtable)
library(gginference)
library(dplyr)
library(tidyr)
library(viridis)
library(RColorBrewer)




# Read data from CSV file
data <- read.csv("./data/questionaire_results_general.csv", sep = ";")
# Read data from CSV file
data_per_participants <- read.csv("./data/questionaire_results_per_participant.csv", sep = ";")






# HYPOTHESIS 1.1 

# Create the contingency table
observed_H1_1 <- as.data.frame(matrix(c(sum(data_per_participants$experienced_uncomfort_VR), 
                                        sum(data_per_participants$experienced_uncomfort_2D), 
                                        12-sum(data_per_participants$experienced_uncomfort_VR), 
                                        12-sum(data_per_participants$experienced_uncomfort_2D)), 
                                      nrow = 2, ncol = 2, byrow = TRUE))
rownames(observed_H1_1) <- c("Experienced_Discomfort", "No_Discomfort_Experienced")
colnames(observed_H1_1) <- c("VR", "2D")
print(observed_H1_1)

# Convert the data frame to a LaTeX table
latex_table <- xtable(observed_H1_1)
print(latex_table, include.rownames = TRUE)

# Calculate the expected frequencies
expected_H1_1 <- as.data.frame(rowSums(observed_H1_1) %*% t(colSums(observed_H1_1)) / sum(observed_H1_1))
rownames(expected_H1_1) <- c("Experienced_Discomfort", "No_Discomfort_Experienced")
print(expected_H1_1)

# Convert the data frame to a LaTeX table
latex_table <- xtable(expected_H1_1)
print(expected_H1_1, include.rownames = TRUE)
print(latex_table, include.rownames = TRUE)

# Calculate the chi-square test statistic
chi_squared <- sum((observed_H1_1 - expected_H1_1)^2 / expected_H1_1)
# Calculate the p-value
p_value <- 1 - pchisq(chi_squared, df=1)
cat("Chi squared equals", round(chi_squared, 3), "with 1 degree of freedom.\n")
cat("The two-tailed P value equals", round(p_value, 4), "\n")

# Check for statistical significance
if (p_value <= 0.1) {
  cat("The proportion of people experiencing symptoms of discomfort is considered significantly different between users of the 2D and users of the VR version.\n")
} else {
  cat("The proportion of people experiencing symptoms of discomfort is not significantly different between users of the 2D and users of the VR version.\n")
}



# Plotting the stacked bubble chart with adjusted legend position
discomfort_ratings = ggplot(data_per_participants, aes(x = rating_VR, fill = factor(experienced_uncomfort_VR))) +
  geom_bar(stat = "count", width = 0.5, color = "black") +
  labs(title = "Rating of VR Experience and Discomfort",
       x = "Rating of VR experience (on a scale from 0(worst) to 10(best))",
       y = "Number of participants") +
  scale_fill_manual(values = c("0" = "steelblue", "1" = "orange"),
                    name = "Experienced Discomfort",
                    labels = c("No Discomfort Experienced", "Discomfort Experienced")) +
  theme_minimal() +
  theme(axis.text = element_text(size = 12),  # Adjust the axis text size
        title = element_text(size = 16), # Adjust the title size
        axis.title = element_text(size = 14),  # Adjust the axis title size
        legend.text = element_text(size = 12),  # Adjust the legend text size
        legend.position = "top",  # Position the legend on top
        legend.title = element_blank(),
        legend.justification = "center")  # Center-align the legend
ggsave("./plots/discomfort_ratings.pdf", discomfort_ratings, width = 6, height = 4)

# bar plot discomfort symptoms

# Separate individual symptoms
symptom_data <- data_per_participants %>%
  separate_rows(uncomfort_symptoms_VR, sep = ",\\s*")
# Filter out "none" symptoms
filtered_data <- symptom_data %>%
  filter(uncomfort_symptoms_VR != "none")
# Assign unique shades of blue to participants
participant_colors <- filtered_data %>%
  distinct(participant_number) %>%
  mutate(color = brewer.pal(n = length(participant_number), name = "Blues"))
# Merge participant colors with symptom data
merged_data <- filtered_data %>%
  left_join(participant_colors, by = "participant_number")
# Count the occurrences of each symptom and participant
symptom_counts <- merged_data %>%
  count(uncomfort_symptoms_VR, participant_number)
# Plot the bar chart
discomfort_symptoms_plot = ggplot(symptom_counts, aes(x = uncomfort_symptoms_VR, y = n, fill = participant_number)) +
  geom_bar(stat = "identity", width = 0.5, color="black") +
  scale_fill_manual(values = participant_colors$color, name = "Participant") +
  xlab("Symptoms") +
  ylab("Number of occurrences") +
  ggtitle("Count of Discomfort Symptoms in VR") +
  theme_minimal() +
  theme(axis.text = element_text(size = 12),  # Adjust the axis text size
        title = element_text(size = 16), # Adjust the title size
        axis.title = element_text(size = 14),  # Adjust the axis title size
        legend.text = element_text(size = 12),  # Adjust the legend text size
        legend.position = "top",  # Position the legend on top
        legend.title = element_blank(),
        legend.justification = "center") +
  scale_y_continuous(breaks = 1:2, limits = c(0, 2))

ggsave("./plots/discomfort_symptoms_plot.pdf", discomfort_symptoms_plot, width = 6, height = 4)





# HYPOTHESIS 1.2

# Create a data frame for the boxplot
boxplot_data_questions <- data.frame(
  Visualization = rep(c("VR", "2D"), each = nrow(data_per_participants)),
  Ratings = c(data_per_participants$rating_VR, data_per_participants$rating_2D)
)
# Create the boxplot
bxp_ratings <- ggplot(boxplot_data_questions, aes(x = Visualization, y = Ratings, fill = Visualization)) +
  geom_boxplot(width = 0.5, lwd = 1, outlier.shape = 1, outlier.stroke = 2, outlier.size = 4, notch = FALSE, outlier.colour = "black", coef = 1.5) +
  scale_y_continuous(breaks = seq(0, 10, 2), limits = c(0, 10), labels = function(x) as.integer(x)) +
  labs(x = "Visualization Type", y = "Ratings",
       title = "Comparison of Ratings\nof the VR and 2D Appplication") +
  theme_minimal() +
  theme(axis.text = element_text(size = 12),  # Adjust the axis text size
        title = element_text(size = 16), # Adjust the title size
        axis.title = element_text(size = 14),  # Adjust the axis title size
        legend.text = element_text(size = 12),  # Adjust the legend text size
        legend.position = "top",  # Position the legend on top
        legend.title = element_blank(),
        legend.justification = "center")  +
  geom_hline(yintercept = 5, linetype = "dashed", size = 1, color = "red")

ggsave("./plots/boxplot_ratings.pdf", bxp_ratings, width = 6, height = 4)

# Print the boxplot
print(bxp_ratings)

# Perform paired t-test
t_test_result_H1_1 <- t.test(data_per_participants$rating_VR, data_per_participants$rating_2D, paired = TRUE, 
                        alternative = "greater", conf.level = 0.95)


# Show the t-test results
print(t_test_result_H1_1)
t_test_1.2 = ggttest(t_test_result_H1_1)+
  theme_minimal() +
  labs(x = "T-Value", y = "Density",
       title = "Paired T Test Result of H1.2")+
  theme(axis.text = element_text(size = 12),  # Adjust the axis text size
        title = element_text(size = 16), # Adjust the title size
        axis.title = element_text(size = 14),  # Adjust the axis title size
        legend.text = element_text(size = 12),  # Adjust the legend text size
        legend.position = "top",  # Position the legend on top
        legend.title = element_blank(),
        legend.justification = "center")

ggsave("./plots/t_test_results_H1.2.pdf", t_test_1.2, width = 6, height = 4)






# HYPOTHESES 2.X & 3

# Initial analysis with plots


# Plot of differences
# Calculate the difference between VR and 2D correct answers
data$diff_correct = data$number_correct_VR - data$number_correct_2D
# Determine the color based on which has more correct answers
data$color <- ifelse(data$number_correct_VR > data$number_correct_2D, "VR", "2D")
# Create the plot
plot_diff <- ggplot(data, aes(x = question_id, y = diff_correct, fill = color)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("VR" = "steelblue", "2D" = "darkorange")) +
  labs(x = "Question ID", y = "Difference in Correct Answers (VR - 2D)",
       title = "Comparison of Correct Answers\nBetween VR and 2D") +
  theme_minimal() +
  theme(legend.position = "bottom",
        axis.title = element_text(size = 12),
        axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
        axis.text.y = element_text(size = 10),
        plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_line(color = "lightgray"),
        panel.grid.major.y = element_line(color = "lightgray")) +
  scale_y_continuous(limits = c(-12, 12), breaks = c(-12, -5, -3, 0, 2, 5, 12))
# Adjust legend title and labels
plot_diff <- plot_diff +
  guides(fill = guide_legend(title = "Comparison - which group of participants performed better",
                             labels = c("2D", "VR")))
# Print the plot
print(plot_diff)


# Boxplot of correctly answered question
# Create a data frame for the boxplot
boxplot_data <- data.frame(
  Visualization = rep(c("VR", "2D"), each = nrow(data)),
  Correct_Answers = c(data$number_correct_VR, data$number_correct_2D)
)
# Create the boxplot
bxp_questions <- ggplot(boxplot_data, aes(x = Visualization, y = Correct_Answers, fill = Visualization)) +
  geom_boxplot(width = 0.5, lwd = 1, outlier.shape = 1, outlier.stroke = 2, notch = FALSE, outlier.size = 4, outlier.colour = "black", coef = 1.5) +
  scale_y_continuous(breaks = seq(0, 12, 2), limits = c(0, 12)) +
  labs(x = "Visualization Type", y = "Number of Correct Answers",
       title = "Comparison of Correct Answers\nBetween VR and 2D Visualizations") +
  theme_minimal() +
  theme(legend.position = "bottom",
        axis.title = element_text(size = 20),
        axis.text = element_text(size = 20),
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
        panel.grid.major.y = element_line(color = "lightgrey"),
        panel.border = element_blank(),
        panel.grid.minor = element_blank()) + 
  geom_hline(yintercept = 6, linetype = "dashed", size =1,  color = "red")
# Print the boxplot
print(bxp_questions)




# Significance test for all questions
# Create a data frame for the overall results
table_data_sum <- data.frame(correct_VR = sum(data$number_correct_VR), corrcct_2D = sum(data$number_correct_2D))
chisq.test(table_data_sum)
ifelse(chisq.test(table_data_sum)$p.value > 0.05, "Not significant", "Significant")
t_test = t.test(data$number_correct_2D, data$number_correct_VR, paired = TRUE, alternative = "two.sided", conf.level = 0.95)
library(gginference)
ggttest(t_test)






# Initialize a data frame to store the results
table_combined <- data.frame(Question = character(),
                             Difference = numeric(),
                             p.value = numeric(),
                             Significance = character(),
                             stringsAsFactors = FALSE)

# Iterate through the questions
questions <- data$question_id
for (question in questions) {
  print(question)
  # Subset the data for the current question
  question_data <- data[data$question_id == question, ]
  # Create the contingency table
  observed <- as.data.frame(matrix(c(sum(question_data$number_correct_VR),
                                     sum(question_data$number_correct_2D),
                                     12-sum(question_data$number_correct_VR),
                                     12-sum(question_data$number_correct_2D)),
                                   nrow = 2, ncol = 2, byrow = TRUE))
  rownames(observed) <- c("Correct", "False")
  colnames(observed) <- c("VR", "2D")
  # Calculate the expected frequencies
  expected <- as.data.frame(rowSums(observed) %*% t(colSums(observed)) / sum(observed))
  rownames(expected) <- c("Correct", "False")
  # Calculate the chi-square test statistic
  chi_squared <- sum((observed - expected)^2 / expected)
  # Calculate the p-value
  p_value <- 1 - pchisq(chi_squared, df = 1)
  
  # Check for statistical significance
  if (p_value <= 0.1) {
    significance <- "Significant"
  } else {
    significance <- "Not significant"
  }
  
  # Append the results to the combined table
  table_combined <- bind_rows(table_combined, data.frame(Question = question, 
                                                         Difference = sum(question_data$number_correct_VR)-sum(question_data$number_correct_2D), 
                                                         p.value = p_value, Significance = significance))
}
# Print the combined table
cat("Combined Table of Expected and Observed Results:\n")
print(table_combined)






# Initialize a data frame to store the results
table_combined <- data.frame(Type = character(),
                             Difference = numeric(),
                             p.value = numeric(),
                             Significance = character(),
                             stringsAsFactors = FALSE)
# Group questions by type
question_types <- unique(substring(data$question_id, 1, nchar(data$question_id) - 2))

# Iterate through the question types
for (type in question_types) {
  # Subset the data for the current question type
  type_data <- data[grep(type, data$question_id), ]
  # Create the contingency table
  observed <- as.data.frame(matrix(c(sum(type_data$number_correct_VR),
                                     sum(type_data$number_correct_2D),
                                     36 - sum(type_data$number_correct_VR),
                                     36 - sum(type_data$number_correct_2D)),
                                   nrow = 2, ncol = 2, byrow = TRUE))
  rownames(observed) <- c("Correct", "False")
  colnames(observed) <- c("VR", "2D")
  print(type)
  print(observed)
  # Calculate the expected frequencies
  expected <- as.data.frame(rowSums(observed) %*% t(colSums(observed)) / sum(observed))
  rownames(expected) <- c("Correct", "False")
  # Calculate the chi-square test statistic
  chi_squared <- sum((observed - expected)^2 / expected)
  # Calculate the p-value
  p_value <- 1 - pchisq(chi_squared, df = 1)
  
  # Check for statistical significance
  if (p_value <= 0.1) {
    significance <- "Significant"
  } else {
    significance <- "Not significant"
  }
  
  # Append the results to the combined table
  table_combined <- bind_rows(table_combined, data.frame(Type = type, 
                                                         Difference = sum(type_data$number_correct_VR) - sum(type_data$number_correct_2D), 
                                                         p.value = p_value, Significance = significance))
}
# Print the combined table
cat("Combined Table of Expected and Observed Results:\n")
print(table_combined)











# FURTHER ANALYSIS


# Do people who perform better also give the visualization a bette rating? 

# Scatter plot with linear regression lines
plot_combined <- ggplot(data_per_participants, aes(x = ratio_correct_answers_2D, y = rating_2D)) +
  geom_point(aes(color = "2D"), size = 3) +
  geom_point(aes(x = ratio_correct_answers_VR, y = rating_VR, color = "VR"), size = 3) +
  geom_smooth(data = data_per_participants, aes(x = ratio_correct_answers_2D, y = rating_2D),
              method = "lm", se = FALSE, linetype = "dashed", color = "steelblue") +
  geom_smooth(data = data_per_participants, aes(x = ratio_correct_answers_VR, y = rating_VR),
              method = "lm", se = FALSE, linetype = "dashed", color = "orange") +
  labs(title = "Relationship between given rating and performance",
       x = "Ratio of Correct Answers",
       y = "Rating of Visualization",
       color = "Visualization") +
  scale_color_manual(values = c("2D" = "steelblue", "VR" = "orange")) +
  theme_minimal()

# Display the combined plot
print(plot_combined)


























  