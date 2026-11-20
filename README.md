# Analysis of Student Academic Performance & Lifestyle Determinants

[![Institution: NIT Jalandhar](https://img.shields.io/badge/Institution-NIT%20Jalandhar-003366.svg)](https://www.nitj.ac.in)
[![Course: DMA Lab](https://img.shields.io/badge/Course-Data%20Mining%20%26%20Analytics%20Lab-2563eb.svg)](#)
[![Student Roll: 24103048](https://img.shields.io/badge/Roll%20No-24103048-0d9488.svg)](#)
[![R: Complete Analysis](https://img.shields.io/badge/R-4.x%20Reproducible-blue.svg)](#)
[![Interactive Dashboard](https://img.shields.io/badge/Dashboard-Chart.js%20%26%20HTML5-emerald.svg)](dashboard/index.html)
[![License: Academic](https://img.shields.io/badge/License-MIT%20Academic-slate.svg)](#)

---

## 📌 Executive Summary

This repository houses the final, complete, and reproducible deliverables for the **Data Mining and Analytics (DMA) Lab** project at **Dr. B. R. Ambedkar National Institute of Technology (NIT), Jalandhar**.

The project investigates the quantitative relationships governing engineering students' academic performance (measured via Semester Grade Point Average, SGPA) and multi-dimensional lifestyle factors, including **daily study duration, institutional attendance, recreational screen media, course backlogs, sleep duration, and study regularity**.

Utilizing both supervised parametric models (ordinary least squares multiple regression) and unsupervised machine learning (k-means clustering), this research establishes actionable thresholds for institutional academic intervention and provides an interactive web-based analytics dashboard for exploratory microdata analysis.

---

## 📂 Repository Structure

The repository is strictly structured with no redundant or extraneous files:

```text
DMA-Student-Performance-Analysis/
├── README.md                              # Comprehensive project documentation
├── .gitignore                             # Git exclusion configuration
├── 24103048_presentation.pptx             # Executive 18-slide PowerPoint deck (16:9 widescreen)
├── 24103048_report.docx                   # Complete 15-section academic report (APA format)
├── cleaned_student_academic_performance.csv# Standardized dataset (121 rows × 27 features)
├── complete_analysis.R                    # Full reproducible end-to-end R analysis script
└── dashboard/                             # Standalone interactive analytics dashboard
    ├── index.html                         # Responsive HTML5 layout & KPI views
    ├── style.css                          # Modern executive stylesheet & heatmap formatting
    └── script.js                          # Embedded dataset (N=121), Chart.js logic & filters
```

---

## 🎯 Authoritative Final Deliverables

| Deliverable | Filename | Format / Specs | Description |
|:---|:---|:---|:---|
| **Executive Presentation** | `24103048_presentation.pptx` | PPTX (18 Slides, 16:9) | Professional academic deck with NIT Jalandhar branding, embedded figures, structured data tables, and complete speaker notes. |
| **Comprehensive Report** | `24103048_report.docx` | DOCX (15 Sections, ~800 KB) | Comprehensive APA-compliant research paper featuring formal equations, literature-aligned discussion, regression diagnostics, and early-warning protocols. |
| **Cleaned Dataset** | `cleaned_student_academic_performance.csv` | CSV (121 rows × 27 cols) | Zero-loss engineered microdata with numeric midpoints, risk categorizations, ordinal rankings, and zero missing values. |
| **Reproducible Script** | `complete_analysis.R` | R Script (~16 KB) | Clean, self-contained R pipeline executing data validation, summary statistics, Spearman correlations, OLS regression, dynamic K-Means, and Base R heatmaps. |
| **Interactive Dashboard** | `dashboard/index.html` | HTML5 / CSS3 / Chart.js | Zero-dependency, client-side dashboard featuring live filtering, cross-tabulation percentage heatmaps, GPA prediction simulator, and download hub. |

---

## 📊 Dataset Schema & Engineered Features

The dataset comprises **$N = 121$ student records** across 18 original survey inputs, cleaned and transformed into 27 analytical variables:

- **Identifiers & Demographics:** `student_id`, `age` (mean: 20.8 yrs), `gender` (71.1% Male, 28.9% Female), `year_of_study` (70.2% 3rd Year), `degree_program` (52.1% CSE, 15.7% ECE, 14.0% Electrical, 9.9% Mechanical, 8.3% Civil).
- **Academic Metrics:** `current_sgpa_range` and `current_sgpa_midpoint` (mean: 7.26), `previous_sgpa_range` and `previous_sgpa_midpoint` (mean: 7.37), `sgpa_trajectory` (35.5% Increased, 33.9% Maintained, 30.6% Decreased).
- **Academic Risk:** `backlogs_category` and `backlogs_count` (61.2% zero backlogs, 18.2% 1 backlog, 14.0% 2 backlogs, 6.6% 4+ backlogs), `academic_standing_risk` (Low Risk: 53.7%, Moderate Risk: 33.9%, High Risk: 12.4%).
- **Effort & Attendance:** `study_hours_original_range` and `study_hours_original_midpoint` (mean: 2.80 hrs/day), `attendance_range` and `attendance_midpoint` (mean: 76.6%), `class_attendance_frequency` (1–5 scale), `assignment_completion_scale` (1–5 scale), `study_regularity_scale` (1–5 scale).
- **Lifestyle & Psychosocial:** `daily_screen_time_range` and `daily_screen_time_midpoint` (mean: 2.91 hrs/day), `sleep_duration_range` and `sleep_duration_midpoint` (mean: 6.83 hrs/day), `academic_confidence_scale` (1–5 scale), `academic_performance_self_rating` (ordinal).

---

## 📈 Key Empirical Findings

### 1. Non-Parametric Spearman Rank Correlations ($\rho$ with Current SGPA)

All hypotheses were tested non-parametrically across $N = 121$ observations:

| Variable | $\rho$ | $p$-value | Significance | Interpretation |
|:---|:---:|:---:|:---:|:---|
| **Daily Study Hours** | **+0.4441** | $3.36 \times 10^{-7}$ | *** | Strongest positive determinant of semester performance |
| **Previous SGPA** | **+0.3560** | $6.15 \times 10^{-5}$ | *** | Statistically significant academic persistence inertia |
| **Class Attendance Frequency** | **+0.3035** | $7.15 \times 10^{-4}$ | *** | Regular lecture participation reinforces retention |
| **Assignment Completion** | **+0.3017** | $7.72 \times 10^{-4}$ | *** | Continuous coursework engagement supports mastery |
| **Attendance Percentage** | **+0.2783** | $1.99 \times 10^{-3}$ | ** | Institutional 75% cutoff threshold effect |
| **Academic Confidence** | **+0.2658** | $3.22 \times 10^{-3}$ | ** | Self-efficacy positively associates with grade outcomes |
| **Daily Screen Time** | **-0.2668** | $3.09 \times 10^{-3}$ | ** | Recreational digital displacement of academic effort |
| **Active Backlogs Count** | **-0.2655** | $3.25 \times 10^{-3}$ | ** | Cognitive overload and prerequisite deficiencies |
| **Sleep Duration** | **+0.1466** | $0.1085$ | ns | Non-linear relationship; non-significant linear rank correlation |

### 2. Stepwise OLS Multiple Regression Model

Applying stepwise Akaike Information Criterion (AIC) model selection yielded the optimal empirical specification:

$$\widehat{\text{SGPA}} = 5.2459 + 0.2797(\text{Study Hours}) + 0.1999(\text{Previous SGPA}) - 0.1360(\text{Backlogs})$$

- **Model Fit:** $R^2 = 0.2513$, $\text{Adjusted } R^2 = 0.2321$
- **ANOVA Significance:** $F(3, 117) = 13.09$, $p = 1.97 \times 10^{-7}$
- **Residual Standard Error:** $0.8878$ on 117 degrees of freedom

### 3. Unsupervised K-Means Behavioral Clustering ($k = 3$)

Features were standardized ($z$-scores) prior to Euclidean clustering (seed = 42):

- **Cluster 1: High Achievers ($n = 49$, 40.5%)**
  - SGPA: $8.01$ | Study: $3.72$ hrs/day | Attendance: $82.1\%$ | Screen: $2.30$ hrs/day | Backlogs: $0.20$
  - *Profile:* Exemplary academic dedication, disciplined media use, clean backlog standing.
- **Cluster 2: At-Risk Cohort ($n = 19$, 15.7%)**
  - SGPA: $6.29$ | Study: $1.97$ hrs/day | Attendance: $65.5\%$ | Screen: $3.39$ hrs/day | Backlogs: $2.74$
  - *Profile:* Sub-threshold study hours, compromised attendance, severe backlog burden; requires immediate administrative intervention.
- **Cluster 3: Moderate / Balanced ($n = 53$, 43.8%)**
  - SGPA: $7.20$ | Study: $2.24$ hrs/day | Attendance: $76.7\%$ | Screen: $3.39$ hrs/day | Backlogs: $0.49$
  - *Profile:* Satisfactory baseline performance; amenable to grade advancement with structured guidance.

---

## 🚨 Institutional Early Warning & Intervention Framework

Derived directly from model inflection points:

```
┌────────────────────────────────────────────────────────────────────────┐
│ TIER 1: HIGH-RISK ACADEMIC ALERT (15.7% of cohort)                     │
│ Criteria: SGPA < 6.50 OR Backlogs ≥ 2 OR Attendance < 70%              │
│ Actions:  Mandatory bi-weekly faculty mentoring, remedial coursework, │
│           digital screen wellness counseling, activity restrictions.   │
├────────────────────────────────────────────────────────────────────────┤
│ TIER 2: MODERATE RISK / TRANSITION (43.8% of cohort)                   │
│ Criteria: SGPA 6.50–7.50 AND 1 Backlog OR Attendance 70–80%            │
│ Actions:  Automated attendance warning triggers, study skill           │
│           workshops, prioritized backlog clearance roadmaps.           │
├────────────────────────────────────────────────────────────────────────┤
│ TIER 3: ACADEMIC EXCELLENCE & LEADERSHIP (40.5% of cohort)             │
│ Criteria: SGPA ≥ 8.00 AND 0 Backlogs AND Attendance > 80%              │
│ Actions:  Undergraduate research opportunities, peer tutoring roles,   │
│           Dean's List commendations, corporate fellowship nominations. │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 💻 Running the Project

### 1. Launching the Interactive Web Dashboard
The dashboard is completely static and self-contained (zero backend dependencies):

- Simply double-click [`dashboard/index.html`](dashboard/index.html) in any modern browser (Chrome, Edge, Firefox, Safari).
- Or run a lightweight local server:
  ```bash
  cd dashboard
  npx serve .
  # or
  python -m http.server 8000
  ```
- **Features:** Real-time cohort filtering by gender, year, branch, study hours, and backlog status; dynamic cross-tabulation percentage heatmaps; interactive GPA regression simulator; direct deliverable downloads.

### 2. Executing the Complete R Analysis Script
Ensure R (v4.0+) is installed. Open terminal in the project root:

```bash
Rscript complete_analysis.R
```

The script runs with exit code 0, reading `cleaned_student_academic_performance.csv` (or regenerating it from `data/student_s.csv`), printing summary tables, correlation matrices, OLS regression summaries, and K-Means cluster profiling directly to standard output.

---

## ⚖️ Methodological Qualifications & Synthetic Data Ethics Statement

1. **Academic Provenance:** The dataset ($N = 121$) was curated for educational evaluation within the Data Mining & Analytics (DMA) curriculum at NIT Jalandhar.
2. **Scenario Qualification:** In alignment with rigorous academic standards, the dataset is designated as a structured scenario-based sample for statistical validation.
3. **Observational Bounds:** The cross-sectional design establishes statistical associations rather than causal mechanisms.
4. **Data Privacy:** All records are fully anonymized (`student_id` 1–121) with zero Personally Identifiable Information (PII).

---

## 👨‍🎓 Project Credits & Attribution

- **Student Author:** Diwakar Kumar (Roll No: **24103048**)
- **Institution:** Dr. B. R. Ambedkar National Institute of Technology (NIT), Jalandhar
- **Department:** Department of Computer Science and Engineering
- **Course:** Data Mining and Analytics (DMA) Laboratory
- **Semester:** 5th Semester / 3rd Year B.Tech (Academic Session 2026)
