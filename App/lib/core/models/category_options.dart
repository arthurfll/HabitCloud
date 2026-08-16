/// Mirrors Core's CategoryOptions (Core/Source/Models/CategoryOptions.cs) so the picker works
/// immediately offline. SyncService refreshes this from GET /api/metadata/category-options
/// whenever it can reach Core, so a future change to Core's list self-corrects without an app update.
class CategoryOptions {
  CategoryOptions._();

  static const maxCategoriesPerUser = 20;

  static const icons = <String>[
    'bi-briefcase', 'bi-laptop', 'bi-building', 'bi-clipboard-check',
    'bi-heart-pulse', 'bi-bicycle', 'bi-trophy', 'bi-activity',
    'bi-book', 'bi-moon-stars', 'bi-brightness-high', 'bi-stars',
    'bi-mortarboard', 'bi-pencil', 'bi-journal-text',
    'bi-cup-hot', 'bi-egg-fried', 'bi-apple',
    'bi-wallet2', 'bi-cash-coin', 'bi-piggy-bank',
    'bi-house', 'bi-alarm', 'bi-brush',
    'bi-controller', 'bi-music-note-beamed', 'bi-palette', 'bi-camera',
    'bi-people', 'bi-chat-heart',
    'bi-moon', 'bi-droplet', 'bi-tree',
    'bi-airplane', 'bi-cloud', 'bi-plus-lg', 'bi-globe', 'bi-umbrella',
  ];

  static const colors = <String>[
    '#0d6efd', '#6610f2', '#6f42c1', '#d63384',
    '#dc3545', '#fd7e14', '#ffc107', '#198754',
    '#20c997', '#0dcaf0', '#0d9488', '#84cc16',
    '#f43f5e', '#6c757d', '#495057', '#212529',
  ];
}
