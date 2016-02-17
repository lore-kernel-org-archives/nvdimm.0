Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 01/10] lib/vsprintf: simplify UUID printing
Date: Wed, 17 Feb 2016 14:17:19 +0200
Message-Id: <1455711448-124103-2-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mathias Nyman <mathias.nyman@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Lv Zheng <lv.zheng@intel.com>, Mark Brown <broonie@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Since we have hex_byte_pack_upper() we may use it directly and avoid second
loop.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/vsprintf.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 525c8e1..17d976b 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1324,7 +1324,10 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	}
 
 	for (i = 0; i < 16; i++) {
-		p = hex_byte_pack(p, addr[index[i]]);
+		if (uc)
+			p = hex_byte_pack_upper(p, addr[index[i]]);
+		else
+			p = hex_byte_pack(p, addr[index[i]]);
 		switch (i) {
 		case 3:
 		case 5:
@@ -1337,13 +1340,6 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 
 	*p = 0;
 
-	if (uc) {
-		p = uuid;
-		do {
-			*p = toupper(*p);
-		} while (*(++p));
-	}
-
 	return string(buf, end, uuid, spec);
 }
 
-- 
2.7.0
