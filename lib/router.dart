part of 'main.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/schedule',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => TabsPage(navigationShell),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/schedule',
              name: 'schedule',
              pageBuilder: (context, state) => const NoTransitionPage(child: SchedulePage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/clients',
              name: 'clients',
              pageBuilder: (context, state) => const NoTransitionPage(child: ClientsPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/inventory',
              name: 'inventory',
              pageBuilder: (context, state) => const NoTransitionPage(child: InventoryPage()),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/add_client',
      name: 'add_client',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const AddClientPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
        path: '/client_info/:client_id',
        name: 'client_info',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: ClientAndServicesPage(state.pathParameters['client_id']!),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                  child: child,
                );
              });
        }),
    GoRoute(
      path: '/add_note',
      name: 'add_note',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: AddNotePage(state.extra as DateTime?),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/edit_note',
      name: 'edit_note',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: EditNotePage(state.extra as NoteModel),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
