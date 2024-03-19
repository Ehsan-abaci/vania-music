import 'package:vania/vania.dart';
import 'package:nicmusic/app/providers/route_service_povider.dart';

import 'cors.dart';

Map<String, dynamic> config = {
  'name': 'nicmusic',
  'key': 'EMjwzWDkuzfIZz8ZDT9545r6nMcx0204uTAp-Y9lwpI=',
  'port': 8000,
  'host': '0.0.0.0',
  'debug': true,
  'url': '',
  'timezone': '',
  'websocket': false,
  'isolate': false,
  'isolateCount': 4,
  'cors': cors,
  'database': null,//databaseConfig,
  'cache': CacheConfig(),
  'auth':'',
  'storage': FileStorageConfig(),
  'providers': <ServiceProvider>[
    RouteServiceProvider(),
  ],
};
