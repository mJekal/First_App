## Introduction

처음으로 개발에 도전해서 만들어본 어플 '작심 며칠?'입니다. 
추후 리팩토링을 하거나 Kotlin으로 기능을 더 추가하여 다시 개발해볼 생각입니다.

## 작심 며칠?

작심 며칠?은 사용자가 설정한 목표와 함께 해당 목표를 이루기 위한 다짐을 기록하고 목표를 설정한지 며칠이 지났는 지 알려주는 D-day 애플리케이션입니다. 
Flutter와 Firebase를 사용하여 개발했습니다.

## 파일 구조

lib/  
|-- assets/  
| |-- Logo.png  
| |-- playstore.png  
|-- configs/  
| |-- color_styles.dart  
| |-- text_style.dart  
|-- model/  
| |-- authentication.dart  
| |-- information.dart  
| |-- login.dart  
| |-- register.dart  
|-- provider/  
| |-- information_default.dart  
|-- screen/  
| |-- information_screen.dart  
| |-- login_screen.dart  
| |-- main_screen.dart  
| |-- profile_screen.dart  
| |-- register_screen.dart  
| |-- splash_screen.dart  
|-- firebase_options.dart  
|-- main.dart  

- **config/**: 색상 및 텍스트 스타일과 관련된 구성 요소를 포함하는 폴더입니다.
- **model/**: 애플리케이션의 데이터 모델 및 인증과 관련된 클래스를 포함하는 폴더입니다.
- **provider/**: Provider 패턴을 구현하는 데 사용되는 클래스를 포함하는 폴더입니다.
- **screen/**: 앱의 각 화면 위젯 파일을 포함하는 폴더입니다.
- **firebase_options.dart**: Firebase 프로젝트의 구성 옵션을 포함하는 파일입니다.
- **main.dart**: MaterialApp을 초기화하고 라우트를 설정하는 파일입니다.

## 주요 기능

### 1. 로그인 및 회원가입

- 사용자는 이메일과 비밀번호를 사용하여 로그인하거나 새 계정을 등록할 수 있습니다.
- Firebase Authentication을 사용하여 사용자 인증을 처리합니다.

### 2. 목표 및 다짐 작성

- 사용자는 목표를 설정하고 해당 목표를 이루기 위한 다짐을 작성할 수 있습니다.
- Firebase Firestore를 사용하여 목표와 다짐을 저장하고 관리합니다.

### 3. 다양한 화면 및 네비게이션

- 애플리케이션은 스플래시 화면, 로그인 화면, 회원가입 화면, 프로필 화면 및 메인 화면을 제공합니다.
- BottomNavigationBar(하단바)를 사용하여 화면전환을 할 수 있습니다.

## 사용된 라이브러리

- **Flutter**
- **Firebase**
- **Provider**: Flutter의 상태 관리 라이브러리
