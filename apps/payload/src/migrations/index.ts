import * as migration_20260922_101054_initial_schema from './20260922_101054_initial_schema';
import * as migration_20260922_114129_add_header_global from './20260922_114129_add_header_global';

export const migrations = [
  {
    up: migration_20260922_101054_initial_schema.up,
    down: migration_20260922_101054_initial_schema.down,
    name: '20260922_101054_initial_schema',
  },
  {
    up: migration_20260922_114129_add_header_global.up,
    down: migration_20260922_114129_add_header_global.down,
    name: '20260922_114129_add_header_global'
  },
];
