import 'package:template_schema/template_schema.dart';
import 'package:test/test.dart';

void main() {
  Map<String, dynamic> validJson() {
    return {
      'schemaVersion': 1,
      'id': 'tpl_001',
      'name': 'Promo Reel',
      'aspectRatio': '9:16',
      'durationMs': 15000,
      'theme': {
        'colors': {'primary': '#FF5733', 'secondary': '#101010'},
        'defaultTextStyle': {
          'fontFamily': 'Poppins',
          'fontSize': 24.0,
          'fontWeight': 'w600',
          'colorRef': 'primary',
        },
      },
      'editableTextFields': [
        {
          'id': 'headline',
          'label': 'Headline',
          'defaultText': 'Your headline',
          'maxLength': 60,
          'style': {
            'fontFamily': 'Poppins',
            'fontSize': 30.0,
            'fontWeight': 'w700',
            'colorRef': 'primary',
          },
        },
      ],
      'slots': [
        {
          'id': 'slot_1',
          'position': 'center',
          'textRef': 'headline',
          'colorRef': 'secondary',
        },
      ],
      'scenes': [
        {
          'id': 'scene_1',
          'startMs': 0,
          'endMs': 5000,
          'slotIds': ['slot_1'],
          'transition': 'fade',
        },
        {
          'id': 'scene_2',
          'startMs': 5000,
          'endMs': 15000,
          'slotIds': ['slot_1'],
          'transition': 'slide_left',
        },
      ],
    };
  }

  test('parses and serializes valid template JSON', () {
    final template = Template.fromJson(validJson());

    expect(template.schemaVersion, 1);
    expect(template.validate(), isEmpty);

    final encoded = template.toJson();
    expect(encoded['schemaVersion'], 1);
    expect(encoded['aspectRatio'], '9:16');
  });

  test('invalid aspect ratio fails validation', () {
    final json = validJson()..['aspectRatio'] = '1:1';
    final template = Template.fromJson(json);

    final issues = template.validate();
    expect(issues.any((issue) => issue.code == 'invalid_aspect_ratio'), isTrue);
  });

  test('duration over 30s fails validation', () {
    final json = validJson()..['durationMs'] = 35000;
    final template = Template.fromJson(json);

    final issues = template.validate();
    expect(
      issues.any((issue) => issue.code == 'duration_exceeds_limit'),
      isTrue,
    );
  });

  test('scene outside template duration fails validation', () {
    final json = validJson();
    (json['scenes'] as List<dynamic>)[1]['endMs'] = 20000;
    final template = Template.fromJson(json);

    final issues = template.validate();
    expect(issues.any((issue) => issue.code == 'scene_out_of_bounds'), isTrue);
  });

  test('scene slotId must exist in template slots', () {
    final json = validJson();
    (json['scenes'] as List<dynamic>)[0]['slotIds'] = ['missing_slot'];
    final template = Template.fromJson(json);

    final issues = template.validate();
    expect(issues.any((issue) => issue.code == 'unknown_scene_slot'), isTrue);
  });

  test('slot textRef must exist in editable text fields', () {
    final json = validJson();
    (json['slots'] as List<dynamic>)[0]['textRef'] = 'missing_text';
    final template = Template.fromJson(json);

    final issues = template.validate();
    expect(issues.any((issue) => issue.code == 'unknown_text_ref'), isTrue);
  });

  test('slot colorRef must exist in theme colors', () {
    final json = validJson();
    (json['slots'] as List<dynamic>)[0]['colorRef'] = 'missing_color';
    final template = Template.fromJson(json);

    final issues = template.validate();
    expect(issues.any((issue) => issue.code == 'unknown_color_ref'), isTrue);
  });
}
