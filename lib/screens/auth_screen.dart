import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isRegistering = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.space4),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppTheme.space8),
                    _buildBrandMark(),
                    const SizedBox(height: AppTheme.space8),
                    Text(
                      _isRegistering ? 'JOIN THE FIELD' : 'WELCOME BACK',
                      textAlign: TextAlign.center,
                      style: textTheme.displayMedium?.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space2),
                    Text(
                      _isRegistering
                          ? 'Create your researcher account.'
                          : 'Continue your botanical expedition.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppTheme.outline,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space8),
                    _buildAuthCard(textTheme),
                    const SizedBox(height: AppTheme.space6),
                    _buildModeSwitcher(textTheme),
                    const SizedBox(height: AppTheme.space8),
                    Text(
                      'FLORADEX // FIELD RESEARCH TERMINAL',
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppTheme.outline,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBrandMark() {
    return Center(
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          border: Border.all(color: AppTheme.primary, width: 3),
          boxShadow: const [
            BoxShadow(color: AppTheme.primary, offset: Offset(-4, -4)),
            BoxShadow(color: AppTheme.onSurface, offset: Offset(4, 4)),
          ],
        ),
        child: const Icon(
          Icons.local_florist,
          size: 48,
          color: AppTheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildAuthCard(TextTheme textTheme) {
    return Container(
      color: AppTheme.surfaceContainerLowest,
      padding: const EdgeInsets.all(AppTheme.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'EMAIL ACCESS',
            style: textTheme.displaySmall?.copyWith(
              color: AppTheme.secondary,
            ),
          ),
          const SizedBox(height: AppTheme.space4),
          TextField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: AppTheme.primary,
            decoration: const InputDecoration(
              labelText: 'EMAIL',
              hintText: 'researcher@example.com',
              prefixIcon: Icon(Icons.alternate_email),
            ),
          ),
          const SizedBox(height: AppTheme.space4),
          TextField(
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            cursorColor: AppTheme.primary,
            decoration: InputDecoration(
              labelText: 'PASSWORD',
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
          if (_isRegistering) ...[
            const SizedBox(height: AppTheme.space4),
            TextField(
              obscureText: true,
              textInputAction: TextInputAction.done,
              cursorColor: AppTheme.primary,
              decoration: const InputDecoration(
                labelText: 'CONFIRM PASSWORD',
                hintText: 'Repeat your password',
                prefixIcon: Icon(Icons.verified_user_outlined),
              ),
            ),
          ],
          if (!_isRegistering) ...[
            const SizedBox(height: AppTheme.space2),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('FORGOT PASSWORD?'),
              ),
            ),
          ],
          const SizedBox(height: AppTheme.space4),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(_isRegistering ? 'CREATE ACCOUNT' : 'SIGN IN'),
            ),
          ),
          const SizedBox(height: AppTheme.space6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: SizedBox(
                  height: AppTheme.space1,
                  child: ColoredBox(color: AppTheme.surfaceContainerHigh),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space4,
                ),
                child: Text('OR', style: textTheme.labelMedium),
              ),
              const Expanded(
                child: SizedBox(
                  height: AppTheme.space1,
                  child: ColoredBox(color: AppTheme.surfaceContainerHigh),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.space6),
          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.account_circle_outlined),
              label: const Text('CONTINUE WITH GOOGLE'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSwitcher(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isRegistering ? 'Already a researcher?' : 'New to FloraDex?',
          style: textTheme.bodyMedium?.copyWith(color: AppTheme.outline),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isRegistering = !_isRegistering;
              _obscurePassword = true;
            });
          },
          child: Text(_isRegistering ? 'SIGN IN' : 'REGISTER'),
        ),
      ],
    );
  }
}
