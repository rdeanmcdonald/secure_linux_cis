# @api private
#
# Ensure grub bootloader password is set (Scored)
#
# Description:
# Setting bootloader password will require a username and password to change default boot options
#
# @summary Ensure bootloader password is set (Scored)
#
# @see https://www.gnu.org/software/grub/manual/grub/grub.html
#
# @see https://github.com/ryran/burg2-mkpasswd-pbkdf2
#
# @param enforced
#   Should this rule be enforced - defaults to false
#
# @param grub_username
#   Account name to authenticate against - defaults to root
#
# @param grub_password_hash
#   String with value of pwssword in GRUB PBKDF2 format
#
# @note IMPORTANT:
#   grub_pbkdf2_password_hash must be set in hiera to implement. See associated grub documentation
#   and test on non-production machines before using elsewhere in your environment
# 
# @example Using hiera
#   secure_linux_cis::rules::ensure_bootloader_password_is_set::enforced: true
#   secure_linux_cis::rules::ensure_bootloader_password_is_set::grub_username: root
#   secure_linux_cis::rules::ensure_bootloader_password_is_set::grub_pbkdf2_password_hash: grub.pbkdf2.sha512.10000.7D81626...ABC0123C616C3210CBA
#

class secure_linux_cis::rules::ensure_bootloader_password_is_set(
  String $grub_pbkdf2_password_hash,
  String $grub_username = root,
  Boolean $enforced = false,
) {
  if $enforced {
    if $facts['grub_pass'] == undef {
      notify { 'gp':
        message  => 'Not in compliance with CIS (Scored). Grub bootloader does not have a set password. Ensuring password is set', #lint:ignore:140chars
        loglevel => 'warning',
      }
    }
    grub_user { $grub_username:
        password => $grub_pbkdf2_password_hash
    }
  }
}
