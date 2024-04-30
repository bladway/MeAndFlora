import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/domain/models/plant_type.dart';
import 'package:me_and_flora/feature/plant_ident_form/presentation/bloc/ident.dart';

import '../../../../core/domain/models/models.dart';
import '../../../../core/theme/theme.dart';

class PlantIdentForm extends StatefulWidget {
  const PlantIdentForm({super.key, required this.plant});

  final Plant plant;

  @override
  State<PlantIdentForm> createState() => _PlantIdentFormState();
}

class _PlantIdentFormState extends State<PlantIdentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();
  PlantType selectedValue = PlantType.unknown;

  List<DropdownMenuItem<PlantType>> get dropdownItems {
    List<DropdownMenuItem<PlantType>> menuItems = [
      DropdownMenuItem(
          value: PlantType.flower, child: Text(PlantType.flower.displayTitle)),
      DropdownMenuItem(
          value: PlantType.tree, child: Text(PlantType.tree.displayTitle)),
      DropdownMenuItem(
          value: PlantType.grass, child: Text(PlantType.grass.displayTitle)),
      DropdownMenuItem(
          value: PlantType.moss, child: Text(PlantType.moss.displayTitle)),
      DropdownMenuItem(
          value: PlantType.unknown,
          child: Text(PlantType.unknown.displayTitle)),
    ];
    return menuItems;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      key: _formKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Введите название растения',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          keyboardType: TextInputType.name,
          controller: _nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: colors.grayGreen),
              borderRadius: BorderRadius.circular(8),
            ),
            counterStyle: Theme.of(context).textTheme.bodySmall,
          ),
          //style: Theme.of(context).textTheme.labelSmall,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return value == null ? "Поле не должно быть пустым" : null;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Введите тип',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 5,
        ),
        DropdownButtonFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: colors.grayGreen),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              //filled: true,
              fillColor: Colors.transparent,
            ),
            dropdownColor: Colors.black,
            style: Theme.of(context).textTheme.titleSmall,
            value: selectedValue,
            onChanged: (PlantType? value) {
              setState(() {
                selectedValue = value ?? PlantType.unknown;
              });
            },
            items: dropdownItems),
        /*
        TextFormField(
          keyboardType: TextInputType.text,
          controller: _typeController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: colors.grayGreen),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return value == null ? "Поле не должно быть пустым" : null;
          },
        ),*/
        const SizedBox(
          height: 10,
        ),
        Text(
          'Введите описание',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          controller: _descriptionController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: colors.grayGreen),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLines: 10,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return value == null ? "Поле не должно быть пустым" : null;
          },
        ),
        const SizedBox(
          height: 25,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [colors.lightGreen, colors.blueGreen])),
            child: TextButton(
              onPressed: () {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  BlocProvider.of<IdentBloc>(context)
                      .add(IdentRequested(plant: widget.plant));
                  context.popRoute();
                }
              },
              child: Text(
                'Идентифицировать растение',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Divider(
                    color: Colors.white,
                  )),
            ),
            Text(
              "или",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Divider(
                    color: Colors.white,
                  )),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              BlocProvider.of<IdentBloc>(context)
                  .add(ImpossibleIdentRequested(plant: widget.plant));
              context.popRoute();
            },
            child: Text(
              "Идентифицировать невозможно",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      ],
    );
  }
}
