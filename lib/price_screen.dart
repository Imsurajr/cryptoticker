import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'constants.dart';

class PriceScreen extends StatefulWidget {
  PriceScreen({this.finalPrice});
  final finalPrice;

  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String fetchedPrice = '';
  String selectedCurrencyValue = selectedCurrency;

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void updateUi() async {
    isWaiting = true;
    try {
      var data = await LivePrice().getLivePrice(selectedCurrencyValue);

      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
    print(coinValues);
  }

  @override
  void initState() {
    super.initState();
    updateUi();
  }

  List<DropdownMenuItem<String>> getDropDownItems() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return dropDownItems;
  }

  Widget build(BuildContext context) {
    getDropDownItems();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: Text('🤑 Coin Ticker' ,
        style: TextStyle(color: Colors.black,
        fontWeight: FontWeight.bold,
        ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CryptoCards(
                    value: isWaiting ? '?' : coinValues['BTC']!,
                    selectedCurrency: selectedCurrencyValue,
                    cryptoCurrency: 'BTC'),
                CryptoCards(
                    value: isWaiting ? '?' : coinValues['ETH']!,
                    selectedCurrency: selectedCurrencyValue,
                    cryptoCurrency: 'ETH'),
                CryptoCards(
                    value: isWaiting ? '?' : coinValues['DOG']!,
                    selectedCurrency: selectedCurrencyValue,
                    cryptoCurrency: 'DOG'),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.grey,
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(10),
                focusColor: Colors.grey[900],
                iconDisabledColor: Colors.grey[600],
                iconEnabledColor: Colors.grey[900],
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                value: selectedCurrencyValue,
                items: getDropDownItems(),
                onChanged: (value) {
                  setState(() {
                    selectedCurrencyValue = value!;
                    selectedCurrency = value!;
                    updateUi();
                  });
                }),
          ),
        ],
      ),
    );
  }
}

class CryptoCards extends StatelessWidget {
  CryptoCards(
      {required this.value,
      required this.selectedCurrency,
      required this.cryptoCurrency});
  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $cryptoCurrency = $value $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
