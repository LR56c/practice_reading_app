// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nhost_flutter_graphql/nhost_flutter_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:practice_reading_app/l10n/l10n.dart';

final nhostClient =
    NhostClient(backendUrl: 'https://nwkoltnkfqkhunjefvbt.nhost.run');

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return NhostGraphQLProvider(
      nhostClient: nhostClient,
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color(0xFF13B9FF),
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("title"),
          ),
          body: Subscription(
            options: SubscriptionOptions(document: gql('''
              subscription  {
                todos {
                  name
                }
              }
                ''')),
            builder: (result, {fetchMore, refetch}) {
              log('$result');
              if (result.hasException) {
                return Center(child: Text(result.exception.toString()));
              }

              if (result.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final todos = result.data!['todos'] as List<dynamic>;

              if (todos.isEmpty) {
                return const Center(child: Text('No books'));
              }

              return Column(
                children: [
                  for (final item in todos)
                    Text('${item['name']}'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
