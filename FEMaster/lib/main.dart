import 'package:rtmp_publisher/camera.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/barcode_scanner_screen.dart';
import 'package:food_app/screens/SignInDemo.dart';
import 'package:food_app/screens/about_screen.dart';
import 'package:food_app/screens/account_screen.dart';
import 'package:food_app/screens/allergy_screen.dart';
import 'package:food_app/screens/rtmp_sender_screen.dart';
import 'package:food_app/screens/cast_screen.dart';
import 'package:food_app/screens/chat_screen.dart';
import 'package:food_app/screens/contact_page_screen.dart';
import 'package:food_app/screens/create_channel_screen.dart';
import 'package:food_app/screens/create_recipe2_screen.dart';
import 'package:food_app/screens/create_recipe3_screen.dart';
import 'package:food_app/screens/create_recipe4_screen.dart';
import 'package:food_app/screens/create_recipe5_screen.dart';
import 'package:food_app/screens/create_recipe_screen.dart';
import 'package:food_app/screens/diet_screen.dart';
import 'package:food_app/screens/event_details_screen.dart';
import 'package:food_app/screens/explore_details_screen.dart';
import 'package:food_app/screens/explore_screen.dart';
import 'package:food_app/screens/forgot_password_screen.dart';
import 'package:food_app/screens/grocery_type_Screen.dart';
import 'package:food_app/screens/health_profile_screen.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:food_app/screens/join_live_streaming_page.dart';
import 'package:food_app/screens/landing_screen.dart';
import 'package:food_app/screens/live_streaming_page.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:food_app/screens/manage_streaming_page.dart';
import 'package:food_app/screens/meal_planner_screen.dart';
import 'package:food_app/screens/nutrition_details_screen.dart';
import 'package:food_app/screens/order_grocery_screen.dart';
import 'package:food_app/screens/order_history_screen.dart';
import 'package:food_app/screens/publish_story_screen.dart';
import 'package:food_app/screens/recipe_details_screen.dart';
import 'package:food_app/screens/recipe_screen.dart';
import 'package:food_app/screens/register_screen.dart';
import 'package:food_app/screens/registration_screen.dart';
import 'package:food_app/screens/rtmp_receiver_screen.dart';
import 'package:food_app/screens/shopping_list_screen.dart';
import 'package:food_app/screens/show_live_vide_screen.dart';
import 'package:food_app/screens/skill_screen.dart';
import 'package:food_app/screens/stripe_payment_screen.dart';
import 'package:food_app/screens/welcome_screen.dart';
import 'package:food_app/screens/your_recipe_screen.dart';
import 'package:food_app/screens/fitbit_screen.dart';
import 'package:food_app/utils/constants.dart';


Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    int frontIndex=0;
    int backIndex=0;
    for (CameraDescription cameraDescription in cameras) {
      //print(cameraDescription.sensorOrientation.bitLength);
      if(cameraDescription.lensDirection == CameraLensDirection.back){
        if(frontIndex==0){
          cameraDescriptions.add(cameraDescription);
        }
        frontIndex++;
      }
      if(cameraDescription.lensDirection == CameraLensDirection.front){
        if(backIndex==0){
          cameraDescriptions.add(cameraDescription);
        }
        backIndex++;
      }
    }

    print(DateTime.now().timeZoneOffset.toString().split(".")[0]);

  } on CameraException catch (e) {
    //logError(e.code, e.description);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),*/
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id : (context) => HomeScreen(),
        AboutScreen.id : (context) => AboutScreen(),
        RegisterScreen.id : (context) => RegisterScreen(),
        DietScreen.id : (context) => DietScreen(),
        SkillScreen.id : (context) => SkillScreen(),
        AllergyScreen.id : (context) => AllergyScreen(),
        LandingScreen.id : (context) => LandingScreen(),
        ExploreScreen.id : (context) => ExploreScreen(),
        RecipeScreen.id : (context) => RecipeScreen(),
        ExploreDetailsScreen.id : (context) => ExploreDetailsScreen(),
        RecipeDetailsScreen.id : (context) => RecipeDetailsScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ChatScreen.id : (context) => ChatScreen(),
        ContactPageScreen.id : (context) => ContactPageScreen(),
        YourRecipeScreen.id : (context) => YourRecipeScreen(),
        AccountScreen.id : (context) => AccountScreen(),
        ForgotPasswordScreen.id : (context) => ForgotPasswordScreen(),
        CreateRecipeScreen.id  : (context) => CreateRecipeScreen(),
        CreateRecipe2Screen.id : (context) => CreateRecipe2Screen(),
        CreateRecipe3Screen.id : (context) => CreateRecipe3Screen(),
        CreateRecipe4Screen.id : (context) => CreateRecipe4Screen(),
        CreateRecipe5Screen.id : (context) => CreateRecipe5Screen(),
        ShoppingListScreen.id : (context) => ShoppingListScreen(),
        OrderGroceryPage.id : (context) => OrderGroceryPage(),
        StripePaymentScreen.id : (context) => StripePaymentScreen(),
        GroceryTypeScreen.id : (context) => GroceryTypeScreen(),
        HealthProfileScreen.id : (context) => HealthProfileScreen(),
        MealPlannerScreen.id : (context) => MealPlannerScreen(),
        NutritionDetailsScreen.id : (context) => NutritionDetailsScreen(),
        CastScreen.id : (context) => CastScreen(),
        BarCodeScanner.id : (context) => BarCodeScanner(),
        PublishStoryScreen.id : (context) => PublishStoryScreen(),
        LiveStreamingScreen.id : (context) => LiveStreamingScreen(),
        FitbitScreen.id: (context) => FitbitScreen(),
        OrderHistoryScreen.id: (context) => OrderHistoryScreen(),
        EventDetailsScreen.id : (context) => EventDetailsScreen(),
        ManageStreamingPage.id : (context) => ManageStreamingPage(),
        JoinLiveStramingPage.id : (context) => JoinLiveStramingPage(),
        RtmpReceiverScreen.id : (context) => RtmpReceiverScreen(),
        ShowLiveVideoScreen.id : (context) => ShowLiveVideoScreen(),
        SignInDemo.id : (context) => SignInDemo(),
        CreateChannelScreen.id : (context) => CreateChannelScreen(),
        RtmpSenderScreen.id : (context) => RtmpSenderScreen()
      },
    );
  }
}