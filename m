Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0454021A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:28:33 -0800 (PST)
Subject: [ndctl PATCH 03/17] ndctl,
 smart: rename 'temperature' helpers to 'media_temperature'
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:24:45 -0800
Message-ID: <151217068584.28402.9909444496961087237.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for adding controller temperature support rename the
current ambiguous 'temperature' to 'media_temperature'.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/hpe1.c       |   10 ++++++----
 ndctl/lib/libndctl.sym |    2 ++
 ndctl/lib/msft.c       |    4 ++--
 ndctl/lib/private.h    |    4 ++--
 ndctl/lib/smart.c      |   34 ++++++++++++++++++++++++++++++----
 ndctl/libndctl.h.in    |   17 +++++++++++++++++
 6 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/ndctl/lib/hpe1.c b/ndctl/lib/hpe1.c
index addebe952ce6..81f60ab27a07 100644
--- a/ndctl/lib/hpe1.c
+++ b/ndctl/lib/hpe1.c
@@ -134,7 +134,7 @@ static unsigned int hpe1_cmd_smart_get_health(struct ndctl_cmd *cmd)
 	return health;
 }
 
-static unsigned int hpe1_cmd_smart_get_temperature(struct ndctl_cmd *cmd)
+static unsigned int hpe1_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
 {
 	if (hpe1_smart_valid(cmd) < 0)
 		return UINT_MAX;
@@ -279,7 +279,8 @@ static unsigned int hpe1_cmd_smart_threshold_get_alarm_control(struct ndctl_cmd
 	return flags;
 }
 
-static unsigned int hpe1_cmd_smart_threshold_get_temperature(struct ndctl_cmd *cmd)
+static unsigned int hpe1_cmd_smart_threshold_get_media_temperature(
+		struct ndctl_cmd *cmd)
 {
 	if (hpe1_smart_threshold_valid(cmd) < 0)
 		return UINT_MAX;
@@ -299,7 +300,7 @@ struct ndctl_smart_ops * const hpe1_smart_ops = &(struct ndctl_smart_ops) {
 	.new_smart = hpe1_dimm_cmd_new_smart,
 	.smart_get_flags = hpe1_cmd_smart_get_flags,
 	.smart_get_health = hpe1_cmd_smart_get_health,
-	.smart_get_temperature = hpe1_cmd_smart_get_temperature,
+	.smart_get_media_temperature = hpe1_cmd_smart_get_media_temperature,
 	.smart_get_spares = hpe1_cmd_smart_get_spares,
 	.smart_get_alarm_flags = hpe1_cmd_smart_get_alarm_flags,
 	.smart_get_life_used = hpe1_cmd_smart_get_life_used,
@@ -308,6 +309,7 @@ struct ndctl_smart_ops * const hpe1_smart_ops = &(struct ndctl_smart_ops) {
 	.smart_get_vendor_data = hpe1_cmd_smart_get_vendor_data,
 	.new_smart_threshold = hpe1_dimm_cmd_new_smart_threshold,
 	.smart_threshold_get_alarm_control = hpe1_cmd_smart_threshold_get_alarm_control,
-	.smart_threshold_get_temperature = hpe1_cmd_smart_threshold_get_temperature,
+	.smart_threshold_get_media_temperature =
+		hpe1_cmd_smart_threshold_get_media_temperature,
 	.smart_threshold_get_spares = hpe1_cmd_smart_threshold_get_spares,
 };
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 30480074d2ef..b3fab6232df6 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -310,4 +310,6 @@ global:
 	ndctl_namespace_injection_get_next_bb;
 	ndctl_bb_get_block;
 	ndctl_bb_get_count;
+	ndctl_cmd_smart_get_media_temperature;
+	ndctl_cmd_smart_threshold_get_media_temperature;
 } LIBNDCTL_13;
diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index 1c4c8913714f..d61c065e752d 100644
--- a/ndctl/lib/msft.c
+++ b/ndctl/lib/msft.c
@@ -120,7 +120,7 @@ static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
 	return health;
 }
 
-static unsigned int msft_cmd_smart_get_temperature(struct ndctl_cmd *cmd)
+static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
 {
 	if (msft_smart_valid(cmd) < 0)
 		return UINT_MAX;
@@ -140,6 +140,6 @@ struct ndctl_smart_ops * const msft_smart_ops = &(struct ndctl_smart_ops) {
 	.new_smart = msft_dimm_cmd_new_smart,
 	.smart_get_flags = msft_cmd_smart_get_flags,
 	.smart_get_health = msft_cmd_smart_get_health,
-	.smart_get_temperature = msft_cmd_smart_get_temperature,
+	.smart_get_media_temperature = msft_cmd_smart_get_media_temperature,
 	.smart_get_life_used = msft_cmd_smart_get_life_used,
 };
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 685d65d89a06..c2ce519ebad2 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -288,7 +288,7 @@ struct ndctl_smart_ops {
 	struct ndctl_cmd *(*new_smart)(struct ndctl_dimm *);
 	unsigned int (*smart_get_flags)(struct ndctl_cmd *);
 	unsigned int (*smart_get_health)(struct ndctl_cmd *);
-	unsigned int (*smart_get_temperature)(struct ndctl_cmd *);
+	unsigned int (*smart_get_media_temperature)(struct ndctl_cmd *);
 	unsigned int (*smart_get_spares)(struct ndctl_cmd *);
 	unsigned int (*smart_get_alarm_flags)(struct ndctl_cmd *);
 	unsigned int (*smart_get_life_used)(struct ndctl_cmd *);
@@ -298,7 +298,7 @@ struct ndctl_smart_ops {
 	unsigned char *(*smart_get_vendor_data)(struct ndctl_cmd *);
 	struct ndctl_cmd *(*new_smart_threshold)(struct ndctl_dimm *);
 	unsigned int (*smart_threshold_get_alarm_control)(struct ndctl_cmd *);
-	unsigned int (*smart_threshold_get_temperature)(struct ndctl_cmd *);
+	unsigned int (*smart_threshold_get_media_temperature)(struct ndctl_cmd *);
 	unsigned int (*smart_threshold_get_spares)(struct ndctl_cmd *);
 };
 
diff --git a/ndctl/lib/smart.c b/ndctl/lib/smart.c
index 1821af2289d3..d30288a1486a 100644
--- a/ndctl/lib/smart.c
+++ b/ndctl/lib/smart.c
@@ -53,7 +53,8 @@ NDCTL_EXPORT rettype name(struct ndctl_cmd *cmd) \
 
 smart_cmd_op(ndctl_cmd_smart_get_flags, smart_get_flags, unsigned int, 0)
 smart_cmd_op(ndctl_cmd_smart_get_health, smart_get_health, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_get_temperature, smart_get_temperature, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_get_media_temperature, smart_get_media_temperature,
+		unsigned int, 0)
 smart_cmd_op(ndctl_cmd_smart_get_spares, smart_get_spares, unsigned int, 0)
 smart_cmd_op(ndctl_cmd_smart_get_alarm_flags, smart_get_alarm_flags, unsigned int, 0)
 smart_cmd_op(ndctl_cmd_smart_get_life_used, smart_get_life_used, unsigned int, 0)
@@ -62,9 +63,21 @@ smart_cmd_op(ndctl_cmd_smart_get_shutdown_count, smart_get_shutdown_count, unsig
 smart_cmd_op(ndctl_cmd_smart_get_vendor_size, smart_get_vendor_size, unsigned int, 0)
 smart_cmd_op(ndctl_cmd_smart_get_vendor_data, smart_get_vendor_data, unsigned char *, NULL)
 smart_cmd_op(ndctl_cmd_smart_threshold_get_alarm_control, smart_threshold_get_alarm_control, unsigned int, 0)
-smart_cmd_op(ndctl_cmd_smart_threshold_get_temperature, smart_threshold_get_temperature, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_threshold_get_media_temperature,
+		smart_threshold_get_media_temperature, unsigned int, 0)
 smart_cmd_op(ndctl_cmd_smart_threshold_get_spares, smart_threshold_get_spares, unsigned int, 0)
 
+NDCTL_EXPORT unsigned int ndctl_cmd_smart_get_temperature(struct ndctl_cmd *cmd)
+{
+	return ndctl_cmd_smart_get_media_temperature(cmd);
+}
+
+NDCTL_EXPORT unsigned int ndctl_cmd_smart_threshold_get_temperature(
+		struct ndctl_cmd *cmd)
+{
+	return ndctl_cmd_smart_threshold_get_media_temperature(cmd);
+}
+
 /*
  * The following intel_dimm_*() and intel_smart_*() functions implement
  * the ndctl_smart_ops for the Intel DSM family (NVDIMM_FAMILY_INTEL):
@@ -126,6 +139,12 @@ intel_smart_get_field(cmd, shutdown_state)
 intel_smart_get_field(cmd, shutdown_count)
 intel_smart_get_field(cmd, vendor_size)
 
+static unsigned int intel_cmd_smart_get_media_temperature(
+		struct ndctl_cmd *cmd)
+{
+	return intel_cmd_smart_get_temperature(cmd);
+}
+
 static unsigned char *intel_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd)
 {
 	struct nd_smart_payload *smart_data;
@@ -159,6 +178,12 @@ intel_smart_threshold_get_field(cmd, alarm_control)
 intel_smart_threshold_get_field(cmd, temperature)
 intel_smart_threshold_get_field(cmd, spares)
 
+static unsigned int intel_cmd_smart_threshold_get_media_temperature(
+		struct ndctl_cmd *cmd)
+{
+	return intel_cmd_smart_threshold_get_temperature(cmd);
+}
+
 static struct ndctl_cmd *intel_dimm_cmd_new_smart_threshold(
 		struct ndctl_dimm *dimm)
 {
@@ -193,7 +218,7 @@ struct ndctl_smart_ops * const intel_smart_ops = &(struct ndctl_smart_ops) {
 	.new_smart = intel_dimm_cmd_new_smart,
 	.smart_get_flags = intel_cmd_smart_get_flags,
 	.smart_get_health = intel_cmd_smart_get_health,
-	.smart_get_temperature = intel_cmd_smart_get_temperature,
+	.smart_get_media_temperature = intel_cmd_smart_get_media_temperature,
 	.smart_get_spares = intel_cmd_smart_get_spares,
 	.smart_get_alarm_flags = intel_cmd_smart_get_alarm_flags,
 	.smart_get_life_used = intel_cmd_smart_get_life_used,
@@ -203,6 +228,7 @@ struct ndctl_smart_ops * const intel_smart_ops = &(struct ndctl_smart_ops) {
 	.smart_get_vendor_data = intel_cmd_smart_get_vendor_data,
 	.new_smart_threshold = intel_dimm_cmd_new_smart_threshold,
 	.smart_threshold_get_alarm_control = intel_cmd_smart_threshold_get_alarm_control,
-	.smart_threshold_get_temperature = intel_cmd_smart_threshold_get_temperature,
+	.smart_threshold_get_media_temperature
+		= intel_cmd_smart_threshold_get_media_temperature,
 	.smart_threshold_get_spares = intel_cmd_smart_threshold_get_spares,
 };
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index fb77d243a893..298adff476c7 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -275,12 +275,18 @@ static inline unsigned long long ndctl_cmd_clear_error_get_cleared(
 }
 #endif
 
+/*
+ * Note: ndctl_cmd_smart_get_temperature is an alias for
+ * ndctl_cmd_smart_get_temperature
+ */
+
 #define HAS_SMART HAVE_NDCTL_SMART
 #if HAS_SMART == 1
 struct ndctl_cmd *ndctl_dimm_cmd_new_smart(struct ndctl_dimm *dimm);
 unsigned int ndctl_cmd_smart_get_flags(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_health(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_temperature(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_spares(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_alarm_flags(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_life_used(struct ndctl_cmd *cmd);
@@ -291,6 +297,7 @@ unsigned char *ndctl_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_smart_threshold(struct ndctl_dimm *dimm);
 unsigned int ndctl_cmd_smart_threshold_get_alarm_control(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_threshold_get_temperature(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_threshold_get_media_temperature(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_threshold_get_spares(struct ndctl_cmd *cmd);
 #else
 static inline struct ndctl_cmd *ndctl_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
@@ -309,6 +316,11 @@ static inline unsigned int ndctl_cmd_smart_get_temperature(struct ndctl_cmd *cmd
 {
 	return 0;
 }
+static inline unsigned int ndctl_cmd_smart_get_media_temperature(
+		struct ndctl_cmd *cmd)
+{
+	return 0;
+}
 static inline unsigned int ndctl_cmd_smart_get_spares(struct ndctl_cmd *cmd)
 {
 	return 0;
@@ -352,6 +364,11 @@ static inline unsigned int ndctl_cmd_smart_threshold_get_temperature(
 {
 	return 0;
 }
+static inline unsigned int ndctl_cmd_smart_threshold_get_media_temperature(
+		struct ndctl_cmd *cmd)
+{
+	return 0;
+}
 static inline unsigned int ndctl_cmd_smart_threshold_get_spares(
 		struct ndctl_cmd *cmd)
 {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
