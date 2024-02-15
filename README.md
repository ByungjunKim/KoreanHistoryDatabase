# 한국사데이터베이스 스크래핑
한국근현대잡지자료(https://db.history.go.kr/item/level.do?itemId=ma) 스크래핑 가능

### 파일 설명
* KoreanHistoryDatabase_Scrap.ipynb : 파이썬을 활용한 스크래핑
* KoreanHistoryDatabase_Crawling.R : R을 활용한 스크래핑(현재 작동 보장못함, 예전코드)
* 240214_한국근현대잡지자료.pkl : 스크래핑 완료한 파이썬 pickle 객체 파일(기사 39,462건). pandas의 read_pickle 함수로 읽기 가능(python3.11에서 저장)
* 240214_한국근현대잡지자료_단락.xlsx : 위 pickle 파일에서 paragraphs 컬럼에 리스트로 담긴 단락을 각 행으로 분할한 엑셀 파일 (단락 326,961건)

### 항목
'url', '잡지명', '발행일', '기사제목', '필자', '기사형태', 'paragraphs', '이름', '지명',
       '단체', '관서', '기타'
##### id
* url : 행 구분(id) 역할을 하는 url (예시 : http://db.history.go.kr/id/ma_001_0010_0030)
##### 메타 정보
각 기사별 메타 정보로 공란이 있을 수 있음
* 잡지명 : (예시) 대한자강회월보 제1호
* 발행일 : (예시) 1906년 07월 31일
* 기사제목 : (예시) 本會會報
* 필자 : (예시) 尹孝定 編纂
##### 본문
* paragraphs : 개행을 기준으로 각 단락으로 구분해 리스트 객체로 담겨있음(pickle 파일 기준)
```text
['本會會報', '尹孝定 編纂', '光武 十年 四月 二日에 大韓自强會 趣旨書 及 規則으로 發起人 尹孝定張志淵沈宜性林珍洙金相範 五氏의 聯名으로 警務廳에 報明書 提呈다.'...]
```
##### 색인
리스트 형태로 담겨 있으며 공란이 있을 수 있음
* 이름 : (예시) ['光武','尹孝定','張志淵','沈宜性','林珍洙']
* 지명 : (예시) ['漢城','園洞','典洞','桑港','桑港']
* 단체 : (예시) ['警務廳','總理','警務廳']
* 관서 : (예시) ['大韓自强會','大韓自强會']
* 기타 : (예시) ['耶蘇','白蓮庵']

### 인용
DOI 혹은 아래의 인용양식을 이용해 인용해주십시오. [![DOI](https://zenodo.org/badge/186150475.svg)](https://zenodo.org/doi/10.5281/zenodo.10660749)
##### APA
김병준. (2024). ByungjunKim/KoreanHistoryDatabase: 1.0 (1.0). Zenodo. https://doi.org/10.5281/zenodo.10660750
##### BibTex
```BibTex
@software{gimbyeongjun_2024_10660750,
  author       = {김병준},
  title        = {ByungjunKim/KoreanHistoryDatabase: 1.0},
  month        = feb,
  year         = 2024,
  publisher    = {Zenodo},
  version      = {1.0},
  doi          = {10.5281/zenodo.10660750},
  url          = {https://doi.org/10.5281/zenodo.10660750}
}
```
