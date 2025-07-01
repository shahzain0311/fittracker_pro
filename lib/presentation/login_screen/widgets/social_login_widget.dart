import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final ValueChanged<String> onSocialLogin;

  const SocialLoginWidget({
    super.key,
    required this.onSocialLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Social Login Buttons
        Row(
          children: [
            // Google Login
            Expanded(
              child: _SocialLoginButton(
                onTap: () => onSocialLogin('Google'),
                icon: 'g_translate',
                label: 'Google',
                backgroundColor: Colors.white,
                borderColor: AppTheme.lightTheme.dividerColor,
                textColor: AppTheme.lightTheme.colorScheme.onSurface,
                iconColor: Colors.red,
              ),
            ),

            SizedBox(width: 3.w),

            // Apple Login
            Expanded(
              child: _SocialLoginButton(
                onTap: () => onSocialLogin('Apple'),
                icon: 'apple',
                label: 'Apple',
                backgroundColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.white,
                iconColor: Colors.white,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Facebook Login (Full Width)
        _SocialLoginButton(
          onTap: () => onSocialLogin('Facebook'),
          icon: 'facebook',
          label: 'Continue with Facebook',
          backgroundColor: const Color(0xFF1877F2),
          borderColor: const Color(0xFF1877F2),
          textColor: Colors.white,
          iconColor: Colors.white,
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final bool isFullWidth;

  const _SocialLoginButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: iconColor,
              size: 5.w,
            ),
            if (isFullWidth) ...[
              SizedBox(width: 3.w),
              Flexible(
                child: Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ] else ...[
              SizedBox(width: 2.w),
              Flexible(
                child: Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
