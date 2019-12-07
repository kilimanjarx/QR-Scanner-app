# QR Scanner 

A simple QR scanning app I developed during my internship

## Getting Started

Dependencies:
- https://pub.dev/packages/flutter_barcode_scanner
- https://pub.dev/packages/fluttertoast

## Screenshots

<img src="https://user-images.githubusercontent.com/24710567/70369516-bd49b580-18f5-11ea-9589-481696b33aa6.jpeg"  width="200" height="400" /> <img src="https://user-images.githubusercontent.com/24710567/70369517-be7ae280-18f5-11ea-8151-1c9faf1edc2a.jpeg"  width="200" height="400" />

Login mechanism: 
1. Get token from server
2. Store the token in sharedPreferences
3. If token available; stay in homepage else kick user to login page

Scanning mechanism:
1. Scan Qr and if valid then redirect to next page else kick user to homepage and display error message.




