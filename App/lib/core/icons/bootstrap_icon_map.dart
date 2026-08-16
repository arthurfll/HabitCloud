import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/widgets.dart';

/// Maps the "bi-*" icon names used by Core's CategoryOptions.Icons (Core/Source/Models/CategoryOptions.cs)
/// to the matching glyph from the `bootstrap_icons` package, which vendors the exact same Bootstrap
/// Icons 1.13.1 font Core serves on the web — so a category looks pixel-identical on both platforms.
/// Kept in sync manually with CategoryOptions.Icons; the app also fetches that list at runtime from
/// GET /api/metadata/category-options and falls back to [IconData] lookup by name via this map.
const Map<String, IconData> bootstrapIconMap = {
  'bi-briefcase': BootstrapIcons.briefcase,
  'bi-laptop': BootstrapIcons.laptop,
  'bi-building': BootstrapIcons.building,
  'bi-clipboard-check': BootstrapIcons.clipboard_check,
  'bi-heart-pulse': BootstrapIcons.heart_pulse,
  'bi-bicycle': BootstrapIcons.bicycle,
  'bi-trophy': BootstrapIcons.trophy,
  'bi-activity': BootstrapIcons.activity,
  'bi-book': BootstrapIcons.book,
  'bi-moon-stars': BootstrapIcons.moon_stars,
  'bi-brightness-high': BootstrapIcons.brightness_high,
  'bi-stars': BootstrapIcons.stars,
  'bi-mortarboard': BootstrapIcons.mortarboard,
  'bi-pencil': BootstrapIcons.pencil,
  'bi-journal-text': BootstrapIcons.journal_text,
  'bi-cup-hot': BootstrapIcons.cup_hot,
  'bi-egg-fried': BootstrapIcons.egg_fried,
  'bi-apple': BootstrapIcons.apple,
  'bi-wallet2': BootstrapIcons.wallet2,
  'bi-cash-coin': BootstrapIcons.cash_coin,
  'bi-piggy-bank': BootstrapIcons.piggy_bank,
  'bi-house': BootstrapIcons.house,
  'bi-alarm': BootstrapIcons.alarm,
  'bi-brush': BootstrapIcons.brush,
  'bi-controller': BootstrapIcons.controller,
  'bi-music-note-beamed': BootstrapIcons.music_note_beamed,
  'bi-palette': BootstrapIcons.palette,
  'bi-camera': BootstrapIcons.camera,
  'bi-people': BootstrapIcons.people,
  'bi-chat-heart': BootstrapIcons.chat_heart,
  'bi-moon': BootstrapIcons.moon,
  'bi-droplet': BootstrapIcons.droplet,
  'bi-tree': BootstrapIcons.tree,
  'bi-airplane': BootstrapIcons.airplane,
  'bi-cloud': BootstrapIcons.cloud,
  'bi-plus-lg': BootstrapIcons.plus_lg,
  'bi-globe': BootstrapIcons.globe,
  'bi-umbrella': BootstrapIcons.umbrella,
};

IconData iconFor(String biName) => bootstrapIconMap[biName] ?? BootstrapIcons.question_circle;
