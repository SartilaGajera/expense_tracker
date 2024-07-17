import 'package:expense_tracker_task/src/data/models/expense_model.dart';
import 'package:expense_tracker_task/src/presentation/bloc/expense_bloc.dart';
import 'package:expense_tracker_task/src/presentation/view/expense_list_screen.dart';
import 'package:expense_tracker_task/src/utils/notification/notificaton_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  await scheduleNotification();
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter()); // Register the adapter

  await Hive.openBox<Expense>('expenses');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExpenseBloc()..add(LoadExpensesEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1E346F)),
        ),
        home: ExpenseListScreen(),
      ),
    );
  }
}

scheduleNotification() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  final tz.TZDateTime firstNotification = now.add(const Duration(seconds: 10));

  NotificationService.scheduleNotification(
    0,
    "Expense Tracker Reminder",
    "This is reminder to add expense details for track history",
    firstNotification.add(const Duration(hours: 4)),
  );
}
