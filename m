Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C54B1A1E46
 for <linux-nvdimm@lists.01.org>; Wed, 12 Oct 2016 13:43:57 -0700 (PDT)
Subject: [ndctl PATCH] libndctl: fix 'type-pun' warnings with hpe1 commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Oct 2016 13:40:41 -0700
Message-ID: <147630484183.28641.3160414367749359017.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Fix warnings of the form:

    libndctl-hpe1.c: In function 'hpe1_smart_valid':
    libndctl-hpe1.c:78:15: warning: dereferencing type-punned pointer will
        break strict-aliasing rules [-Wstrict-aliasing]
        CMD_HPE1(cmd)->gen.nd_family != NVDIMM_FAMILY_HPE1 ||
        ^
    libndctl-hpe1.c:79:15: warning: dereferencing type-punned pointer will
        break strict-aliasing rules [-Wstrict-aliasing]
        CMD_HPE1(cmd)->gen.nd_command != NDN_HPE1_CMD_SMART ||
        ^
    libndctl-hpe1.c: In function 'hpe1_cmd_smart_get_flags':
    libndctl-hpe1.c:93:55: warning: dereferencing type-punned pointer will
        break strict-aliasing rules [-Wstrict-aliasing]
    libndctl-hpe1.c:93:55: warning: dereferencing type-punned pointer will
        break strict-aliasing rules [-Wstrict-aliasing]
    libndctl-hpe1.c: In function 'hpe1_cmd_smart_get_health':
    libndctl-hpe1.c:121:56: warning: dereferencing type-punned pointer will
        break strict-aliasing rules [-Wstrict-aliasing]
    libndctl-hpe1.c:121:56: warning: dereferencing type-punned pointer will
        break strict-aliasing rules [-Wstrict-aliasing]

...for distributions that include "-Wstrict-aliasing" in CFLAGS.

Cc: Brian Boylston <brian.boylston@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl-hpe1.c    |    8 +++-----
 ndctl/lib/libndctl-private.h |    2 ++
 ndctl/lib/ndctl-hpe1.h       |   24 +++++++++++++++---------
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/ndctl/lib/libndctl-hpe1.c b/ndctl/lib/libndctl-hpe1.c
index 48d8e02cf46e..ec542527e509 100644
--- a/ndctl/lib/libndctl-hpe1.c
+++ b/ndctl/lib/libndctl-hpe1.c
@@ -19,11 +19,9 @@
 
 #include "ndctl-hpe1.h"
 
-#define CMD_HPE1(_c) ((struct ndn_pkg_hpe1 *)((_c)->cmd_buf))
-#define CMD_HPE1_SMART(_c) \
-	((struct ndn_hpe1_smart_data *)(CMD_HPE1(_c)->u.smart.data))
-#define CMD_HPE1_SMART_THRESH(_c) \
-	((struct ndn_hpe1_smart_threshold_data *)(CMD_HPE1(_c)->u.thresh.data))
+#define CMD_HPE1(_c) ((_c)->hpe1)
+#define CMD_HPE1_SMART(_c) (CMD_HPE1(_c)->u.smart.data)
+#define CMD_HPE1_SMART_THRESH(_c) (CMD_HPE1(_c)->u.thresh.data)
 
 static struct ndctl_cmd *hpe1_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 {
diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
index 4363f2373d7b..0dc9e30cdb6e 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/libndctl-private.h
@@ -31,6 +31,7 @@
 #include <ndctl/libndctl.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
+#include "ndctl-hpe1.h"
 
 #define SZ_16M 0x01000000
 
@@ -191,6 +192,7 @@ struct ndctl_cmd {
 #ifdef HAVE_NDCTL_CLEAR_ERROR
 		struct nd_cmd_clear_error clear_err[0];
 #endif
+		struct ndn_pkg_hpe1 hpe1[0];
 		struct nd_cmd_smart smart[0];
 		struct nd_cmd_smart_threshold smart_t[0];
 		struct nd_cmd_get_config_size get_size[0];
diff --git a/ndctl/lib/ndctl-hpe1.h b/ndctl/lib/ndctl-hpe1.h
index 0d41aab4e64f..b050831ec2c4 100644
--- a/ndctl/lib/ndctl-hpe1.h
+++ b/ndctl/lib/ndctl-hpe1.h
@@ -33,12 +33,6 @@ enum {
 };
 
 /* NDN_HPE1_CMD_SMART */
-struct ndn_hpe1_smart {
-	__u32 in_valid_flags;
-	__u32 status;
-	__u8 data[124];
-} __attribute__((packed));
-
 /* ndn_hpe1_smart.in_valid_flags / ndn_hpe1_smart_data.out_valid_flags */
 #define NDN_HPE1_SMART_HEALTH_VALID	(1 << 0)
 #define NDN_HPE1_SMART_TEMP_VALID	(1 << 1)
@@ -112,12 +106,16 @@ struct ndn_hpe1_smart_data {
 	__u8	vnd_spec_data[60];
 } __attribute__((packed));
 
-/* NDN_HPE1_CMD_SMART_THRESHOLD */
-struct ndn_hpe1_smart_threshold {
+struct ndn_hpe1_smart {
+	__u32 in_valid_flags;
 	__u32 status;
-	__u8 data[32];
+	union {
+		__u8 buf[124];
+		struct ndn_hpe1_smart_data data[0];
+	};
 } __attribute__((packed));
 
+/* NDN_HPE1_CMD_SMART_THRESHOLD */
 struct ndn_hpe1_smart_threshold_data {
 	__u16	threshold_alarm_ctl;
 	__u16	temp_threshold;
@@ -134,6 +132,14 @@ struct ndn_hpe1_smart_threshold_data {
 	__u64	res4;
 } __attribute__((packed));
 
+struct ndn_hpe1_smart_threshold {
+	__u32 status;
+	union {
+		__u8 buf[32];
+		struct ndn_hpe1_smart_threshold_data data[0];
+	};
+} __attribute__((packed));
+
 /* NDN_HPE1_CMD_GET_CONFIG_SIZE */
 struct ndn_hpe1_get_config_size {
 	__u32 status;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
