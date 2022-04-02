---
title: 'Comparative Evaluation of Transformer Models for Deidentification of Protected Health Information from Primary Care Electronic Medical Records'
date: 1-March-2022
permalink: /posts/2022/02/2022_transformer_deid//
tags:
  - Transformers
  - Deep Learning
  - Deidentification
  - Protected Health Information
  - Electronic Medical Records
---

This post will review and comparatively evaluate BERT, ROBERTA and ALBERT transformer models for deidentification of protected health information (PHI) from electronic medical records. We are interested in comparatively evaluating BERT, ROBERTA and ALBERT models with respect to their ability to identify PHI elements in the i2b2-2014 challenge. We fine tune the transformer models with respect to the following hyper-parameters: batch size, number of training epochs learning rate, and weight decay. We evaluate models with respect to overall performance to identify PHI versus non-PHI tokens. Additionally, we evaluate models on a PHI-class-specific basis (i.e. with respect to their ability to identify PHI classes: names, dates, locations, organizations, professions, etc.). Evaluation metrics include: sensitviity (recall), precision (PPV), and F1-score. We observe that larger transformer models outperform their base counterparts. More specifically, ROBERTA-large and ALBERT-xxlarge perform best with respect to the identifying PHI in the i2b2-2014 corpus. 

Data are publicly available at [N2C2](https://portal.dbmi.hms.harvard.edu/projects/n2c2-nlp/). 

An R script to parse the input texts, and align token sequences to class labels is provided [here](../files/2022_02_Rcode_i2b2_BIOtag.R).

A Jupyter notebook illustrating how to fine-tune and evaluate the ROBERTA-large model is given [here](../files/2022_02_Transformers_NER_FineTune_i2b2_2014_DEID_Roberta.ipynb).

A more rigorous description of our study/experiment is provided in this Arxiv pre-print, available [here](../files/2022_02_TransformerDEID_i2b2_2014_MeaneyHakimpourKaliaMoineddin_ArxivSubmit.pdf). 

As future work, we would like to apply these fine-tuned transformer models to primary care clinical text data available from our instution (DFCM/UTOPIAN). It would be interesting to see how they perform in the presence of domain/distributional-shift. 
