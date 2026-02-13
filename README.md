# S&P 500 Forecasting with Reddit Sentiment Analysis

This project implements a **multi-modal deep learning framework** to predict S&P 500 index movements by integrating historical market data with Reddit-derived financial sentiment. By combining Natural Language Processing (NLP) and Recurrent Neural Networks (RNNs), the model evaluates whether social media sentiment enhances short-term market prediction performance.

---

## Project Overview

- **Target Asset:** SPDR S&P 500 ETF Trust (SPY)  
- **Time Period:** January 1, 2022 – January 24, 2026  
- **Objective:** Predict next-day SPY price movements using:
  - Historical market features  
  - Reddit-based financial sentiment  

SPY was selected due to its strong representation of the broader U.S. economy and its high correlation with overall market sentiment expressed on financial subreddits.


## Methodology

The system follows a two-stage pipeline:

1. **NLP-Based Sentiment Extraction**
2. **Time-Series Forecasting with Deep Learning**


#  1. NLP Pipeline

###  Data Extraction
Financial discussions and news posts were collected from Reddit using the `RedditExtractoR` package in R.

### Text Preprocessing
The preprocessing pipeline included:

- Lowercasing  
- Punctuation removal  
- Stopword removal  
- Tokenization  
- Lemmatization  

This ensured standardized, noise-reduced textual input for downstream modeling.


### Grammatical & Entity Analysis
- **Part-of-Speech (POS) Tagging** to identify syntactic structure  
- **Named Entity Recognition (NER)** to detect key organizations and financial entities  

NER successfully identified high-frequency organizations such as:

- Microsoft  
- Federal Reserve (Fed)  
- Google  

This structured representation helped contextualize sentiment within financial discussions.

### Sentiment Classification
Sentiment was computed using **FinBERT**, a BERT-based transformer model pre-trained specifically on financial text.  

Each Reddit post was classified into:

- Positive  
- Negative  
- Neutral  

Daily sentiment scores were aggregated and aligned with market trading days.

# 2. Time-Series Modeling

###  Market Data Integration
Market features included:

- Open  
- High  
- Low  
- Close  
- Adjusted Close  
- Volume  

These were merged with the daily aggregated sentiment scores to form the final modeling dataset.

---

###  Feature Engineering

- Data was standardized using `StandardScaler`  
- The scaler was fit **only on training data** to prevent data leakage  
- A sliding window approach was applied to construct temporal sequences  

---

### Sequence Construction

- `n_past = 5` → Previous 5 trading days used as input  
- `n_future = 1` → Predict next-day price  

This structure enables the model to learn short-term temporal dependencies.

---

### Model Architecture

A **Bidirectional LSTM network** was implemented to capture forward and backward temporal relationships.

**Architecture:**

- Bidirectional LSTM (256 units)  
- Dropout (0.2)  
- Dense output layer  

Bidirectional LSTM was chosen to better capture contextual dependencies across short historical windows while mitigating overfitting through dropout regularization.


## Research Goal

 Does Reddit-derived financial sentiment improve short-term S&P 500 forecasting accuracy when combined with historical price data?

This project evaluates the incremental predictive value of social sentiment in a deep learning time-series framework.
