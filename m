Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 47D7C21A1099A
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:29:16 -0800 (PST)
Subject: [ndctl PATCH 11/17] ndctl: refactor 'smart_ops' into generic
 'dimm_ops'
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:25:28 -0800
Message-ID: <151217072833.28402.3168795736947236643.stgit@dwillia2-desk3.amr.corp.intel.com>
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

There are cases beyond SMART commands where we need to generically ask
the per-family provider for more information, or take some NVDIMM-family
specific action. Rename smart_ops to dimm_ops.

This also cleans up ndctl_dimm_get_smart_ops() to be open coded
("dimm->ops"). The NDCTL_EXPORT on the previous symbol name was
invalidated by the fact that ndctl/lib/libndctl.sym never listed the
symbol.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/hpe1.c     |    2 +-
 ndctl/lib/intel.c    |    2 +-
 ndctl/lib/libndctl.c |   11 +++--------
 ndctl/lib/msft.c     |    2 +-
 ndctl/lib/private.h  |   10 +++++-----
 ndctl/lib/smart.c    |   16 +++++++++-------
 ndctl/libndctl.h     |    1 -
 7 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/ndctl/lib/hpe1.c b/ndctl/lib/hpe1.c
index 81f60ab27a07..dbc1ff06737e 100644
--- a/ndctl/lib/hpe1.c
+++ b/ndctl/lib/hpe1.c
@@ -296,7 +296,7 @@ static unsigned int hpe1_cmd_smart_threshold_get_spares(struct ndctl_cmd *cmd)
 	return CMD_HPE1_SMART_THRESH(cmd)->spare_block_threshold;
 }
 
-struct ndctl_smart_ops * const hpe1_smart_ops = &(struct ndctl_smart_ops) {
+struct ndctl_dimm_ops * const hpe1_dimm_ops = &(struct ndctl_dimm_ops) {
 	.new_smart = hpe1_dimm_cmd_new_smart,
 	.smart_get_flags = hpe1_cmd_smart_get_flags,
 	.smart_get_health = hpe1_cmd_smart_get_health,
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index e9da565dd57d..af13c60d4f52 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -283,7 +283,7 @@ intel_smart_set_threshold_field(spares)
 intel_smart_set_threshold_field(media_temperature)
 intel_smart_set_threshold_field(ctrl_temperature)
 
-struct ndctl_smart_ops * const intel_smart_ops = &(struct ndctl_smart_ops) {
+struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
 	.new_smart = intel_dimm_cmd_new_smart,
 	.smart_get_flags = intel_cmd_smart_get_flags,
 	.smart_get_health = intel_cmd_smart_get_health,
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 47ba2807495e..d6d8a7f0c0b3 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1301,11 +1301,11 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		dimm->cmd_family = strtoul(buf, NULL, 0);
 	if (dimm->cmd_family == NVDIMM_FAMILY_INTEL)
-		dimm->smart_ops = intel_smart_ops;
+		dimm->ops = intel_dimm_ops;
 	if (dimm->cmd_family == NVDIMM_FAMILY_HPE1)
-		dimm->smart_ops = hpe1_smart_ops;
+		dimm->ops = hpe1_dimm_ops;
 	if (dimm->cmd_family == NVDIMM_FAMILY_MSFT)
-		dimm->smart_ops = msft_smart_ops;
+		dimm->ops = msft_dimm_ops;
 
 	sprintf(path, "%s/nfit/dsm_mask", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
@@ -1563,11 +1563,6 @@ NDCTL_EXPORT struct ndctl_bus *ndctl_dimm_get_bus(struct ndctl_dimm *dimm)
 	return dimm->bus;
 }
 
-NDCTL_EXPORT struct ndctl_smart_ops *ndctl_dimm_get_smart_ops(struct ndctl_dimm *dimm)
-{
-	return dimm->smart_ops;
-}
-
 NDCTL_EXPORT struct ndctl_ctx *ndctl_dimm_get_ctx(struct ndctl_dimm *dimm)
 {
 	return dimm->bus->ctx;
diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index d61c065e752d..e15bc076a6c2 100644
--- a/ndctl/lib/msft.c
+++ b/ndctl/lib/msft.c
@@ -136,7 +136,7 @@ static unsigned int msft_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
 	return 100 - CMD_MSFT_SMART(cmd)->nvm_lifetime;
 }
 
-struct ndctl_smart_ops * const msft_smart_ops = &(struct ndctl_smart_ops) {
+struct ndctl_dimm_ops * const msft_dimm_ops = &(struct ndctl_dimm_ops) {
 	.new_smart = msft_dimm_cmd_new_smart,
 	.smart_get_flags = msft_cmd_smart_get_flags,
 	.smart_get_health = msft_cmd_smart_get_health,
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 5e9f24f2b3c5..490de96f6ce6 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -61,7 +61,7 @@ struct nvdimm_data {
 struct ndctl_dimm {
 	struct kmod_module *module;
 	struct ndctl_bus *bus;
-	struct ndctl_smart_ops *smart_ops;
+	struct ndctl_dimm_ops *ops;
 	struct nvdimm_data ndd;
 	unsigned int handle, major, minor, serial;
 	unsigned short phys_id;
@@ -277,7 +277,7 @@ struct ndctl_bb {
 	struct list_node list;
 };
 
-struct ndctl_smart_ops {
+struct ndctl_dimm_ops {
 	struct ndctl_cmd *(*new_smart)(struct ndctl_dimm *);
 	unsigned int (*smart_get_flags)(struct ndctl_cmd *);
 	unsigned int (*smart_get_health)(struct ndctl_cmd *);
@@ -303,9 +303,9 @@ struct ndctl_smart_ops {
 	int (*smart_threshold_set_spares)(struct ndctl_cmd *, unsigned int);
 };
 
-struct ndctl_smart_ops * const intel_smart_ops;
-struct ndctl_smart_ops * const hpe1_smart_ops;
-struct ndctl_smart_ops * const msft_smart_ops;
+struct ndctl_dimm_ops * const intel_dimm_ops;
+struct ndctl_dimm_ops * const hpe1_dimm_ops;
+struct ndctl_dimm_ops * const msft_dimm_ops;
 
 static inline struct ndctl_bus *cmd_to_bus(struct ndctl_cmd *cmd)
 {
diff --git a/ndctl/lib/smart.c b/ndctl/lib/smart.c
index 58a6f4bb28ad..846030e70e92 100644
--- a/ndctl/lib/smart.c
+++ b/ndctl/lib/smart.c
@@ -17,13 +17,14 @@
 #include "private.h"
 
 /*
- * Define the wrappers around the ndctl_smart_ops:
+ * Define the wrappers around the ndctl_dimm_ops:
  */
 
 NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart(
 		struct ndctl_dimm *dimm)
 {
-	struct ndctl_smart_ops *ops = ndctl_dimm_get_smart_ops(dimm);
+	struct ndctl_dimm_ops *ops = dimm->ops;
+
 	if (ops && ops->new_smart)
 		return ops->new_smart(dimm);
 	else
@@ -33,7 +34,8 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart(
 NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart_threshold(
 		struct ndctl_dimm *dimm)
 {
-	struct ndctl_smart_ops *ops = ndctl_dimm_get_smart_ops(dimm);
+	struct ndctl_dimm_ops *ops = dimm->ops;
+
 	if (ops && ops->new_smart_threshold)
 		return ops->new_smart_threshold(dimm);
 	else
@@ -47,11 +49,11 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart_threshold(
 NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart_set_threshold(
 		struct ndctl_cmd *cmd)
 {
-	struct ndctl_smart_ops *ops;
+	struct ndctl_dimm_ops *ops;
 
 	if (!cmd || !cmd->dimm)
 		return NULL;
-	ops = ndctl_dimm_get_smart_ops(cmd->dimm);
+	ops = cmd->dimm->ops;
 
 	if (ops && ops->new_smart_set_threshold)
 		return ops->new_smart_set_threshold(cmd);
@@ -63,7 +65,7 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart_set_threshold(
 NDCTL_EXPORT rettype ndctl_cmd_##op(struct ndctl_cmd *cmd) \
 { \
 	if (cmd->dimm) { \
-		struct ndctl_smart_ops *ops = ndctl_dimm_get_smart_ops(cmd->dimm); \
+		struct ndctl_dimm_ops *ops = cmd->dimm->ops; \
 		if (ops && ops->op) \
 			return ops->op(cmd); \
 	} \
@@ -103,7 +105,7 @@ smart_cmd_op(smart_threshold_get_supported_alarms, unsigned int, 0);
 NDCTL_EXPORT int ndctl_cmd_##op(struct ndctl_cmd *cmd, unsigned int val) \
 { \
 	if (cmd->dimm) { \
-		struct ndctl_smart_ops *ops = ndctl_dimm_get_smart_ops(cmd->dimm); \
+		struct ndctl_dimm_ops *ops = cmd->dimm->ops; \
 		if (ops && ops->op) \
 			return ops->op(cmd, val); \
 	} \
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 69333443ee78..0dfd373e7897 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -162,7 +162,6 @@ unsigned int ndctl_dimm_handle_get_channel(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_handle_get_dimm(struct ndctl_dimm *dimm);
 const char *ndctl_dimm_get_devname(struct ndctl_dimm *dimm);
 struct ndctl_bus *ndctl_dimm_get_bus(struct ndctl_dimm *dimm);
-struct ndctl_smart_ops *ndctl_dimm_get_smart_ops(struct ndctl_dimm *dimm);
 struct ndctl_ctx *ndctl_dimm_get_ctx(struct ndctl_dimm *dimm);
 struct ndctl_dimm *ndctl_dimm_get_by_handle(struct ndctl_bus *bus,
 		unsigned int handle);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
