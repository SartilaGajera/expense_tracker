import 'package:expense_tracker_task/src/data/models/expense_model.dart';
import 'package:expense_tracker_task/src/presentation/bloc/expense_bloc.dart';
import 'package:expense_tracker_task/src/presentation/widgets/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  final bool isEdit;
  final Expense? expense;

  const AddExpenseScreen({super.key, required this.isEdit, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _pickedDate;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  // String _category = '';

  @override
  void initState() {
    _priceController.text = widget.isEdit ? widget.expense?.amount.toString() ?? '' : '';
    _descController.text = widget.isEdit ? widget.expense?.description ?? '' : '';
    _dateController.text = widget.isEdit ? widget.expense?.date.toString() ?? '' : '';
    _pickedDate = widget.isEdit ? widget.expense?.date : DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CommonTextFormField(
                hineText: 'Amount',
                keyboardType: TextInputType.number,
                controller: _priceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CommonTextFormField(
                isReadOnly: true,
                controller: _dateController,
                hineText: 'Date',
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                suffixIcon: GestureDetector(
                  onTap: _startDatePicker,
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      height: 24,
                      width: 24,
                      child: const Icon(Icons.date_range)),
                ),
              ),
              const SizedBox(height: 10),
              CommonTextFormField(
                hineText: 'Description',
                controller: _descController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.isEdit) {
                      final updatedExpense = widget.expense
                        ?..amount = double.parse(_priceController.text)
                        ..date = _pickedDate!
                        ..description = _descController.text;
                      context.read<ExpenseBloc>().add(EditExpenseEvent(expense: updatedExpense!));
                    } else {
                      final newExpense = Expense(
                        amount: double.parse(_priceController.text),
                        date: _pickedDate!,
                        description: _descController.text,
                      );
                      context.read<ExpenseBloc>().add(AddExpenseEvent(expense: newExpense));
                    }

                    Navigator.pop(context);
                  }
                },
                child: Container(
                  key: const ValueKey('btn'),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xff1E346F)),
                  child: Center(
                      child: Text(
                    widget.isEdit ? "EDIT" : "ADD",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.parse("2020-01-01 00:00:01Z"),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      _pickedDate = value;
      _dateController.text = DateFormat.yMMMd().format(_pickedDate ?? DateTime.now());
    });
  }
}
