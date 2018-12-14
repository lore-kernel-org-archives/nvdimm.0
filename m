Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0803B211A43D3
 for <linux-nvdimm@lists.01.org>; Fri, 14 Dec 2018 13:09:20 -0800 (PST)
Subject: [PATCH v6 03/12] ndctl: add disable security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 14 Dec 2018 14:09:19 -0700
Message-ID: <154482175960.65434.5223732643058583241.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154482154540.65434.14399161818571651882.stgit@djiang5-desk3.ch.intel.com>
References: <154482154540.65434.14399161818571651882.stgit@djiang5-desk3.ch.intel.com>
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
To: "vishal.l.verma."@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for disable security to libndctl and also command line option
of "disable-passphrase" for ndctl. This provides a way to disable security
on the nvdimm.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am                  |    3 ++
 Documentation/ndctl/ndctl-disable-passphrase.txt |   27 +++++++++++++++++++++
 builtin.h                                        |    1 +
 ndctl/dimm.c                                     |   22 +++++++++++++++++
 ndctl/lib/dimm.c                                 |    9 +++++++
 ndctl/lib/keys.c                                 |   28 ++++++++++++++++++++++
 ndctl/lib/libndctl.sym                           |    2 ++
 ndctl/libndctl.h                                 |    7 ++++++
 ndctl/ndctl.c                                    |    1 +
 9 files changed, 99 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-disable-passphrase.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 7ad6666b..31570a77 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -49,7 +49,8 @@ man1_MANS = \
 	ndctl-list.1 \
 	ndctl-monitor.1 \
 	ndctl-enable-passphrase.1 \
-	ndctl-update-passphrase.1
+	ndctl-update-passphrase.1 \
+	ndctl-disable-passphrase.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-disable-passphrase.txt b/Documentation/ndctl/ndctl-disable-passphrase.txt
new file mode 100644
index 00000000..e921eb23
--- /dev/null
+++ b/Documentation/ndctl/ndctl-disable-passphrase.txt
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-disable-passphrase(1)
+===========================
+
+NAME
+----
+ndctl-disable-passphrase - disabling passphrase for an NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl disable-passphrase' <dimm> [<options>]
+
+DESCRIPTION
+-----------
+Provide a generic interface for disabling passphrase for NVDIMM.
+Ndctl will search the user key ring for the associated DIMM. If no key is
+found, it will attempt to load the key blob from the expected location. Ndctl
+will remove the key and the key blob once passphrase is disabled.
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+include::../copyright.txt[]
diff --git a/builtin.h b/builtin.h
index ed018d96..8d8f61e2 100644
--- a/builtin.h
+++ b/builtin.h
@@ -50,4 +50,5 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx);
 int cmd_inject_smart(int argc, const char **argv, void *ctx);
 int cmd_passphrase_setup(int argc, const char **argv, void *ctx);
 int cmd_passphrase_update(int argc, const char **argv, void *ctx);
+int cmd_disable_passphrase(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 581be497..edb4b9d7 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -861,6 +861,18 @@ static int action_key_update(struct ndctl_dimm *dimm,
 	return ndctl_dimm_update_key(dimm, param.master_key);
 }
 
+static int action_passphrase_disable(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	if (!ndctl_dimm_security_supported(dimm)) {
+		error("%s: security operation not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
+
+	return ndctl_dimm_disable_key(dimm);
+}
+
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
 {
@@ -1245,3 +1257,13 @@ int cmd_passphrase_setup(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_disable_passphrase(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_passphrase_disable, base_options,
+			"ndctl disable-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "passphrase disabled %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 2da0d01a..9cc22016 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -659,3 +659,12 @@ NDCTL_EXPORT int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
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
index a005c6a6..779e82af 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -387,3 +387,31 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 
 	return 0;
 }
+
+NDCTL_EXPORT int ndctl_dimm_disable_key(struct ndctl_dimm *dimm)
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
index a790b1ea..90038e75 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -393,4 +393,6 @@ global:
 	ndctl_dimm_enable_key;
 	ndctl_dimm_update_key;
 	ndctl_dimm_update_passphrase;
+	ndctl_dimm_disable_passphrase;
+	ndctl_dimm_disable_key;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 00ec1907..18cccbb1 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -702,6 +702,7 @@ int ndctl_dimm_get_security(struct ndctl_dimm *dimm,
 bool ndctl_dimm_security_supported(struct ndctl_dimm *dimm);
 int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
+int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
@@ -711,6 +712,7 @@ enum ndctl_key_type {
 #ifdef ENABLE_KEYUTILS
 int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master);
+int ndctl_dimm_disable_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
 		const char *master)
@@ -723,6 +725,11 @@ static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int ndctl_dimm_disable_key(struct ndctl_dimm *dimm)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #ifdef __cplusplus
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 4336c94c..1e82ded0 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -90,6 +90,7 @@ static struct cmd_struct commands[] = {
 	{ "start-scrub", cmd_start_scrub },
 	{ "enable-passphrase", cmd_passphrase_setup },
 	{ "update-passphrase", cmd_passphrase_update },
+	{ "disable-passphrase", cmd_disable_passphrase },
 	{ "list", cmd_list },
 	{ "monitor", cmd_monitor},
 	{ "help", cmd_help },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
