Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 07/10] sysctl: drop away useless label
Date: Wed, 17 Feb 2016 14:17:25 +0200
Message-Id: <1455711448-124103-8-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mathias Nyman <mathias.nyman@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Lv Zheng <lv.zheng@intel.com>, Mark Brown <broonie@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

We have no locking in bin_uuid(). Thus, we may remove the out label and use
return statements directly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 kernel/sysctl_binary.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 7e7746a..509abe4 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1123,15 +1123,14 @@ static ssize_t bin_uuid(struct file *file,
 
 		result = kernel_read(file, 0, buf, sizeof(buf) - 1);
 		if (result < 0)
-			goto out;
+			return result;
 
 		buf[result] = '\0';
 
 		/* Convert the uuid to from a string to binary */
 		for (i = 0; i < 16; i++) {
-			result = -EIO;
 			if (!isxdigit(str[0]) || !isxdigit(str[1]))
-				goto out;
+				return -EIO;
 
 			uuid[i] = (hex_to_bin(str[0]) << 4) |
 					hex_to_bin(str[1]);
@@ -1143,15 +1142,12 @@ static ssize_t bin_uuid(struct file *file,
 		if (oldlen > 16)
 			oldlen = 16;
 
-		result = -EFAULT;
 		if (copy_to_user(oldval, uuid, oldlen))
-			goto out;
+			return -EFAULT;
 
 		copied = oldlen;
 	}
-	result = copied;
-out:
-	return result;
+	return copied;
 }
 
 static ssize_t bin_dn_node_address(struct file *file,
-- 
2.7.0
