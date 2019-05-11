#####�ѱ������������ڷ� ���� ����####
###http://db.history.go.kr/item/level.do?itemId=ma###
#�����ڰ�ȸ����#
#������ȸȸ��#
#����#
#������ȸ����#

setwd("C:/Google ����̺�/�ٴ� ���� �������ι��� ����/data_crawling")

save.image(file=".RData")

####packages load####
library(data.table)
library(rvest)
library(dplyr)
library(stringr)
#library(readxl)


####URL####
# http://db.history.go.kr/item/level.do?sort=levelId&dir=ASC&start=1&limit=20&page=1&pre_page=1&setId=-1&prevPage=0&prevLimit=&itemId=ma&types=&synonym=off&chinessChar=on&brokerPagingInfo=&levelId=ma_001&position=-1 ##�����ڰ�ȸ���� ����

# contents_url <- "http://db.history.go.kr/item/level.do?sort=levelId&dir=ASC&start=1&limit=20&page=1&pre_page=1&setId=-1&prevPage=0&prevLimit=&itemId=ma&types=&synonym=off&chinessChar=on&brokerPagingInfo=&levelId=ma_001_0020_0040&position=-1"
# contents_url <- "http://db.history.go.kr/item/level.do?sort=levelId&dir=ASC&start=1&limit=20&page=1&pre_page=1&setId=-1&prevPage=0&prevLimit=&itemId=ma&types=&synonym=off&chinessChar=on&brokerPagingInfo=&levelId=ma_002_0090_0370&position=-1"

contents_url <- "http://db.history.go.kr/item/level.do?sort=levelId&dir=ASC&start=1&limit=20&page=1&pre_page=1&setId=-1&prevPage=0&prevLimit=&itemId=ma&types=&synonym=off&chinessChar=on&brokerPagingInfo=&levelId=ma_001_0010_0010&position=-1"
  
####Parsing####
html_contents <- read_html(contents_url,encoding = 'UTF-8')
html_contents %>% html_nodes(".cont_view")

###�����÷� ����###
## ������, ������, �������, ����, �������, ����, ���ξ�(nested) ##
##���� ���̺�##
#�÷���#
html_contents %>% 
  html_nodes(".cont_view") %>%
    html_nodes(".dl_data_pru tbody tr")
#���� - ����#
title_text <- html_contents %>% 
  html_nodes(".cont_view") %>%
    html_nodes(".dl_data_pru tbody tr td") %>%
      html_text(trim = T) %>%
        data.table()


nrow(title_text)

##���� ���̺�##
#����#
contents <- html_contents %>% 
  html_nodes(".cont_view") %>%
    html_nodes(xpath = '//*[@id="cont_view"]')
  
contents_text <- html_contents %>% 
  html_nodes(".cont_view") %>%
    html_nodes(xpath = '//*[@id="cont_view"]') %>%
      html_text(trim = T)


##���ξ� ���̺�##
#���ξ� ����#
index <- html_contents %>% 
  html_nodes(".cont_side") %>%
    html_nodes(xpath = '//*[@id="container"]/div[4]/div/div/b')

#���ξ� ��ü �ܾ#
index_terms <- html_contents %>% 
  html_nodes(".cont_side") %>%
    html_nodes(xpath = '//*[@id="container"]/div[4]/div/div/a/span') %>%
      html_text()

#���ξ� ������ �ܾ#
index_by_terms <- html_contents %>% 
  html_nodes(".cont_side") %>%
    html_nodes(xpath = '//*[@id="container"]/div[4]/div/div/a/span')


html_attr(index_by_terms,'title')
unique(html_attr(index_by_terms,'title')) #���ξ� ����
index_type <- unique(html_attr(index_by_terms,'title')) #���ξ� ����
#html_nodes(index_by_terms,css ='[@title==�̸�]')
terms_table <- data.table()
for(i in 1:length(index_by_terms)){
  for(j in 1:length(unique(html_attr(index_by_terms,'title')))){
    if(xml_attrs(index_by_terms[[i]])["title"]==index_type[j]){
    }
  }
  #terms_table[,index_type[j]:=res]
}

####Merge####
# ma_001~004 : ���� ����
# ma_001~095 : ��ü
## �Ķ���� ���� ##
# ma_001_0020_0040
# 00*1 : ���� (1�� ����)
# 00*10 : ��ȣ (10�� ����)
# 00*10 : ����ȣ(10�� ����)
###�����ڰ�ȸ###
# i, j ,r
book_index <- str_pad(seq(1,95,1),3,"left","0") # ����
vol_index <- str_pad(seq(10,500,10),4,"left","0") #��ȣ
article_index <- str_pad(seq(10,500,10),4,"left","0") #����ȣ

# contents_url <- paste0("http://db.history.go.kr/item/level.do?sort=levelId&dir=ASC&start=1&limit=100&page=1&pre_page=1&setId=-1&prevPage=0&prevLimit=&itemId=ma&types=&synonym=off&chinessChar=on&brokerPagingInfo=&levelId=ma_",book_index[1],"_",vol_index[1],"_",article_index[1],"&position=-1")

##�������� <br> ��ũ \n���� ��ȯ
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


#### ������ ���� ####
# master <- data.table()
# master2 <- data.table()
master3 <- data.table()
master_res <- data.table()

###For loop###
for(i in 1:95){ #�����ڰ�ȸ����, ������ȸȸ��, ����, ������ȸ����(1~4),1910s: 1~12&48, last 95
  for(j in 1:50){
    if(j==1&&i>1){
      cat("index:",i-1," ",str_split(title_text[1]," ",simplify = T)[1],"��, ���� ���� ����","\n")
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
        title_res <- data.table(������=title_text[1], ������=title_text[2],
                                �������=title_text[3], ����=title_text[4],
                                �������=title_text[5])
      }else{
        title_res <- data.table(������=title_text[1], ������=title_text[2],
                                �������=title_text[3], ����="",
                                �������=title_text[4])
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
      
      index_terms_all <- paste(html_text(index_terms), collapse = ',') #�ϳ��� string���� ��ȯ
      
      ##���ξ� ������ ����
      index_terms_name <- c()
      index_terms_place <- c()
      index_terms_group <- c()
      index_terms_office <- c()
      index_terms_etc <- c()
      
      #���ξ� ���� : �̸�, ����, ��ü, ����, ��Ÿ
      if(length(index_terms)!=0){
        for(q in 1:length(index_terms)){
          {
            if(xml_attrs(index_terms[[q]])[["title"]]=="�̸�"){
              index_terms_name_res <- html_text(index_terms[q])
              index_terms_name <- c(index_terms_name,index_terms_name_res)
            }
            else if(xml_attrs(index_terms[[q]])[["title"]]=="����"){
              index_terms_place_res <- html_text(index_terms[q])
              index_terms_place <- c(index_terms_place,index_terms_place_res)
            }
            else if(xml_attrs(index_terms[[q]])[["title"]]=="��ü"){
              index_terms_group_res <- html_text(index_terms[q])
              index_terms_group <- c(index_terms_group,index_terms_group_res)
            }
            else if(xml_attrs(index_terms[[q]])[["title"]]=="��Ÿ"){
              index_terms_etc_res <- html_text(index_terms[q])
              index_terms_etc <- c(index_terms_etc,index_terms_etc_res)
            }
            else if(xml_attrs(index_terms[[q]])[["title"]]=="����"){
              index_terms_office_res <- html_text(index_terms[q])
              index_terms_office <- c(index_terms_office,index_terms_office_res)
            }
            else{
              print('���� �� ���ξ� ����')
            }
          }
          
          #�ϳ��� string���� ��ȯ
          index_terms_name <- gsub("^\\,","",paste(index_terms_name, collapse = ','))
          index_terms_place <- gsub("^\\,","",paste(index_terms_place, collapse = ',')) 
          index_terms_group <- gsub("^\\,","",paste(index_terms_group, collapse = ','))
          index_terms_office <- gsub("^\\,","",paste(index_terms_office, collapse = ','))
          index_terms_etc <- gsub("^\\,","",paste(index_terms_etc, collapse = ','))
        }
      }  
      
      #���ξ ���� ��
      if(length(index_terms)==0){
        index_terms_name <- ""
        index_terms_place <- ""
        index_terms_group <- ""
        index_terms_office <- ""
        index_terms_etc <- ""
      }
      
      #merge
      master_res <- cbind(title_res,����=contents_text,���ξ�_����=index_terms_all,
                          ���ξ�_�̸�=index_terms_name, ���ξ�_����=index_terms_place,
                          ���ξ�_��ü=index_terms_group, ���ξ�_��Ÿ=index_terms_etc,
                          url=contents_url)
      # master <- rbindlist(list(master,master_res))
      # master2 <- rbindlist(list(master2,master_res))
      master3 <- rbindlist(list(master3,master_res))
    }
  }
if(i==95&&j==50&&r==50){
  cat("index:",i," ",str_split(title_text[1]," ",simplify = T)[1],"��, ��������","\n")
 }
}


####Save####
#master <- unique(master)
# master2 <- unique(master2)
## master_1910_V2 <- master3
master3 <- unique(master3)
save.image(file=".RData")


#������ Ȯ��
# unique(master$������)
# unique(master2$������)
unique(master3$������)

#�������� �÷� �߰�
# master[,��������:=tstrsplit(������," ")[1]]
# master2[,��������:=tstrsplit(������," ")[1]]
master3[,��������:=tstrsplit(������," ")[1]]

#column order
# setcolorder(master,c("��������","������","������","�������","����","�������","����","���ξ�"))
# setcolorder(master2,c("��������","������","������","�������","����","�������","����","���ξ�"))
setcolorder(master3,c("��������","������","������","�������","����","�������","����","���ξ�_����","���ξ�_�̸�","���ξ�_����"
                      ,"���ξ�_��ü","���ξ�_��Ÿ","url"))

#### export ####
# fwrite(master,"master.csv",quote = T)
# fwrite(master2,"master2.csv",quote=T)
fwrite(master3,"master3.csv",quote=T)