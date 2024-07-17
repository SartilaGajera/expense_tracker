part of 'expense_bloc.dart';

abstract class ExpenseState {}

class ExpensesLoading extends ExpenseState {}

class ExpensesLoaded extends ExpenseState {
  final List<Expense> expenses;

  ExpensesLoaded(this.expenses);
}

class ExpensesLoadFailure extends ExpenseState {
  final String error;

  ExpensesLoadFailure(this.error);
}
