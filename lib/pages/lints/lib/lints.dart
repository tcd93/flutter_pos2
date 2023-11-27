import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _Linter();

class DisallowDirectDatabaseImports extends DartLintRule {
  /// Metadata about the warning that will show-up in the IDE.
  /// This is used for `// ignore: code` and enabling/disabling the lint
  static const _code = LintCode(
    name: 'disallow_direct_repo_imports',
    problemMessage:
        'Don\'t import /database directly in UI layer, use /data layer instead',
  );

  DisallowDirectDatabaseImports() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addImportDirective((node) {
      String path = node.uri.stringValue ?? '';
      if (!path.contains('_database.dart') && !path.contains('models.dart'))
        return;
      node.root.visitChildren(_ClassVisitor(
        () => reporter.reportErrorForNode(_code, node),
      ));
    });
  }
}

class _ClassVisitor extends SimpleAstVisitor {
  final void Function() visitWidgetCallback;

  _ClassVisitor(this.visitWidgetCallback);

  @override
  visitClassDeclaration(ClassDeclaration node) {
    final superClass = node.extendsClause?.superclass.toString();
    if (superClass == null) return;
    if (superClass.contains('Widget')) {
      visitWidgetCallback();
    }
  }
}

/// A plugin class is used to list all the assists/lints defined by a plugin.
class _Linter extends PluginBase {
  /// We list all the custom warnings/infos/errors
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [
      DisallowDirectDatabaseImports(),
    ];
  }
}
