import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Simple Interest Calculator App',
    home: SIForm(),
    theme: _buildTheme(),
  ));
}

class SIForm extends StatefulWidget {
  @override
  _SIFormState createState() => _SIFormState();
}

class _SIFormState extends State<SIForm> {
  //  Data
  //
  var _formKey = GlobalKey<FormState>();
  List<String> _currencies = ['Euro', 'Dollar', 'Ruble', 'Pound', 'Other'];
  var _currentItemSelected = '';
  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  var formatter = NumberFormat.currency(locale: 'fi');
  final _minimumPadding = 5.0;
  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();
  var displayResult = '';
  //
  //
  @override
  Widget build(BuildContext context) {
    // define textStyle
    TextStyle textStyle = Theme.of(context).primaryTextTheme.subtitle2;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            centerTitle: false,
            title: Text(
              'Interest Calculator',
            )),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(_minimumPadding * 3, _minimumPadding,
                  _minimumPadding * 3, _minimumPadding * 3),
              child: ListView(children: <Widget>[
                getImageAsset(),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 1, bottom: _minimumPadding * 2),
                  child: TextFormField(
                      controller: principalController,
                      validator: (String value) {
                        if (value.isEmpty || double.tryParse(value) == null) {
                          return 'Please enter valid principal amount';
                        } else
                          return null;
                      },
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                            color: Colors.red[700],
                            fontSize: 14.5,
                          ),
                          labelStyle: textStyle,
                          labelText: 'Principal',
                          hintText: 'Enter Principal e.g. 12000',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 2, bottom: _minimumPadding * 2),
                  child: TextFormField(
                      controller: roiController,
                      validator: (String value) {
                        if (value.isEmpty || double.tryParse(value) == null) {
                          return 'Please enter valid rate of interest';
                        } else
                          return null;
                      },
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                            color: Colors.red[700],
                            fontSize: 14.5,
                          ),
                          labelStyle: textStyle,
                          labelText: 'Rate of Interest',
                          hintText: 'Type in Percent',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 2, bottom: _minimumPadding * 2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                            controller: termController,
                            validator: (String value) {
                              if (value.isEmpty ||
                                  double.tryParse(value) == null) {
                                return 'Please enter term';
                              } else
                                return null;
                            },
                            keyboardType: TextInputType.number,
                            style: textStyle,
                            decoration: InputDecoration(
                                errorStyle: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 14.5,
                                ),
                                labelStyle: textStyle,
                                labelText: 'Term',
                                hintText: 'Type Term in Years',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ))),
                      ),
                      Container(width: _minimumPadding * 5),
                      Expanded(
                        child: DropdownButton(
                          items: _currencies.map((String currency) {
                            return DropdownMenuItem<String>(
                              value: currency,
                              child: Text(
                                currency,
                                style: textStyle,
                              ),
                            );
                          }).toList(),
                          value: this._currentItemSelected,
                          onChanged: (String newValueSelected) {
                            _onDropDownItemSelected(newValueSelected);
                            currencyPostfix(newValueSelected);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 1.5,
                      bottom: _minimumPadding * 1.5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColorDark,
                          child: Text(
                            'Calculate',
                            textScaleFactor: 1.15,
                            style: textStyle,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_formKey.currentState.validate()) {
                                displayResult = _calculateTotalReturns();
                              }
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColorDark,
                          child: Text(
                            'Reset',
                            textScaleFactor: 1.15,
                            style: textStyle,
                          ),
                          onPressed: () {
                            setState(() {
                              _reset();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 8,
                      left: _minimumPadding * 4,
                      right: _minimumPadding * 4),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.pink[100])),
                    child: Padding(
                      padding: EdgeInsets.all(_minimumPadding * 4),
                      child: Text(
                        this.displayResult,
                        style: textStyle,
                        textScaleFactor: 1.25,
                      ),
                    ),
                  ),
                )
              ]),
            )));
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/plus.png');
    Image image = Image(
      image: assetImage,
      width: 170.0,
      height: 170.0,
    );
    return Container(
        child: image,
        margin: EdgeInsets.only(
            top: _minimumPadding * 0, bottom: _minimumPadding * 3));
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(
      () {
        this._currentItemSelected = newValueSelected;
      },
    );
  }

  void currencyPostfix(String newValue) {
    String currencyPrefix = '';
    if (newValue == 'Euro')
      currencyPrefix = 'eu';
    else if (newValue == 'Dollar')
      currencyPrefix = 'en-us';
    else if (newValue == 'Ruble')
      currencyPrefix = 'ru';
    else if (newValue == 'Pound')
      currencyPrefix = 'en-gb';
    else
      currencyPrefix = 'eu';

    this.formatter = NumberFormat.currency(locale: currencyPrefix);
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    String result =
        "After $term years, your investment will be worth ${this.formatter.format(totalAmountPayable)}";

    return result;
  }

  void _reset() {
    this.principalController.clear(); //principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
  }
}

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    // brightness: Brightness.dark,
    canvasColor: Colors.pink[200],
    primaryColor: Colors.pink[200],
    accentColor: Colors.pink[200],
    primaryTextTheme: TextTheme(
      subtitle2: TextStyle(
        color: Colors.white,
      ),
      headline6: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
      ),
    ),
    scaffoldBackgroundColor: Colors.pink[200],
    appBarTheme: _appBarTheme(),
  );
}

AppBarTheme _appBarTheme() {
  return AppBarTheme(
    elevation: 0.0,
    color: Colors.pink[200],
    iconTheme: IconThemeData(
      color: Colors.pinkAccent[200],
    ),
  );
}
