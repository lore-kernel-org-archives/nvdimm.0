Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 09/10] efi: redefine type, constant, macro from generic code
Date: Wed, 17 Feb 2016 14:17:27 +0200
Message-Id: <1455711448-124103-10-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mathias Nyman <mathias.nyman@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Lv Zheng <lv.zheng@intel.com>, Mark Brown <broonie@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Generic UUID library defines structure type, macro to define UUID, and the
length of the UUID string. This patch removes duplicate data structure
definition, UUID string length constant  as well as macro for UUID handling.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/efi.h  | 14 ++++----------
 include/linux/uuid.h |  2 +-
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 3c6cbbd..1a0dad5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -21,6 +21,7 @@
 #include <linux/pfn.h>
 #include <linux/pstore.h>
 #include <linux/reboot.h>
+#include <linux/uuid.h>
 
 #include <asm/page.h>
 
@@ -43,17 +44,10 @@ typedef u16 efi_char16_t;		/* UNICODE character */
 typedef u64 efi_physical_addr_t;
 typedef void *efi_handle_t;
 
-
-typedef struct {
-	u8 b[16];
-} efi_guid_t;
+typedef uuid_le efi_guid_t;
 
 #define EFI_GUID(a,b,c,d0,d1,d2,d3,d4,d5,d6,d7) \
-((efi_guid_t) \
-{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
-  (b) & 0xff, ((b) >> 8) & 0xff, \
-  (c) & 0xff, ((c) >> 8) & 0xff, \
-  (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+	UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
 
 /*
  * Generic EFI table header
@@ -1025,7 +1019,7 @@ efi_reboot(enum reboot_mode reboot_mode, const char *__unused) {}
  * Length of a GUID string (strlen("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"))
  * not including trailing NUL
  */
-#define EFI_VARIABLE_GUID_LEN 36
+#define EFI_VARIABLE_GUID_LEN	UUID_STRING_LEN
 
 /*
  * The type of search to perform when calling boottime->locate_handle
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 6bd40d0..bb778a4 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -20,7 +20,7 @@
 
 /*
  * The length of a UUID string ("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
- * not including trailing NUL.
+ * excluding trailing NUL.
  */
 #define	UUID_STRING_LEN		36
 
-- 
2.7.0
