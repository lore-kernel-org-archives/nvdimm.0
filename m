Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 05E112119623A
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 13:34:14 -0800 (PST)
Subject: [PATCH v5 09/12] ndctl: add overwrite-wait support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 30 Nov 2018 14:34:14 -0700
Message-ID: <154361365412.6129.13010087792253637506.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154361315118.6129.3346352930852675435.stgit@djiang5-desk3.ch.intel.com>
References: <154361315118.6129.3346352930852675435.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding a monitoring command to ndctl in order to wait on the progress of
overwrite.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am              |    3 +
 Documentation/ndctl/ndctl-wait-overwrite.txt |   31 ++++++++++
 builtin.h                                    |    1 
 ndctl/dimm.c                                 |   27 +++++++++
 ndctl/lib/dimm.c                             |   79 ++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym                       |    1 
 ndctl/libndctl.h                             |    1 
 ndctl/ndctl.c                                |    1 
 8 files changed, 143 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-wait-overwrite.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index bbea9674..a60a67e5 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -52,7 +52,8 @@ man1_MANS = \
 	ndctl-update-passphrase.1 \
 	ndctl-disable-passphrase.1 \
 	ndctl-freeze-security.1 \
-	ndctl-sanitize-dimm.1
+	ndctl-sanitize-dimm.1 \
+	ndctl-wait-overwrite.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-wait-overwrite.txt b/Documentation/ndctl/ndctl-wait-overwrite.txt
new file mode 100644
index 00000000..97583a36
--- /dev/null
+++ b/Documentation/ndctl/ndctl-wait-overwrite.txt
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-wait-overwrite(1)
+=======================
+
+NAME
+----
+ndctl-wait-overwrite - wait for nvdimm overwrite operation to complete
+
+SYNOPSIS
+--------
+[verse]
+'ndctl wait-overwrite' <dimm> [<options>]
+
+DESCRIPTION
+-----------
+The ernel provides a POLL(2) capable sysfs file ('security') to indicate
+the state of overwrite. The 'ndctl wait-overwrite' operation waits for
+'security', across all specified dimms.
+
+OPTIONS
+-------
+-v::
+--verbose::
+	Emit debug messages for the overwrite wait process
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkndctl:ndctl-sanitize-dimm[1]
diff --git a/builtin.h b/builtin.h
index db0f2858..32bee59e 100644
--- a/builtin.h
+++ b/builtin.h
@@ -53,4 +53,5 @@ int cmd_passphrase_update(int argc, const char **argv, void *ctx);
 int cmd_disable_passphrase(int argc, const char **argv, void *ctx);
 int cmd_freeze_security(int argc, const char **argv, void *ctx);
 int cmd_sanitize_dimm(int argc, const char **argv, void *ctx);
+int cmd_wait_overwrite(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index febda71a..68443893 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -928,6 +928,24 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 	return 0;
 }
 
+static int action_wait_overwrite(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	int rc;
+
+	if (!ndctl_dimm_security_supported(dimm)) {
+		error("%s: security operation not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
+
+	rc = ndctl_dimm_wait_for_overwrite_completion(dimm);
+	if (rc == 1)
+		printf("%s: overwrite completed.\n",
+				ndctl_dimm_get_devname(dimm));
+	return rc;
+}
+
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
 {
@@ -1355,3 +1373,12 @@ int cmd_sanitize_dimm(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_wait_overwrite(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_wait_overwrite,
+			base_options,
+			"ndctl wait-overwrite <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 2dff80f0..d815b9fc 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -16,6 +16,7 @@
 #include <util/bitmap.h>
 #include <util/sysfs.h>
 #include <stdlib.h>
+#include <poll.h>
 #include "private.h"
 
 static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
@@ -689,3 +690,81 @@ NDCTL_EXPORT int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key)
 	sprintf(buf, "overwrite %ld\n", key);
 	return write_security(dimm, buf);
 }
+
+NDCTL_EXPORT int ndctl_dimm_wait_for_overwrite_completion(
+		struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	struct pollfd fds;
+	char buf[SYSFS_ATTR_SIZE];
+	int fd = 0, rc;
+	char *path = dimm->dimm_buf;
+	int len = dimm->buf_len;
+
+	if (snprintf(path, len, "%s/security", dimm->dimm_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_dimm_get_devname(dimm));
+		return -ERANGE;
+	}
+
+	fd = open(path, O_RDONLY|O_CLOEXEC);
+	if (fd < 0) {
+		rc = -errno;
+		err(ctx, "open: %s\n", strerror(errno));
+		return rc;
+	}
+	memset(&fds, 0, sizeof(fds));
+	fds.fd = fd;
+
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc < 0) {
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+	/* skipping if we aren't in overwrite state */
+	if (strcmp(buf, "overwrite") != 0) {
+		rc = 0;
+		goto out;
+	}
+
+	for (;;) {
+		rc = sysfs_read_attr(ctx, path, buf);
+		if (rc < 0) {
+			rc = -EOPNOTSUPP;
+			break;
+		}
+
+		if (strcmp(buf, "overwrite") == 0) {
+			rc = poll(&fds, 1, -1);
+			if (rc < 0) {
+				rc = -errno;
+				err(ctx, "poll error: %s\n", strerror(errno));
+				break;
+			}
+			dbg(ctx, "poll wake: revents: %d\n", fds.revents);
+			if (pread(fd, buf, 1, 0) == -1) {
+				rc = -errno;
+				break;
+			}
+			fds.revents = 0;
+		} else {
+			if (strcmp(buf, "disabled") == 0)
+				rc = 1;
+			break;
+		}
+	}
+
+	if (rc == 1)
+		dbg(ctx, "%s: overwrite complete\n",
+				ndctl_dimm_get_devname(dimm));
+	else if (rc == 0)
+		dbg(ctx, "%s: ovewrite skipped\n",
+				ndctl_dimm_get_devname(dimm));
+	else
+		dbg(ctx, "%s: overwrite error waiting for complete\n",
+				ndctl_dimm_get_devname(dimm));
+
+ out:
+	close(fd);
+	return rc;
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 0fedae1a..0da8b282 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -400,4 +400,5 @@ global:
 	ndctl_dimm_secure_erase_key;
 	ndctl_dimm_overwrite;
 	ndctl_dimm_overwrite_key;
+	ndctl_dimm_wait_for_overwrite_completion;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 24866ef3..d21e07d2 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -706,6 +706,7 @@ int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
+int ndctl_dimm_wait_for_overwrite_completion(struct ndctl_dimm *dimm);
 
 #ifdef ENABLE_KEYUTILS
 int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master);
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 40982f43..d16e1ed0 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -93,6 +93,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-passphrase", cmd_disable_passphrase },
 	{ "freeze-security", cmd_freeze_security },
 	{ "sanitize-dimm", cmd_sanitize_dimm },
+	{ "wait-overwrite", cmd_wait_overwrite },
 	{ "list", cmd_list },
 	{ "monitor", cmd_monitor},
 	{ "help", cmd_help },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
