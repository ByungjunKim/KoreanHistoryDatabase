# 한국사데이터베이스 스크래핑
한국근현대잡지자료(https://db.history.go.kr/item/level.do?itemId=ma) 스크래핑 가능

### 파일 설명
* KoreanHistoryDatabase_Scrap.ipynb : 파이썬을 활용한 스크래핑
* KoreanHistoryDatabase_Crawling.R : R을 활용한 스크래핑(현재 작동 보장못함, 예전코드)
* 240214_한국근현대잡지자료.pkl : 스크래핑 완료한 파이썬 pickle 객체 파일. pandas의 read_pickle 함수로 읽기 가능(python3.11에서 저장)
* 240214_한국근현대잡지자료_단락.xlsx : 위 pickle 파일에서 paragraphs 컬럼에 리스트로 담긴 단락을 각 행으로 분할한 엑셀 파일

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
