Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7E15211B509C
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 18:38:44 -0800 (PST)
Subject: [PATCH v9 04/13] ndctl: add disable security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 17 Jan 2019 19:38:44 -0700
Message-ID: <154777912422.42557.17988597711346573900.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
References: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for disable security to libndctl and also command line option
of "disable-passphrase" for ndctl. This provides a way to disable security
on the nvdimm.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am                 |    3 ++
 Documentation/ndctl/ndctl-remove-passphrase.txt |   26 +++++++++++++++++++++
 ndctl/builtin.h                                 |    1 +
 ndctl/dimm.c                                    |   23 ++++++++++++++++++
 ndctl/lib/dimm.c                                |    9 +++++++
 ndctl/lib/keys.c                                |   29 +++++++++++++++++++++++
 ndctl/lib/libndctl.sym                          |    2 ++
 ndctl/libndctl.h                                |    7 ++++++
 ndctl/ndctl.c                                   |    1 +
 9 files changed, 100 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-remove-passphrase.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 7b155d4d..96519653 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -50,7 +50,8 @@ man1_MANS = \
 	ndctl-monitor.1 \
 	ndctl-install-encrypt-key.1 \
 	ndctl-setup-passphrase.1 \
-	ndctl-update-passphrase.1
+	ndctl-update-passphrase.1 \
+	ndctl-disable-passphrase.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-remove-passphrase.txt b/Documentation/ndctl/ndctl-remove-passphrase.txt
new file mode 100644
index 00000000..17ff905b
--- /dev/null
+++ b/Documentation/ndctl/ndctl-remove-passphrase.txt
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-remove-passphrase(1)
+===========================
+
+NAME
+----
+ndctl-remove-passphrase - Stop a DIMM from locking at power-loss and requiring a passphrase to access media
+
+SYNOPSIS
+--------
+[verse]
+'ndctl remove-passphrase' <nmem0> [<nmem1>..<nmemN>] [<options>]
+
+DESCRIPTION
+-----------
+Search the user key ring for the associated NVDIMM key. If not found,
+attempt to load the key blob. After disabling the passphrase successfully,
+remove the key and the key blob.
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+include::../copyright.txt[]
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 33c04983..3d71cb30 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -35,4 +35,5 @@ int cmd_inject_smart(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_install_kek(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_passphrase_remove(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index bea7cf62..f71eafe7 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -860,6 +860,18 @@ static int action_key_update(struct ndctl_dimm *dimm,
 	return ndctl_dimm_update_key(dimm);
 }
 
+static int action_passphrase_remove(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	if (ndctl_dimm_get_security(dimm) < 0) {
+		error("%s: security operation not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
+
+	return ndctl_dimm_remove_key(dimm);
+}
+
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
 {
@@ -1227,3 +1239,14 @@ int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_passphrase_remove(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_passphrase_remove,
+			base_options,
+			"ndctl remove-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "passphrase removed for %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 72b6f66c..a944c9af 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -655,3 +655,12 @@ NDCTL_EXPORT int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 	sprintf(buf, "update %ld %ld\n", ckey, nkey);
 	return write_security(dimm, buf);
 }
+
+NDCTL_EXPORT int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm,
+		long key)
+{
+	char buf[SYSFS_ATTR_SIZE];
+
+	sprintf(buf, "disable %ld\n", key);
+	return write_security(dimm, buf);
+}
diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
index 1ae0ff02..fe618870 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -13,6 +13,7 @@
 #include <syslog.h>
 
 #include <ndctl.h>
+#include <ndctl/config.h>
 #include <ndctl/libndctl.h>
 #include "private.h"
 
@@ -385,3 +386,31 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm)
 
 	return 0;
 }
+
+NDCTL_EXPORT int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	key_serial_t key;
+	int rc;
+
+	key = dimm_check_key(dimm, false);
+	if (key < 0) {
+		key = dimm_load_key(dimm, false);
+		if (key < 0) {
+			err(ctx, "Unable to load key\n");
+			return -ENOKEY;
+		}
+	}
+
+	rc = ndctl_dimm_disable_passphrase(dimm, key);
+	if (rc < 0) {
+		err(ctx, "Failed to disable security for %s\n",
+				ndctl_dimm_get_devname(dimm));
+		return rc;
+	}
+
+	rc = dimm_remove_key(dimm, false);
+	if (rc < 0)
+		err(ctx, "Unable to cleanup key.\n");
+	return 0;
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index ce05d604..ed387ac0 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -395,4 +395,6 @@ global:
 	ndctl_dimm_enable_key;
 	ndctl_dimm_update_key;
 	ndctl_dimm_update_passphrase;
+	ndctl_dimm_disable_passphrase;
+	ndctl_dimm_remove_key;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 727dedcf..823e4cff 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -703,6 +703,7 @@ enum ndctl_security_state ndctl_dimm_get_security(struct ndctl_dimm *dimm);
 const char *ndctl_bus_get_kek_handle(struct ndctl_bus *bus);
 int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
+int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
@@ -712,6 +713,7 @@ enum ndctl_key_type {
 #ifdef ENABLE_KEYUTILS
 int ndctl_dimm_enable_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_remove_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm)
 {
@@ -722,6 +724,11 @@ static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #define ND_KEY_DESC_SIZE	128
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index a715f69a..11f640c0 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -90,6 +90,7 @@ static struct cmd_struct commands[] = {
 	{ "start-scrub", { cmd_start_scrub } },
 	{ "setup-passphrase", { cmd_passphrase_setup } },
 	{ "update-passphrase", { cmd_passphrase_update } },
+	{ "remove-passphrase", { cmd_passphrase_remove } },
 	{ "list", { cmd_list } },
 	{ "monitor", { cmd_monitor } },
 	{ "install-encrypt-key", { cmd_install_kek } },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
