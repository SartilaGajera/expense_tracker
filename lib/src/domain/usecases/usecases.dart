import 'package:expense_tracker_task/src/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker_task/src/data/models/expense_model.dart';

class AddExpense {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  Future<void> call(Expense expense) async {
    return repository.addExpense(expense);
  }
}

class DeleteExpense {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  Future<void> call(int id) async {
    return repository.deleteExpense(id);
  }
}

class EditExpense {
  final ExpenseRepository repository;

  EditExpense(this.repository);

  Future<void> call(Expense expense) async {
    return repository.editExpense(expense);
  }
}

class GetExpenses {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  Future<List<Expense>> call() async {
    return repository.getExpenses();
  }
}
