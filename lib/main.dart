import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/repositories/budgets_repository.dart';
import 'package:orca_e_organiza/core/repositories/event_repository.dart';
import 'package:orca_e_organiza/core/repositories/modalities_repository.dart';
import 'package:orca_e_organiza/screens/event_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EventRepository(),
      child: ChangeNotifierProvider(
        create: (context) => ModalitiesRepository(),
        child: ChangeNotifierProvider(
          create: (context) => BudgetsRepository(),
          child: MaterialApp(
            home: EventScreen(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('pt', 'BR')],
          ),
        ),
      ),
    )
  );
}

