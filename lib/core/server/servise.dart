bool testMode = false;

class ApiService {
  ApiService._();
  static String url = 'https://api.sheep.market';
  static String domain =
      testMode
          ? "https://api.sheep.market/api/"
          : "https://api.sheep.market/api/";
  static String login = "Auth/Login";
  static String signup = "Auth/Register";
  static String logout = "Auth/Logout";
  static String vOtp = "Auth/VerifyOtp";
  static String resendCode = "Auth/ResendOtp";
  static String auctions = "Auctions/GetAuctions";
  static String auctionsDetails = "Auctions/GetById";
  static String placeBid = "Auctions/PlaceBid";
  static String allShops = "Users/GetSellers";
  static String products = "Products/GetProducts";
  static String addProduct = "Products/Create";
  static String addAuction = "Auctions/Create";
  static String updateProduct = "Products/Update";
  static String sellerDetails = "Users/GetMyDetails";
  static String myProduct = "Products/GetMyProducts";
  static String deleteProduct = "Products/Delete";
  static String detailsProduct = "Products/GetProductById";
  static String category = "Categories/GetAll";
  static String breeds = "Breeds/GetAll";
  static String conversation = "Chat/GetConversations";
  static String myAuction = "Auctions/GetMyAuctions";
  static String startLive = "LiveStreams/Start";
  static String endLive = "LiveStreams/End";
  static String getToken = "LiveStreams/GetToken";
  static String getLives = "LiveStreams/GetLives";
  static String startChat = "Chat/Start";
  static String sendMessage = "Chat/Send";
  static String getMessages = "Chat/GetMessages";



 
  


  
}
