import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_task_flow/repositories/task_repository.dart';
import 'package:user_task_flow/services/connectivity_service.dart';
import 'package:user_task_flow/services/task_service.dart';
import 'package:user_task_flow/view_models/task/task_bloc.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../view_models/auth/auth_bloc.dart';
import '../view_models/user/user_bloc.dart';

import 'app/routes.dart';
import 'data/local/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthRepository(AuthServices())),
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(UserRepository(UserServices())),
        ),
        BlocProvider<TaskBloc>(
          create: (_) => TaskBloc(
            TaskRepository(
              database: AppDatabase(),
              apiService: TaskApiService(),
              connectivityService: ConnectivityService(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: GoogleFonts.plusJakartaSans().fontFamily),
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
