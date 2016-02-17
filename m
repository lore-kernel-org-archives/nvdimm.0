Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 04/10] lib/uuid: remove FSF address
Date: Wed, 17 Feb 2016 14:17:22 +0200
Message-Id: <1455711448-124103-5-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mathias Nyman <mathias.nyman@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Lv Zheng <lv.zheng@intel.com>, Mark Brown <broonie@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

There is no point to keep an address in the file since it's a subject to
change.

While here, update Intel Copyright years.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/uuid.h      | 6 +-----
 include/uapi/linux/uuid.h | 4 ----
 lib/uuid.c                | 6 +-----
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 616347f..6bd40d0 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -1,7 +1,7 @@
 /*
  * UUID/GUID definition
  *
- * Copyright (C) 2010, Intel Corp.
+ * Copyright (C) 2010, 2015 Intel Corp.
  *	Huang Ying <ying.huang@intel.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 #ifndef _LINUX_UUID_H_
 #define _LINUX_UUID_H_
diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
index 786f077..3738e5f 100644
--- a/include/uapi/linux/uuid.h
+++ b/include/uapi/linux/uuid.h
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef _UAPI_LINUX_UUID_H_
diff --git a/lib/uuid.c b/lib/uuid.c
index 995865c..0918232 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -1,7 +1,7 @@
 /*
  * Unified UUID/GUID definition
  *
- * Copyright (C) 2009, Intel Corp.
+ * Copyright (C) 2009, 2015 Intel Corp.
  *	Huang Ying <ying.huang@intel.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/kernel.h>
-- 
2.7.0
