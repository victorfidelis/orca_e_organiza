import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/repositories/budgets_repository.dart';
import 'package:orca_e_organiza/core/repositories/event_repository.dart';
import 'package:orca_e_organiza/core/repositories/modalities_repository.dart';
import 'package:orca_e_organiza/screens/event_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

/*
App organizador e orçador de eventos, reformas e afins.

Através deste aplicativo o usuário cria eventos onde pode cadastrar qualquer tipo de tópico orçamentário 
(chamados no app de modalidades). Dentro de cada modalidade pode-se cadastrar diversos orçamentos e 
compará-los. Além disso, o usuário pode selecionar o melhor orçamento de cada modalidade, e, ao fazê-lo, o 
aplicativo calcula o orçamento total do seu evento, fazendo com que o usuário tenha um controle total de 
gastos.
*/

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

