import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';


///DropDownField has customized autocomplete text field functionality
///
///Parameters
///
///value - dynamic - Optional value to be set into the Dropdown field by default when this field renders
///
///icon - Widget - Optional icon to be shown to the left of the Dropdown field
///
///hintText - String - Optional Hint text to be shown
///
///hintStyle - TextStyle - Optional styling for Hint text. Default is normal, gray colored font of size 18.0
///
///labelText - String - Optional Label text to be shown
///
///labelStyle - TextStyle - Optional styling for Label text. Default is normal, gray colored font of size 18.0
///
///required - bool - True will validate that this field has a non-null/non-empty value. Default is false
///
///enabled - bool - False will disable the field. You can unset this to use the Dropdown field as a read only form field. Default is true
///
///items - List<dynamic> - List of items to be shown as suggestions in the Dropdown. Typically a list of String values.
///You can supply a static list of values or pass in a dynamic list using a FutureBuilder
///
///textStyle - TextStyle - Optional styling for text shown in the Dropdown. Default is bold, black colored font of size 14.0
///
///inputFormatters - List<TextInputFormatter> - Optional list of TextInputFormatter to format the text field
///
///setter - FormFieldSetter<dynamic> - Optional implementation of your setter method. Will be called internally by Form.save() method
///
///onValueChanged - ValueChanged<dynamic> - Optional implementation of code that needs to be executed when the value in the Dropdown
///field is changed
///
///strict - bool - True will validate if the value in this dropdown is amongst those suggestions listed.
///False will let user type in new values as well. Default is true
///
///itemsVisibleInDropdown - int - Number of suggestions to be shown by default in the Dropdown after which the list scrolls. Defaults to 3
class DropDownField extends FormField<String> {
  final dynamic value;
  final Widget icon;
  final String hintText;
  final TextStyle hintStyle;
  final String labelText;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final bool required;
  final bool enabled;
  final List<dynamic> items;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldSetter<dynamic> setter;
  final ValueChanged<dynamic> onValueChanged;
  final bool strict;
  final int itemsVisibleInDropdown;
  VoidCallback nodeFocus;
  VoidCallback add;
  VoidCallback ontap;
  VoidCallback onEditingcomplete;
  String unit;
  double reduceWidth;
  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController controller;
  final TextEditingController qtycontroller;

  DropDownField(
      {Key key,
        this.controller,
        this.value,
        this.required: false,
        this.icon,
        this.hintText,
        this.hintStyle: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
        this.labelText,
        this.labelStyle: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
        this.inputFormatters,
        this.items,
        this.textStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14.0),
        this.setter,
        this.onValueChanged,
        this.itemsVisibleInDropdown: 3,
        this.enabled: true,
        this.add,
        this.ontap,
        this.onEditingcomplete,
        this.unit,
        this.nodeFocus,
        this.qtycontroller,
        this.reduceWidth:0,
        this.strict: true})
      : super(
    key: key,
    autovalidate: false,
    initialValue: controller != null ? controller.text : (value ?? ''),
    onSaved: setter,
    builder: (FormFieldState<String> field) {
      final DropDownFieldState state = field;
      final ScrollController _scrollController = ScrollController();
      final InputDecoration effectiveDecoration = InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
          ),

          filled: true,
          fillColor: Colors.white,
          //icon: icon,
          prefixIcon: icon,
          focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
          ),
          hintStyle: hintStyle,
          labelStyle: labelStyle,
          hintText: hintText,
          labelText: labelText,
        contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
      );

      return Container(
        // width: 300,
        margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            Row(

              children: <Widget>[

                Container(
                  height: SizeConfig.height60,
                  //width: SizeConfig.screenWidth-(SizeConfig.width40),
                  width: SizeConfig.screenWidth-(reduceWidth),

                  child: TextFormField(
                    onTap: (){
                      state._showdropdown=true;
                      ontap();
                    },
                    // autovalidate: true,
                    controller: state._effectiveController,
                    decoration: effectiveDecoration,
                    style: textStyle,
                    textAlign: TextAlign.start,
                    autofocus: false,
                    obscureText: false,

                    // maxLengthEnforced: true,
                    maxLines: 1,
                    // validator: (String newValue) {
                    //   if (required) {
                    //     if (newValue == null || newValue.isEmpty)
                    //       return 'This field cannot be empty!';
                    //   }
                    //
                    //   //Items null check added since there could be an initial brief period of time
                    //   //when the dropdown items will not have been loaded
                    //   if (items != null) {
                    //     if (strict &&
                    //         newValue.isNotEmpty &&
                    //         !items.contains(newValue))
                    //       return 'Invalid value in this field!';
                    //   }
                    //
                    //   return null;
                    // },
                    onChanged: (v){
                      if(v.isEmpty){
                        state._showdropdown=false;


                        // print(items.length);
                      }
                      add();
                      state._getChildren( items);
                      // print(state.noitems);
                    },
                    onEditingComplete: (){
                      state._effectiveController.text = state._searchText;
                     // state.clearValue();
                      state._showdropdown=false;
                      // state._showdropdown=false;
                      print(state._showdropdown);
                      nodeFocus();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      onEditingcomplete();
                    },

                    onSaved: setter,
                    enabled: enabled,
                    inputFormatters: inputFormatters,
                  ),
                ),
                // SizedBox(width: 20,),
                //
                // Container(
                //   height: 70,
                //   width: 150,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(3),
                //       border: Border.all(color: AppTheme.addNewTextFieldBorder),
                //     color: Colors.white
                //   ),
                //   alignment: Alignment.centerLeft,
                //   padding: EdgeInsets.only(left: SizeConfig.width20),
                //   child: TextFormField(
                //     controller: qtycontroller,
                //     keyboardType: TextInputType.number,
                //     style:  TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.addNewTextFieldText),
                //     decoration: InputDecoration(
                //       border: InputBorder.none,
                //       focusedBorder: InputBorder.none,
                //       errorBorder: InputBorder.none,
                //       enabledBorder: InputBorder.none,
                //
                //       suffixIcon: Padding(
                //         padding: EdgeInsets.only(top:10.0,right: 10),
                //         child: Text(unit??"",style: TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.addNewTextFieldText),),
                //       )
                //     ),
                //     inputFormatters: [
                //       FilteringTextInputFormatter.digitsOnly
                //     ],
                //
                //   )
                //   ),
                // // Text(unit??"",style: TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.addNewTextFieldText),)
                // SizedBox(width: 20,),
                // GestureDetector(
                //   onTap: (){
                //     state._effectiveController.text = state._searchText;
                //     // state.clearValue();
                //     state._showdropdown=false;
                //     // state._showdropdown=false;
                //     // print(state._showdropdown);
                //     SystemChannels.textInput.invokeMethod('TextInput.hide');
                //     add();
                //   },
                //   child: Container(
                //     height: SizeConfig.height40,
                //     width: SizeConfig.height40,
                //     padding: EdgeInsets.only(left: SizeConfig.screenWidth*(3/800)),
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: AppTheme.addNewTextFieldFocusBorder
                //
                //     ),
                //     child: Center(
                //       child:  Icon(Icons.add,
                //         color: Colors.white,size: 28,),
                //     ),
                //   ),
                // ),
                // IconButton(
                //   icon: Icon(Icons.close),
                //   onPressed: () {
                //     if (!enabled) return;
                //     state.clearValue();
                //     state._showdropdown=false;
                //   },
                // )
              ],
            ),
            !state._showdropdown
                ? Container()
                :!state.noitems? Container(
              // alignment: Alignment.centerLeft,
              height: itemsVisibleInDropdown * 48.0, //limit to default 3 items in dropdownlist view and then remaining scrolls
              //width: SizeConfig.screenWidth-(SizeConfig.width40),
              width: SizeConfig.screenWidth-(reduceWidth),

              // margin: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: AppTheme.addNewTextFieldBorder)

              ),
              // constraints: BoxConstraints(
              //   maxHeight: 150,
              //   minHeight: 50
              // ),
              child: ListView(
                cacheExtent: 0.0,
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                // padding: EdgeInsets.only(left: 40.0),
                children: items.isNotEmpty
                    ? ListTile.divideTiles(
                    context: field.context,
                    tiles: state._getChildren(state._items))
                    .toList()
                    : List(),
              ),
            ):Container(),
          ],
        ),
      );
    },
  );

  @override
  DropDownFieldState createState() => DropDownFieldState();
}

class DropDownFieldState extends FormFieldState<String> {
  TextEditingController _controller;
  bool _showdropdown = false;
  bool _isSearching = true;
  String _searchText = "";

  bool noitems=false;
  @override
  DropDownField get widget => super.widget;
  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  List<String> get _items => widget.items;
  var node;
  void toggleDropDownVisibility() {}

  void clearValue() {
    setState(() {
      _effectiveController.text = '';
    });
  }

  @override
  void didUpdateWidget(DropDownField oldWidget) {
     // node=FocusScope.of(context);
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // node=FocusScope.of(context);
    _isSearching = false;
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }

    _effectiveController.addListener(_handleControllerChanged);

    _searchText = _effectiveController.text;
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  showDropOff(){
    setState(() {
      _showdropdown=false;
      _isSearching = false;
    });
  }

  List<ListTile> _getChildren(List<String> items) {
    List<ListTile> childItems = List();
    for (var item in items) {
      if (_searchText.isNotEmpty) {
        if (item.toUpperCase().contains(_searchText.toUpperCase())){
          childItems.add(_getListTile(item));
          setState(() {
            noitems=false;
          });
        }
      } else {
        childItems.add(_getListTile(item));
        setState(() {
          noitems=false;
        });
      }
    }
    _isSearching ? childItems : List();
    // print(childItems.length);
    if(childItems.length==0){
      setState(() {
        // _showdropdown=false;
        //  _isSearching=false;
         noitems=true;
      });
    }
    return childItems;
  }

  ListTile _getListTile(String text) {
    return ListTile(
      dense: true,
      title: Text(
        text,
        style: TextStyle(fontSize: 20,fontFamily: 'RR',color: AppTheme.addNewTextFieldText),
      ),
      onTap: () {
        // node.unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        setState(() {
          _effectiveController.text = text;
          _handleControllerChanged();
          _showdropdown = false;
          _isSearching = false;
          if (widget.onValueChanged != null) widget.onValueChanged(text);
        });
      },
    );
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);

    if (_effectiveController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchText = "";
      });
    } else {
      setState(() {
        _isSearching = true;
        _searchText = _effectiveController.text;
        _showdropdown = true;
      });
    }
  }
}