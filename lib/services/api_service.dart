class ApiService {


  static const String baseUrl = 'https://dev-packwork.pazl.info/api';

  static const login="${baseUrl}/user/employee/login";

  static const forgotPassword="${baseUrl}/common-service/forgot-password";


  static const String StaticToken="4b3e77f648e5b9055a45f0812b3a4c3b88b08ff10b2f34ec21d11b6f678b6876a4014c88ff2a3c7e8e934c4f4790a94d3acb28d2f78a9b90f18960feaf3e4f99";


  
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    "x-api-key":StaticToken
  };
}