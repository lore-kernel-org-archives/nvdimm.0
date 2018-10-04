Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B0EBA21A00AE6
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 15:36:59 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] libndctl: set errno for routines that don't return an
 error status
Date: Thu,  4 Oct 2018 16:34:12 -0600
Message-Id: <20181004223412.17403-1-vishal.l.verma@intel.com>
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

For routines that return a UINT_MAX or UL{L}ONG_MAX, there isn't a way
to get any information as to what went wrong. Set errno in such routines
so that the callers can get some additional context about the error.

Reported-by: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/dimm.c     |  8 +++--
 ndctl/lib/hpe1.c     | 79 +++++++++++++++++++++++++++++++++++++-------
 ndctl/lib/inject.c   |  2 ++
 ndctl/lib/intel.c    | 45 +++++++++++++++++++++----
 ndctl/lib/libndctl.c | 54 ++++++++++++++++++++++--------
 ndctl/lib/msft.c     | 27 ++++++++++++---
 6 files changed, 177 insertions(+), 38 deletions(-)

diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index b3e032e..0299b41 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -565,17 +565,21 @@ NDCTL_EXPORT unsigned long ndctl_dimm_get_available_labels(
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	char *path = dimm->dimm_buf;
-	int len = dimm->buf_len;
+	int rc, len = dimm->buf_len;
 	char buf[20];
 
 	if (snprintf(path, len, "%s/available_slots", dimm->dimm_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
 				ndctl_dimm_get_devname(dimm));
+		errno = EOVERFLOW;
 		return ULONG_MAX;
 	}
 
-	if (sysfs_read_attr(ctx, path, buf) < 0)
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc < 0) {
+		errno = -rc;
 		return ULONG_MAX;
+	}
 
 	return strtoul(buf, NULL, 0);
 }
diff --git a/ndctl/lib/hpe1.c b/ndctl/lib/hpe1.c
index dbc1ff0..b26120e 100644
--- a/ndctl/lib/hpe1.c
+++ b/ndctl/lib/hpe1.c
@@ -90,9 +90,13 @@ static unsigned int hpe1_cmd_smart_get_flags(struct ndctl_cmd *cmd)
 {
 	unsigned int hpe1flags;
 	unsigned int flags;
+	int rc;
 
-	if (hpe1_smart_valid(cmd) < 0)
+	rc = hpe1_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	hpe1flags = CMD_HPE1_SMART(cmd)->out_valid_flags;
 	flags = 0;
@@ -118,9 +122,13 @@ static unsigned int hpe1_cmd_smart_get_health(struct ndctl_cmd *cmd)
 {
 	unsigned char hpe1health;
 	unsigned int health;
+	int rc;
 
-	if (hpe1_smart_valid(cmd) < 0)
+	rc = hpe1_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	hpe1health = CMD_HPE1_SMART(cmd)->stat_summary;
 	health = 0;
@@ -136,16 +144,26 @@ static unsigned int hpe1_cmd_smart_get_health(struct ndctl_cmd *cmd)
 
 static unsigned int hpe1_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
 {
-	if (hpe1_smart_valid(cmd) < 0)
+	int rc;
+
+	rc = hpe1_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	return CMD_HPE1_SMART(cmd)->curr_temp;
 }
 
 static unsigned int hpe1_cmd_smart_get_spares(struct ndctl_cmd *cmd)
 {
-	if (hpe1_smart_valid(cmd) < 0)
+	int rc;
+
+	rc = hpe1_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	return CMD_HPE1_SMART(cmd)->spare_blocks;
 }
@@ -154,9 +172,13 @@ static unsigned int hpe1_cmd_smart_get_alarm_flags(struct ndctl_cmd *cmd)
 {
 	unsigned int hpe1flags;
 	unsigned int flags;
+	int rc;
 
-	if (hpe1_smart_valid(cmd) < 0)
+	rc = hpe1_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	hpe1flags = CMD_HPE1_SMART(cmd)->alarm_trips;
 	flags = 0;
@@ -170,8 +192,13 @@ static unsigned int hpe1_cmd_smart_get_alarm_flags(struct ndctl_cmd *cmd)
 
 static unsigned int hpe1_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
 {
-	if (hpe1_smart_valid(cmd) < 0)
+	int rc;
+
+	rc = hpe1_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	return CMD_HPE1_SMART(cmd)->device_life;
 }
@@ -179,9 +206,13 @@ static unsigned int hpe1_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
 static unsigned int hpe1_cmd_smart_get_shutdown_state(struct ndctl_cmd *cmd)
 {
 	unsigned int shutdown;
+	int rc;
 
-	if (hpe1_smart_valid(cmd) < 0)
+	rc = hpe1_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	shutdown = CMD_HPE1_SMART(cmd)->last_shutdown_stat;
 	if (shutdown == NDN_HPE1_SMART_LASTSAVEGOOD)
@@ -192,16 +223,26 @@ static unsigned int hpe1_cmd_smart_get_shutdown_state(struct ndctl_cmd *cmd)
 
 static unsigned int hpe1_cmd_smart_get_vendor_size(struct ndctl_cmd *cmd)
 {
-	if (hpe1_smart_valid(cmd) < 0)
+	int rc;
+
+	rc = hpe1_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	return CMD_HPE1_SMART(cmd)->vndr_spec_data_size;
 }
 
 static unsigned char *hpe1_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd)
 {
-	if (hpe1_smart_valid(cmd) < 0)
+	int rc;
+
+	rc = hpe1_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return NULL;
+	}
 
 	return CMD_HPE1_SMART(cmd)->vnd_spec_data;
 }
@@ -265,9 +306,13 @@ static unsigned int hpe1_cmd_smart_threshold_get_alarm_control(struct ndctl_cmd
 {
 	unsigned int hpe1flags;
 	unsigned int flags;
+	int rc;
 
-	if (hpe1_smart_threshold_valid(cmd) < 0)
+	rc = hpe1_smart_threshold_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	hpe1flags = CMD_HPE1_SMART_THRESH(cmd)->threshold_alarm_ctl;
 	flags = 0;
@@ -282,16 +327,26 @@ static unsigned int hpe1_cmd_smart_threshold_get_alarm_control(struct ndctl_cmd
 static unsigned int hpe1_cmd_smart_threshold_get_media_temperature(
 		struct ndctl_cmd *cmd)
 {
-	if (hpe1_smart_threshold_valid(cmd) < 0)
+	int rc;
+
+	rc = hpe1_smart_threshold_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	return CMD_HPE1_SMART_THRESH(cmd)->temp_threshold;
 }
 
 static unsigned int hpe1_cmd_smart_threshold_get_spares(struct ndctl_cmd *cmd)
 {
-	if (hpe1_smart_threshold_valid(cmd) < 0)
+	int rc;
+
+	rc = hpe1_smart_threshold_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	return CMD_HPE1_SMART_THRESH(cmd)->spare_block_threshold;
 }
diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
index 268c5cd..2b0702e 100644
--- a/ndctl/lib/inject.c
+++ b/ndctl/lib/inject.c
@@ -498,6 +498,7 @@ NDCTL_EXPORT unsigned long long ndctl_bb_get_block(struct ndctl_bb *bb)
 {
 	if (bb)
 		return bb->block;
+	errno = EINVAL;
 	return ULLONG_MAX;
 }
 
@@ -505,5 +506,6 @@ NDCTL_EXPORT unsigned long long ndctl_bb_get_count(struct ndctl_bb *bb)
 {
 	if (bb)
 		return bb->count;
+	errno = EINVAL;
 	return ULLONG_MAX;
 }
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 0abea1e..744386f 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -85,8 +85,12 @@ static int intel_smart_valid(struct ndctl_cmd *cmd)
 #define intel_smart_get_field(cmd, field) \
 static unsigned int intel_cmd_smart_get_##field(struct ndctl_cmd *cmd) \
 { \
-	if (intel_smart_valid(cmd) < 0) \
+	int rc; \
+	rc = intel_smart_valid(cmd); \
+	if (rc < 0) { \
+		errno = -rc; \
 		return UINT_MAX; \
+	} \
 	return cmd->intel->smart.field; \
 }
 
@@ -173,8 +177,12 @@ static int intel_smart_threshold_valid(struct ndctl_cmd *cmd)
 static unsigned int intel_cmd_smart_threshold_get_##field( \
 			struct ndctl_cmd *cmd) \
 { \
-	if (intel_smart_threshold_valid(cmd) < 0) \
+	int rc; \
+	rc = intel_smart_threshold_valid(cmd); \
+	if (rc < 0) { \
+		errno = -rc; \
 		return UINT_MAX; \
+	} \
 	return cmd->intel->thresh.field; \
 }
 
@@ -431,8 +439,12 @@ static int intel_fw_get_info_valid(struct ndctl_cmd *cmd)
 static unsigned int intel_cmd_fw_info_get_##field( \
 			struct ndctl_cmd *cmd) \
 { \
-	if (intel_fw_get_info_valid(cmd) < 0) \
+	int rc; \
+	rc = intel_fw_get_info_valid(cmd); \
+	if (rc < 0) { \
+		errno = -rc; \
 		return UINT_MAX; \
+	} \
 	return cmd->intel->info.field; \
 }
 
@@ -440,8 +452,12 @@ static unsigned int intel_cmd_fw_info_get_##field( \
 static unsigned long long intel_cmd_fw_info_get_##field( \
 			struct ndctl_cmd *cmd) \
 { \
-	if (intel_fw_get_info_valid(cmd) < 0) \
+	int rc; \
+	rc = intel_fw_get_info_valid(cmd); \
+	if (rc < 0) { \
+		errno = -rc; \
 		return ULLONG_MAX; \
+	} \
 	return cmd->intel->info.field; \
 }
 
@@ -454,8 +470,13 @@ intel_fw_info_get_field64(cmd, run_version);
 static unsigned long long intel_cmd_fw_info_get_updated_version(
 		struct ndctl_cmd *cmd)
 {
-	if (intel_fw_get_info_valid(cmd) < 0)
+	int rc;
+
+	rc = intel_fw_get_info_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return ULLONG_MAX;
+	}
 	return cmd->intel->info.updated_version;
 
 }
@@ -488,8 +509,13 @@ static int intel_fw_start_valid(struct ndctl_cmd *cmd)
 
 static unsigned int intel_cmd_fw_start_get_context(struct ndctl_cmd *cmd)
 {
-	if (intel_fw_start_valid(cmd) < 0)
+	int rc;
+
+	rc = intel_fw_start_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 	return cmd->intel->start.context;
 }
 
@@ -580,8 +606,13 @@ static int intel_fw_fquery_valid(struct ndctl_cmd *cmd)
 static unsigned long long
 intel_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd)
 {
-	if (intel_fw_fquery_valid(cmd) < 0)
+	int rc;
+
+	rc = intel_fw_fquery_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return ULLONG_MAX;
+	}
 	return cmd->intel->fquery.updated_fw_rev;
 }
 
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 4ceb70e..1506e53 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1112,12 +1112,15 @@ NDCTL_EXPORT unsigned long long ndctl_region_get_resource(struct ndctl_region *r
 	if (snprintf(path, len, "%s/resource", region->region_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
 				ndctl_region_get_devname(region));
+		errno = EOVERFLOW;
 		return ULLONG_MAX;
 	}
 
 	rc = sysfs_read_attr(ctx, path, buf);
-	if (rc < 0)
+	if (rc < 0) {
+		errno = -rc;
 		return ULLONG_MAX;
+	}
 
 	return strtoull(buf, NULL, 0);
 }
@@ -1256,9 +1259,13 @@ NDCTL_EXPORT unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus)
 {
 	unsigned int scrub_count = 0;
 	bool active = false;
+	int rc;
 
-	if (__ndctl_bus_get_scrub_state(bus, &scrub_count, &active))
+	rc = __ndctl_bus_get_scrub_state(bus, &scrub_count, &active);
+	if (rc) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 	return scrub_count;
 }
 
@@ -1720,15 +1727,19 @@ NDCTL_EXPORT unsigned int ndctl_dimm_get_health(struct ndctl_dimm *dimm)
 	unsigned int health;
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	const char *devname = ndctl_dimm_get_devname(dimm);
+	int rc;
 
 	cmd = ndctl_dimm_cmd_new_smart(dimm);
 	if (!cmd) {
 		err(ctx, "%s: no smart command support\n", devname);
 		return UINT_MAX;
 	}
-	if (ndctl_cmd_submit(cmd)) {
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
 		err(ctx, "%s: smart command failed\n", devname);
 		ndctl_cmd_unref(cmd);
+		if (rc < 0)
+			errno = -rc;
 		return UINT_MAX;
 	}
 
@@ -1743,15 +1754,19 @@ NDCTL_EXPORT unsigned int ndctl_dimm_get_flags(struct ndctl_dimm *dimm)
 	unsigned int flags;
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	const char *devname = ndctl_dimm_get_devname(dimm);
+	int rc;
 
 	cmd = ndctl_dimm_cmd_new_smart(dimm);
 	if (!cmd) {
 		dbg(ctx, "%s: no smart command support\n", devname);
 		return UINT_MAX;
 	}
-	if (ndctl_cmd_submit(cmd)) {
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
 		dbg(ctx, "%s: smart command failed\n", devname);
 		ndctl_cmd_unref(cmd);
+		if (rc < 0)
+			errno = -rc;
 		return UINT_MAX;
 	}
 
@@ -1769,6 +1784,7 @@ NDCTL_EXPORT int ndctl_dimm_is_flag_supported(struct ndctl_dimm *dimm,
 
 NDCTL_EXPORT unsigned int ndctl_dimm_get_event_flags(struct ndctl_dimm *dimm)
 {
+	int rc;
 	struct ndctl_cmd *cmd = NULL;
 	unsigned int alarm_flags, event_flags = 0;
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
@@ -1779,9 +1795,12 @@ NDCTL_EXPORT unsigned int ndctl_dimm_get_event_flags(struct ndctl_dimm *dimm)
 		err(ctx, "%s: no smart command support\n", devname);
 		return UINT_MAX;
 	}
-	if (ndctl_cmd_submit(cmd)) {
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
 		err(ctx, "%s: smart command failed\n", devname);
 		ndctl_cmd_unref(cmd);
+		if (rc < 0)
+			errno = -rc;
 		return UINT_MAX;
 	}
 
@@ -2166,7 +2185,7 @@ NDCTL_EXPORT unsigned long long ndctl_region_get_available_size(
 	unsigned int nstype = ndctl_region_get_nstype(region);
 	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
 	char *path = region->region_buf;
-	int len = region->buf_len;
+	int rc, len = region->buf_len;
 	char buf[SYSFS_ATTR_SIZE];
 
 	switch (nstype) {
@@ -2180,11 +2199,15 @@ NDCTL_EXPORT unsigned long long ndctl_region_get_available_size(
 	if (snprintf(path, len, "%s/available_size", region->region_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
 				ndctl_region_get_devname(region));
+		errno = EOVERFLOW;
 		return ULLONG_MAX;
 	}
 
-	if (sysfs_read_attr(ctx, path, buf) < 0)
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc < 0) {
+		errno = -rc;
 		return ULLONG_MAX;
+	}
 
 	return strtoull(buf, NULL, 0);
 }
@@ -2195,7 +2218,7 @@ NDCTL_EXPORT unsigned long long ndctl_region_get_max_available_extent(
 	unsigned int nstype = ndctl_region_get_nstype(region);
 	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
 	char *path = region->region_buf;
-	int len = region->buf_len;
+	int rc, len = region->buf_len;
 	char buf[SYSFS_ATTR_SIZE];
 
 	switch (nstype) {
@@ -2210,12 +2233,15 @@ NDCTL_EXPORT unsigned long long ndctl_region_get_max_available_extent(
 		     "%s/max_available_extent", region->region_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
 				ndctl_region_get_devname(region));
+		errno = EOVERFLOW;
 		return ULLONG_MAX;
 	}
 
 	/* fall back to legacy behavior if max extents is not exported */
-	if (sysfs_read_attr(ctx, path, buf) < 0) {
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc < 0) {
 		dbg(ctx, "max extents attribute not exported on older kernels\n");
+		errno = -rc;
 		return ULLONG_MAX;
 	}
 
@@ -4017,9 +4043,10 @@ NDCTL_EXPORT unsigned int ndctl_namespace_get_supported_sector_size(
 	if (ndns->lbasize.num == 0)
 		return 0;
 
-	if (i < 0 || i > ndns->lbasize.num)
+	if (i < 0 || i > ndns->lbasize.num) {
+		errno = EINVAL;
 		return UINT_MAX;
-	else
+	} else
 		return ndns->lbasize.supported[i];
 }
 
@@ -4428,9 +4455,10 @@ NDCTL_EXPORT unsigned int ndctl_btt_get_id(struct ndctl_btt *btt)
 NDCTL_EXPORT unsigned int ndctl_btt_get_supported_sector_size(
 		struct ndctl_btt *btt, int i)
 {
-	if (i < 0 || i > btt->lbasize.num)
+	if (i < 0 || i > btt->lbasize.num) {
+		errno = EINVAL;
 		return UINT_MAX;
-	else
+	} else
 		return btt->lbasize.supported[i];
 }
 
diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index e15bc07..19453cd 100644
--- a/ndctl/lib/msft.c
+++ b/ndctl/lib/msft.c
@@ -77,8 +77,13 @@ static int msft_smart_valid(struct ndctl_cmd *cmd)
 
 static unsigned int msft_cmd_smart_get_flags(struct ndctl_cmd *cmd)
 {
-	if (msft_smart_valid(cmd) < 0)
+	int rc;
+
+	rc = msft_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	/* below health data can be retrieved via MSFT _DSM function 11 */
 	return NDN_MSFT_SMART_HEALTH_VALID |
@@ -103,9 +108,13 @@ static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
 {
 	unsigned int health;
 	unsigned int num;
+	int rc;
 
-	if (msft_smart_valid(cmd) < 0)
+	rc = msft_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	num = num_set_bit_health(CMD_MSFT_SMART(cmd)->health);
 	if (num == 0)
@@ -122,16 +131,26 @@ static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
 
 static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
 {
-	if (msft_smart_valid(cmd) < 0)
+	int rc;
+
+	rc = msft_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	return CMD_MSFT_SMART(cmd)->temp * 16;
 }
 
 static unsigned int msft_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
 {
-	if (msft_smart_valid(cmd) < 0)
+	int rc;
+
+	rc = msft_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
 		return UINT_MAX;
+	}
 
 	return 100 - CMD_MSFT_SMART(cmd)->nvm_lifetime;
 }
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
