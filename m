Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3663D2116DFAF
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 15:29:08 -0700 (PDT)
Subject: [PATCH v4 6/7] ndctl: add request-key upcall reference app
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 15:29:08 -0700
Message-ID: <153938334807.20740.14762115053745941956.stgit@djiang5-desk3.ch.intel.com>
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

Adding a reference upcall helper for request-key in order to retrieve the
security passphrase from userspace to provide to the kernel. The reference
app uses keyutils API to respond to the upcall from the kernel and is
invoked by /sbin/request-key of the keyutils.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am       |    3 -
 Documentation/ndctl/nvdimm-upcall.txt |   33 +++++++
 Makefile.am                           |    5 +
 contrib/nvdimm.conf                   |    1 
 ndctl.spec.in                         |    2 
 ndctl/Makefile.am                     |    4 +
 ndctl/nvdimm-upcall.c                 |  154 +++++++++++++++++++++++++++++++++
 7 files changed, 201 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/nvdimm-upcall.txt
 create mode 100644 contrib/nvdimm.conf
 create mode 100644 ndctl/nvdimm-upcall.c

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 8c171ecb..f4e8b24c 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -51,7 +51,8 @@ man1_MANS = \
 	ndctl-update-security.1 \
 	ndctl-disable-security.1 \
 	ndctl-freeze-security.1 \
-	ndctl-sanitize.1
+	ndctl-sanitize.1 \
+	nvdimm-upcall.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/nvdimm-upcall.txt b/Documentation/ndctl/nvdimm-upcall.txt
new file mode 100644
index 00000000..bbf52fd1
--- /dev/null
+++ b/Documentation/ndctl/nvdimm-upcall.txt
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+
+nvdimm-upcall(1)
+================
+
+NAME
+----
+nvdimm-upcall - upcall helper for keyutils
+
+SYNOPSIS
+--------
+[verse]
+'nvdimm-upcall' [key_id]
+
+DESCRIPTION
+-----------
+nvdimm-upcall is called by request-key from keyutils and not meant to be used
+directly by the user. It expects to read from /etc/nvdimm.passwd to retrieve
+the description and passphrase for the NVDIMM key.
+
+The nvdimm.passwd is formatted as:
+<description id>:<passphrase with padded 0 to 32bytes>
+cdab-0a-07e0-feffffff:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
+
+In order for this util to be called, /etc/request-key.conf must be appended
+with the following line:
+create   logon   nvdimm*          *               /usr/sbin/nvdimm-upcall %k
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+http://pmem.io/documents/NVDIMM_DSM_Interface-V1.7.pdf
diff --git a/Makefile.am b/Makefile.am
index e0c463a3..73aa2645 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -42,6 +42,11 @@ bashcompletiondir = $(BASH_COMPLETION_DIR)
 dist_bashcompletion_DATA = contrib/ndctl
 endif
 
+key_config_file = contrib/nvdimm.conf
+key_configdir = $(sysconfdir)/request-key.d/
+key_config_DATA = $(key_config_file)
+EXTRA_DIST += $(key_config_file)
+
 noinst_LIBRARIES = libccan.a
 libccan_a_SOURCES = \
 	ccan/str/str.h \
diff --git a/contrib/nvdimm.conf b/contrib/nvdimm.conf
new file mode 100644
index 00000000..e1f9a28b
--- /dev/null
+++ b/contrib/nvdimm.conf
@@ -0,0 +1 @@
+create  logon   nvdimm:*         *               /usr/sbin/nvdimm-upcall %k
diff --git a/ndctl.spec.in b/ndctl.spec.in
index f57b4fd5..ef591615 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -120,6 +120,8 @@ make check
 %{bashcompdir}/
 %{_sysconfdir}/ndctl/monitor.conf
 %{_unitdir}/ndctl-monitor.service
+%{_sbindir}/nvdimm-upcall
+%{_sysconfdir}/request-key.d/nvdimm.conf
 
 %files -n daxctl
 %defattr(-,root,root)
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 5b62251b..24ca98c7 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -1,6 +1,7 @@
 include $(top_srcdir)/Makefile.am.in
 
 bin_PROGRAMS = ndctl
+sbin_PROGRAMS = nvdimm-upcall
 
 ndctl_SOURCES = ndctl.c \
 		bus.c \
@@ -52,3 +53,6 @@ EXTRA_DIST += $(monitor_config_file)
 if ENABLE_SYSTEMD_UNITS
 systemd_unit_DATA = ndctl-monitor.service
 endif
+
+nvdimm_upcall_SOURCES = nvdimm-upcall.c
+nvdimm_upcall_LDADD = -lkeyutils
diff --git a/ndctl/nvdimm-upcall.c b/ndctl/nvdimm-upcall.c
new file mode 100644
index 00000000..c8248359
--- /dev/null
+++ b/ndctl/nvdimm-upcall.c
@@ -0,0 +1,154 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
+
+/*
+ * Used by /sbin/request-key for handling nvdimm upcall of key requests
+ * for security DSMs.
+ */
+
+
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/param.h>
+#include <keyutils.h>
+#include <syslog.h>
+#include <ctype.h>
+
+#define PASSPHRASE_SIZE		32
+#define PASS_PATH		"/etc/nvdimm.passwd"
+
+static FILE *fp;
+
+static int get_passphrase_from_id(const char *id, char *pass)
+{
+	ssize_t rc = 0;
+	size_t size = 0, i;
+	char *line = NULL;
+	char *desc, *pass1;
+	int found = 0, comment = 0;
+
+	fp = fopen(PASS_PATH, "r+");
+	if (!fp) {
+		syslog(LOG_ERR, "fopen: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	while ((rc = getline(&line, &size, fp)) != -1) {
+		/* skip comments */
+		for (i = 0; i < size; i++) {
+			if (isspace(line[i]))
+				continue;
+			if (line[i] == '#')
+				comment = 1;
+		}
+
+		if (comment) {
+			comment = 0;
+			continue;
+		}
+
+		desc = strtok(line, ":");
+		if (!desc)
+			break;
+		if (strcmp(desc, id) == 0) {
+			found = 1;
+			rc = 0;
+			break;
+		}
+	}
+
+	if (rc == 0 && found) {
+		pass1 = strtok(NULL, ":");
+		if (!pass1) {
+			rc = -EINVAL;
+			goto out;
+		}
+		memset(pass, 0, PASSPHRASE_SIZE);
+		memcpy(pass, pass1, MIN(strlen(pass1), PASSPHRASE_SIZE));
+	} else
+		rc = -ENXIO;
+
+out:
+	free(line);
+	fclose(fp);
+	return rc;
+}
+
+static char *get_key_desc(char *buf)
+{
+	char *tmp = &buf[0];
+	int count = 0;
+
+	while (*tmp != '\0') {
+		if (*tmp == ';')
+			count++;
+		if (count == 4) {
+			tmp++;
+			return tmp;
+		}
+		tmp++;
+	}
+
+	return NULL;
+}
+
+int main(int argc, const char **argv)
+{
+	key_serial_t key;
+	int rc;
+	char *buf, *desc, *dimm_id;
+	char pass[PASSPHRASE_SIZE];
+
+	if (argc < 2) {
+		syslog(LOG_ERR, "Incorrect number of arguments\n");
+		return -EINVAL;
+	}
+
+	syslog(LOG_DEBUG, "key passed in: %s\n", argv[1]);
+	key = strtol(argv[1], NULL, 10);
+	if (key < 0) {
+		syslog(LOG_ERR, "Invalid key format: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	rc = keyctl_describe_alloc(key, &buf);
+	if (rc < 0) {
+		syslog(LOG_ERR, "keyctl_describe_alloc failed: %s\n",
+				strerror(errno));
+		rc = -errno;
+		goto out;
+	}
+
+	desc = get_key_desc(buf);
+	if (!desc) {
+		syslog(LOG_ERR, "Can't find key description\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	strtok_r(desc, ":", &dimm_id);
+	rc = get_passphrase_from_id(dimm_id, pass);
+	if (rc < 0) {
+		syslog(LOG_ERR, "failed to retrieve passphrase\n");
+		goto out;
+	}
+
+	rc = keyctl_instantiate(key, pass, PASSPHRASE_SIZE, 0);
+	if (rc < 0) {
+		syslog(LOG_ERR, "keyctl_instantiate failed: %s\n",
+				strerror(errno));
+		rc = -errno;
+		goto out;
+	}
+
+ out:
+	if (rc < 0)
+		keyctl_negate(key, 1, KEY_REQKEY_DEFL_DEFAULT);
+
+	return rc;
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
