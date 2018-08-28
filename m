Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CB0421102DAE
 for <linux-nvdimm@lists.01.org>; Tue, 28 Aug 2018 15:52:24 -0700 (PDT)
Subject: [PATCH v3 6/6] ndctl: add request-key upcall reference app
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 28 Aug 2018 15:52:18 -0700
Message-ID: <153549673831.5723.3252005522935384062.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153549661384.5723.4757814248604794802.stgit@djiang5-desk3.ch.intel.com>
References: <153549661384.5723.4757814248604794802.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, alison.schofield@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding a reference upcall helper for request-key in order to retrieve the
security passphrase from userspace to provide to the kernel. The reference
app uses keyutils API to respond to the upcall from the kernel and is
invoked by /sbin/request-key of the keyutils.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am       |    3 -
 Documentation/ndctl/nvdimm-upcall.txt |   33 ++++++++
 ndctl.spec.in                         |    1 
 ndctl/Makefile.am                     |    5 +
 ndctl/nvdimm-upcall.c                 |  138 +++++++++++++++++++++++++++++++++
 5 files changed, 179 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/nvdimm-upcall.txt
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
diff --git a/ndctl.spec.in b/ndctl.spec.in
index c71bd581..6416c0b6 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -123,6 +123,7 @@ make check
 %{_unitdir}/ndctl-monitor.service
 %{_udevrulesdir}/80-ndctl.rules
 %{udevdir}/ndctl-udev
+%{_sbindir}/nvdimm-upcall
 
 %files -n daxctl
 %defattr(-,root,root)
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 4b44294e..ec4c9229 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -1,6 +1,7 @@
 include $(top_srcdir)/Makefile.am.in
 
 bin_PROGRAMS = ndctl
+sbin_PROGRAMS = nvdimm-upcall
 
 ndctl_SOURCES = ndctl.c \
 		bus.c \
@@ -56,3 +57,7 @@ ndctl_udevdir = $(UDEVDIR)
 ndctl_udev_PROGRAMS = ndctl-udev
 ndctl_udev_SOURCES = ndctl-udev.c
 ndctl_udev_LDADD = lib/libndctl.la
+
+nvdimm_upcall_SOURCES = nvdimm-upcall.c
+
+nvdimm_upcall_LDADD = $(KEYUTILS_LIBS)
diff --git a/ndctl/nvdimm-upcall.c b/ndctl/nvdimm-upcall.c
new file mode 100644
index 00000000..904a1141
--- /dev/null
+++ b/ndctl/nvdimm-upcall.c
@@ -0,0 +1,138 @@
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
+
+#define PASSPHRASE_SIZE		32
+#define PASS_PATH		"/etc/nvdimm.passwd"
+
+static FILE *fp;
+
+static int get_passphrase_from_id(const char *id, char *pass, int *psize)
+{
+	ssize_t rc = 0;
+	size_t size;
+	char *line = NULL;
+	char *tmp, *id_tok, *secret;
+	int found = 0;
+
+	fp = fopen(PASS_PATH, "r+");
+	if (!fp) {
+		syslog(LOG_ERR, "fopen: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	while ((rc = getline(&line, &size, fp)) != -1) {
+		id_tok = strtok_r(line, ":", &tmp);
+		if (!id_tok)
+			break;
+		if (strcmp(id_tok, id) == 0) {
+			secret = tmp;
+			found = 1;
+			rc = 0;
+			break;
+		}
+	}
+
+	if (rc == 0 && found && secret) {
+		memset(pass, 0, PASSPHRASE_SIZE*2+1);
+		size = MIN(strlen(secret), (PASSPHRASE_SIZE*2+1));
+		memcpy(pass, secret, size);
+		*psize = size-1;
+	} else
+		rc = -ENXIO;
+
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
+	char pass[PASSPHRASE_SIZE * 2 + 1];
+	int size = 0;
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
+	rc = get_passphrase_from_id(dimm_id, pass, &size);
+	if (rc < 0) {
+		syslog(LOG_ERR, "failed to retrieve passphrase\n");
+		goto out;
+	}
+
+	rc = keyctl_instantiate(key, pass, size, 0);
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
