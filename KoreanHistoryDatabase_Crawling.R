#####한국근현대잡지자료 원문 수집####
###http://db.history.go.kr/item/level.do?itemId=ma###
#대한자강회월보#
#대한협회회보#
#서우#
#서북학회월보#

setwd("C:/Google 드라이브/근대 잡지 디지털인문학 연구/data_crawling")

save.image(file=".RData")

####packages load####
library(data.table)
library(rvest)
library(dplyr)
library(stringr)
#library(readxl)


####URL####
# http://db.history.go.kr/item/level.do?sort=levelId&dir=ASC&start=1&limit=20&page=1&pre_page=1&setId=-1&prevPage=0&prevLimit=&itemId=ma&types=&synonym=off&chinessChar=on&brokerPagingInfo=&levelId=ma_001&position=-1 ##대한자강회월보 예시

# contents_url <- "http://db.history.go.kr/item/level.do?sort=levelId&dir=ASC&start=1&limit=20&page=1&pre_page=1&setId=-1&prevPage=0&prevLimit=&itemId=ma&types=&synonym=off&chinessChar=on&brokerPagingInfo=&levelId=ma_001_0020_0040&position=-1"
# contents_url <- "http://db.history.go.kr/item/level.do?sort=levelId&dir=ASC&start=1&limit=20&page=1&pre_page=1&setId=-1&prevPage=0&prevLimit=&itemId=ma&types=&synonym=off&chinessChar=on&brokerPagingInfo=&levelId=ma_002_0090_0370&position=-1"

contents_url <- "http://db.history.go.kr/item/level.do?sort=levelId&dir=ASC&start=1&limit=20&page=1&pre_page=1&setId=-1&prevPage=0&prevLimit=&itemId=ma&types=&synonym=off&chinessChar=on&brokerPagingInfo=&levelId=ma_001_0010_0010&position=-1"
  
####Parsing####
html_contents <- read_html(contents_url,encoding = 'UTF-8')
html_contents %>% html_nodes(".cont_view")

###수집컬럼 구성###
## 잡지명, 발행일, 기사제목, 필자, 기사형태, 본문, 색인어(nested) ##
##제목 테이블##
#컬럼명#
html_contents %>% 
  html_nodes(".cont_view") %>%
    html_nodes(".dl_data_pru tbody tr")
#제목 - 내용#
title_text <- html_contents %>% 
  html_nodes(".cont_view") %>%
    html_nodes(".dl_data_pru tbody tr td") %>%
      html_text(trim = T) %>%
        data.table()


nrow(title_text)

##본문 테이블##
#본문#
contents <- html_contents %>% 
  html_nodes(".cont_view") %>%
    html_nodes(xpath = '//*[@id="cont_view"]')
  
contents_text <- html_contents %>% 
  html_nodes(".cont_view") %>%
    html_nodes(xpath = '//*[@id="cont_view"]') %>%
      html_text(trim = T)


##색인어 테이블##
#색인어 종류#
index <- html_contents %>% 
  html_nodes(".cont_side") %>%
    html_nodes(xpath = '//*[@id="container"]/div[4]/div/div/b')

#색인어 전체 단어군#
index_terms <- html_contents %>% 
  html_nodes(".cont_side") %>%
    html_nodes(xpath = '//*[@id="container"]/div[4]/div/div/a/span') %>%
      html_text()

#색인어 종류별 단어군#
index_by_terms <- html_contents %>% 
  html_nodes(".cont_side") %>%
    html_nodes(xpath = '//*[@id="container"]/div[4]/div/div/a/span')


html_attr(index_by_terms,'title')
unique(html_attr(index_by_terms,'title')) #색인어 종류
index_type <- unique(html_attr(index_by_terms,'title')) #색인어 종류
#html_nodes(index_by_terms,css ='[@title==이름]')
terms_table <- data.table()
for(i in 1:length(index_by_terms)){
  for(j in 1:length(unique(html_attr(index_by_terms,'title')))){
    if(xml_attrs(index_by_terms[[i]])["title"]==index_type[j]){
    }
  }
  #terms_table[,index_type[j]:=res]
}

####Merge####
# ma_001~004 : 연구 도서
# ma_001~095 : 전체
## 파라미터 패턴 ##
# ma_001_0020_0040
# 00*1 : 도서 (1씩 증가)
# 00*10 : 권호 (10씩 증가)
# 00*10 : 기사번호(10씩 증가)
###대한자강회###
# i, j ,r
book_index <- str_pad(seq(1,95,1),3,"left","0") # 도서
vol_index <- str_pad(seq(10,500,10),4,"left","0") #권호
article_index <- str_pad(seq(10,500,10),4,"left","0") #기사번호

# contents_url <- paste0("http://db.history.go.kr/item/level.do?sort=levelId&dir=ASC&start=1&limit=100&page=1&pre_page=1&setId=-1&prevPage=0&prevLimit=&itemId=ma&types=&synonym=off&chinessChar=on&brokerPagingInfo=&levelId=ma_",book_index[1],"_",vol_index[1],"_",article_index[1],"&position=-1")

##본문에서 <br> 태크 \n으로 변환
#function definition
html_text_collapse <- function(x, trim = F, collapse = "\n"){
  UseMethod("html_text_collapse")
}

html_text_collapse.xml_nodeset <- function(x, trim = F, collapse = "\n"){
  vapply(x, html_text_collapse.xml_node, character(1), trim = trim, collapse = collapse)
}

html_text_collapse.xml_node <- function(x, trim = F, collapse = "\n"){
  paste(xml2::xml_find_all(x, ".//text()"), collapse = collapse)
}


#### 수집기 실행 ####
# master <- data.table()
# master2 <- data.table()
master3 <- data.table()
master_res <- data.table()

###For loop###
for(i in 1:95){ #대한자강회월보, 대한협회회보, 서우, 서북학회월보(1~4),1910s: 1~12&48, last 95
  for(j in 1:50){
    if(j==1&&i>1){
      cat("index:",i-1," ",str_split(title_text[1]," ",simplify = T)[1],"끝, 다음 잡지 시작","\n")
    }
    for(r in 1:50){
      #print(r)
      contents_url <- paste0("http://db.history.go.kr/item/level.do?sort=levelId&dir=ASC&start=1&limit=100&page=1&pre_page=1&setId=-1&prevPage=0&prevLimit=&itemId=ma&types=&synonym=off&chinessChar=on&brokerPagingInfo=&levelId=ma_",book_index[i],"_",vol_index[j],"_",article_index[r],"&position=-1")
      
      html_contents <-  tryCatch(read_html(contents_url,encoding = 'UTF-8'),
                                 error=function(e){NA})
      
      if(is.na(html_contents)){
        next
      }
      
      title_text <- html_contents %>% 
        html_nodes(".cont_view") %>%
        html_nodes(".dl_data_pru tbody tr td") %>%
        html_text(trim = T)
      
      if(length(title_text)==5){
        title_res <- data.table(잡지명=title_text[1], 발행일=title_text[2],
                                기사제목=title_text[3], 필자=title_text[4],
                                기사형태=title_text[5])
      }else{
        title_res <- data.table(잡지명=title_text[1], 발행일=title_text[2],
                                기사제목=title_text[3], 필자="",
                                기사형태=title_text[4])
      }
      #title <- rbindlist(list(title,title_res))
      
      # contents_text <- html_contents %>%
      #   html_nodes(".cont_view") %>%
      #   html_nodes(xpath = '//*[@id="cont_view"]') %>%
      #   html_text(trim=F)
      
      contents_text <- html_contents %>% 
        html_nodes(".cont_view") %>%
        html_nodes(xpath = '//*[@id="cont_view"]') %>%
        html_text_collapse()
      
      index_terms <- html_contents %>% 
        html_nodes(".cont_side") %>%
        html_nodes(xpath = '//*[@id="container"]/div[4]/div/div/a/span')
      
      index_terms_all <- paste(html_text(index_terms), collapse = ',') #하나의 string으로 변환
      
      ##색인어 종류별 구분
      index_terms_name <- c()
      index_terms_place <- c()
      index_terms_group <- c()
      index_terms_office <- c()
      index_terms_etc <- c()
      
      #색인어 종류 : 이름, 지명, 단체, 관서, 기타
      if(length(index_terms)!=0){
        for(q in 1:length(index_terms)){
          {
            if(xml_attrs(index_terms[[q]])[["title"]]=="이름"){
              index_terms_name_res <- html_text(index_terms[q])
              index_terms_name <- c(index_terms_name,index_terms_name_res)
            }
            else if(xml_attrs(index_terms[[q]])[["title"]]=="지명"){
              index_terms_place_res <- html_text(index_terms[q])
              index_terms_place <- c(index_terms_place,index_terms_place_res)
            }
            else if(xml_attrs(index_terms[[q]])[["title"]]=="단체"){
              index_terms_group_res <- html_text(index_terms[q])
              index_terms_group <- c(index_terms_group,index_terms_group_res)
            }
            else if(xml_attrs(index_terms[[q]])[["title"]]=="기타"){
              index_terms_etc_res <- html_text(index_terms[q])
              index_terms_etc <- c(index_terms_etc,index_terms_etc_res)
            }
            else if(xml_attrs(index_terms[[q]])[["title"]]=="관서"){
              index_terms_office_res <- html_text(index_terms[q])
              index_terms_office <- c(index_terms_office,index_terms_office_res)
            }
            else{
              print('범위 밖 색인어 종류')
            }
          }
          
          #하나의 string으로 변환
          index_terms_name <- gsub("^\\,","",paste(index_terms_name, collapse = ','))
          index_terms_place <- gsub("^\\,","",paste(index_terms_place, collapse = ',')) 
          index_terms_group <- gsub("^\\,","",paste(index_terms_group, collapse = ','))
          index_terms_office <- gsub("^\\,","",paste(index_terms_office, collapse = ','))
          index_terms_etc <- gsub("^\\,","",paste(index_terms_etc, collapse = ','))
        }
      }  
      
      #색인어가 없을 때
      if(length(index_terms)==0){
        index_terms_name <- ""
        index_terms_place <- ""
        index_terms_group <- ""
        index_terms_office <- ""
        index_terms_etc <- ""
      }
      
      #merge
      master_res <- cbind(title_res,본문=contents_text,색인어_전부=index_terms_all,
                          색인어_이름=index_terms_name, 색인어_지명=index_terms_place,
                          색인어_단체=index_terms_group, 색인어_기타=index_terms_etc,
                          url=contents_url)
      # master <- rbindlist(list(master,master_res))
      # master2 <- rbindlist(list(master2,master_res))
      master3 <- rbindlist(list(master3,master_res))
    }
  }
if(i==95&&j==50&&r==50){
  cat("index:",i," ",str_split(title_text[1]," ",simplify = T)[1],"끝, 수집종료","\n")
 }
}


####Save####
#master <- unique(master)
# master2 <- unique(master2)
## master_1910_V2 <- master3
master3 <- unique(master3)
save.image(file=".RData")


#잡지명 확인
# unique(master$잡지명)
# unique(master2$잡지명)
unique(master3$잡지명)

#잡지종류 컬럼 추가
# master[,잡지종류:=tstrsplit(잡지명," ")[1]]
# master2[,잡지종류:=tstrsplit(잡지명," ")[1]]
master3[,잡지종류:=tstrsplit(잡지명," ")[1]]

#column order
# setcolorder(master,c("잡지종류","잡지명","발행일","기사제목","필자","기사형태","본문","색인어"))
# setcolorder(master2,c("잡지종류","잡지명","발행일","기사제목","필자","기사형태","본문","색인어"))
setcolorder(master3,c("잡지종류","잡지명","발행일","기사제목","필자","기사형태","본문","색인어_전부","색인어_이름","색인어_지명"
                      ,"색인어_단체","색인어_기타","url"))

#### export ####
# fwrite(master,"master.csv",quote = T)
# fwrite(master2,"master2.csv",quote=T)
fwrite(master3,"master3.csv",quote=T)
