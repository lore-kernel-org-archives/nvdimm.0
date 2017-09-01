Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F082B21E79027
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 18:46:48 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id E978AAC00E0
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 10:49:29 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local
 (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
 by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 4B1C6692756
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 10:49:29 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: [RFC patch 4/4]ndctl: nvdimmd: notify/monitor the feathers of over
 threshold event
Date: Fri, 1 Sep 2017 01:49:28 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222756C92E@g01jpexmbkw01>
Content-Language: ja-JP
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Notify.c is used to call the emulation of event of over threshold.
You can test nvdimm daemon with the following command.

 notify [nmemX] [all]

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>

---
nvdimmd/Makefile |   6 ++-
nvdimmd/notify.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
2 files changed, 119 insertions(+), 1 deletion(-)
diff --git a/nvdimmd/Makefile b/nvdimmd/Makefile
index df7eb46..9fb37ec 100644
--- a/nvdimmd/Makefile
+++ b/nvdimmd/Makefile
@@ -3,7 +3,7 @@ LIBS		= -ludev -luuid -lkmod
 DEST		= /usr/bin
 OBJS		= ../ndctl/lib/.libs/libndctl.o ../daxctl/lib/.libs/libdaxctl.o ../util/.libs/sysfs.o ../util/.libs/log.o ../ndctl/lib/.libs/libndctl-smart.o
 IDIR		= -I../ -I../ndctl
-PROGRAM	= nvdimmd
+PROGRAM	= nvdimmd notify
 
 all:		$(PROGRAM)
 nvdimmd:	$(OBJS) nvdimmd.o libnvdimmd.o
@@ -12,6 +12,10 @@ libnvdimmd.o:	libnvdimmd.c
 			$(CC) -o libnvdimmd.o $(IDIR) -c libnvdimmd.c
 nvdimmd.o:	nvdimmd.c
 			$(CC) -o nvdimmd.o $(IDIR) -c nvdimmd.c
+notify:		$(OBJS) notify.o libnvdimmd.o
+			$(CC) $(OBJS) notify.o libnvdimmd.o $(LIBS) $(IDIR) -o notify
+notify.o:	notify.c
+			$(CC) -o notify.o $(IDIR) -c notify.c
 install:	nvdimmd nvdimmd.service
 			install -s nvdimmd $(DEST)
 			cp nvdimmd.service /usr/lib/systemd/system/
diff --git a/nvdimmd/notify.c b/nvdimmd/notify.c
new file mode 100644
index 0000000..f83e60d
--- /dev/null
+++ b/nvdimmd/notify.c
@@ -0,0 +1,113 @@
+/*
+ * Copyright (c) 2017, FUJITSU LIMITED. All rights reserved.
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
+ *  notify [nmemX] [all]
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <syslog.h>
+#include <ndctl/libndctl.h>
+#include "libnvdimmd.h"
+
+const char *notify_help_info = "notify [nmemX] [all]";
+
+static int notify_submit_cmd(threshold_dimm *t_dimm)
+{
+	struct ndctl_cmd *cmd;
+	const char *msg = "command to call over threshold event notification: ";
+
+	cmd = ndctl_dimm_cmd_new_smart_threshold(t_dimm->dimm);
+	if (!cmd) {
+		printf("failed to prepare %s[%s]\n", msg, t_dimm->devname);
+		return -1;
+	}
+	if(ndctl_cmd_submit(cmd)) {
+		printf("failed to submit %s[%s]\n", msg, t_dimm->devname);
+		return -1;
+	}
+	ndctl_cmd_unref(cmd);
+	return 0;
+}
+
+static int
+notify_submit(threshold_dimm *t_dimm, int count_dimm, char *notify_devname)
+{
+	int count_notify = 0;
+
+	for (int i= 0; i < count_dimm; i++) {
+		if (!strcmp(notify_devname, "all")) {
+			if (!notify_submit_cmd(&t_dimm[i]))
+				count_notify++;
+			continue;
+		}
+		if (!strcmp(notify_devname, t_dimm[i].devname)) {
+			if (!notify_submit_cmd(&t_dimm[i]))
+				count_notify++;
+			else
+				count_notify--;
+			break;
+		}
+	}
+	return count_notify;
+}
+
+int main(int argc, char *argv[])
+{
+	struct ndctl_ctx *ctx;
+	int rc, count_dimm;
+	char *notify_devname;
+	threshold_dimm *t_dimm;
+
+	if (argc < 1) {
+		printf("usage: %s\n", notify_help_info);
+		goto out;
+	}
+
+	notify_devname = argv[1];
+	if (!notify_devname || !strcmp(notify_devname, "--help")){
+		printf("usage: %s\n", notify_help_info);
+		goto out;
+	}
+	rc = ndctl_new(&ctx);
+	if (rc)
+		goto out;
+
+	t_dimm = calloc(NUM_MAX_DIMM, sizeof(threshold_dimm));
+	if (!t_dimm) {
+		printf("notify error: memory not allocate\n");
+		goto out;
+	}
+
+	count_dimm = get_threshold_dimm(ctx, t_dimm, NULL, NULL);
+	if (count_dimm == 0) {
+		printf("notify error: no dimm support over threshold notify\n");
+		goto out;
+	}
+
+	rc = notify_submit(t_dimm, count_dimm, notify_devname);
+
+	if (!rc && strcmp(notify_devname, "all"))
+		printf("UNKNOWM DIMM_NAME\n");
+	else if (rc >= 0)
+		printf("%d notify submit: [%s]\n", rc, notify_devname);
+
+	ndctl_unref(ctx);
+out:
+	return 1;
+}

--
QI Fuli <qi.fuli@jp.fujitsu.com>


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
