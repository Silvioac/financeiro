import 'package:financeiro/helpers/transaction_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CreateProducts extends StatefulWidget {
  final Transaction transactionUpdate;

  CreateProducts({this.transactionUpdate});

  @override
  _CreateProductsState createState() => _CreateProductsState();
}

class _CreateProductsState extends State<CreateProducts> {
  final controlDesc = TextEditingController();
  final controlValue = TextEditingController();
  var _type = 'C';
  String _currentGroup;
  List<String> _listGroupCost = ['Lazer', 'Comida', 'Jogos', 'Transporte'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  Transaction _transactionEdit;
  bool _controlEdit = false;

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    _currentGroup = _dropDownMenuItems[0].value;
    _transactionEdit = widget.transactionUpdate;

    if (widget.transactionUpdate != null) {
      //Update product
      _transactionEdit = Transaction.fromMap(widget.transactionUpdate.toMap());
      controlDesc.text = _transactionEdit.description;
      controlValue.text = _transactionEdit.value.toString();
      _type = _transactionEdit.type;
      _currentGroup = _transactionEdit.group;
    } else {
      _transactionEdit = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _controlPop,
      child: Scaffold(
        appBar: AppBar(
          /*leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              if(!_controlEdit)
                Navigator.pop(context, false);
            },
          ), */
          title:
              Text(_transactionEdit == null ? "Adicionar Produto" : "Atualizar Produto"),
          backgroundColor: Color(0xff4285F4),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveProducts,
          child: Icon(Icons.check),
        ),
        resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Radio(
                    groupValue: _type,
                    value: 'C',
                    onChanged: _setType,
                  ),
                  Text('Credito'),
                  Radio(
                    groupValue: _type,
                    value: 'D',
                    onChanged: _setType,
                  ),
                  Text('Debito'),
                ],
              ),
              Container(
                width: double.infinity,
                child: DropdownButton(
                  isExpanded: true,
                  value: _currentGroup,
                  items: _dropDownMenuItems,
                  onChanged: (v) {
                    _controlEdit = true;
                    setState(() {
                      _currentGroup = v;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: TextField(
                  controller: controlDesc,
                  onChanged: (input) {
                    _controlEdit = true;
                  },
                  decoration: InputDecoration(labelText: "Produto"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: TextField(
                  controller: controlValue,
                  onChanged: (input) {
                    _controlEdit = true;
                  },
                  decoration: InputDecoration(labelText: "Valor"),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setType(type) {
    _controlEdit = true;
    setState(() {
      _type = type;
    });
  }

  Future<bool> _controlPop() {
    if (_controlEdit) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Warning'),
              content: Text(
                  'You haven\'t saved your changes. Are you sure you want to leave?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context); // Leave Alert
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context); // Leave Alert
                    Navigator.pop(context); // Leave Screen
                  },
                  child: Text(
                    'Confirm',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              ],
            );
          });
      debugPrint('Warning: data not saved!');
      return Future.value(false);
    }
    return Future.value(true);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String i in _listGroupCost) {
      items.add(new DropdownMenuItem(value: i, child: new Text(i)));
    }
    return items;
  }

  void _saveProducts() async {
    Transaction t;
    TransactionHelper transactionHelper = TransactionHelper();
    Map<String, dynamic> item = Map();
    item[descriptionColumn] = controlDesc.text;
    item[typeColumn] = _type;
    item[valueColumn] = double.parse(controlValue.text);
    item[groupColumn] = _currentGroup;
    item[dateColumn] = DateFormat("dd-MM-yyyy").format(DateTime.now());

    if (_transactionEdit == null) {
      t = await transactionHelper.saveTransaction(Transaction.fromMap(item));
      debugPrint(t.toString());
      Fluttertoast.showToast(
          msg: "Item criado!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 3,
          fontSize: 16.0);
      Navigator.pop(context, t.id != null ? true : false);
    } else {
      item[idColumn] = _transactionEdit.id;
      int i =
          await transactionHelper.updateTransaction(Transaction.fromMap(item));
      debugPrint(i.toString());
      Fluttertoast.showToast(
          msg: "Item atualizado!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 3,
          fontSize: 16.0);
      Navigator.pop(context, i != 0 ? true : false);
    }
  }
}