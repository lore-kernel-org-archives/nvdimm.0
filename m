Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85EBE220D4BE9
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 23:43:15 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id D39A0AC00D4
 for <linux-nvdimm@lists.01.org>; Tue, 14 Nov 2017 16:47:13 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RFC PATCH v2 7/7] ndctl: nvdimmd: add a temporary test for nvdimm
 daemon
Date: Tue, 14 Nov 2017 16:47:04 +0900
Message-Id: <20171114074704.3446-8-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
References: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch is used to test nvdimmd service temporarily.
I will make it an ndctl command or an option of ndctl inject-error
in next step.
Currently, You can test nvdimm daemon with the following command.

  nvdimmd_test [nmemX] [all]

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 nvdimmd/Makefile.am    |  14 ++++-
 nvdimmd/nvdimmd_test.c | 142 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+), 1 deletion(-)
 create mode 100644 nvdimmd/nvdimmd_test.c

diff --git a/nvdimmd/Makefile.am b/nvdimmd/Makefile.am
index bca0bc8..cca1980 100644
--- a/nvdimmd/Makefile.am
+++ b/nvdimmd/Makefile.am
@@ -1,6 +1,6 @@
 include $(top_srcdir)/Makefile.am.in
 
-bin_PROGRAMS = nvdimmd
+bin_PROGRAMS = nvdimmd nvdimmd_test
 
 nvdimmd_SOURCES =\
 		nvdimmd.c \
@@ -18,6 +18,18 @@ nvdimmd_LDADD = ../ndctl/lib/libndctl.la \
 		$(UUID_LIBS) \
 		$(UDEV_LIBS)
 
+nvdimmd_test_SOURCES =\
+		nvdimmd_test.c \
+		../util/log.c
+
+nvdimmd_test_LDADD =\
+		../ndctl/lib/libndctl.la \
+		../daxctl/lib/libdaxctl.la \
+		../libutil.a \
+		$(KMOD_LIBS) \
+		$(UUID_LIBS) \
+		$(UDEV_LIBS)
+
 unitfiles = nvdimmd.service
 
 unitdir = /usr/lib/systemd/system/
diff --git a/nvdimmd/nvdimmd_test.c b/nvdimmd/nvdimmd_test.c
new file mode 100644
index 0000000..8d16243
--- /dev/null
+++ b/nvdimmd/nvdimmd_test.c
@@ -0,0 +1,142 @@
+/*
+ * Copyright (c) 2017, FUJITSU LIMITED. All rirhts reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for
+ * more details.
+ */
+
+/*
+ * This program is used to call the emulation of event of over threshold.
+ * You can test nvdimmd daemon with the following command.
+ * nvdimmd_test [nmemX] [all]
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <syslog.h>
+#include <util/log.h>
+#include <ndctl/libndctl.h>
+#define NUM_MAX_DIMM 1024
+#include <ndctl/lib/private.h>
+
+struct threshold_dimm {
+	struct ndctl_dimm *dimm;
+	const char *devname;
+	int health_eventfd;
+};
+
+const char *test_help_info = "nvdimmd_test [nmemX] [all]";
+
+static int get_threshold(struct ndctl_ctx *ctx, struct threshold_dimm *t_dimm)
+{
+	struct ndctl_bus *bus;
+	struct ndctl_dimm *dimm;
+	int cnt_dimm = 0;
+
+	ndctl_bus_foreach(ctx, bus) {
+		ndctl_dimm_foreach(bus, dimm) {
+			if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD))
+				continue;
+			t_dimm[cnt_dimm].dimm = dimm;
+			t_dimm[cnt_dimm].devname = ndctl_dimm_get_devname(dimm);
+			cnt_dimm++;
+		}
+	}
+	return cnt_dimm;
+}
+
+static int test_submit_cmd(struct threshold_dimm *t_dimm)
+{
+	struct ndctl_cmd *cmd;
+	const char *msg = "command to call over threshold event notification: ";
+
+	cmd = ndctl_dimm_cmd_new_smart_threshold(t_dimm->dimm);
+	if (!cmd) {
+		fprintf(stderr, "failed to prepare %s[%s]\n",
+				msg, t_dimm->devname);
+		return -1;
+	}
+	if(ndctl_cmd_submit(cmd)) {
+		fprintf(stderr, "failed to submit %s[%s]\n",
+				msg, t_dimm->devname);
+		return -1;
+	}
+	ndctl_cmd_unref(cmd);
+	return 0;
+}
+
+static int
+test_submit(struct threshold_dimm *t_dimm, int count_dimm, char *test_devname)
+{
+	int count_test = 0;
+
+	for (int i= 0; i < count_dimm; i++) {
+		if (!strcmp(test_devname, "all")) {
+			if (!test_submit_cmd(&t_dimm[i]))
+				count_test++;
+			continue;
+		}
+		if (!strcmp(test_devname, t_dimm[i].devname)) {
+			if (!test_submit_cmd(&t_dimm[i]))
+				count_test++;
+			else
+				count_test--;
+			break;
+		}
+	}
+	return count_test;
+}
+
+int main(int argc, char *argv[])
+{
+	struct ndctl_ctx *ctx;
+	int rc, count_dimm;
+	char *test_devname;
+	struct threshold_dimm *t_dimm;
+
+	if (argc < 1) {
+		fprintf(stderr, "usage: %s\n", test_help_info);
+		goto out;
+	}
+
+	test_devname = argv[1];
+	if (!test_devname || !strcmp(test_devname, "--help")){
+		fprintf(stderr, "usage: %s\n", test_help_info);
+		goto out;
+	}
+	rc = ndctl_new(&ctx);
+	if (rc)
+		goto out;
+
+	t_dimm = calloc(NUM_MAX_DIMM, sizeof(struct threshold_dimm));
+	if (!t_dimm) {
+		fprintf(stderr, "nvdimmd test error: memory not allocate\n");
+		goto out;
+	}
+
+	count_dimm = get_threshold(ctx, t_dimm);
+	if (count_dimm == 0) {
+		fprintf(stderr, "nvdimmd test error: no dimm support over threshold\n");
+		goto out;
+	}
+
+	rc = test_submit(t_dimm, count_dimm, test_devname);
+
+	if (!rc && strcmp(test_devname, "all"))
+		fprintf(stderr, "UNKNOWM DIMM_NAME\n");
+	else if (rc >= 0)
+		printf("%d nvdimmd test submit: [%s]\n", rc, test_devname);
+
+	ndctl_unref(ctx);
+out:
+	return 1;
+}
-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
