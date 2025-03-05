import "package:flutter/material.dart";
import "package:flutter_accessibility/flutter_accessibility.dart";
import "package:flutter_availability/src/ui/widgets/base_page.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// Overview screen for all the availability templates
class AvailabilityTemplateOverview extends HookWidget {
  /// Constructor
  const AvailabilityTemplateOverview({
    required this.onExit,
    required this.onEditTemplate,
    required this.onAddTemplate,
    this.onSelectTemplate,
    super.key,
  });

  /// Callback for when the user wants to navigate back
  final VoidCallback onExit;

  /// Callback for when the user goes to edit an existing template
  final void Function(AvailabilityTemplateModel template) onEditTemplate;

  /// Callback for when the user goes to create a new template
  final void Function(AvailabilityTemplateType type) onAddTemplate;

  /// Callback for when the user selects a template
  final void Function(AvailabilityTemplateModel template)? onSelectTemplate;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var service = availabilityScope.service;
    var options = availabilityScope.options;
    var translations = options.translations;
    var identifiers = options.accessibilityIds;

    var dayTemplateStream = useMemoized(() => service.getDayTemplates());
    var weekTemplateStream = useMemoized(() => service.getWeekTemplates());

    var dayTemplatesSnapshot = useStream(dayTemplateStream);
    var weekTemplatesSnapshot = useStream(weekTemplateStream);

    useEffect(() {
      availabilityScope.popHandler.add(onExit);
      return () => availabilityScope.popHandler.remove(onExit);
    });

    var dayTemplates =
        dayTemplatesSnapshot.data ?? <AvailabilityTemplateModel>[];
    var weekTemplates =
        weekTemplatesSnapshot.data ?? <AvailabilityTemplateModel>[];

    var title = Center(
      child: Text(
        translations.templateScreenTitle,
        style: theme.textTheme.displaySmall,
      ),
    );

    var dayTemplateSection = _TemplateListSection(
      sectionTitle: translations.dayTemplates,
      createButtonText: translations.createDayTemplate,
      createButtonIdentifier: identifiers.createNewDayTemplateButtonIdentifier,
      onEditTemplate: onEditTemplate,
      onSelectTemplate: onSelectTemplate,
      onAddTemplate: () => onAddTemplate(AvailabilityTemplateType.day),
      templates: dayTemplates,
      isLoading:
          dayTemplatesSnapshot.connectionState == ConnectionState.waiting,
    );

    var weekTemplateSection = _TemplateListSection(
      sectionTitle: translations.weekTemplates,
      createButtonText: translations.createWeekTemplate,
      createButtonIdentifier: identifiers.createNewWeekTemplateButtonIdentifier,
      templates: weekTemplates,
      isLoading:
          weekTemplatesSnapshot.connectionState == ConnectionState.waiting,
      onEditTemplate: onEditTemplate,
      onSelectTemplate: onSelectTemplate,
      onAddTemplate: () => onAddTemplate(AvailabilityTemplateType.week),
    );
    var body = BasePage(
      body: [
        title,
        const SizedBox(height: 24),
        dayTemplateSection,
        const SizedBox(height: 40),
        weekTemplateSection,
      ],
      buttons: const [],
    );

    return options.baseScreenBuilder(context, onExit, body);
  }
}

/// Displays a list of templates and a button to create a new template
class _TemplateListSection extends StatelessWidget {
  const _TemplateListSection({
    required this.sectionTitle,
    required this.createButtonText,
    required this.createButtonIdentifier,
    required this.templates,
    required this.isLoading,
    required this.onEditTemplate,
    required this.onAddTemplate,
    required this.onSelectTemplate,
  });

  final String sectionTitle;
  final String createButtonText;

  /// The accessibility identifier for the create button
  final String createButtonIdentifier;

  // transform the stream to a snapshot as low as possible to reduce rebuilds
  final List<AvailabilityTemplateModel> templates;
  final bool isLoading;
  final void Function(AvailabilityTemplateModel template) onEditTemplate;
  final VoidCallback onAddTemplate;
  final void Function(AvailabilityTemplateModel template)? onSelectTemplate;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;

    void onClickTemplate(AvailabilityTemplateModel template) {
      // if the onSelectTemplate is set the user can select a template
      // The user will need to click on the edit button to edit
      (onSelectTemplate ?? onEditTemplate).call(template);
    }

    var templateCreationButton = InkWell(
      hoverColor: Colors.transparent,
      onTap: onAddTemplate,
      child: Container(
        color: Colors.transparent,
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add),
            const SizedBox(width: 8),
            CustomSemantics(
              identifier: createButtonIdentifier,
              child: options.smallTextButtonBuilder(
                context,
                onAddTemplate,
                Text(
                  createButtonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [
        Text(sectionTitle, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        const Divider(height: 1),
        for (var (index, template) in templates.indexed) ...[
          _TemplateListSectionItem(
            template: template,
            index: index,
            onTemplateClicked: onClickTemplate,
            onEditTemplate: onEditTemplate,
          ),
        ],
        if (isLoading) ...[
          options.loadingIndicatorBuilder(context),
        ],
        const SizedBox(height: 8),
        templateCreationButton,
      ],
    );
  }
}

class _TemplateListSectionItem extends StatelessWidget {
  const _TemplateListSectionItem({
    required this.template,
    required this.index,
    required this.onTemplateClicked,
    required this.onEditTemplate,
  });

  final AvailabilityTemplateModel template;

  /// The index of the template in the list
  final int index;

  final void Function(AvailabilityTemplateModel template) onTemplateClicked;
  final void Function(AvailabilityTemplateModel template) onEditTemplate;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var identifiers = options.accessibilityIds;
    var templateTypeIdentifer =
        template.templateType == AvailabilityTemplateType.day
            ? identifiers.dayTemplateEditButtonIdentifier
            : identifiers.weekTemplateEditButtonIdentifier;
    var templateIdentifier = "${templateTypeIdentifer}_$index";

    return CustomSemantics(
      identifier: templateIdentifier,
      child: InkWell(
        onTap: () => onTemplateClicked(template),
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.dividerColor,
              width: 1,
            ),
            borderRadius: options.borderRadius,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(template.color),
                  borderRadius: options.borderRadius,
                ),
                height: 20,
                width: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  template.name,
                  style: theme.textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () => onEditTemplate(template),
                child: const Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
