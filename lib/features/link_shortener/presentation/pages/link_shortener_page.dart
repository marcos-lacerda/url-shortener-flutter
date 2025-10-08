import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_shortener/app/di/injection.dart';
import 'package:url_shortener/core/theme/app_spacing.dart';
import 'package:url_shortener/features/link_shortener/domain/entities/short_link.dart';
import 'package:url_shortener/features/link_shortener/presentation/controllers/link_shortener_controller.dart';
import 'package:url_shortener/features/link_shortener/presentation/controllers/link_shortener_state.dart';
import 'package:url_shortener/features/link_shortener/presentation/widgets/app_error_message.dart';
import 'package:url_shortener/features/link_shortener/presentation/widgets/app_list.dart';
import 'package:url_shortener/features/link_shortener/presentation/widgets/app_text_field.dart';
import 'package:url_shortener/features/link_shortener/presentation/widgets/empty_state.dart';
import 'package:url_shortener/features/link_shortener/presentation/widgets/send_button.dart';
import 'package:url_shortener/l10n/app_localizations.dart';
import 'package:url_shortener/l10n/error_localizer.dart';

class LinkShortenerPage extends StatefulWidget {
  const LinkShortenerPage({super.key});

  @override
  State<LinkShortenerPage> createState() => _LinkShortenerState();
}

class _LinkShortenerState extends State<LinkShortenerPage> {
  late final TextEditingController _urlTextFieldController;

  @override
  void initState() {
    super.initState();
    _urlTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _urlTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LinkShortenerController>(
      create: (_) => getIt<LinkShortenerController>(),
      child: _LinkShortenerView(
        urlTextFieldController: _urlTextFieldController,
      ),
    );
  }
}

class _LinkShortenerView extends StatelessWidget {
  const _LinkShortenerView({required this.urlTextFieldController});

  final TextEditingController urlTextFieldController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LinkShortenerController, LinkShortenerState>(
      builder: (context, state) {
        return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            behavior: HitTestBehavior.translucent,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(AppLocalizations.of(context)!.appTitle),
              ),
              body: SafeArea(
                child: Padding(
                  padding: AppSpacing.all(AppSpacing.lg),
                  child: Column(
                    spacing: AppSpacing.xl,
                    children: [
                      Row(
                        spacing: AppSpacing.md,
                        children: [
                          _buildURLTextField(context),
                          _buildSendButton(context),
                        ],
                      ),
                      _buildErrorMessage(context),
                      _buildLoadingState(context),
                      _buildListURL(context),
                      _buildEmptyState(context),
                    ],
                  ),
                ),
              ),
            )
        );
      },
    );
  }

  // #region URL TextField Builder
  Widget _buildURLTextField(BuildContext context) {
    final controller = context.read<LinkShortenerController>();
    return Expanded(
      child: AppTextField(
        controller: urlTextFieldController,
        hint: AppLocalizations.of(context)!.ls_inputHint,
        prefix: const Icon(Icons.link),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.url,
        suffix: IconButton(
          icon: const Icon(Icons.close),
          onPressed: urlTextFieldController.clear,
        ),
        onSubmitted: (_) => controller.shorten(urlTextFieldController.text),
      ),
    );
  }
  // #endregion

  // #region Send Button Builder
  Widget _buildSendButton(BuildContext context) {
    final controller = context.read<LinkShortenerController>();
    return SendButton(
      icon: Icons.send_rounded,
      onPressed: () => controller.shorten(urlTextFieldController.text),
      backgroundColor: Theme.of(context).colorScheme.primary,
      iconColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
  // #endregion

  // #region URL List Builder
  Widget _buildListURL(BuildContext context) {
    final controller = context.read<LinkShortenerController>();
    return BlocSelector<
      LinkShortenerController,
      LinkShortenerState,
      LinkShortenerState
    >(
      selector: (s) => s,
      builder: (context, state) {
        if ((state is LinkShortenerLoading) || state.items.isEmpty) {
          return const SizedBox.shrink();
        }
        return Flexible(
          child: AppList<ShortLink>(
            title: AppLocalizations.of(context)!.ls_list_title,
            items: state.items,
            itemBuilder: (context, item) {
              return ListTile(
                leading: const Icon(Icons.link),
                title: Text(item.short.toString()),
                onTap: () => controller.open(item),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => controller.deleteLink(item),
                ),
              );
            },
          ),
        );
      },
    );
  }
  // #endregion

  // #region Loading State Builder
  Widget _buildLoadingState(BuildContext context) {
    return BlocSelector<
      LinkShortenerController,
      LinkShortenerState,
      LinkShortenerLoading?
    >(
      selector: (s) => s is LinkShortenerLoading ? s : null,
      builder: (context, state) {
        if (state == null) return const SizedBox.shrink();
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
  // #endregion

  // #region Error Message Builder
  Widget _buildErrorMessage(BuildContext context) {
    final controller = context.read<LinkShortenerController>();

    return BlocSelector<
      LinkShortenerController,
      LinkShortenerState,
      LinkShortenerError?
    >(
      selector: (s) => s is LinkShortenerError ? s : null,
      builder: (context, state) {
        if (state == null) return const SizedBox.shrink();
        return AppErrorMessage(
          message: ErrorLocalizer(
            AppLocalizations.of(context)!,
          ).byCode(state.errorCode),
          onClose: controller.clearError,
        );
      },
    );
  }
  // #endregion

  // #region Empty State Builder
  Widget _buildEmptyState(BuildContext context) {
    return BlocSelector<
      LinkShortenerController,
      LinkShortenerState,
      LinkShortenerState
    >(
      selector: (s) => s,
      builder: (context, state) {
        if ((state is LinkShortenerLoading) || state.items.isNotEmpty) {
          return const SizedBox.shrink();
        }

        return EmptyState(
          icon: Icons.link_off,
          title: AppLocalizations.of(context)!.ls_emptyState_title,
          message: AppLocalizations.of(context)!.ls_emptyState_message,
        );
      },
    );
  }

  // #endregion
}
