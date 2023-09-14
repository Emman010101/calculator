import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = "";
  String answer = "";
  String displayExpression = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    expression.isEmpty
                        ? ''
                        : displayExpression,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            // buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                  width: value == Btn.n0
                      ? screenSize.width / 2
                      : (screenSize.width / 4),
                  height: screenSize.width / 5,
                  child: buildButton(value),
                ),
              )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        // shape: OutlineInputBorder(
        //   borderSide: const BorderSide(
        //     color: Colors.white24,
        //   ),
        //   borderRadius: BorderRadius.circular(100),
        // ),
        shape: Border.all(color: Colors.grey),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage(value);
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void calculate() {

    //condition to test if the last character on a string is not an operator
    if(int.tryParse(expression[expression.length-1]) == null){

      if(expression[expression.length-1] != '%') {
        expression = expression.substring(0, expression.length - 1);
      }

    }

    answer = expression.interpret().toString();

    //check if the answer ends with .0 so if that's the case remove the .0 to make it a whole number
    if (answer.endsWith(".0")) {
      answer = answer.substring(0, answer.length - 2);
    }

    setState(() {
      expression = answer;
      displayExpression = expression;
    });
  }

  void convertToPercentage(value) {
    bool noSecondNumber = true;


    //check every character in the expression string so we can tell if theres already a second number
    for(var i  = 0;i < expression.length;i++){
      //try to parse the character if its not a number it will return null
      if(int.tryParse(expression[i]) == null){
        //check the character if its not equal to %
        if(expression[i] != '%'){
          noSecondNumber = false;
        }
      }
    }

    //if there's no second number calculate the percentage else append it to the end of string
    if(noSecondNumber) {
      calculate();
      final number = double.parse(expression);
      setState(() {
        expression = "${(number / 100)}";
        displayExpression = expression;
      });
    }else{
      appendValue(value);
    }
  }

  //clearing all the values
  void clearAll() {
    setState(() {
      expression = "";
      displayExpression = expression;
    });
  }

  //delete characters on expression string one by one
  void delete() {
    if(expression.length == 1){
      expression = '';
    }else{
      expression = expression.substring(0,expression.length-1);
    }

    displayExpression = expression;
    setState(() {});
  }

  //append characters on expression string
  void appendValue(String value) {

    //change values for × and ÷ symbols
    if(value == '×'){
      value = '*';
    }else if(value == '÷'){
      value = '/';
    }

    //check if the value is not an operator or the expression is not null
    if(int.tryParse(value) != null || expression.isNotEmpty) {

      //if expression is not empty get the last character
      if(expression.isNotEmpty) {
        String lastChar = expression.substring(
            expression.length - 1, expression.length);
        //check the last character if it is a number or the value is a number
        if (int.tryParse(lastChar) != null || int.tryParse(value) != null) {
          expression += value;
        }
      }else{
        expression += value;
      }
    }

    displayExpression = "";

    //this is for the display expression
    for(var i = 0;i < expression.length;i++){
      if(expression[i] == '*'){
        displayExpression += '×';
      }else if(expression[i] == '/'){
        displayExpression += '÷';
      }else{
        displayExpression += expression[i];
      }
    }
    setState(() {});
  }


  //for btn color
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
      Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.calculate,
    ].contains(value)
        ? Colors.orange
        : Colors.black87;
  }
}