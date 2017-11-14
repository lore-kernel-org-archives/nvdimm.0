Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F314202E5E53
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 23:43:09 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 4F0ADAC00CB
 for <linux-nvdimm@lists.01.org>; Tue, 14 Nov 2017 16:47:13 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RFC PATCH v2 3/7] ndctl: nvdimmd: add nvdimmd necessary functions
Date: Tue, 14 Nov 2017 16:47:00 +0900
Message-Id: <20171114074704.3446-4-qi.fuli@jp.fujitsu.com>
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

Libnvdimmd is used to provide nvdimmd necessary functions.
The get_nvdimmd_conf() will read the nvdimmd.conf and set the
parameters' value as global variables when nvdimmd service starts.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 nvdimmd/libnvdimmd.c | 315 +++++++++++++++++++++++++++++++++++++++++++++++++++
 nvdimmd/libnvdimmd.h |  53 +++++++++
 2 files changed, 368 insertions(+)
 create mode 100644 nvdimmd/libnvdimmd.c
 create mode 100644 nvdimmd/libnvdimmd.h

diff --git a/nvdimmd/libnvdimmd.c b/nvdimmd/libnvdimmd.c
new file mode 100644
index 0000000..7e5d16b
--- /dev/null
+++ b/nvdimmd/libnvdimmd.c
@@ -0,0 +1,315 @@
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
+#include <syslog.h>
+#include <json-c/json.h>
+#include <util/json.h>
+#include <util/filter.h>
+#include <ndctl/lib/private.h>
+#include <dirent.h>
+#include "libnvdimmd.h"
+
+void log_syslog(struct ndctl_ctx *ctx, int priority, const char *file,
+	int line, const char *fn, const char *format, va_list args)
+{
+	char buf[BUF_SIZE];
+	struct log_ctx *log_ctx;
+
+	log_ctx = &ctx->ctx;
+	vsnprintf(buf, sizeof(buf), format, args);
+	syslog(priority, "%s: %s: %s", log_ctx->owner, fn, buf);
+}
+
+void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
+	int line, const char *fn, const char *format, va_list args)
+{
+	DIR *dir;
+	FILE *f;
+	time_t c_time;
+	char date[32], buf[BUF_SIZE];
+	char *filename;
+	int len = strlen(nvdimmd_cf->logfile) + strlen("/var/log/nvdimmd/");
+
+	filename = (char *) malloc(len);
+	strcpy(filename, "/var/log/nvdimmd/");
+	strcat(filename, nvdimmd_cf->logfile);
+
+	dir = opendir("/var/log/nvdimmd");
+	if (dir) {
+		if (get_size(filename) >= 20000000)
+			logrotate(filename);
+	} else {
+		if (mkdir("/var/log/nvdimmd", 0744) == -1) {
+			syslog(LOG_ERR, "cannot make dir /var/log/nvdimmd\n");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	f = fopen(filename, "a+");
+	if (f == NULL) {
+		syslog(LOG_ERR, "%s cannot be opened\n", filename);
+		exit(EXIT_FAILURE);
+	}
+
+	c_time = time(NULL);
+	strftime(date, sizeof(date), "%Y/%m/%d %H:%M:%S", localtime(&c_time));
+	vsnprintf(buf, sizeof(buf), format, args);
+	fprintf(f, "%s [%u] %s: %s\n", date, (int)getpid(), fn, buf);
+	fclose(f);
+	free(filename);
+}
+
+static char *get_json_msg(struct ndctl_ctx *ctx, struct threshold_dimm *t_dimm)
+{
+	struct json_object *jdimm, *jhealth;
+	char *msg;
+
+	msg = (char *) malloc(1024);
+	msg[0] = '\0';
+	jdimm = util_dimm_to_json(t_dimm->dimm, 0);
+	if (!jdimm) {
+		printf("no jdimm");
+	}
+	jhealth = util_dimm_health_to_json(t_dimm->dimm);
+	if (jhealth)
+		json_object_object_add(jdimm, "health", jhealth);
+	else if (ndctl_dimm_is_cmd_supported(t_dimm->dimm, ND_CMD_SMART))
+		dbg(ctx, "dimm [%s] do not support smart", t_dimm->devname);
+	else
+		dbg(ctx, "dimm [%s] can not get health info", t_dimm->devname);
+
+	strcat(msg, json_object_to_json_string_ext(jdimm,
+			JSON_C_TO_STRING_PRETTY));
+	return msg;
+}
+
+static char *get_text_msg(struct ndctl_ctx *ctx, struct threshold_dimm *t_dimm)
+{
+	char *msg;
+	struct ndctl_cmd *cmd;
+	int rc;
+	unsigned int flags;
+
+	msg = (char *) malloc(1024);
+	msg[0] = '\0';
+	strcat(msg, "dev: ");
+	strcat(msg, t_dimm->devname);
+	strcat(msg, "\n health_state: ");
+
+	cmd = ndctl_dimm_cmd_new_smart(t_dimm->dimm);
+	if (!cmd) {
+		dbg(ctx, "new smart command error");
+		goto out;
+	}
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc || ndctl_cmd_get_firmware_status(cmd)) {
+		dbg(ctx, "subbmit smart command error");
+		goto out;
+	}
+
+	flags = ndctl_cmd_smart_get_flags(cmd);
+	if (flags & ND_SMART_HEALTH_VALID) {
+		unsigned int health = ndctl_cmd_smart_get_health(cmd);
+		if (health & ND_SMART_FATAL_HEALTH)
+			strcat(msg, "fatal");
+		else if (health & ND_SMART_CRITICAL_HEALTH)
+			strcat(msg, "critical");
+		else if (health & ND_SMART_NON_CRITICAL_HEALTH)
+			strcat(msg, "non-critical");
+		else
+			strcat(msg, "ok");
+	} else {
+		strcat(msg, "failed to get data");
+	}
+	strcat(msg, "\n spares_percentage: ");
+
+	if (flags & ND_SMART_SPARES_VALID) {
+		char buf[6];
+		snprintf(buf, 6, "%d", ndctl_cmd_smart_get_spares(cmd));
+		strcat(msg, buf);
+	}
+	else
+		strcat(msg, "failed to get data");
+
+	ndctl_cmd_unref(cmd);
+	return msg;
+
+ out:
+	strcat(msg, "failed to get data\n spares_percentage: failed to get data");
+	return msg;
+}
+
+static void get_notice_msg(struct ndctl_ctx *ctx, struct threshold_dimm *t_dimm,
+				char **log_msg)
+{
+	char *msg;
+	msg = (char *) malloc(2048);
+	msg[0] = '\0';
+	strcat(msg, "nvdimm dimm over threshold notify\n");
+
+	if (strcmp(nvdimmd_cf->logformat, "json") == 0)
+		strcat(msg, get_json_msg(ctx, t_dimm));
+	else
+		strcat(msg, get_text_msg(ctx, t_dimm));
+
+	*log_msg = msg;
+}
+
+int log_notify(struct ndctl_ctx *ctx, struct threshold_dimm *t_dimm,
+		int cnt_dimm, fd_set fds, int cnt_select)
+{
+	int log_notify = 0;
+	char *log_msg;
+
+	for (int i = 0; i < cnt_dimm; i++) {
+		if (log_notify >= cnt_select)
+			break;
+
+		if (!FD_ISSET(t_dimm[i].health_eventfd, &fds))
+			continue;
+		log_notify++;
+
+		get_notice_msg(ctx, &t_dimm[i], &log_msg);
+		notice(ctx, "%s", log_msg);
+		free(log_msg);
+	}
+	return log_notify;
+}
+
+int get_threshold_dimm(struct ndctl_ctx *ctx, struct threshold_dimm *t_dimm,
+			fd_set *fds, int *maxfd)
+{
+	struct ndctl_bus *bus;
+	struct ndctl_dimm *dimm;
+	bool flag = false;
+	int fd, cnt_dimm = 0;
+	char buf[BUF_SIZE];
+
+	ndctl_bus_foreach(ctx, bus) {
+		for (int i = 0; i < cnt_mbus; i++) {
+			if (util_bus_filter(bus, buslist[i])) {
+				flag = true;
+				break;
+			}
+		}
+		if (!flag)
+			continue;
+		flag = false;
+		ndctl_dimm_foreach(bus, dimm) {
+			for (int j = 0; j < cnt_mdimm; j++) {
+				if (util_dimm_filter(dimm, dimmlist[j])) {
+					flag = true;
+					break;
+				}
+			}
+			if (!flag)
+				continue;
+			flag = false;
+			if (!ndctl_dimm_is_cmd_supported(dimm,
+					ND_CMD_SMART_THRESHOLD))
+				continue;
+			t_dimm[cnt_dimm].dimm = dimm;
+			t_dimm[cnt_dimm].devname = ndctl_dimm_get_devname(dimm);
+			fd = ndctl_dimm_get_health_eventfd(dimm);
+			read(fd, buf, sizeof(buf));
+			t_dimm[cnt_dimm].health_eventfd = fd;
+
+			if (fds)
+				FD_SET(fd, fds);
+			if (maxfd) {
+				if (*maxfd < fd)
+					*maxfd = fd;
+			}
+			cnt_dimm++;
+		}
+	}
+	return cnt_dimm;
+}
+
+int get_nvdimmd_conf(const char *path)
+{
+	FILE *f;
+	char buf[BUF_SIZE];
+	struct nvdimmd_conf *conf;
+
+	f = fopen(path, "r");
+	if (f == NULL) {
+		syslog(LOG_ERR, "%s cannot be found\n", path);
+		return -1;
+	}
+
+	conf = calloc(1, sizeof(struct nvdimmd_conf));
+	if (conf == NULL)
+		goto file_err;
+
+	while (fgets(buf, BUF_SIZE, f) != NULL) {
+		char *key;
+		char *value;
+
+		key = trim_string(buf);
+
+		if (key[0] == '#' || key[0] == '\0'){
+			continue;
+		}
+
+		value = strchr(key, '=');
+		if (value == NULL)
+			continue;
+
+		value[0] = '\0';
+		value++;
+
+		key = trim_string(key);
+		if (key == NULL)
+			continue;
+		value = trim_string(value);
+		if (value == NULL)
+			continue;
+
+		if (strcmp(key, "LOGFILE") == 0) {
+			set_string(&conf->logfile, value);
+			continue;
+		}
+		if (strcmp(key, "LOGFORMAT") == 0) {
+			set_string(&conf->logformat, value);
+			continue;
+		}
+		if (strcmp(key, "MONITORBUS") == 0) {
+			set_string(&conf->mbus, value);
+			continue;
+		}
+		if (strcmp(key, "MONITORDIMM") == 0) {
+			set_string(&conf->mdimm, value);
+			continue;
+		}
+	}
+	fclose(f);
+
+	if (conf->logfile == NULL || conf->logformat == NULL
+		|| conf->mbus == NULL || conf->mdimm == NULL)
+		return -1;
+
+	nvdimmd_cf = conf;
+	cnt_mbus = split_string(nvdimmd_cf->mbus, ",", buslist);
+	cnt_mdimm = split_string(nvdimmd_cf->mdimm, ",", dimmlist);
+	return 0;
+
+file_err:
+	fclose(f);
+	return -1;
+}
diff --git a/nvdimmd/libnvdimmd.h b/nvdimmd/libnvdimmd.h
new file mode 100644
index 0000000..75317e0
--- /dev/null
+++ b/nvdimmd/libnvdimmd.h
@@ -0,0 +1,53 @@
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
+#include <util/log.h>
+#include <ndctl/libndctl.h>
+#include "util.h"
+#define BUF_SIZE 4096
+
+struct nvdimmd_conf {
+	char *logfile;
+	char *logformat;
+	char *mbus;
+	char *mdimm;
+};
+
+struct threshold_dimm {
+	struct ndctl_dimm *dimm;
+	const char *devname;
+	int health_eventfd;
+};
+
+struct nvdimmd_conf *nvdimmd_cf;
+char *buslist[NUM_MAX_DIMM];
+char *dimmlist[NUM_MAX_DIMM];
+int cnt_mbus, cnt_mdimm;
+
+void log_syslog(struct ndctl_ctx *ctx, int priority, const char *file, int line,
+		const char *fn, const char *format, va_list args);
+void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
+	int line, const char *fn, const char *format, va_list args);
+
+int log_notify(struct ndctl_ctx *ctx, struct threshold_dimm *t_dimm,
+		int count_dimm, fd_set fds, int count_select);
+int get_threshold_dimm(struct ndctl_ctx *ctx,
+		struct threshold_dimm *t_dimm, fd_set *fds, int *maxfd);
+
+int get_nvdimmd_conf(const char *path);
+
+#endif
-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
