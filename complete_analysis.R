# ==============================================================================
# Analysis of Student Academic Performance & Lifestyle Determinants
# Data Mining and Analytics (DMA) Lab - Dr. B. R. Ambedkar NIT Jalandhar
# ==============================================================================

if (!interactive()) pdf(NULL)
Sys.setenv(R_LIBS_USER = "")
set.seed(42)

# ------------------------------------------------------------------------------
# 1. DATA IMPORT, CLEANING & PREPROCESSING
# ------------------------------------------------------------------------------
raw_path <- file.path("data", "student_s.csv")
if (!file.exists(raw_path)) raw_path <- "student_s.csv"
if (!file.exists(raw_path)) stop("Dataset student_s.csv not found!")

raw_df <- read.csv(raw_path, check.names = FALSE, stringsAsFactors = FALSE)

clean_str <- function(x) gsub("\u2013", "-", gsub("–", "-", trimws(x)))

sgpa_levels   <- c("5-6", "6-7", "7-8", "8-9", "9-10")
sgpa_mid      <- c("5-6" = 5.5, "6-7" = 6.5, "7-8" = 7.5, "8-9" = 8.5, "9-10" = 9.5)
att_levels    <- c("Below 50%", "50-60%", "60-70%", "70-80%", "80-90%", "90-100%")
att_mid       <- c("Below 50%" = 45, "50-60%" = 55, "60-70%" = 65, "70-80%" = 75, "80-90%" = 85, "90-100%" = 95)
study_levels  <- c("Less than 1 hour", "1-2 hours", "2-3 hours", "3-4 hours", "4-5 hours", "More than 5 hours")
study_mid     <- c("Less than 1 hour" = 0.5, "1-2 hours" = 1.5, "2-3 hours" = 2.5, "3-4 hours" = 3.5, "4-5 hours" = 4.5, "More than 5 hours" = 5.5)
screen_levels <- c("1-2 hours", "2-3 hours", "3-4 hours", "More than 4 hours")
screen_mid    <- c("1-2 hours" = 1.5, "2-3 hours" = 2.5, "3-4 hours" = 3.5, "More than 4 hours" = 4.5)
sleep_levels  <- c("Less than 5 hours", "5-6 hours", "6-7 hours", "7-8 hours", "8+ hours")
sleep_mid     <- c("Less than 5 hours" = 4.5, "5-6 hours" = 5.5, "6-7 hours" = 6.5, "7-8 hours" = 7.5, "8+ hours" = 8.5)
assign_levels <- c("Never", "Rarely", "Sometimes", "Often", "Always")
assign_scale  <- c("Never" = 1, "Rarely" = 2, "Sometimes" = 3, "Often" = 4, "Always" = 5)
backlog_cnt   <- c("0" = 0, "1" = 1, "2" = 2, "4 or more" = 4)

prev_clean <- clean_str(raw_df[["Previous Semester SGPA"]])
curr_clean <- clean_str(raw_df[["Current Semester SGPA"]])
p_rnk <- match(prev_clean, sgpa_levels)
c_rnk <- match(curr_clean, sgpa_levels)
traj  <- ifelse(c_rnk > p_rnk, "Increased", ifelse(c_rnk == p_rnk, "Maintained", "Decreased"))

df <- data.frame(
  student_id                      = 1:nrow(raw_df),
  age                             = as.integer(raw_df[["Age"]]),
  gender                          = trimws(raw_df[["Gender"]]),
  year_of_study                   = trimws(raw_df[["Year of Study"]]),
  degree_program                  = trimws(raw_df[["Degree / Program"]]),
  previous_sgpa_range             = prev_clean,
  previous_sgpa_midpoint          = unname(sgpa_mid[prev_clean]),
  current_sgpa_range              = curr_clean,
  current_sgpa_midpoint           = unname(sgpa_mid[curr_clean]),
  sgpa_trajectory                 = traj,
  backlogs_category               = clean_str(raw_df[["Number of Backlogs"]]),
  backlogs_count                  = as.integer(backlog_cnt[clean_str(raw_df[["Number of Backlogs"]])]),
  attendance_range                = clean_str(raw_df[["Average Attendance Percentage"]]),
  attendance_midpoint             = unname(att_mid[clean_str(raw_df[["Average Attendance Percentage"]])]),
  study_hours_original_range      = clean_str(raw_df[["Original Average Study Hours Per Day"]]),
  study_hours_original_midpoint   = unname(study_mid[clean_str(raw_df[["Original Average Study Hours Per Day"]])]),
  study_regularity_scale          = as.integer(raw_df[["How regularly do you study?"]]),
  assignment_completion_frequency = clean_str(raw_df[["How often do you complete assignments on time?"]]),
  assignment_completion_scale     = as.integer(assign_scale[clean_str(raw_df[["How often do you complete assignments on time?"]])]),
  daily_screen_time_range         = clean_str(raw_df[["Average Daily Screen / Social Media Usage"]]),
  daily_screen_time_midpoint      = unname(screen_mid[clean_str(raw_df[["Average Daily Screen / Social Media Usage"]])]),
  sleep_duration_range            = clean_str(raw_df[["Average Sleep Duration"]]),
  sleep_duration_midpoint         = unname(sleep_mid[clean_str(raw_df[["Average Sleep Duration"]])]),
  class_attendance_frequency      = trimws(raw_df[["How frequently do you attend classes regularly?"]]),
  academic_confidence_scale       = as.integer(raw_df[["How confident are you about your academic performance?"]]),
  academic_performance_self_rating= trimws(raw_df[["How would you rate your overall academic performance?"]]),
  academic_standing_risk          = trimws(raw_df[["How would you classify your current academic standing?"]]),
  stringsAsFactors                = FALSE
)

stopifnot(nrow(df) == 121, sum(is.na(df)) == 0)
write.csv(df, "cleaned_student_academic_performance.csv", row.names = FALSE)
cat("Dataset validated and cleaned: 121 observations, 27 variables.\n")

# ------------------------------------------------------------------------------
# 2. DESCRIPTIVE STATISTICS
# ------------------------------------------------------------------------------
cat("\n--- Demographic Overview ---\n")
print(table(df$gender))
print(round(prop.table(table(df$gender)) * 100, 1))

print(table(factor(df$year_of_study, levels = c("1st Year", "2nd Year", "3rd Year", "4th Year"))))
print(table(df$degree_program))

cat("\n--- Academic Performance Overview ---\n")
print(table(factor(df$current_sgpa_range, levels = sgpa_levels)))
print(table(factor(df$sgpa_trajectory, levels = c("Increased", "Maintained", "Decreased"))))
print(table(factor(df$backlogs_category, levels = c("0", "1", "2", "4 or more"))))

# ------------------------------------------------------------------------------
# 3. VISUALIZATION SUITE (NEW HEATMAP & EXPLORATORY APPROACH)
# ------------------------------------------------------------------------------
col_navy <- "#101C2C"
col_slate <- "#263B53"
col_teal <- "#00BFC4"
col_coral <- "#F8766D"
col_blue <- "#2171B5"

# Helper for Cross-Tabulation Percentage Heatmaps
plot_pct_heatmap <- function(row_vals, col_vals, row_levels, col_levels, title, xlab, ylab, pal_high = "#2171B5", pal_low = "#F7FBFF") {
  rf <- factor(row_vals, levels = row_levels)
  cf <- factor(col_vals, levels = col_levels)
  tab <- table(rf, cf)
  pct <- round(prop.table(tab, 1) * 100)
  
  nr <- length(row_levels)
  nc <- length(col_levels)
  mat <- t(pct)
  
  par(mar = c(4.5, 9.5, 3.5, 2), bg = "#FFFFFF", family = "sans")
  col_ramp <- colorRampPalette(c(pal_low, pal_high))(100)
  
  image(1:nc, 1:nr, mat, col = col_ramp, zlim = c(0, 100), axes = FALSE,
        xlab = xlab, ylab = "", main = title, font.main = 2, col.main = col_navy)
  axis(1, at = 1:nc, labels = col_levels, cex.axis = 0.9)
  axis(2, at = 1:nr, labels = row_levels, las = 1, cex.axis = 0.85)
  title(ylab = ylab, line = 8)
  
  for (i in 1:nc) {
    for (j in 1:nr) {
      val <- mat[i, j]
      text_col <- ifelse(val > 50, "white", col_navy)
      text(i, j, labels = paste0(val, "%"), col = text_col, font = 2, cex = 0.85)
    }
  }
  box(col = "#CBD5E1")
}

# Graph 1: Gender Distribution
par(mar = c(4.5, 4.5, 3, 1), bg = "#FFFFFF", family = "sans")
cnt_g <- table(df$gender)
bp1 <- barplot(cnt_g, col = c(col_coral, col_teal), ylim = c(0, 100),
               main = "Gender Distribution", ylab = "Number of Students")
text(bp1, cnt_g + 4, labels = paste0(cnt_g, " (", round(prop.table(cnt_g)*100, 1), "%)"), font = 2)

# Graph 2: Year of Study
cnt_y <- table(factor(df$year_of_study, levels = c("1st Year", "2nd Year", "3rd Year", "4th Year")))
bp2 <- barplot(cnt_y, col = "#3B82F6", ylim = c(0, 100),
               main = "Respondents by Year of Study", ylab = "Number of Students")
text(bp2, cnt_y + 4, labels = paste0(cnt_y, " (", round(prop.table(cnt_y)*100, 1), "%)"), font = 2)

# Graph 3: Degree Program Distribution
par(mar = c(4.5, 8.5, 3, 1))
cnt_d <- sort(table(df$degree_program))
bp3 <- barplot(cnt_d, horiz = TRUE, col = col_teal, xlim = c(0, 75), las = 1,
               main = "Degree / Program Distribution", xlab = "Number of Students")
text(cnt_d + 4, bp3, labels = paste0(cnt_d, " (", round(prop.table(cnt_d)*100, 1), "%)"), font = 2)

# Graph 4: Previous vs Current Semester SGPA (Grouped Bar Chart)
par(mar = c(4.5, 4.5, 3, 1))
mat_sgpa <- rbind(Previous = table(factor(df$previous_sgpa_range, levels = sgpa_levels)),
                  Current  = table(factor(df$current_sgpa_range, levels = sgpa_levels)))
bp4 <- barplot(mat_sgpa, beside = TRUE, col = c(col_coral, col_teal), ylim = c(0, 60),
               main = "Previous vs Current Semester SGPA", ylab = "Number of Students")
legend("topright", legend = c("Previous Semester", "Current Semester"), fill = c(col_coral, col_teal), bty = "n")
text(bp4, mat_sgpa + 2.5, labels = as.vector(mat_sgpa), font = 2, cex = 0.85)

# Graph 5: Backlog Distribution
cnt_b <- table(factor(df$backlogs_category, levels = c("0", "1", "2", "4 or more")))
bp5 <- barplot(cnt_b, col = col_teal, ylim = c(0, 85),
               main = "Backlog Distribution", ylab = "Number of Students", xlab = "Number of Backlogs")
text(bp5, cnt_b + 4, labels = paste0(cnt_b, " (", round(prop.table(cnt_b)*100, 1), "%)"), font = 2)

# Graph 6: Daily Study Hours Distribution
cnt_s <- table(factor(df$study_hours_original_range, levels = study_levels))
bp6 <- barplot(cnt_s, col = col_coral, ylim = c(0, 45), las = 2, cex.names = 0.8,
               main = "Daily Study Hours", ylab = "Number of Students")
text(bp6, cnt_s + 2, labels = as.vector(cnt_s), font = 2)

# Graph 7: Study Hours vs Current SGPA (Percentage Heatmap)
plot_pct_heatmap(df$study_hours_original_range, df$current_sgpa_range, study_levels, sgpa_levels,
                 "Study Hours vs Current SGPA (Row %)", "Current SGPA", "Study Hours per Day")

# Graph 8: Attendance Group vs Current SGPA (Percentage Heatmap)
plot_pct_heatmap(df$attendance_range, df$current_sgpa_range, att_levels, sgpa_levels,
                 "Attendance Group vs Current SGPA (Row %)", "Current SGPA", "Attendance Percentage")

# Graph 9: Screen Time vs Current SGPA (Percentage Heatmap)
plot_pct_heatmap(df$daily_screen_time_range, df$current_sgpa_range, screen_levels, sgpa_levels,
                 "Screen Time vs Current SGPA (Row %)", "Current SGPA", "Daily Screen / Social Media Usage")

# Graph 10: Sleep Duration vs Current SGPA (Percentage Heatmap)
plot_pct_heatmap(df$sleep_duration_range, df$current_sgpa_range, sleep_levels, sgpa_levels,
                 "Sleep Duration vs Current SGPA (Row %)", "Current SGPA", "Sleep Duration")

# Graph 11: Backlogs vs Academic Standing Risk (Percentage Heatmap)
plot_pct_heatmap(df$backlogs_category, df$academic_standing_risk,
                 c("0", "1", "2", "4 or more"), c("Low Risk", "Moderate Risk", "High Risk"),
                 "Backlogs vs Self-Classified Academic Risk (Row %)",
                 "Academic Standing", "Number of Backlogs", pal_high = "#B30000", pal_low = "#FFF7EC")

# Graph 12: Spearman Correlation Matrix Heatmap
cor_vars <- data.frame(
  Current_SGPA     = df$current_sgpa_midpoint,
  Attendance       = df$attendance_midpoint,
  Study_Hours      = df$study_hours_original_midpoint,
  Study_Regularity = df$study_regularity_scale,
  Sleep_Duration   = df$sleep_duration_midpoint,
  Screen_Time      = df$daily_screen_time_midpoint,
  Confidence       = df$academic_confidence_scale,
  Backlogs         = df$backlogs_count
)

cmat <- cor(cor_vars, method = "spearman")
nv <- ncol(cmat)
cfun <- colorRampPalette(c("#B2182B", "#FFFFFF", "#2166AC"))(100)

par(mar = c(6.5, 7.5, 3.5, 2), bg = "#FFFFFF", family = "sans")
image(1:nv, 1:nv, t(cmat[nv:1, ]), axes = FALSE, xlab = "", ylab = "", col = cfun, zlim = c(-1, 1),
      main = "Spearman Correlation Heatmap", font.main = 2, col.main = col_navy)
axis(1, at = 1:nv, labels = colnames(cmat), las = 2, cex.axis = 0.85)
axis(2, at = 1:nv, labels = rev(colnames(cmat)), las = 1, cex.axis = 0.85)
for (i in 1:nv) {
  for (j in 1:nv) {
    v <- cmat[nv - j + 1, i]
    text(i, j, labels = sprintf("%.2f", v), cex = 0.8, col = ifelse(abs(v) > 0.45, "white", col_navy), font = 2)
  }
}
box(col = "#CBD5E1")

# ------------------------------------------------------------------------------
# 4. REGRESSION ANALYSIS (OBSERVATIONAL PREDICTIVE MODELING)
# ------------------------------------------------------------------------------
cat("\n--- Multiple Linear Regression (Full Model) ---\n")
lm_data <- data.frame(
  Current_SGPA = df$current_sgpa_midpoint,
  Prev_SGPA    = df$previous_sgpa_midpoint,
  Study_Hours  = df$study_hours_original_midpoint,
  Attendance   = df$attendance_midpoint,
  Screen_Time  = df$daily_screen_time_midpoint,
  Sleep        = df$sleep_duration_midpoint,
  Backlogs     = df$backlogs_count
)
fit_full <- lm(Current_SGPA ~ Prev_SGPA + Study_Hours + Attendance + Screen_Time + Sleep + Backlogs, data = lm_data)
print(summary(fit_full))

cat("\n--- Stepwise AIC Regression (Optimal Drivers) ---\n")
fit_opt <- step(fit_full, trace = 0)
print(summary(fit_opt))

# ------------------------------------------------------------------------------
# 5. K-MEANS CLUSTERING (DYNAMIC PROFILE SEGMENTATION)
# ------------------------------------------------------------------------------
features_scaled <- scale(df[, c("current_sgpa_midpoint", "study_hours_original_midpoint", 
                                "attendance_midpoint", "daily_screen_time_midpoint", "backlogs_count")])
km <- kmeans(features_scaled, centers = 3, nstart = 25)

prof <- aggregate(df[, c("current_sgpa_midpoint", "study_hours_original_midpoint", 
                         "attendance_midpoint", "daily_screen_time_midpoint", "backlogs_count")], 
                  by = list(Cluster = km$cluster), mean)

min_c <- which.min(prof$current_sgpa_midpoint)
max_c <- which.max(prof$current_sgpa_midpoint)
mid_c <- setdiff(1:3, c(min_c, max_c))
pcts  <- round(km$size / nrow(df) * 100, 1)

cluster_summary <- prof
cluster_summary$Student_Count <- km$size
cluster_summary$Cohort_Share  <- paste0(pcts, "%")

labels <- character(3)
labels[min_c] <- "At-Risk / Vulnerable Cohort"
labels[max_c] <- "High Achievers / Dedicated Learners"
labels[mid_c] <- "Moderate / Balanced Learners"
cluster_summary$Archetype <- labels

cat("\n--- K-Means Cluster Segmentation Summary (k=3) ---\n")
colnames(cluster_summary)[2:6] <- c("Mean_SGPA", "Mean_StudyHrs", "Mean_AttPct", "Mean_ScreenHrs", "Mean_Backlogs")
print(cluster_summary[, c("Cluster", "Archetype", "Student_Count", "Cohort_Share", 
                          "Mean_SGPA", "Mean_StudyHrs", "Mean_AttPct", "Mean_ScreenHrs", "Mean_Backlogs")], row.names = FALSE)

# Graph 13: K-Means Normalized Profile Barplot
c_titles <- character(3)
c_titles[min_c] <- sprintf("Cluster %d:\nAt-Risk (%.1f%%)", prof$Cluster[min_c], pcts[min_c])
c_titles[max_c] <- sprintf("Cluster %d:\nHigh Achiever (%.1f%%)", prof$Cluster[max_c], pcts[max_c])
c_titles[mid_c] <- sprintf("Cluster %d:\nBalanced (%.1f%%)", prof$Cluster[mid_c], pcts[mid_c])

m_mat <- t(as.matrix(prof[, 2:6]))
colnames(m_mat) <- c_titles
norm_mat <- sweep(m_mat, 1, apply(m_mat, 1, max), "/")

par(mar = c(4.5, 4.5, 3.5, 1), bg = "#FFFFFF", family = "sans")
barplot(norm_mat, beside = TRUE, col = c("#12B8A6", "#3B82F6", "#10B981", "#F59E0B", "#EF4444"), ylim = c(0, 1.3),
        main = "K-Means Student Archetypes (Normalized Feature Ratios)", ylab = "Relative Intensity")
legend("topright", legend = c("SGPA", "Study Hours", "Attendance", "Screen Time", "Backlogs"),
       fill = c("#12B8A6", "#3B82F6", "#10B981", "#F59E0B", "#EF4444"), bty = "n", ncol = 3, cex = 0.8)

cat("\n==============================================================================\n")
cat("COMPLETE ANALYSIS FINISHED SUCCESSFULLY.\n")
cat("==============================================================================\n")
