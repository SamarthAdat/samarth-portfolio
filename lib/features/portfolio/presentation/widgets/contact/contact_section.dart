import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../controllers/contact_form_controller.dart';
import 'contact_form_field.dart';

/// Body of the Contact tab: the message form.
///
/// The widget owns only layout and feedback; field values, validation rules,
/// and delivery all live in [ContactFormController].
class ContactSection extends StatefulWidget {
  final ContactFormController controller;

  const ContactSection({super.key, required this.controller});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    final ContactSubmissionOutcome? outcome = await widget.controller.submit();
    if (outcome == null || !mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(outcome.message)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.cardLight.withValues(alpha: 0.74),
            AppColors.card,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool twoColumns = constraints.maxWidth > 680;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Send Message',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Share your project goal, timeline, and expected outcome. I will reply via email.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.muted,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                if (twoColumns)
                  Row(
                    children: <Widget>[
                      Expanded(child: _buildNameField()),
                      const SizedBox(width: 22),
                      Expanded(child: _buildEmailField()),
                    ],
                  )
                else ...<Widget>[
                  _buildNameField(),
                  const SizedBox(height: 18),
                  _buildEmailField(),
                ],
                const SizedBox(height: 22),
                ContactFormField(
                  controller: widget.controller.subjectController,
                  hint: 'Subject',
                  validator: widget.controller.validator.validateSubject,
                ),
                const SizedBox(height: 22),
                ContactFormField(
                  controller: widget.controller.messageController,
                  hint: 'Project brief',
                  maxLines: 6,
                  validator: widget.controller.validator.validateBody,
                ),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerRight,
                  child: _SubmitButton(
                    controller: widget.controller,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameField() {
    return ContactFormField(
      controller: widget.controller.nameController,
      hint: 'Full name',
      validator: widget.controller.validator.validateName,
    );
  }

  Widget _buildEmailField() {
    return ContactFormField(
      controller: widget.controller.emailController,
      hint: 'Email address',
      keyboardType: TextInputType.emailAddress,
      validator: widget.controller.validator.validateEmail,
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final ContactFormController controller;
  final VoidCallback onPressed;

  const _SubmitButton({required this.controller, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        final bool isSending = controller.isSending;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ElevatedButton.icon(
            onPressed: isSending ? null : onPressed,
            icon: isSending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_outlined),
            label: Text(isSending ? 'Sending...' : 'Send Message'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cardLight,
              foregroundColor: AppColors.accent,
              disabledBackgroundColor: AppColors.cardLight,
              disabledForegroundColor: AppColors.muted,
              elevation: 14,
              shadowColor: Colors.black.withValues(alpha: 0.35),
              padding: const EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.9),
                ),
              ),
              textStyle: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        );
      },
    );
  }
}
