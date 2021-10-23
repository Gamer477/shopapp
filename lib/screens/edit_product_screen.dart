import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlEditingController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  var _editedProdut = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    // TODO: implement initState
    super.initState();
  }

  var _initValues = {
    'title': '',
    'discription': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editedProdut = Provider.of<ProductsProvider>(context, listen: false)
            .findByID(productId);
        _initValues = {
          'title': _editedProdut.title,
          'discription': _editedProdut.description,
          'price': _editedProdut.price.toString(),
          'imageUrl': '',
        };
        _imageUrlEditingController.text = _editedProdut.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlEditingController.text.startsWith('http') &&
              !_imageUrlEditingController.text.startsWith('https')) ||
          (!_imageUrlEditingController.text.endsWith('.jpg') &&
              !_imageUrlEditingController.text.endsWith('png') &&
              !_imageUrlEditingController.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final _isValid = _form.currentState!.validate();
    if (!_isValid) {
      return;
    }

    _form.currentState!.save();

    // ignore: unnecessary_null_comparison
    if (_editedProdut.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProdut.id, _editedProdut);
    }
    Provider.of<ProductsProvider>(context, listen: false)
        .addProduct(_editedProdut);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(
              Icons.save,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Provide A value';
                  }
                  return null;
                },
                onSaved: (val) => _editedProdut = Product(
                    title: val!,
                    description: _editedProdut.description,
                    id: _editedProdut.id,
                    isFavorite: _editedProdut.isFavorite,
                    imageUrl: _editedProdut.imageUrl,
                    price: _editedProdut.price),
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Provide A Price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please Enter A Valid Number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please Enter a Number Greater Than Zero';
                  }
                  return null;
                },
                onSaved: (val) => _editedProdut = Product(
                    title: _editedProdut.title,
                    description: _editedProdut.description,
                    id: _editedProdut.id,
                    isFavorite: _editedProdut.isFavorite,
                    imageUrl: _editedProdut.imageUrl,
                    price: double.parse(val!)),
              ),
              TextFormField(
                initialValue: _initValues['discription'],
                decoration: InputDecoration(
                  labelText: 'Discription',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Provide A Discription';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 Charcters Long';
                  }
                  return null;
                },
                onSaved: (val) => _editedProdut = Product(
                    title: _editedProdut.title,
                    description: val!,
                    id: _editedProdut.id,
                    isFavorite: _editedProdut.isFavorite,
                    imageUrl: _editedProdut.imageUrl,
                    price: _editedProdut.price),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlEditingController.text.isEmpty
                        ? Text('Enter a Url')
                        : FittedBox(
                            child:
                                Image.network(_imageUrlEditingController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image Url',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlEditingController,
                      focusNode: _imageUrlFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Provide A URL';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please Enter a Valid URL';
                        }
                        if (!value.endsWith('.jpg') &&
                            !value.endsWith('png') &&
                            !value.endsWith('jpeg')) {
                          return 'Please Enter a Valid URL';
                        }
                        return null;
                      },
                      onSaved: (val) => _editedProdut = Product(
                          title: _editedProdut.title,
                          description: _editedProdut.description,
                          id: _editedProdut.id,
                          isFavorite: _editedProdut.isFavorite,
                          imageUrl: val!,
                          price: _editedProdut.price),
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
