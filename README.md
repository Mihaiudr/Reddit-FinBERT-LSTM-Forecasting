# S&P 500 Forecasting with Reddit Sentiment Analysis

This project implements a multi-modal deep learning approach to predict S&P 500 index movements by integrating historical market data with social media sentiment. It leverages NLP techniques and evaluates its predictive power when combined with recurrent neural networks.

### Project Overview

The analysis covers market data and social media activity from *January 1, 2022*, to *January 24, 2026*. 
The S&P 500 (SPY) was selected as the primary benchmark due to its role as a comprehensive economic indicator and its high correlation with broad financial sentiment found on platforms like Reddit.

### Technical Workflow

**1. NLP Pipeline** 

Data Extraction: Financial news and discussions were pulled from Reddit using the RedditExtractoR library in R.


Preprocessing: The pipeline included text cleaning (lowercase, punctuation, and stopword removal), tokenization, and lemmatization.


Grammatical Analysis: Implemented Part-of-Speech (POS) tagging and Named Entity Recognition (NER) to structure the text data.

Entity Identification: NER identified central organizations such as Microsoft, Fed, and Google within the dataset.

Sentiment Analysis: Utilized FinBERT, a BERT model pre-trained on financial news, to classify text into positive, negative, or neutral sentiment scores.

**2. Time Series Modeling**

Data Preparation: Market features (Open, High, Low, Close, Volume, Adj Close) were merged with the sentiment scores derived from the NLP stage.


Feature Engineering: Data was standardized using a StandardScaler fitted only on training data to prevent data leakage.


Architecture: A Bidirectional LSTM network was developed with a 256-unit architecture and Dropout layers (0.2) to capture temporal dependencies .


Sequence Construction: The model used a sliding window of 5 past days (n_past = 5) to predict the price for the following day (n_future = 1).
