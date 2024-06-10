// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'bloc/radio_button_bloc.dart';



// class RadioExample extends StatelessWidget {
//   final RadioButtonBloc radioButtonBloc = RadioButtonBloc();

//   RadioExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<RadioButtonBloc>(
//       create: (context) => radioButtonBloc,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Radio Button'),
//         ),
//         body: BlocBuilder<RadioButtonBloc, RadioButtonState>(
//           builder: (context, state) {
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RadioListTile(
//                     title: const Text('Cash'),
//                     value: 'cash',
//                     groupValue: state.selectedOption,
//                     onChanged: (value) {
//                       context.read<RadioButtonBloc>().add(RadioButtonChanged(
//                           selectedOption: value ?? "", showTextField: false));
//                     },
//                   ),
//                   RadioListTile(
//                     title: const Text('Credit'),
//                     value: 'credit',
//                     groupValue: state.selectedOption,
//                     onChanged: (value) {
//                       context.read<RadioButtonBloc>().add(RadioButtonChanged(
//                           selectedOption: value ?? "", showTextField: true));
//                     },
//                   ),
//                   if (state.showTextField)
//                   Column(
//                     children: [TextFormField(
//                       decoration: const InputDecoration(
//                           labelText: 'Enter Account Number'),
//                       keyboardType: TextInputType.number,
//                     ),  TextFormField(
//                       decoration: const InputDecoration(
//                           labelText: 'Enter Bank Name'),
//                       keyboardType: TextInputType.text,
//                     ),],
//                   )
                    
//                 ],
//               ),
           
           
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
