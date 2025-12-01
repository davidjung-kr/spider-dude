module spider.common.enums.calendar;

import std.datetime: Date;

immutable bool[Date] HOLIDAY_KR_YN = [
    Date(2015,  1,  1):true, // 신정
    Date(2015,  2, 18):true, // 설날
    Date(2015,  2, 19):true, // 설날
    Date(2015,  2, 20):true, // 설날
    Date(2015,  3,  1):true, // 삼일절
    Date(2015,  5,  5):true, // 어린이날
    Date(2015,  5, 25):true, // 부처님오신날
    Date(2015,  6,  6):true, // 현충일
    Date(2015,  8, 14):true, // 임시공휴일
    Date(2015,  8, 15):true, // 광복절
    Date(2015,  9, 26):true, // 추석
    Date(2015,  9, 27):true, // 추석
    Date(2015,  9, 28):true, // 추석
    Date(2015,  9, 29):true, // 추석대체공휴)
    Date(2015, 10,  3):true, // 개천절
    Date(2015, 10,  9):true, // 한글날
    Date(2015, 12, 25):true, // 크리스마스

    Date(2016,  1,  1):true, // 신정
    Date(2016,  2,  7):true, // 설날
    Date(2016,  2,  8):true, // 설날
    Date(2016,  2,  9):true, // 설날
    Date(2016,  2, 10):true, // 설날 대체공휴일
    Date(2016,  3,  1):true, // 삼일절
    Date(2016,  4, 13):true, // 제20대 국회의원 선거
    Date(2016,  5,  5):true, // 어린이날
    Date(2016,  5,  6):true, // 임시공휴일
    Date(2016,  5, 14):true, // 석가탄신일
    Date(2016,  6,  6):true, // 현충일
    Date(2016,  8, 15):true, // 광복절
    Date(2016,  9, 14):true, // 추석
    Date(2016,  9, 15):true, // 추석
    Date(2016,  9, 16):true, // 추석
    Date(2016, 10,  3):true, // 개천절
    Date(2016, 10,  9):true, // 한글날
    Date(2016, 12, 25):true, // 크리스마스

    Date(2017,  1,  1):true, // 신정
    Date(2017,  1, 27):true, // 설날
    Date(2017,  1, 28):true, // 설날
    Date(2017,  1, 29):true, // 설날
    Date(2017,  1, 30):true, // 설날 대체공휴일
    Date(2017,  3,  1):true, // 삼일절
    Date(2017,  5,  3):true, // 석가탄신일
    Date(2017,  5,  5):true, // 어린이날
    Date(2017,  5,  9):true, // 임시공휴일 - 제19대 대통령 선거
    Date(2017,  6,  6):true, // 현충일
    Date(2017,  8, 15):true, // 광복절
    Date(2017, 10,  2):true, // 임시공휴일
    Date(2017, 10,  3):true, // 개천절
    Date(2017, 10,  4):true, // 추석
    Date(2017, 10,  5):true, // 추석
    Date(2017, 10,  6):true, // 추석
    Date(2017, 10,  9):true, // 한글날
    Date(2017, 12, 25):true, // 크리스마스

    Date(2018,  1,  1):true, // 신정
    Date(2018,  2, 15):true, // 설날
    Date(2018,  2, 16):true, // 설날
    Date(2018,  2, 17):true, // 설날
    Date(2018,  3,  1):true, // 삼일절
    Date(2018,  5,  5):true, // 어린이날
    Date(2018,  5,  7):true, // 어린이날 대체공휴일
    Date(2018,  5, 22):true, // 석가탄신일
    Date(2018,  6,  6):true, // 현충일
    Date(2018,  6, 13):true, // 제7회 전국동시 지방선거
    Date(2018,  8, 15):true, // 광복절
    Date(2018,  9, 23):true, // 추석
    Date(2018,  9, 24):true, // 추석
    Date(2018,  9, 25):true, // 추석
    Date(2018,  9, 26):true, // 추석 대체공휴일
    Date(2018, 10,  3):true, // 개천절
    Date(2018, 10,  9):true, // 한글날
    Date(2018, 12, 25):true, // 크리스마스

    Date(2019,  1,  1):true, // 신정
    Date(2019,  2,  4):true, // 설날
    Date(2019,  2,  5):true, // 설날
    Date(2019,  2,  6):true, // 설날
    Date(2019,  3,  1):true, // 삼일절
    Date(2019,  5,  5):true, // 어린이날
    Date(2019,  5,  6):true, // 어린이날 대체공휴일
    Date(2019,  5, 12):true, // 석가탄신일
    Date(2019,  6,  6):true, // 현충일
    Date(2019,  8, 15):true, // 광복절
    Date(2019,  9, 12):true, // 추석
    Date(2019,  9, 13):true, // 추석
    Date(2019,  9, 14):true, // 추석
    Date(2019, 10,  3):true, // 개천절
    Date(2019, 10,  9):true, // 한글날
    Date(2019, 12, 25):true, // 크리스마스

    Date(2020,  1,  1):true, // 신정
    Date(2020,  1, 24):true, // 설날
    Date(2020,  1, 25):true, // 설날
    Date(2020,  1, 26):true, // 설날
    Date(2020,  1, 27):true, // 설날 대체공휴일
    Date(2020,  3,  1):true, // 삼일절
    Date(2020,  4, 15):true, // 제21대 국회의원 선거
    Date(2020,  4, 30):true, // 석가탄신일
    Date(2020,  5,  5):true, // 어린이날
    Date(2020,  6,  6):true, // 현충일
    Date(2020,  8, 15):true, // 광복절
    Date(2020,  8, 17):true, // 임시공휴일
    Date(2020,  9, 30):true, // 추석
    Date(2020, 10,  1):true, // 추석
    Date(2020, 10,  2):true, // 추석
    Date(2020, 10,  3):true, // 개천절
    Date(2020, 10,  9):true, // 한글날
    Date(2020, 12, 25):true, // 크리스마스

    Date(2021,  1,  1):true, // 신정
    Date(2021,  2, 11):true, // 설날
    Date(2021,  2, 12):true, // 설날
    Date(2021,  2, 13):true, // 설날
    Date(2021,  3,  1):true, // 삼일절
    Date(2021,  5,  5):true, // 어린이날
    Date(2021,  5, 19):true, // 석가탄신일
    Date(2021,  6,  6):true, // 현충일
    Date(2021,  8, 15):true, // 광복절
    Date(2021,  8, 16):true, // 광복절 대체공휴일
    Date(2021,  9, 20):true, // 추석
    Date(2021,  9, 21):true, // 추석
    Date(2021,  9, 22):true, // 추석
    Date(2021, 10,  3):true, // 개천절
    Date(2021, 10,  4):true, // 개천절 대체공휴일
    Date(2021, 10,  9):true, // 한글날
    Date(2021, 10, 11):true, // 한글날 대체공휴일
    Date(2021, 12, 25):true, // 크리스마스

    Date(2022,  1,  1):true, // 신정
    Date(2022,  1, 31):true, // 설날
    Date(2022,  2,  1):true, // 설날
    Date(2022,  2,  2):true, // 설날
    Date(2022,  3,  1):true, // 삼일절
    Date(2022,  3,  9):true, // 제20대 대통령 선거
    Date(2022,  5,  5):true, // 어린이날
    Date(2022,  5,  8):true, // 석가탄신일
    Date(2022,  6,  1):true, // 제8회 전국동시 지방선거
    Date(2022,  6,  6):true, // 현충일
    Date(2022,  8, 15):true, // 광복절
    Date(2022,  9,  9):true, // 추석
    Date(2022,  9, 10):true, // 추석
    Date(2022,  9, 11):true, // 추석
    Date(2022,  9, 12):true, // 추석 대체공휴일
    Date(2022, 10,  3):true, // 개천절
    Date(2022, 10,  9):true, // 한글날
    Date(2022, 10, 10):true, // 한글날 대체공휴일
    Date(2022, 12, 25):true, // 크리스마스

    Date(2023,  1,  1):true, // 신정
    Date(2023,  1, 21):true, // 설날
    Date(2023,  1, 22):true, // 설날
    Date(2023,  1, 23):true, // 설날
    Date(2023,  1, 24):true, // 설날 대체공휴일
    Date(2023,  3,  1):true, // 삼일절
    Date(2023,  5,  5):true, // 어린이날
    Date(2023,  5, 27):true, // 석가탄신일
    Date(2023,  5, 29):true, // 부처님오신날 대체공휴일
    Date(2023,  6,  6):true, // 현충일
    Date(2023,  8, 15):true, // 광복절
    Date(2023,  9, 28):true, // 추석
    Date(2023,  9, 29):true, // 추석
    Date(2023,  9, 30):true, // 추석
    Date(2023, 10,  2):true, // 임시공휴일
    Date(2023, 10,  3):true, // 개천절
    Date(2023, 10,  9):true, // 한글날
    Date(2023, 12, 25):true, // 크리스마스

    Date(2024,  1,  1):true, // 신정
    Date(2024,  2,  9):true, // 설날
    Date(2024,  2, 10):true, // 설날
    Date(2024,  2, 11):true, // 설날
    Date(2024,  2, 12):true, // 설날 대체공휴일
    Date(2024,  3,  1):true, // 삼일절
    Date(2024,  4, 10):true, // 제22대 국회의원 선거
    Date(2024,  5,  5):true, // 어린이날
    Date(2024,  5,  6):true, // 어린이날 대체공휴일
    Date(2024,  5, 15):true, // 석가탄신일
    Date(2024,  6,  6):true, // 현충일
    Date(2024,  8, 15):true, // 광복절
    Date(2024,  9, 16):true, // 추석
    Date(2024,  9, 17):true, // 추석
    Date(2024,  9, 18):true, // 추석
    Date(2024, 10,  3):true, // 개천절
    Date(2024, 10,  9):true, // 한글날
    Date(2024, 12, 25):true, // 크리스마스

    Date(2025,  1,  1):true, // 신정
    Date(2025,  1, 28):true, // 설날
    Date(2025,  1, 29):true, // 설날
    Date(2025,  1, 30):true, // 설날
    Date(2025,  3,  1):true, // 삼일절
    Date(2025,  3,  3):true, // 삼일절 대체공휴일
    Date(2025,  4, 24):true, // 석가탄신일
    Date(2025,  5,  5):true, // 어린이날
    Date(2025,  6,  6):true, // 현충일
    Date(2025,  8, 15):true, // 광복절
    Date(2025, 10,  5):true, // 추석
    Date(2025, 10,  6):true, // 추석
    Date(2025, 10,  7):true, // 추석
    Date(2025, 10,  3):true, // 개천절
    Date(2025, 10,  9):true, // 한글날
    Date(2025, 12, 25):true, // 크리스마
];

/// 연도별 마지막 영업일
enum LastBusinessDay {
    Y2015 = Date(2015, 12, 30),
    Y2016 = Date(2016, 12, 29),
    Y2017 = Date(2017, 12, 27),
    Y2018 = Date(2018, 12, 28),
    Y2019 = Date(2019, 12, 30),
    Y2020 = Date(2020, 12, 30),
    Y2021 = Date(2021, 12, 30),
    Y2022 = Date(2022, 12, 29),
    Y2023 = Date(2023, 12, 28),
    Y2024 = Date(2024, 12, 30),
    Y2025 = Date(2025, 12, 30),
    Y2026 = Date(2026, 12, 30),
    Y2027 = Date(2027, 12, 30),
    Y2028 = Date(2028, 12, 29),
    Y2029 = Date(2029, 12, 31),
    Y2030 = Date(2030, 12, 30),
    Y2031 = Date(2031, 12, 30),
    Y2032 = Date(2032, 12, 30),
    Y2033 = Date(2033, 12, 30),
    Y2034 = Date(2034, 12, 29),
    Y2035 = Date(2035, 12, 31),
    Y2036 = Date(2036, 12, 30),
    Y2037 = Date(2037, 12, 30),
    Y2038 = Date(2038, 12, 30),
    Y2039 = Date(2039, 12, 30),
    Y2040 = Date(2040, 12, 28),
    Y2041 = Date(2041, 12, 30),
    Y2042 = Date(2042, 12, 30),
    Y2043 = Date(2043, 12, 30),
    Y2044 = Date(2044, 12, 30),
    Y2045 = Date(2045, 12, 29),
    Y2046 = Date(2046, 12, 31),
    Y2047 = Date(2047, 12, 30),
    Y2048 = Date(2048, 12, 30),
    Y2049 = Date(2049, 12, 30),
    Y2050 = Date(2050, 12, 30),
}