# LRG - LinkedIn Resume Generation Tool

This application lets users generate PDF of Their CV. User can input data manually throug screens or They can select their LinkedIn .zip archive of their profile. After taht one can generate pdf of their CV and save it or share it how the like. There is also possiblity to create profile and send CV to datebase from wich it can be reterived later or on diffrent device.

This application works with on:
- iOS
- macOS
- Android
- Web*

*) without possiblity to load from LinkedIn archive on web.

LinkedIn archive can be requested on this website: [LinkedIn.com](https://www.linkedin.com/settings/data-export-page). It contains a lot of information, but this application is concearend only about files:
- Education.csv
- Email Addresses.csv
- Endorsement_Received_Info.csv
- Positions.csv
- Profile.csv
- Skills.csv

Possibility of saving CV to database nessesitates a need to configure datebase. I choose firebase and configured "Firestore Databes" and "Authentication". Database is configured in simple way. We have one collection "user", and each user has one collection "cv_data". In "cv_data" collection there are user's CVs in JSON format.

---
## Packages used in application
- [pdf](https://pub.dev/packages/pdf)
- [printing](https://pub.dev/packages/printing)
- [file_picker](https://pub.dev/packages/file_picker/install)
- [csv](https://pub.dev/packages/csv/install)
- [intl](https://pub.dev/packages/intl)
- [archive](https://pub.dev/packages/archive/install)
- [firebase_core](https://pub.dev/packages/firebase_core)
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- [firebase_auth](https://pub.dev/packages/firebase_auth)
- [json_serializable](https://pub.dev/packages/json_serializable)
- [firebase_database](https://pub.dev/packages/firebase_database)
- [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- [email_validator](https://pub.dev/packages/email_validator)
## Screens
* Log in screen - Where we can log in or register

* Home screen - Where we can see preview of CV

* Data field screen - Where we can edit data

* PDF generation screen - Where we can save or share generated PDF of CV

## User stories

| As a | I can | 
| --- | ---|
| User | Log in |
| User | Create CV using LinkedIn profile data |
| User | Look through fetched data and edit indivitual entries |
| User | Pick what data will be in CV and what will be omited |
| User | Turn off app without losing manually inputed and fetched data |
| User | Save CV to PDF |
| User | Upload my CV to datebase |
| User | Download my CVs from datebase |
| User | Delete my CV from datebase |
| User | Load data from .zip archive generated on LinkedIn |
| User | Use application without loggin in |
