Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7DBD02116DFAE
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 15:28:52 -0700 (PDT)
Subject: [PATCH v4 3/7] ndctl: add disable security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 15:28:51 -0700
Message-ID: <153938333196.20740.17643143764278748768.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153938316555.20740.14314691018876178251.stgit@djiang5-desk3.ch.intel.com>
References: <153938316555.20740.14314691018876178251.stgit@djiang5-desk3.ch.intel.com>
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
of "disable-security" for ndctl. This provides a way to disable security
on the nvdimm. ndctl does not handle the actual processing of the
passphrase. It only starts the request.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am                |    3 +-
 Documentation/ndctl/ndctl-disable-security.txt |   48 ++++++++++++++++++++++++
 builtin.h                                      |    1 +
 ndctl/dimm.c                                   |   46 +++++++++++++++++++++++
 ndctl/lib/dimm.c                               |    9 +++++
 ndctl/lib/libndctl.sym                         |    1 +
 ndctl/libndctl.h                               |    1 +
 ndctl/ndctl.c                                  |    1 +
 8 files changed, 109 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-disable-security.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 2c064c3a..faeb0d9b 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -48,7 +48,8 @@ man1_MANS = \
 	ndctl-update-firmware.1 \
 	ndctl-list.1 \
 	ndctl-monitor.1 \
-	ndctl-update-security.1
+	ndctl-update-security.1 \
+	ndctl-disable-security.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-disable-security.txt b/Documentation/ndctl/ndctl-disable-security.txt
new file mode 100644
index 00000000..e51717f2
--- /dev/null
+++ b/Documentation/ndctl/ndctl-disable-security.txt
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-disable-security(1)
+========================
+
+NAME
+----
+ndctl-disable-security - enabling or disable security for an NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl disable-security' <dimm> [<options>]
+
+DESCRIPTION
+-----------
+Provide a generic interface for disabling security for NVDIMM. The use of this
+depends on support from the underlying libndctl, kernel, as well as the
+platform itself.
+
+For the reference passphrase setup, /etc/nvdimm.passwd is read for passphrase
+retrieval:
+
+The nvdimm.passwd is formatted as:
+<description id>:<passphrase with padded 0 to 32bytes>
+cdab-0a-07e0-feffffff:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+-i::
+--insecure::
+	Using the default reference support to parse the nvdimm passphrase
+	file, inject the key, and initiate disable operation. This is labeled
+	as insecure as it just provides a reference to how to inject keys
+	for the nvdimm. The passphrase is in clear text and is not considered
+	as secure as it can be.
+
+-e::
+--exec::
+	The external binary module that would inject the passphrase and
+	initiate the disable operation. Use this or -i, not both.
+
+
+
+include::../copyright.txt[]
diff --git a/builtin.h b/builtin.h
index 37404c79..39e4e38d 100644
--- a/builtin.h
+++ b/builtin.h
@@ -49,4 +49,5 @@ int cmd_bat(int argc, const char **argv, void *ctx);
 int cmd_update_firmware(int argc, const char **argv, void *ctx);
 int cmd_inject_smart(int argc, const char **argv, void *ctx);
 int cmd_key_update(int argc, const char **argv, void *ctx);
+int cmd_disable_security(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 62a102b4..1de145b1 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -877,6 +877,42 @@ static int action_key(struct ndctl_dimm *dimm,
 	return rc;
 }
 
+static int action_security_disable(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	int rc, po_valid, pn_valid;
+	char old_payload[ND_PASSPHRASE_SIZE];
+	char new_payload[ND_PASSPHRASE_SIZE];
+	key_serial_t old_key, new_key;
+
+	if (param.key_exec)
+		return execl(param.key_exec, ndctl_dimm_get_devname(dimm),
+				ndctl_dimm_get_unique_id(dimm), (char *)NULL);
+
+	if (!param.key_insecure)
+		return -EINVAL;
+
+	rc = ndctl_dimm_get_key_payload(dimm, new_payload, &pn_valid,
+			old_payload, &po_valid);
+	if (rc < 0)
+		return rc;
+
+	/*
+	 * We will ignore the "old" key. The "new" key is actually the
+	 * current key, which we will pass to the kernel.
+	 */
+	rc = ndctl_dimm_add_keys(dimm, &new_key, new_payload, &old_key, NULL);
+	if (rc < 0)
+		return rc;
+
+	rc = ndctl_dimm_disable_security(dimm, new_key);
+	if (rc < 0)
+		error("Failed to disable security for %s\n",
+				ndctl_dimm_get_devname(dimm));
+
+	return rc;
+}
+
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
 {
@@ -1249,3 +1285,13 @@ int cmd_key_update(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_disable_security(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_security_disable, key_options,
+			"ndctl disable-security <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "security disabled %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index c9ef894a..16cf2a79 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -623,3 +623,12 @@ NDCTL_EXPORT int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm,
 	sprintf(buf, "update %d %d\n", ckey, nkey);
 	return ndctl_dimm_write_security(dimm, buf);
 }
+
+NDCTL_EXPORT int ndctl_dimm_disable_security(struct ndctl_dimm *dimm,
+		key_serial_t key)
+{
+	char buf[SYSFS_ATTR_SIZE];
+
+	sprintf(buf, "disable %d\n", key);
+	return ndctl_dimm_write_security(dimm, buf);
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index a37e7389..b84f0063 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -392,4 +392,5 @@ global:
 	ndctl_dimm_get_key_payload;
 	ndctl_dimm_add_keys;
 	ndctl_dimm_set_change_key;
+	ndctl_dimm_disable_security;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 4fee6467..72ec1763 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -695,6 +695,7 @@ int ndctl_dimm_get_key_payload(struct ndctl_dimm *dimm, char *pass,
 int ndctl_dimm_add_keys(struct ndctl_dimm *dimm, key_serial_t *new_key,
 		const char *new_payload, key_serial_t *old_key,
 		const char *old_payload);
+int ndctl_dimm_disable_security(struct ndctl_dimm *dimm, key_serial_t key);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index c7096dfd..2dab02d2 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -89,6 +89,7 @@ static struct cmd_struct commands[] = {
 	{ "wait-scrub", cmd_wait_scrub },
 	{ "start-scrub", cmd_start_scrub },
 	{ "update-security", cmd_key_update },
+	{ "disable-security", cmd_disable_security },
 	{ "list", cmd_list },
 	{ "monitor", cmd_monitor},
 	{ "help", cmd_help },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
