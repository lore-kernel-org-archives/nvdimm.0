Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5E1F2203D614
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 08:44:16 -0800 (PST)
Subject: [ndctl PATCH] libdaxctl: use the same uuid definition as libdaxctl
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Nov 2017 08:40:08 -0800
Message-ID: <151059120823.1173.7255627659909695931.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Lukasz Plewa <lukasz.plewa@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

libdaxtl inadvertently included the uuid-devel version of the uuid.h
header rather than the libuuid header. Fix this up to avoid type
conflicts for applications that include both libdaxctl.h and libndctl.h.

Reported-by: Lukasz Plewa <lukasz.plewa@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/libdaxctl.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 77f6a25d2e30..21bc376ce629 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -15,7 +15,12 @@
 
 #include <stdarg.h>
 #include <unistd.h>
-#include <uuid.h>
+
+#ifdef HAVE_LIBUUID
+#include <uuid/uuid.h>
+#else
+typedef unsigned char uuid_t[16];
+#endif
 
 #ifdef __cplusplus
 extern "C" {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
