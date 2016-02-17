Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 08/10] sysctl: use generic UUID library
Date: Wed, 17 Feb 2016 14:17:26 +0200
Message-Id: <1455711448-124103-9-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mathias Nyman <mathias.nyman@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Lv Zheng <lv.zheng@intel.com>, Mark Brown <broonie@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

UUID library provides uuid_be type and uuid_be_to_bin() function. This
substitutes open coded variant by generic library calls.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 kernel/sysctl_binary.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 509abe4..4e5ca94 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -13,6 +13,7 @@
 #include <linux/ctype.h>
 #include <linux/netdevice.h>
 #include <linux/kernel.h>
+#include <linux/uuid.h>
 #include <linux/slab.h>
 #include <linux/compat.h>
 
@@ -1117,9 +1118,8 @@ static ssize_t bin_uuid(struct file *file,
 
 	/* Only supports reads */
 	if (oldval && oldlen) {
-		char buf[40], *str = buf;
-		unsigned char uuid[16];
-		int i;
+		char buf[UUID_STRING_LEN + 1];
+		uuid_be uuid;
 
 		result = kernel_read(file, 0, buf, sizeof(buf) - 1);
 		if (result < 0)
@@ -1128,21 +1128,13 @@ static ssize_t bin_uuid(struct file *file,
 		buf[result] = '\0';
 
 		/* Convert the uuid to from a string to binary */
-		for (i = 0; i < 16; i++) {
-			if (!isxdigit(str[0]) || !isxdigit(str[1]))
-				return -EIO;
-
-			uuid[i] = (hex_to_bin(str[0]) << 4) |
-					hex_to_bin(str[1]);
-			str += 2;
-			if (*str == '-')
-				str++;
-		}
+		if (uuid_be_to_bin(buf, &uuid))
+			return -EIO;
 
 		if (oldlen > 16)
 			oldlen = 16;
 
-		if (copy_to_user(oldval, uuid, oldlen))
+		if (copy_to_user(oldval, &uuid, oldlen))
 			return -EFAULT;
 
 		copied = oldlen;
-- 
2.7.0
