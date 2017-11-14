Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 335EA2035A7DB
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 23:43:12 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 3B917AC0078
 for <linux-nvdimm@lists.01.org>; Tue, 14 Nov 2017 16:47:13 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RFC PATCH v2 2/7] ndctl: nvdimmd: add nvdimmd necessary util
 functions
Date: Tue, 14 Nov 2017 16:46:59 +0900
Message-Id: <20171114074704.3446-3-qi.fuli@jp.fujitsu.com>
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

This patch is used to provide helper functions needed for nvdimm daemon.
These util functions can be used by other features as well in the future.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 nvdimmd/util.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 nvdimmd/util.h | 33 ++++++++++++++++++++++++
 2 files changed, 113 insertions(+)
 create mode 100644 nvdimmd/util.c
 create mode 100644 nvdimmd/util.h

diff --git a/nvdimmd/util.c b/nvdimmd/util.c
new file mode 100644
index 0000000..ef6819e
--- /dev/null
+++ b/nvdimmd/util.c
@@ -0,0 +1,80 @@
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
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include "util.h"
+
+void logrotate(char *file)
+{
+	time_t c_time;
+	char buf[4096], tstamp[32];
+
+	c_time = time(NULL);
+	strftime(tstamp, sizeof(tstamp), ".%Y%m%d%H%M%S", localtime(&c_time));
+	strcpy(buf, file);
+	strcat(buf, tstamp);
+	rename(file, buf);
+}
+
+long get_size(char *file)
+{
+	struct stat buf;
+	if (stat(file, &buf) == 0)
+		return buf.st_size;
+	return -1L;
+}
+
+char *set_string(char **str, const char *value)
+{
+	*str = strdup(value);
+	return *str;
+}
+
+char *trim_string(char *str)
+{
+	char *start;
+	char *end;
+	int len = strlen(str);
+
+	if (len == 0)
+		return NULL;
+
+	if (str[len-1] == '\n') {
+		len--;
+		str[len] = 0;
+	}
+
+	start = str;
+	end = str + len - 1;
+	while(*start && isspace(*start))
+		start++;
+	while(*end && isspace(*end))
+		*end-- = 0;
+	strcpy(str, start);
+	return str;
+}
+
+int split_string(char *str, const char *deli, char *outlist[])
+{
+	int cnt = 0;
+	char *temp;
+
+	temp = strtok(str, deli);
+	while (temp != NULL && cnt < NUM_MAX_DIMM) {
+		outlist[cnt++] = temp;
+		temp = strtok(NULL, deli);
+	}
+	return cnt;
+}
diff --git a/nvdimmd/util.h b/nvdimmd/util.h
new file mode 100644
index 0000000..9648256
--- /dev/null
+++ b/nvdimmd/util.h
@@ -0,0 +1,33 @@
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
+#ifndef _UTIL_H_
+#define _UTIL_H_
+
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <ctype.h>
+#define NUM_MAX_DIMM 1024
+
+void logrotate(char *file);
+
+long get_size(char *file);
+
+char *set_string(char **str, const char *value);
+
+char *trim_string(char *str);
+
+int split_string(char *str, const char *deli, char *outlist[]);
+
+#endif
-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
