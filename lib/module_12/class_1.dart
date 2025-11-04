import 'package:expensetracker/module_12/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final List<String> catergories = ['food', 'Transport', 'Enter', 'Bills'];
  final List<Expense> _expense = [];
  double total = 0.0;
  void _showFrom(BuildContext context) {
    String selectedCarergory = catergories.first;
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    DateTime expenseDateTime = DateTime.now();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                items: catergories
                    .map(
                      (catergory) => DropdownMenuItem(
                        value: catergory,
                        child: Text(catergory),
                      ),
                    )
                    .toList(),
                onChanged: (value) => selectedCarergory = value!,
                decoration: InputDecoration(labelText: 'Select any one'),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      if (titleController.text.isNotEmpty ||
                          double.tryParse(amountController.text) != null) {
                        _adExpense(
                          titleController.text,
                          double.parse(amountController.text),
                          expenseDateTime,
                          selectedCarergory,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Add Expense',
                      style: TextStyle(color: Colors.white,fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _adExpense(
    String title,
    double amount,
    DateTime date,
    String catergory,
  ) {
    setState(() {
      _expense.add(
        Expense(title: title, amount: amount, date: date, catergory: catergory),
      );
      total += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        title: Text('Expense Tracker',
            style: TextStyle(
                color: Colors.white,
            )),
        actions: [
          IconButton(
            onPressed: () => _showFrom(context),
            icon: Icon(Icons.add),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Card(
              color: Colors.blue,
              margin: EdgeInsets.all(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 80,
                  right: 80,
                  bottom: 40,
                  top: 40,
                ),
                child: Text(
                  'Total :৳$total',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expense.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          _expense[index].catergory,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10, // smaller text fits nicely
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      title: Text(_expense[index].title),
                      subtitle: Text(
                        DateFormat.yMMMd().format(_expense[index].date)
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
