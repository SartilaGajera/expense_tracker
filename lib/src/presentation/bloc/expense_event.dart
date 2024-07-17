part of 'expense_bloc.dart';

abstract class ExpenseEvent {}

class LoadExpensesEvent extends ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  final Expense expense;

  AddExpenseEvent({required this.expense});
}

class EditExpenseEvent extends ExpenseEvent {
  final Expense expense;

  EditExpenseEvent({required this.expense});
}

class DeleteExpenseEvent extends ExpenseEvent {
  final int key;

  DeleteExpenseEvent({required this.key});
}

class FilterExpensesByDateEvent extends ExpenseEvent {
  final DateTime startDate;
  final DateTime endDate;

  FilterExpensesByDateEvent({required this.startDate, required this.endDate});
}
class FilterExpensesByMonthEvent extends ExpenseEvent {
  final int month;
  final int year;

  FilterExpensesByMonthEvent({required this.month, required this.year});
}