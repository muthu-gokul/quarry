
import 'package:quarry/widgets/decimal.dart';

class Calculation {

  add(dynamic n1,dynamic n2){
    return double.parse((Decimal.parse(n1.toString())+Decimal.parse(n2.toString())).toString());
  }
  sub(dynamic n1,dynamic n2){
    return double.parse((Decimal.parse(n1.toString())-Decimal.parse(n2.toString())).toString());
  }

  mul(dynamic n1,dynamic n2){
    return double.parse((Decimal.parse(n1.toString())*Decimal.parse(n2.toString())).toString());
  }


  taxAmount({dynamic taxValue, dynamic amount, dynamic discountAmount}){
    return double.parse(((Decimal.parse(taxValue.toString())*(Decimal.parse(amount.toString())-Decimal.parse(discountAmount.toString())))/Decimal.parse("100")).toString());
  }

  discountAmount({dynamic discountValue, dynamic amount}){
   return double.parse(((Decimal.parse(discountValue.toString())*Decimal.parse(amount.toString()))/Decimal.parse("100")).toString());
  }

  totalAmount({dynamic amount, dynamic taxAmount, dynamic discountAmount}){
   return double.parse((Decimal.parse(amount.toString())+Decimal.parse(taxAmount.toString())-Decimal.parse(discountAmount.toString())).toString());
  }



}