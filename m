Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B0882095BB80
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 18:44:12 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B9232AC00DA
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 10:46:51 +0900 (JST)
Received: from G01JPEXCHKW16.g01.fujitsu.local
 (G01JPEXCHKW16.g01.fujitsu.local [10.0.194.55])
 by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 1C29238000C
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 10:46:51 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: [RFC patch 2/4]ndctl: nvdimmd: notify/monitor the feathers of over
 threshold event
Date: Fri, 1 Sep 2017 01:46:49 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222756C8F7@g01jpexmbkw01>
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

Nvdimmd.c is the body file of nvdimm daemon. Currently, it writes a log which includes
notified dimm's name and spare percentage.

Sign-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>

--- 
nvdimmd/Makefile  | 10 +++++-
nvdimmd/nvdimmd.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
2 files changed, 106 insertions(+), 1 deletion(-)
diff --git a/nvdimmd/Makefile b/nvdimmd/Makefile
index a20a747..3908e5d 100644
--- a/nvdimmd/Makefile
+++ b/nvdimmd/Makefile
@@ -1,7 +1,15 @@
 CC		= gcc
+LIBS		= -ludev -luuid -lkmod
+OBJS		= ../ndctl/lib/.libs/libndctl.o ../daxctl/lib/.libs/libdaxctl.o ../util/.libs/sysfs.o ../util/.libs/log.o ../ndctl/lib/.libs/libndctl-smart.o
 IDIR		= -I../ -I../ndctl
+PROGRAM	= nvdimmd
 
+all:		$(PROGRAM)
+nvdimmd:	$(OBJS) nvdimmd.o libnvdimmd.o
+			$(CC) $(OBJS) nvdimmd.o libnvdimmd.o $(LIBS) $(IDIR) -o nvdimmd
 libnvdimmd.o:	libnvdimmd.c
 			$(CC) -o libnvdimmd.o $(IDIR) -c libnvdimmd.c
+nvdimmd.o:	nvdimmd.c
+			$(CC) -o nvdimmd.o $(IDIR) -c nvdimmd.c
 clean:
-			rm -rf *.o
+			rm -rf *.o $(PROGRAM)
diff --git a/nvdimmd/nvdimmd.c b/nvdimmd/nvdimmd.c
new file mode 100644
index 0000000..cdf78c8
--- /dev/null
+++ b/nvdimmd/nvdimmd.c
@@ -0,0 +1,97 @@
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
+ * Nvdimm daemon is used to monitor the features of over threshold events.
+ * It automatically searches and monitors all of the dimms which support smart
+ * threshold. When an over threshold event fires, it will write a notification
+ * into the system log.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <signal.h>
+#include <sys/stat.h>
+#include <syslog.h>
+#include <ndctl/libndctl.h>
+#include "libnvdimmd.h"
+
+int wait_threshold_notify()
+{
+	struct ndctl_ctx *ctx;
+	int rc, maxfd, count_dimm;
+	threshold_dimm *t_dimm;
+
+	rc = ndctl_new(&ctx);
+	if (rc){
+		syslog(LOG_ERR, "nvdimmd error: failed to instantiate context");
+		goto out;
+	}
+
+	t_dimm = calloc(NUM_MAX_DIMM, sizeof(threshold_dimm));
+	if (!t_dimm) {
+		syslog(LOG_ERR, "nvdimmd error: t_dimm memory not allocated");
+		goto out_ctx;
+	}
+
+	fd_set fds;
+	FD_ZERO(&fds);
+
+	count_dimm = get_threshold_dimm(ctx, t_dimm, &fds, &maxfd);
+	if (count_dimm == 0) {
+		syslog(LOG_ERR,
+		       "nvdimmd error: there is no dimm which supports over threshold notification");
+		goto out_tdimm;
+	}
+
+	rc = select(maxfd + 1, NULL, NULL, &fds, NULL);
+	if (rc < 1) {
+		if (rc == 0)
+			syslog(LOG_ERR, "nvdimmd error: select unexpected timeout");
+		else
+			syslog(LOG_ERR, "nvdimmd error: select %s", strerror(errno));
+		goto out_tdimm;
+	}
+
+	if (log_notify(t_dimm, count_dimm, fds, rc) == -1)
+		goto out_tdimm;
+
+	free(t_dimm);
+	ndctl_unref(ctx);
+	return 0;
+
+out_tdimm:
+	free(t_dimm);
+out_ctx:
+	ndctl_unref(ctx);
+out:
+	return 1;
+}
+
+int main()
+{
+	if (daemon(0, 0) != 0) {
+		syslog(LOG_ERR, "nvdimmd error: daemon start failed\n");
+		exit(EXIT_FAILURE);
+	}
+	syslog(LOG_NOTICE, "nvdimmd started\n");
+
+	int ret = 0;
+	while (ret == 0)
+		ret = wait_threshold_notify();
+
+	syslog(LOG_NOTICE, "nvdimmd ended\n");
+	return 0;
+}

--
QI Fuli <qi.fuli@jp.fujitsu.com>


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
