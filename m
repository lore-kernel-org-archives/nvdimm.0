Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E05BB21E70D21
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 18:42:38 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 49A3CAC0136
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 10:45:18 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local
 (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
 by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id A139C32884B
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 10:45:17 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: [RFC patch 1/4]ndctl: nvdimmd: notify/monitor the feathers of over
 threshold event
Date: Fri, 1 Sep 2017 01:45:17 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222756C8E1@g01jpexmbkw01>
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

Libnvdimmd.c provides functions which are used by nvdimm daemon, and
currently it just supports for logging. 
Libnvdimmd.h is a head file of libnvdimmd.c.
Since I do not use automake, I defined gentenv.h to compile instead of it temporarily.
So I suppose more good way is necessary.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>

---
nvdimmd/Makefile     |   7 +++
nvdimmd/getenv.h     |   1 +
nvdimmd/libnvdimmd.c | 141 +++++++++++++++++++++++++++++++++++++++++++++++++++
nvdimmd/libnvdimmd.h |  31 +++++++++++
4 files changed, 180 insertions(+)
diff --git a/nvdimmd/Makefile b/nvdimmd/Makefile
new file mode 100644
index 0000000..a20a747
--- /dev/null
+++ b/nvdimmd/Makefile
@@ -0,0 +1,7 @@
+CC		= gcc
+IDIR		= -I../ -I../ndctl
+
+libnvdimmd.o:	libnvdimmd.c
+			$(CC) -o libnvdimmd.o $(IDIR) -c libnvdimmd.c
+clean:
+			rm -rf *.o
diff --git a/nvdimmd/getenv.h b/nvdimmd/getenv.h
new file mode 100644
index 0000000..45747b4
--- /dev/null
+++ b/nvdimmd/getenv.h
@@ -0,0 +1 @@
+#define HAVE_SECURE_GETENV 1
diff --git a/nvdimmd/libnvdimmd.c b/nvdimmd/libnvdimmd.c
new file mode 100644
index 0000000..89ff701
--- /dev/null
+++ b/nvdimmd/libnvdimmd.c
@@ -0,0 +1,141 @@
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
+ * This program is used to provide nvdimm daemon necessary functions.
+ */
+
+#include "getenv.h"
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <syslog.h>
+#include <ndctl/libndctl.h>
+#include <ndctl/lib/libndctl-private.h>
+#include "libnvdimmd.h"
+#define BUF_SIZE 4096
+
+static int get_health_info(threshold_dimm *t_dimm)
+{
+	struct ndctl_cmd *cmd;
+	int rc;
+	unsigned int flags;
+	char *msg = "nvdimm warning: dimm over threshold notify";
+	char *err_msg;
+
+	cmd = ndctl_dimm_cmd_new_smart(t_dimm->dimm);
+	if (!cmd) {
+		err_msg = "failed to prepare command to get health info";
+		syslog(LOG_WARNING, "%s [%s], %s\n", msg, t_dimm->devname, err_msg);
+		return -1;
+	}
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc || ndctl_cmd_get_firmware_status(cmd)) {
+		err_msg = "failed to submit command to get health info";
+		syslog(LOG_WARNING, "%s [%s], %s\n", msg, t_dimm->devname, err_msg);
+		ndctl_cmd_unref(cmd);
+		return -1;
+	}
+
+	flags = ndctl_cmd_smart_get_flags(cmd);
+	if (flags & ND_SMART_HEALTH_VALID) {
+		unsigned int health = ndctl_cmd_smart_get_health(cmd);
+		if (health & ND_SMART_FATAL_HEALTH)
+			t_dimm->health_state = "fatal";
+		else if (health & ND_SMART_CRITICAL_HEALTH)
+			t_dimm->health_state = "critical";
+		else if (health & ND_SMART_NON_CRITICAL_HEALTH)
+			t_dimm->health_state = "non-critical";
+		else
+			t_dimm->health_state = "ok";
+	} else {
+		t_dimm->health_state = "failed to get data";
+	}
+	if (flags & ND_SMART_SPARES_VALID)
+		t_dimm->spares = ndctl_cmd_smart_get_spares(cmd);
+	else
+		t_dimm->spares = -1;
+
+	ndctl_cmd_unref(cmd);
+	return 0;
+}
+
+int log_notify(threshold_dimm *t_dimm, int count_dimm, fd_set fds, int count_select)
+{
+	int log_notify = 0;
+	char *msg = "nvdimm warning: dimm over threshold notify";
+
+	for (int i = 0; i < count_dimm; i++) {
+		if (log_notify >= count_select)
+			break;
+
+		if (!FD_ISSET(t_dimm[i].health_eventfd, &fds))
+			continue;
+
+		log_notify++;
+		if (get_health_info(&t_dimm[i]))
+			continue;
+
+		if (t_dimm[i].spares == -1) {
+			syslog(LOG_WARNING,
+				"%s [%s]\nhealth_state: %s\n"
+				"spares_percentage: failed to get data\n",
+				msg, t_dimm[i].devname, t_dimm[i].health_state);
+			continue;
+		}
+		syslog(LOG_WARNING,"%s [%s]\nhealth_state: %s\nspares_percentage: %d\n",
+			msg, t_dimm[i].devname, t_dimm[i].health_state, t_dimm[i].spares);
+	}
+	return log_notify;
+}
+
+static struct ndctl_dimm *is_supported_threshold_notify(struct ndctl_dimm *dimm)
+{
+	if (ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD))
+		return dimm;
+	return NULL;
+}
+
+int
+get_threshold_dimm(struct ndctl_ctx *ctx, threshold_dimm *t_dimm, fd_set *fds, int *maxfd)
+{
+	struct ndctl_bus *bus;
+	struct ndctl_dimm *dimm;
+	char buf[BUF_SIZE];
+	int fd, count_dimm = 0;
+
+	ndctl_bus_foreach(ctx, bus) {
+		ndctl_dimm_foreach(bus, dimm) {
+
+			if (!is_supported_threshold_notify(dimm))
+				continue;
+			t_dimm[count_dimm].dimm = dimm;
+			t_dimm[count_dimm].devname = ndctl_dimm_get_devname(dimm);
+			fd = ndctl_dimm_get_health_eventfd(dimm);
+			read(fd, buf, sizeof(buf));
+			t_dimm[count_dimm].health_eventfd = fd;
+
+			if (fds)
+				FD_SET(fd, fds);
+			if (maxfd) {
+				if (*maxfd < fd)
+					*maxfd = fd;
+			}
+			count_dimm++;
+		}
+	}
+	return count_dimm;
+}
diff --git a/nvdimmd/libnvdimmd.h b/nvdimmd/libnvdimmd.h
new file mode 100644
index 0000000..78e5871
--- /dev/null
+++ b/nvdimmd/libnvdimmd.h
@@ -0,0 +1,31 @@
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
+#ifndef _LIBNVDIMMD_H_
+#define _LIBBVDIMMD_H_
+
+#include <stdio.h>
+#define NUM_MAX_DIMM 1024
+
+typedef struct {
+	struct ndctl_dimm *dimm;
+	const char *devname;
+	int health_eventfd;
+	int spares;
+	char *health_state;
+} threshold_dimm;
+
+int log_notify(threshold_dimm *t_dimm, int count_dimm, fd_set fds, int count_select);
+int get_threshold_dimm(struct ndctl_ctx *ctx, threshold_dimm *t_dimm, fd_set *fds, int *maxfd);
+
+#endif

--
QI Fuli <qi.fuli@jp.fujitsu.com>


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
