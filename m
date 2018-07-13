Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F42520985980
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 15:45:59 -0700 (PDT)
Subject: [PATCH 5/6] ndctl: add support for secure erase
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 13 Jul 2018 15:45:58 -0700
Message-ID: <153152195849.6787.147607747293528279.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153152170933.6787.1111990895827764695.stgit@djiang5-desk3.ch.intel.com>
References: <153152170933.6787.1111990895827764695.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for secure erase to libndctl and also command line option
of "secure-erase" for ndctl. This will initiate the request to securely
erase a DIMM. ndctl does not actually handle the verification of the
security. That is handled by the kernel and the key upcall mechanism.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am            |    1 +
 Documentation/ndctl/ndctl-secure-erase.txt |   21 +++++++++++++++++++++
 builtin.h                                  |    1 +
 ndctl/dimm.c                               |   21 +++++++++++++++++++++
 ndctl/lib/dimm.c                           |    5 +++++
 ndctl/lib/libndctl.sym                     |    1 +
 ndctl/libndctl.h                           |    1 +
 ndctl/ndctl.c                              |    1 +
 8 files changed, 52 insertions(+)
 create mode 100644 Documentation/ndctl/ndctl-secure-erase.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 98348178..8a84c11c 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -49,6 +49,7 @@ man1_MANS = \
 	ndctl-update-security.1 \
 	ndctl-disable-security.1 \
 	ndctl-freeze-security.1 \
+	ndctl-secure-erase.1 \
 	ndctl-list.1
 
 CLEANFILES = $(man1_MANS)
diff --git a/Documentation/ndctl/ndctl-secure-erase.txt b/Documentation/ndctl/ndctl-secure-erase.txt
new file mode 100644
index 00000000..8f82248a
--- /dev/null
+++ b/Documentation/ndctl/ndctl-secure-erase.txt
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-secure-erase(1)
+=====================
+
+NAME
+----
+ndctl-secure-erase - securely erasing the user data on the NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl secure-erase' <dimm>
+
+DESCRIPTION
+-----------
+Provide a generic interface to securely erase NVDIMM. This does not change
+the label storage area. The use of this depends on support from the underlying
+libndctl, kernel, as well as the platform itself.
+
+include::../copyright.txt[]
diff --git a/builtin.h b/builtin.h
index 6e6ae069..a9b6443e 100644
--- a/builtin.h
+++ b/builtin.h
@@ -50,4 +50,5 @@ int cmd_inject_smart(int argc, const char **argv, void *ctx);
 int cmd_update_security(int argc, const char **argv, void *ctx);
 int cmd_disable_security(int argc, const char **argv, void *ctx);
 int cmd_freeze_security(int argc, const char **argv, void *ctx);
+int cmd_secure_erase(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 49097cff..45c9efce 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -857,6 +857,17 @@ static int action_security_freeze(struct ndctl_dimm *dimm,
 	return rc;
 }
 
+static int action_secure_erase(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	int rc;
+
+	rc = ndctl_dimm_secure_erase(dimm);
+	if (rc < 0)
+		error("Failed to secure erase for %s\n",
+				ndctl_dimm_get_devname(dimm));
+	return rc;
+}
 static struct parameters {
 	const char *bus;
 	const char *outfile;
@@ -1244,3 +1255,13 @@ int cmd_freeze_security(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_secure_erase(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_secure_erase, base_options,
+			"ndctl secure-erase <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "secure erased %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 2ff68daa..bb896d21 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -625,3 +625,8 @@ NDCTL_EXPORT int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm)
 {
 	return ndctl_dimm_write_security(dimm, "freeze");
 }
+
+NDCTL_EXPORT int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm)
+{
+	return ndctl_dimm_write_security(dimm, "erase");
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 613d9bb2..08727f94 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -375,4 +375,5 @@ global:
 	ndctl_dimm_set_change_key;
 	ndctl_dimm_disable_security;
 	ndctl_dimm_freeze_security;
+	ndctl_dimm_secure_erase;
 } LIBNDCTL_16;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 4615ba09..88ba8a29 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -663,6 +663,7 @@ int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm, char *state);
 int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_disable_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
+int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 5a1a81e4..b1a91033 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -91,6 +91,7 @@ static struct cmd_struct commands[] = {
 	{ "update-security", cmd_update_security },
 	{ "disable-security", cmd_disable_security },
 	{ "freeze-security", cmd_freeze_security },
+	{ "secure-erase", cmd_secure_erase },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
