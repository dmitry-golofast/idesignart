import * as migration_20260922_101054_initial_schema from './20260922_101054_initial_schema';
import * as migration_20260922_114129_add_header_global from './20260922_114129_add_header_global';
import * as migration_20261012_105926_portfolio_grid__drop_showAllButton from './20261012_105926_portfolio_grid__drop_showAllButton';
import * as migration_20261012_105942_portfolio_grid__add_showFilters_and_facts_cards from './20261012_105942_portfolio_grid__add_showFilters_and_facts_cards';
import * as migration_20261012_121240_portfolio_block_manual_projects__categories_order from './20261012_121240_portfolio_block_manual_projects__categories_order';
import * as migration_20261013_073214_drop_hero_appearance_group from './20261013_073214_drop_hero_appearance_group';
import * as migration_20261013_084339_stats_cards__add_icon_description_image from './20261013_084339_stats_cards__add_icon_description_image';

export const migrations = [
  {
    up: migration_20260922_101054_initial_schema.up,
    down: migration_20260922_101054_initial_schema.down,
    name: '20260922_101054_initial_schema',
  },
  {
    up: migration_20260922_114129_add_header_global.up,
    down: migration_20260922_114129_add_header_global.down,
    name: '20260922_114129_add_header_global',
  },
  {
    up: migration_20261012_105926_portfolio_grid__drop_showAllButton.up,
    down: migration_20261012_105926_portfolio_grid__drop_showAllButton.down,
    name: '20261012_105926_portfolio_grid__drop_showAllButton',
  },
  {
    up: migration_20261012_105942_portfolio_grid__add_showFilters_and_facts_cards.up,
    down: migration_20261012_105942_portfolio_grid__add_showFilters_and_facts_cards.down,
    name: '20261012_105942_portfolio_grid__add_showFilters_and_facts_cards',
  },
  {
    up: migration_20261012_121240_portfolio_block_manual_projects__categories_order.up,
    down: migration_20261012_121240_portfolio_block_manual_projects__categories_order.down,
    name: '20261012_121240_portfolio_block_manual_projects__categories_order',
  },
  {
    up: migration_20261013_073214_drop_hero_appearance_group.up,
    down: migration_20261013_073214_drop_hero_appearance_group.down,
    name: '20261013_073214_drop_hero_appearance_group',
  },
  {
    up: migration_20261013_084339_stats_cards__add_icon_description_image.up,
    down: migration_20261013_084339_stats_cards__add_icon_description_image.down,
    name: '20261013_084339_stats_cards__add_icon_description_image'
  },
];
