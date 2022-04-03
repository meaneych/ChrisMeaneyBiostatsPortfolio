################################################################
## Parse Question Answer Dataset
## From Kumar, Clark (2011). 1000 Clinical Questions Answered
## https://med-mu.com/wp-content/uploads/2018/06/medsouls.blogspot.com-1000-Questions-and-Answers-from-Kumar-_-Clark_s-Clinical-Medicine-2e-Saunders-2011.pdf
################################################################

###################################
## Package Dependencies
###################################
library(qdapRegex)


###################################
## Import Data
###################################

## Specify where the text book lives
fpath <- "/working_dir/clinical_question_answer/pdf_clinical_textbook/KumarClark_2011_1000ClinicalQuestionsAnswered.txt"

## Read in the lines of the txt file
book_lines <- readLines(fpath)
str(book_lines)

##
## Very gentle text processing
##

## trim white space (normalize strings)
book_lines <- trimws(book_lines, which="both")

## convert to lower case (normalize strings)
book_lines <- tolower(book_lines)
sum(sapply(book_lines, nchar))


#########################################
## Pattern Matching:
## 1) Find Question Lines
## 2) Find Answer Lines
## 3) Note: Questions/Answers delimitted by one/two "" strings (find them)
## 4) Grab contents between start gate and stop gate
#########################################

## 1. Question Lines
q_lines <- grepl(x=book_lines, pattern="^question [0-9]+$")
table(q_lines)
#book_lines[q_lines]

## 2. Answer Lines
a_lines <- grepl(x=book_lines, pattern="^answer [0-9]+$")
table(a_lines)
#book_lines[a_lines]

## 3. Delimiter Lines
d_lines <- book_lines==""
table(d_lines)
## book_lines[d_lines]

##
## You know blank lines are delimiters, to 
##
length(book_lines)

## Blank Lines
book_lines <- ifelse(d_lines==TRUE, "BLANK_STRING", book_lines)
book_lines <- ifelse(q_lines==TRUE, toupper(gsub(book_lines, pattern=" ", replace="")), book_lines)
book_lines <- ifelse(a_lines==TRUE, toupper(gsub(book_lines, pattern=" ", replace="")), book_lines)

table(book_lines=="BLANK_STRING")
table(grepl(x=book_lines, pattern="QUESTION[0-9]+"))
table(grepl(x=book_lines, pattern="ANSWER[0-9]+"))

##
## Convert to single character string
##
book_string <- paste0(book_lines, collapse=" ")
str(book_string)
nchar(book_string)
sum(sapply(book_lines, nchar))

##
## Grab all the contents between start/end patterns
## 1) Start is Question/Answer
## 2) End is "BLANK_STRING" symbol
##

## 1. Questions
questions <- qdapRegex::ex_between(text.var=book_string, 
									left="QUESTION", 
									right="BLANK_STRING", 
									 extract=TRUE,
									 include.markers=TRUE)[[1]]

## 2. Answers
answers <- qdapRegex::ex_between(text.var=book_string, 
									left="ANSWER", 
									right="BLANK_STRING", 
									 extract=TRUE,
									 include.markers=TRUE)[[1]]

##
## FML they dont match in length...lets hack up a solution
##
str(questions)
str(answers)

questions_clean <- gsub(questions, pattern=" BLANK_STRING", replace="")
answers_clean <- gsub(answers, pattern=" BLANK_STRING", replace="")

##
## Now we will try to wrangle these two objects into alignment
##
questions_numbers <- data.frame(questions=sapply(strsplit(questions_clean, " "), function(x) x[[1]][1]))
answers_numbers <- data.frame(answers=sapply(strsplit(answers_clean, " "), function(x) x[[1]][1]))

## Get the cumulative occurrence of the question/answer (corresponding to its chapter)
## https://stackoverflow.com/questions/15230446/cumulative-sequence-of-occurrences-of-values
questions_numbers$questions_count <- with(questions_numbers, ave(as.character(questions), questions, FUN=seq_along))
questions_numbers$numbers <- gsub(x=questions_numbers$questions, pattern="QUESTION", replace="")
questions_numbers$diff_numbers <- c(NA, diff(as.numeric(questions_numbers$numbers)))
num_ch <- sum(questions_numbers$diff_numbers<0,na.rm=TRUE)+1
seq_lens <- diff(c(0, which(questions_numbers$diff_numbers<0), nrow(questions_numbers)))
ch <- rep(1:num_ch, seq_lens)
questions_numbers$ch <- ch

answers_numbers$answers_count <- with(answers_numbers, ave(as.character(answers), answers, FUN=seq_along))
answers_numbers$numbers <- gsub(x=answers_numbers$answers, pattern="ANSWER", replace="")
answers_numbers$diff_numbers <- c(NA, diff(as.numeric(answers_numbers$numbers)))
num_ch <- sum(answers_numbers$diff_numbers<0,na.rm=TRUE)+1
seq_lens <- diff(c(0, which(answers_numbers$diff_numbers<0), nrow(answers_numbers)))
ch <- rep(1:num_ch, seq_lens)
answers_numbers$ch <- ch

## Parse into unique ID
questions_numbers$id <- with(questions_numbers, paste0("CH", ch, "_", gsub(x=questions, pattern="QUESTION", replace="QA")))
answers_numbers$id <- with(answers_numbers, paste0("CH", ch, "_", gsub(x=answers, pattern="ANSWER", replace="QA")))

## IDs in both question and answer
in_both <- intersect(questions_numbers$id, answers_numbers$id)

## Get bool masks for questions and answers
questions_mask <- questions_numbers$id %in% in_both
table(questions_mask)

answers_mask <- answers_numbers$id %in% in_both
table(answers_mask)


########################################
## Get matching rows of questions/answers
########################################
questions_sm <- questions_clean[questions_mask]
answers_sm <- answers_clean[answers_mask]

str(questions_sm)
str(answers_sm)

## Put into single dataframe
qa_df <- data.frame(questions=questions_sm, answers=answers_sm, stringsAsFactors=FALSE)
str(qa_df)

## Can write the parsed dataset to disk 
fpath_out <- "/working_dir/clinical_question_answer/pdf_clinical_textbook/KumarClark_2011_1000ClinicalQuestionsAnswered_Parsed.RDS"
saveRDS(qa_df, file=fpath_out)

fpath_out <- "/working_dir/clinical_question_answer/pdf_clinical_textbook/KumarClark_2011_1000ClinicalQuestionsAnswered_Parsed.csv"
write.csv(x=qa_df, file=fpath_out, row.names=FALSE)

