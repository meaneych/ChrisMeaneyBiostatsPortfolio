###########################################
## Parse PDF into txt and eventually into a structured "Question-Answer" dataset
## From Kumar, Clark (2011). 1000 Clinical Questions Answered
## https://med-mu.com/wp-content/uploads/2018/06/medsouls.blogspot.com-1000-Questions-and-Answers-from-Kumar-_-Clark_s-Clinical-Medicine-2e-Saunders-2011.pdf
###########################################

## Updates
sudo apt-get update

## Install poppler-utils
sudo apt install poppler-utils

## PDF2text command from poppler-utils
pdftotext -layout KumarClark_2011_1000ClinicalQuestionsAnswered.pdf KumarClark_2011_1000ClinicalQuestionsAnswered.txt
