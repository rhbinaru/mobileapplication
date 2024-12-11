//im/2021/099
import 'package:flutter/material.dart';
import 'package:calculator/button_values.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  
  String number1 = ""; // . 0-9
  String operand = ""; // + - * /
  String number2 = ""; // . 0-9
  bool isResult = true;
  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return Scaffold(
     body:SafeArea(
       
       bottom:false,
       child: Column (children: [
        //output- top part
     
        Expanded(
          child: SingleChildScrollView(
            reverse: true,
            child: Container(
     
              //0 edits tika
     
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(16),
              child: Text(
                          "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              )),
            ),
          ),
        ),
       
        //buttons - yata tika
        Padding(
          padding: const EdgeInsets.only(bottom:8.0),
          child: Wrap(
            children: Btn.buttonValues
            .map((value) => SizedBox(
              width:screenSize.width/4,
              height:screenSize.width/5,
              child: buildButton(value)),
            )
            .toList(),
          ),
        )
       ]),
     ),
     );
  }

 Widget buildButton(value) {
  return Padding(
    padding: const EdgeInsets.all(3.0), // btn padding
    child: Material(
      color: getBtnColor(value), // button background color
      clipBehavior: Clip.hardEdge, // clip contents tightly to the shape
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(150), // rounded corners
      ),
      elevation: 10, // adds depth to simulate a shadow
      child: InkWell(
        onTap: () => onBtnTap(value), // handle button taps
        child: Container(
          alignment: Alignment.center, // align text in the center
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
      ),
    ),
  );
}


  // ####
  // btn colors
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? const Color.fromARGB(255, 218, 112, 19) 
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? const Color.fromARGB(255, 149, 132, 142)
            : const Color.fromARGB(221, 63, 62, 62);
  }

bool hasResult = false;
  // ###
  // what happens when press a btn

void appendValue(String value) {

  // Handling the result state (after "=" is pressed)
  if (isResult) {
    if (int.tryParse(value) != null || value == Btn.dot) {
      // If a number or dot is pressed after '=', start a new operation.
      number1 = value; // Set the new number as number1.
      operand = ""; // Clear operand.
      number2 = ""; // Clear number2.
      isResult = false; // Reset the result flag.
      setState(() {}); // Rebuild UI
      return;
    }
  }
    // number1 opernad number2
    // 565       +      9864
    if (hasResult) {
    // Reset for a new operation if a result was previously displayed
    number1 = "";
    operand = "";
    number2 = "";
    hasResult = false; // Disable flag after starting a new operation
          }
    // if is operand and not "."
    if (value != Btn.dot && int.tryParse(value) == null) { //operand detected
      // operand pressed
      if (operand.isNotEmpty && number2.isNotEmpty) { 
        //A complete operation can be performed (e.g., number1 operand number2).
        
        calculate();
      }
      operand = value;  // eka calculation ekk unata passe aluth operand ekata value ekk pass wenwa.
    }
    // assign value to number1 variable
    else if (number1.isEmpty || operand.isEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return; // num1 eke dot ekk already have nm aai dot ekk wadin nathuwa return wenwa
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        // ex: number1 = "" | "0"
        value = "0.";  // "." ebuwama 0. kelinma type wenwa meken
      }
      number1 += value; //Appends the current value (number or .) to number1.
                        //number 1 eka continue wewnwa
    }
    // assign value to number2 variable
    else if (number2.isEmpty || operand.isNotEmpty) {
      // check if value is "." | ex: number2 = "1.2"
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        // number2 = "" | "0"
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }


  void onBtnTap(String value){

    if(value == Btn.del){
      delete();
      return;
    }

     if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
    // If "=" is pressed, perform calculation and reset states
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate(); // Perform the calculation
      isResult = true; // Set flag to indicate result is shown
      setState(() {});  // Rebuild UI
      return;
    }
  }

  // Handling the result state:
  if (isResult) {
    if (int.tryParse(value) != null || value == Btn.dot) {
      // If a number or dot is pressed after '=', start a new operation.
      number1 = value; // Set the new number as number1.
      operand = ""; // Clear operand.
      number2 = ""; // Clear number2.
      isResult = false; // Reset the result flag.
      setState(() {}); // Rebuild UI
      return;
    }
    }

    if (value == Btn.sqrt) {
    calculateSquareRoot();
    return;
    }


    appendValue(value);
  }

  //####
  //calculate funtion

  void calculate() {
  if (number1.isEmpty) return;
  if (operand.isEmpty) return;
  if (number2.isEmpty) return;

  final double num1 = double.parse(number1);
  final double num2 = double.parse(number2);

  String result;

  switch (operand) {
    case Btn.add:
      result = (num1 + num2).toString();
      break;
    case Btn.subtract:
      result = (num1 - num2).toString();
      break;
    case Btn.multiply:
      result = (num1 * num2).toString();
      break;
    case Btn.divide:
      if (num2 == 0) {
        result = "Can't divide by 0"; // Handle division by zero
      } else {
        result = (num1 / num2).toString();
      }
      break;
    default:
      result = "";
  }

  setState(() {
    if (result == "Can't divide by 0") {
      number1 = result; // Display error message
    } else {
      // Parse the result as a double and clean trailing zeros for whole numbers
      final parsedResult = double.parse(result);
      number1 = parsedResult % 1 == 0
          ? parsedResult.toInt().toString() // Convert to integer if whole
          : parsedResult.toStringAsPrecision(3); // Keep up to 3 significant digits
    }

    operand = "";
    number2 = "";
    
  });
}




  //####
  //delete funtion

  void delete() {
    if (number2.isNotEmpty) {
      // 12323 => 1232
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  //####
  //clr function
   void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  //####
  //percentage function
  void convertToPercentage() {
    // ex: 434+324
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      // calculate before conversion
      calculate();
    }

    if (operand.isNotEmpty) {
      // cannot be converted
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  } 

  //####
  //sqrroot function

  void calculateSquareRoot() {
  if (number1.isEmpty || operand.isNotEmpty) {
    // Square root can only be applied to a single number (number1).
    return;
  }

  final double num1 = double.parse(number1);

  if (num1 < 0) {
    // Handle square root of negative numbers (optional).
    setState(() {
      number1 = "Error"; // or display "NaN"
    });
    return;
  }

  setState(() {
    // Calculate square root and clean up result
    number1 = (sqrt(num1)).toStringAsFixed(10); // Using Dart's `sqrt` function
    number1 = number1.contains('.')
        ? number1.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')
        : number1;

    // Reset operand and number2 for a clean operation
    operand = "";
    number2 = "";
  });
}


}



 