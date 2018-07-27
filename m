Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E1A4A210C0CE5
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 15:02:33 -0700 (PDT)
Subject: [PATCH v2 6/6] ndctl: add request-key upcall reference app
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 27 Jul 2018 15:02:31 -0700
Message-ID: <153272895127.12034.14914040322261561207.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153272888859.12034.12514972515977309760.stgit@djiang5-desk3.ch.intel.com>
References: <153272888859.12034.12514972515977309760.stgit@djiang5-desk3.ch.intel.com>
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

Adding a reference upcall helper for request-key in order to retrieve the
security passphrase from userspace to provide to the kernel. The reference
app uses keyutils API to respond to the upcall from the kernel and is
invoked by /sbin/request-key of the keyutils.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am       |    3 -
 Documentation/ndctl/nvdimm-upcall.txt |   33 ++++++++
 configure.ac                          |    1 
 ndctl.spec.in                         |    2 
 ndctl/Makefile.am                     |    5 +
 ndctl/nvdimm-upcall.c                 |  138 +++++++++++++++++++++++++++++++++
 6 files changed, 181 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/nvdimm-upcall.txt
 create mode 100644 ndctl/nvdimm-upcall.c

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 8a84c11c..d61e5f9a 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -50,7 +50,8 @@ man1_MANS = \
 	ndctl-disable-security.1 \
 	ndctl-freeze-security.1 \
 	ndctl-secure-erase.1 \
-	ndctl-list.1
+	ndctl-list.1 \
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
diff --git a/configure.ac b/configure.ac
index cf442607..4b125919 100644
--- a/configure.ac
+++ b/configure.ac
@@ -114,6 +114,7 @@ PKG_CHECK_MODULES([KMOD], [libkmod])
 PKG_CHECK_MODULES([UDEV], [libudev])
 PKG_CHECK_MODULES([UUID], [uuid])
 PKG_CHECK_MODULES([JSON], [json-c])
+PKG_CHECK_MODULES([KEYUTILS], [keyutils])
 
 AC_ARG_WITH([bash-completion-dir],
 	AS_HELP_STRING([--with-bash-completion-dir[=PATH]],
diff --git a/ndctl.spec.in b/ndctl.spec.in
index e2c879ca..342f01d7 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -20,6 +20,7 @@ BuildRequires:	pkgconfig(libudev)
 BuildRequires:	pkgconfig(uuid)
 BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
+BuildRequires:  pkgconfig(keyutils)
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -116,6 +117,7 @@ make check
 %{_bindir}/ndctl
 %{_mandir}/man1/ndctl*
 %{bashcompdir}/
+%{_sbindir}/nvdimm-upcall
 
 %files -n daxctl
 %defattr(-,root,root)
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 0f568719..d6401df9 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -1,6 +1,7 @@
 include $(top_srcdir)/Makefile.am.in
 
 bin_PROGRAMS = ndctl
+sbin_PROGRAMS = nvdimm-upcall
 
 ndctl_SOURCES = ndctl.c \
 		bus.c \
@@ -41,3 +42,7 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 ../test/core.c \
 		 test.c
 endif
+
+nvdimm_upcall_SOURCES = nvdimm-upcall.c
+
+nvdimm_upcall_LDADD = $(KEYUTILS_LIBS)
diff --git a/ndctl/nvdimm-upcall.c b/ndctl/nvdimm-upcall.c
new file mode 100644
index 00000000..9406b23a
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
+	char *buf, *desc, *dimm_id, *tmp;
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
+	tmp = strtok_r(desc, ":", &dimm_id);
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
