Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 06C3B1A1E63
 for <linux-nvdimm@lists.01.org>; Fri,  2 Sep 2016 06:34:14 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [ndctl PATCH 2/2] ndctl,
 util: add support for HPE DSM SMART interfaces
Date: Fri,  2 Sep 2016 08:32:38 -0500
Message-Id: <20160902133238.22200-3-brian.boylston@hpe.com>
In-Reply-To: <20160902133238.22200-1-brian.boylston@hpe.com>
References: <20160902133238.22200-1-brian.boylston@hpe.com>
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

This patch introduces util_hpe_dimm_health_to_json(), which calls the HPE
DSM functions defined in [1] and populates a JSON object with health data.
This delivers health reporting parity for HPE type N NVDIMMs, but we are
planning a future patch to export JSON for some of the additional health
data defined in [1].

[1] https://github.com/HewlettPackard/hpe-nvm/raw/master/Documentation/NFIT_DSM_DDR4_NVDIMM-N_v84s.pdf

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jerry Hoemann <jerry.hoemann@hpe.com>
Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
---
 ndctl/Makefile.am       |   1 +
 ndctl/builtin-list.c    |   2 +
 ndctl/util/json-hpe.c   | 283 ++++++++++++++++++++++++++++++++++++++++
 ndctl/util/json.h       |   6 +
 ndctl/util/ndctl-hpe1.h | 335 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 627 insertions(+)
 create mode 100644 ndctl/util/json-hpe.c
 create mode 100644 ndctl/util/ndctl-hpe1.h

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 04f3a63..ee1e856 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -48,6 +48,7 @@ ndctl_SOURCES = ndctl.c \
 
 if ENABLE_SMART
 ndctl_SOURCES += util/json-smart.c
+ndctl_SOURCES += util/json-hpe.c
 endif
 
 if ENABLE_DESTRUCTIVE
diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
index 0875ca9..fb1a361 100644
--- a/ndctl/builtin-list.c
+++ b/ndctl/builtin-list.c
@@ -316,6 +316,8 @@ int cmd_list(int argc, const char **argv)
 				struct json_object *jhealth;
 
 				jhealth = util_dimm_health_to_json(dimm);
+				if (!jhealth)
+					jhealth = util_hpe_dimm_health_to_json(dimm);
 				if (jhealth)
 					json_object_object_add(jdimm, "health",
 							jhealth);
diff --git a/ndctl/util/json-hpe.c b/ndctl/util/json-hpe.c
new file mode 100644
index 0000000..02a02e1
--- /dev/null
+++ b/ndctl/util/json-hpe.c
@@ -0,0 +1,283 @@
+/*
+ * Copyright (C) 2016 Hewlett Packard Enterprise Development LP
+ * Copyright (c) 2014-2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+
+#include <string.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+#include <util/json.h>
+#include <json-c/json.h>
+#include <ndctl/libndctl.h>
+#include <ccan/array_size/array_size.h>
+
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+
+#include "ndctl-hpe1.h"
+
+/* Open the control node for the given dimm and return the
+ * file descriptor.  The caller must close() the returned
+ * descriptor.
+ */
+static int open_dimm(struct ndctl_dimm *dimm)
+{
+	struct stat st;
+	char path[20], *prefix;
+	unsigned int major, minor, id;
+	int rc = 0, fd, len = sizeof(path);
+
+	prefix = "nmem";
+	id = ndctl_dimm_get_id(dimm);
+	major = ndctl_dimm_get_major(dimm);
+	minor = ndctl_dimm_get_minor(dimm);
+
+	if (snprintf(path, len, "/dev/%s%u", prefix, id) >= len) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	fd = open(path, O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr,
+			"failed to open %s: %s\n", path, strerror(errno));
+		rc = -errno;
+		goto out;
+	}
+
+	if (fstat(fd, &st) >= 0 && S_ISCHR(st.st_mode)
+			&& major(st.st_rdev) == major
+			&& minor(st.st_rdev) == minor) {
+		return fd;
+	} else {
+		fprintf(stderr,
+			"failed to validate %s as a control node\n", path);
+		rc = -ENXIO;
+	}
+	close(fd);
+ out:
+	return rc;
+}
+
+/* Fetch and return the ndn_hpe1_smart_data for the given dimm.
+ * The caller must free() the returned buffer.
+ */
+static struct ndn_hpe1_smart_data *fetch_smart(struct ndctl_dimm *dimm,
+	unsigned int which)
+{
+	struct ndn_pkg_hpe1 cmd;
+	int fd;
+	struct ndn_hpe1_smart_data *smart;
+	int rc;
+
+	fd = open_dimm(dimm);
+	if (fd < 0)
+		return NULL;
+
+	smart = malloc(sizeof(*smart));
+	if (!smart) {
+		close(fd);
+		return NULL;
+	}
+
+	bzero(&cmd, sizeof(cmd));
+	cmd.gen.nd_family = NVDIMM_FAMILY_HPE1;
+	cmd.gen.nd_command = NDN_HPE1_CMD_SMART;
+	cmd.gen.nd_fw_size = 0;
+	cmd.gen.nd_size_in = (__u64)&((struct ndn_hpe1_smart *)0UL)->status;
+	cmd.gen.nd_size_out = sizeof(cmd.u.smart);
+	cmd.u.smart.in_valid_flags = which;
+	cmd.u.smart.status = 3;
+
+	rc = ioctl(fd, NDN_IOCTL_HPE1_PASSTHRU, &cmd);
+	close(fd);
+	if (rc == -1 || cmd.u.smart.status != 0) {
+		free(smart);
+		return NULL;
+	}
+
+	memcpy(smart, &(cmd.u.smart.data), sizeof(*smart));
+	return smart;
+}
+
+/* Fetch and return the ndn_hpe1_smart_threshold_data for the given dimm.
+ * The caller must free() the returned buffer.
+ */
+static struct ndn_hpe1_smart_threshold_data *fetch_smart_thresh(
+	struct ndctl_dimm *dimm)
+{
+	struct ndn_pkg_hpe1 cmd;
+	int fd;
+	struct ndn_hpe1_smart_threshold_data *thresh;
+	int rc;
+
+	fd = open_dimm(dimm);
+	if (fd < 0)
+		return NULL;
+
+	thresh = malloc(sizeof(*thresh));
+	if (!thresh) {
+		close(fd);
+		return NULL;
+	}
+
+	bzero(&cmd, sizeof(cmd));
+	cmd.gen.nd_family = NVDIMM_FAMILY_HPE1;
+	cmd.gen.nd_command = NDN_HPE1_CMD_SMART_THRESHOLD;
+	cmd.gen.nd_fw_size = 0;
+	cmd.gen.nd_size_in = (__u64)&((struct ndn_hpe1_smart_threshold *)0UL)->status;
+	cmd.gen.nd_size_out = sizeof(cmd.u.thresh);
+	cmd.u.thresh.status = 3;
+
+	rc = ioctl(fd, NDN_IOCTL_HPE1_PASSTHRU, &cmd);
+	close(fd);
+	if (rc == -1 || cmd.u.thresh.status != 0) {
+		free(thresh);
+		return NULL;
+	}
+
+	memcpy(thresh, &(cmd.u.thresh.data), sizeof(*thresh));
+	return thresh;
+}
+
+struct json_object *util_hpe_dimm_health_to_json(struct ndctl_dimm *dimm)
+{
+	struct json_object *jhealth = json_object_new_object();
+	struct json_object *jobj;
+	struct ndn_hpe1_smart_data *smart = NULL;
+	struct ndn_hpe1_smart_threshold_data *thresh = NULL;
+	unsigned int flags;
+
+	if (!jhealth)
+		return NULL;
+
+	flags = 0;
+	flags |= NDN_HPE1_SMART_HEALTH_VALID;
+	flags |= NDN_HPE1_SMART_TEMP_VALID;
+	flags |= NDN_HPE1_SMART_SPARES_VALID;
+	flags |= NDN_HPE1_SMART_ALARM_VALID;
+	flags |= NDN_HPE1_SMART_USED_VALID;
+	flags |= NDN_HPE1_SMART_SHUTDOWN_VALID;
+	smart = fetch_smart(dimm, flags);
+	if (!smart)
+		goto err;
+
+	thresh = fetch_smart_thresh(dimm);
+	if (!thresh)
+		goto err;
+
+	flags = smart->out_valid_flags;
+
+	if (flags & NDN_HPE1_SMART_HEALTH_VALID) {
+		unsigned char health = smart->stat_summary;
+
+		if (health & NDN_HPE1_SMART_FATAL_HEALTH)
+			jobj = json_object_new_string("fatal");
+		else if (health & NDN_HPE1_SMART_CRITICAL_HEALTH)
+			jobj = json_object_new_string("critical");
+		else if (health & NDN_HPE1_SMART_NONCRIT_HEALTH)
+			jobj = json_object_new_string("non-critical");
+		else
+			jobj = json_object_new_string("ok");
+		if (jobj)
+			json_object_object_add(jhealth, "health_state", jobj);
+	}
+
+	if (flags & NDN_HPE1_SMART_TEMP_VALID) {
+		double t = parse_smart_temperature(smart->curr_temp);
+
+		jobj = json_object_new_double(t);
+		if (jobj)
+			json_object_object_add(jhealth,
+				"temperature_celsius", jobj);
+	}
+
+	if (flags & NDN_HPE1_SMART_SPARES_VALID) {
+		jobj = json_object_new_int(smart->spare_blocks);
+		if (jobj)
+			json_object_object_add(jhealth,
+				"spares_percentage", jobj);
+	}
+
+	if (flags & NDN_HPE1_SMART_ALARM_VALID) {
+		unsigned int alarm_flags = smart->alarm_trips;
+		bool temp_flag = !!(alarm_flags & NDN_HPE1_SMART_TEMP_TRIP);
+		bool spares_flag = !!(alarm_flags & NDN_HPE1_SMART_SPARE_TRIP);
+
+		jobj = json_object_new_boolean(temp_flag);
+		if (jobj)
+			json_object_object_add(jhealth,
+				"alarm_temperature", jobj);
+
+		jobj = json_object_new_boolean(spares_flag);
+		if (jobj)
+			json_object_object_add(jhealth,
+				"alarm_spares", jobj);
+	}
+
+	if (thresh->threshold_alarm_ctl & NDN_HPE1_SMART_TEMP_TRIP) {
+		double t = parse_smart_temperature(thresh->temp_threshold);
+
+		jobj = json_object_new_double(t);
+		if (jobj)
+			json_object_object_add(jhealth,
+				"temperature_threshold", jobj);
+	}
+
+	if (thresh->threshold_alarm_ctl & NDN_HPE1_SMART_SPARE_TRIP) {
+		jobj = json_object_new_int(thresh->spare_block_threshold);
+		if (jobj)
+			json_object_object_add(jhealth,
+				"spares_threshold", jobj);
+	}
+
+	if (flags & NDN_HPE1_SMART_USED_VALID) {
+		unsigned int life_used = smart->device_life;
+
+		jobj = json_object_new_int(life_used);
+		if (jobj)
+			json_object_object_add(jhealth,
+				"life_used_percentage", jobj);
+	}
+
+	if (flags & NDN_HPE1_SMART_SHUTDOWN_VALID) {
+		unsigned int shutdown = smart->last_shutdown_stat;
+
+		if (shutdown == NDN_HPE1_SMART_LASTSAVEGOOD)
+			jobj = json_object_new_string("clean");
+		else
+			jobj = json_object_new_string("dirty");
+		if (jobj)
+			json_object_object_add(jhealth, "shutdown_state", jobj);
+	}
+
+	free(thresh);
+	free(smart);
+
+	return jhealth;
+
+err:
+	if (thresh)
+		free(thresh);
+	if (smart)
+		free(smart);
+	json_object_put(jhealth);
+	return NULL;
+}
diff --git a/ndctl/util/json.h b/ndctl/util/json.h
index e8b1549..afceda4 100644
--- a/ndctl/util/json.h
+++ b/ndctl/util/json.h
@@ -15,6 +15,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 #ifdef HAVE_NDCTL_SMART
 double parse_smart_temperature(unsigned int temp);
 struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
+struct json_object *util_hpe_dimm_health_to_json(struct ndctl_dimm *dimm);
 #else
 static inline double parse_smart_temperature(unsigned int temp)
 {
@@ -25,5 +26,10 @@ static inline struct json_object *util_dimm_health_to_json(
 {
 	return NULL;
 }
+static inline struct json_object *util_hpe_dimm_health_to_json(
+		struct ndctl_dimm *dimm)
+{
+	return NULL;
+}
 #endif
 #endif /* __NDCTL_JSON_H__ */
diff --git a/ndctl/util/ndctl-hpe1.h b/ndctl/util/ndctl-hpe1.h
new file mode 100644
index 0000000..0d41aab
--- /dev/null
+++ b/ndctl/util/ndctl-hpe1.h
@@ -0,0 +1,335 @@
+/*
+ * Copyright (C) 2016 Hewlett Packard Enterprise Development LP
+ * Copyright (c) 2014-2015, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#ifndef __NDCTL_HPE1_H__
+#define __NDCTL_HPE1_H__
+
+enum {
+	NDN_HPE1_CMD_QUERY = 0,
+
+	/* non-root commands */
+	NDN_HPE1_CMD_SMART = 1,
+	NDN_HPE1_CMD_SMART_THRESHOLD = 2,
+	NDN_HPE1_CMD_GET_CONFIG_SIZE = 4,
+	NDN_HPE1_CMD_GET_CONFIG_DATA = 5,
+	NDN_HPE1_CMD_SET_CONFIG_DATA = 6,
+	NDN_HPE1_CMD_GET_IDENT = 10,
+	NDN_HPE1_CMD_GET_ES_IDENT = 11,
+	NDN_HPE1_CMD_GET_LAST_BACKUP = 12,
+	NDN_HPE1_CMD_SET_LIFE_THRESHOLD = 13,
+	NDN_HPE1_CMD_ERRINJ_QUERY = 18,
+	NDN_HPE1_CMD_ERRINJ_INJECT = 19,
+	NDN_HPE1_CMD_ERRINJ_STATUS = 20,
+};
+
+/* NDN_HPE1_CMD_SMART */
+struct ndn_hpe1_smart {
+	__u32 in_valid_flags;
+	__u32 status;
+	__u8 data[124];
+} __attribute__((packed));
+
+/* ndn_hpe1_smart.in_valid_flags / ndn_hpe1_smart_data.out_valid_flags */
+#define NDN_HPE1_SMART_HEALTH_VALID	(1 << 0)
+#define NDN_HPE1_SMART_TEMP_VALID	(1 << 1)
+#define NDN_HPE1_SMART_SPARES_VALID	(1 << 2)
+#define NDN_HPE1_SMART_ALARM_VALID	(1 << 3)
+#define NDN_HPE1_SMART_USED_VALID	(1 << 4)
+#define NDN_HPE1_SMART_SHUTDOWN_VALID	(1 << 5)
+#define NDN_HPE1_SMART_STATS_VALID	(1 << 6)
+#define NDN_HPE1_SMART_DETAIL_VALID	(1 << 7)
+#define NDN_HPE1_SMART_ENERGY_VALID	(1 << 8)
+#define NDN_HPE1_SMART_VENDOR_VALID	(1 << 9)
+#define NDN_HPE1_SMART_NOTIFIED		(1 << 31)
+
+/* ndn_hpe1_smart_data.stat_summary */
+#define NDN_HPE1_SMART_NONCRIT_HEALTH	(1 << 0)
+#define NDN_HPE1_SMART_CRITICAL_HEALTH	(1 << 1)
+#define NDN_HPE1_SMART_FATAL_HEALTH	(1 << 2)
+
+/* ndn_hpe1_smart_data.alarm_trips */
+#define NDN_HPE1_SMART_TEMP_TRIP	(1 << 0)
+#define NDN_HPE1_SMART_SPARE_TRIP	(1 << 1)
+#define NDN_HPE1_SMART_LIFEWARN_TRIP	(1 << 2)
+#define NDN_HPE1_SMART_LIFEERR_TRIP	(1 << 3)
+#define NDN_HPE1_SMART_ESLIFEWARN_TRIP	(1 << 4)
+#define NDN_HPE1_SMART_ESLIFEERR_TRIP	(1 << 5)
+#define NDN_HPE1_SMART_ESTEMPWARN_TRIP	(1 << 6)
+#define NDN_HPE1_SMART_ESTEMPERR_TRIP	(1 << 7)
+
+/* ndn_hpe1_smart_data.last_shutdown_stat */
+#define NDN_HPE1_SMART_LASTSAVEGOOD	(1 << 1)
+
+/* ndn_hpe1_smart_data.mod_hlth_stat */
+#define NDN_HPE1_SMART_ES_FAILURE	(1 << 0)
+#define NDN_HPE1_SMART_CTLR_FAILURE	(1 << 1)
+#define NDN_HPE1_SMART_UE_TRIP		(1 << 2)
+#define NDN_HPE1_SMART_CE_TRIP		(1 << 3)
+#define NDN_HPE1_SMART_SAVE_FAILED	(1 << 4)
+#define NDN_HPE1_SMART_RESTORE_FAILED	(1 << 5)
+#define NDN_HPE1_SMART_ARM_FAILED	(1 << 6)
+#define NDN_HPE1_SMART_ERASE_FAILED	(1 << 7)
+#define NDN_HPE1_SMART_CONFIG_ERROR	(1 << 8)
+#define NDN_HPE1_SMART_FW_ERROR		(1 << 9)
+#define NDN_HPE1_SMART_VENDOR_ERROR	(1 << 10)
+
+struct ndn_hpe1_smart_data {
+	__u32	out_valid_flags;
+	__u8	stat_summary;
+	__u16	curr_temp;
+	__u8	spare_blocks;
+	__u16	alarm_trips;
+	__u8	device_life;
+	__u8	last_shutdown_stat;
+	__u16	last_save_op_dur;
+	__u16	last_restore_op_dur;
+	__u16	last_erase_op_dur;
+	__u16	res1;
+	__u32	save_ops;
+	__u32	restore_ops;
+	__u32	erase_ops;
+	__u32	life_save_ops;
+	__u32	life_restore_ops;
+	__u32	life_erase_ops;
+	__u32	life_mod_pwr_cycles;
+	__u32	mod_hlth_stat;
+	__u32	energy_src_check;
+	__u8	energy_src_life_percent;
+	__u16	energy_src_curr_temp;
+	__u8	res2;
+	__u16	energy_src_total_runtime;
+	__u16	vndr_spec_data_size;
+	__u8	vnd_spec_data[60];
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_SMART_THRESHOLD */
+struct ndn_hpe1_smart_threshold {
+	__u32 status;
+	__u8 data[32];
+} __attribute__((packed));
+
+struct ndn_hpe1_smart_threshold_data {
+	__u16	threshold_alarm_ctl;
+	__u16	temp_threshold;
+	__u8	spare_block_threshold;
+	__u8	res1[3];
+	__u8	dev_lifewarn_threshold;
+	__u8	dev_lifeerr_threshold;
+	__u8	res2[6];
+	__u8	es_lifewarn_threshold;
+	__u8	es_lifeerr_threshold;
+	__u8	es_tempwarn_threshold;
+	__u8	es_temperr_threshold;
+	__u8	res3[4];
+	__u64	res4;
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_GET_CONFIG_SIZE */
+struct ndn_hpe1_get_config_size {
+	__u32 status;
+	__u32 config_size;
+	__u32 max_xfer;
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_GET_CONFIG_DATA */
+struct ndn_hpe1_get_config_data_hdr {
+	__u32 in_offset;
+	__u32 in_length;
+	__u32 status;
+	__u8 out_buf[0];
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_SET_CONFIG_DATA */
+struct ndn_hpe1_set_config_hdr {
+	__u32 in_offset;
+	__u32 in_length;
+	__u8 in_buf[0];
+} __attribute__((packed));
+
+
+/* ndn_hpe1_get_id.sup_backup_trigger */
+#define NDN_HPE1_BKUP_SUPPORT_CKE	(1 << 0)
+#define NDN_HPE1_BKUP_SUPPORT_EXTERNAL	(1 << 1)
+#define NDN_HPE1_BKUP_SUPPORT_12V	(1 << 2)
+#define NDN_HPE1_BKUP_SUPPORT_I2C	(1 << 3)
+#define NDN_HPE1_BKUP_SUPPORT_SAVEN	(1 << 4)
+
+/* NDN_HPE1_CMD_GET_IDENT */
+struct ndn_hpe1_get_id {
+	__u32	status;
+	__u8	spec_rev;
+	__u8	num_stnd_pages;
+	__u32	hw_rev;
+	__u8	sup_backup_trigger;
+	__u16	max_op_retries;
+	__u8	__res1[3];
+	__u32	backup_op_timeout;
+	__u32	restore_op_timeout;
+	__u32	erase_op_timeout;
+	__u32	arm_op_timeout;
+	__u32	fw_op_timeout;
+	__u32	region_block_size;
+	__u16	min_op_temp;
+	__u16	max_op_temp;
+	__u8	curr_fw_slot;
+	__u8	res2[1];
+	__u16	num_fw_slots;
+	__u8	fw_slot_revision[0];
+} __attribute__((packed));
+
+/* ndn_hpe1_get_energy_src_id.attr */
+#define NDN_HPE1_ES_ATTR_BUILTIN	(1 << 0)
+#define NDN_HPE1_ES_ATTR_TETHERED	(1 << 1)
+#define NDN_HPE1_ES_ATTR_SHARED		(1 << 2)
+
+/* ndn_hpe1_get_energy_src_id.tech */
+#define NDN_HPE1_ES_TECH_UNDEFINED	(1 << 0)
+#define NDN_HPE1_ES_TECH_SUPERCAP	(1 << 1)
+#define NDN_HPE1_ES_TECH_BATTERY	(1 << 2)
+#define NDN_HPE1_ES_TECH_HYBRIDCAP	(1 << 3)
+
+/* NDN_HPE1_CMD_GET_ES_IDENT */
+struct ndn_hpe1_get_energy_src_id {
+	__u32	status;
+	__u8	energy_src_policy;
+	__u8	attr;
+	__u8	tech;
+	__u8	reserved;
+	__u16	hw_rev;
+	__u16	fw_rev;
+	__u32	charge_timeout;
+	__u16	min_op_temp;
+	__u16	max_op_temp;
+} __attribute__((packed));
+
+/* ndn_hpe1_last_backup_info.last_backup_initiation */
+#define NDN_HPE1_LASTBKUP_SAVEN		(1 << 0)
+#define NDN_HPE1_LASTBKUP_EXTERNAL	(1 << 1)
+#define NDN_HPE1_LASTBKUP_CKE		(1 << 2)
+#define NDN_HPE1_LASTBKUP_FW		(1 << 3)
+#define NDN_HPE1_LASTBKUP_RESETN	(1 << 4)
+
+/* ndn_hpe1_last_backup_info.ctlr_backup_stat */
+#define NDN_HPE1_LASTBKUP_GTG		(1 << 0)
+#define NDN_HPE1_LASTBKUP_SDRAM_FAULT	(1 << 1)
+#define NDN_HPE1_LASTBKUP_GEN_FAULT	(1 << 2)
+
+/* NDN_HPE1_CMD_GET_LAST_BACKUP */
+struct ndn_hpe1_get_last_backup {
+	__u32	status;
+	__u32	last_backup_info;
+} __attribute__((packed));
+
+struct ndn_hpe1_last_backup_info {
+	__u8	backup_image;
+	__u8	backup_cmplt_stat;
+	__u8	last_backup_initiation;
+	__u8	ctlr_backup_stat;
+} __attribute__((packed));
+
+
+/* NDN_HPE1_CMD_SET_LIFE_THRESHOLD */
+struct ndn_hpe1_set_lifetime_threshold {
+	__u8	in_nvm_lifetime_warn_threshold;
+	__u32	status;
+} __attribute__((packed));
+
+
+/* ndn_hpe1_inj_err.in_err_typ
+ * ndn_hpe1_get_inj_err_status.err_inj_type
+ * log2(ndn_hpe1_query_err_inj_cap.err_inj_cap)
+ */
+enum {
+	NDN_HPE1_EINJ_DEV_NONCRIT = 1,
+	NDN_HPE1_EINJ_DEV_CRIT = 2,
+	NDN_HPE1_EINJ_DEV_FATAL = 3,
+	NDN_HPE1_EINJ_UE_BACKUP = 4,
+	NDN_HPE1_EINJ_UE_RESTORE = 5,
+	NDN_HPE1_EINJ_UE_ERASE = 6,
+	NDN_HPE1_EINJ_UE_ARM = 7,
+	NDN_HPE1_EINJ_BADBLOCK = 8,
+	NDN_HPE1_EINJ_ES_FAULT = 9,
+	NDN_HPE1_EINJ_ES_LOWCHARGE = 10,
+	NDN_HPE1_EINJ_ES_TEMPWARN = 11,
+	NDN_HPE1_EINJ_ES_TEMPERR = 12,
+	NDN_HPE1_EINJ_ES_LIFEWARN = 13,
+	NDN_HPE1_EINJ_ES_LIFEERR = 14,
+	NDN_HPE1_EINJ_DEV_LIFEWARN = 15,
+	NDN_HPE1_EINJ_DEV_LIFEERR = 16,
+	NDN_HPE1_EINJ_FWUPDATE_ERR = 17,
+	NDN_HPE1_EINJ_CTRL_ERR = 18,
+};
+
+/* ndn_hpe1_inj_err.in_options / ndn_hpe1_get_inj_err_status.err_inj_opt */
+enum {
+	NDN_HPE1_EINJ_OPT_SINGLE = 0,
+	NDN_HPE1_EINJ_OPT_PERSISTENT = 1,
+	NDN_HPE1_EINJ_OPT_CLEAR = 2,
+};
+
+/* ndn_hpe1_get_inj_err_status.err_inj_stat_info */
+enum {
+	NDN_HPE1_EINJ_STAT_NONE = 0,
+	NDN_HPE1_EINJ_STAT_INJECTED = 1,
+	NDN_HPE1_EINJ_STAT_PENDING = 2,
+};
+
+/* NDN_HPE1_CMD_ERRINJ_QUERY */
+struct ndn_hpe1_query_err_inj_cap {
+	__u32	status;
+	__u8	err_inj_cap[32];
+} __attribute__((packed));
+
+
+/* NDN_HPE1_CMD_ERRINJ_INJECT */
+struct ndn_hpe1_inj_err {
+	__u8	in_err_typ;
+	__u8	in_options;
+	__u32	status;
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_ERRINJ_STATUS */
+struct ndn_hpe1_get_inj_err_status {
+	__u32	status;
+	__u8	err_inj_stat_info;
+	__u8	err_inj_type;
+	__u8	err_inj_opt;
+} __attribute__((packed));
+
+union ndn_hpe1_cmd {
+	__u64					query;
+	struct ndn_hpe1_smart			smart;
+	struct ndn_hpe1_smart_threshold		thresh;
+	struct ndn_hpe1_get_config_size		get_size;
+	struct ndn_hpe1_get_config_data_hdr	get_data;
+	struct ndn_hpe1_get_id			get_id;
+	struct ndn_hpe1_get_energy_src_id	get_energy_src_id;
+	struct ndn_hpe1_get_last_backup		get_last_backup;
+	struct ndn_hpe1_last_backup_info	last_backup_info;
+	struct ndn_hpe1_set_lifetime_threshold	set_life_thresh;
+	struct ndn_hpe1_query_err_inj_cap	err_cap;
+	struct ndn_hpe1_inj_err			inj_err;
+	struct ndn_hpe1_get_inj_err_status	inj_err_stat;
+
+	unsigned char				buf[128];
+};
+
+struct ndn_pkg_hpe1 {
+	struct nd_cmd_pkg gen;
+	union ndn_hpe1_cmd u;
+} __attribute__((packed));
+
+#define NDN_IOCTL_HPE1_PASSTHRU		_IOWR(ND_IOCTL, ND_CMD_CALL, \
+					struct ndn_pkg_hpe1)
+
+#endif /* __NDCTL_HPE1_H__ */
-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
