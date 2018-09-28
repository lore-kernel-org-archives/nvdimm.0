Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D323D21159CAA
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 17:53:46 -0700 (PDT)
Subject: [ndctl PATCH v3 1/3] ndctl,
 lib: Add dirty-shutdown-count retrieval helper
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Sep 2018 17:41:42 -0700
Message-ID: <153809530287.1963951.9693220998113414361.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153809529764.1963951.7530312689559729607.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153809529764.1963951.7530312689559729607.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The kernel now exports nmemX/nfit/dirty_shutdown for DIMMs/platforms
that provide a free running dirty-shutdown-counter.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c   |   10 ++++++++++
 ndctl/lib/libndctl.sym |    5 +++++
 ndctl/lib/private.h    |    1 +
 ndctl/libndctl.h       |    1 +
 test/libndctl.c        |   29 ++++++++++++++++++++++-------
 5 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 481b110d2a18..737b1de2c930 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1322,6 +1322,7 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	dimm->device_id = -1;
 	dimm->revision_id = -1;
 	dimm->health_eventfd = -1;
+	dimm->dirty_shutdown = -ENOENT;
 	dimm->subsystem_vendor_id = -1;
 	dimm->subsystem_device_id = -1;
 	dimm->subsystem_revision_id = -1;
@@ -1387,6 +1388,10 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		dimm->revision_id = strtoul(buf, NULL, 0);
 
+	sprintf(path, "%s/nfit/dirty_shutdown", dimm_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		dimm->dirty_shutdown = strtoll(buf, NULL, 0);
+
 	sprintf(path, "%s/nfit/subsystem_vendor", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		dimm->subsystem_vendor_id = strtoul(buf, NULL, 0);
@@ -1489,6 +1494,11 @@ NDCTL_EXPORT unsigned short ndctl_dimm_get_revision(struct ndctl_dimm *dimm)
 	return dimm->revision_id;
 }
 
+NDCTL_EXPORT long long ndctl_dimm_get_dirty_shutdown(struct ndctl_dimm *dimm)
+{
+	return dimm->dirty_shutdown;
+}
+
 NDCTL_EXPORT unsigned short ndctl_dimm_get_subsystem_vendor(
 		struct ndctl_dimm *dimm)
 {
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index a6849ee1fa4a..f1421a92bb09 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -378,3 +378,8 @@ global:
 	ndctl_region_get_max_available_extent;
 	ndctl_cmd_smart_inject_ctrl_temperature;
 } LIBNDCTL_16;
+
+LIBNDCTL_18 {
+global:
+	ndctl_dimm_get_dirty_shutdown;
+} LIBNDCTL_17;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index b6e438aff8c7..55fcd4e0ad05 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -76,6 +76,7 @@ struct ndctl_dimm {
 	unsigned long cmd_family;
 	unsigned long cmd_mask;
 	unsigned long nfit_dsm_mask;
+	long long dirty_shutdown;
 	char *unique_id;
 	char *dimm_path;
 	char *dimm_buf;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 83d6c6cae18d..7d164f688681 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -150,6 +150,7 @@ unsigned short ndctl_dimm_get_phys_id(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_vendor(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_device(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_revision(struct ndctl_dimm *dimm);
+long long ndctl_dimm_get_dirty_shutdown(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_subsystem_vendor(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_subsystem_device(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_manufacturing_date(struct ndctl_dimm *dimm);
diff --git a/test/libndctl.c b/test/libndctl.c
index e36c1fb5e2e5..50365f00e5fe 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -118,6 +118,7 @@ struct dimm {
 	unsigned int subsystem_vendor;
 	unsigned short manufacturing_date;
 	unsigned char manufacturing_location;
+	long long dirty_shutdown;
 	union {
 		unsigned long flags;
 		struct {
@@ -136,15 +137,15 @@ struct dimm {
 	(((n & 0xfff) << 16) | ((s & 0xf) << 12) | ((i & 0xf) << 8) \
 	 | ((c & 0xf) << 4) | (d & 0xf))
 static struct dimm dimms0[] = {
-	{ DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, 2016, 10, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 0, 0, 1), 1, 0, 2016, 10, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 1, 0, 0), 2, 0, 2016, 10, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 1, 0, 1), 3, 0, 2016, 10, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, 2016, 10, 42, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 0, 0, 1), 1, 0, 2016, 10, 42, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 1, 0, 0), 2, 0, 2016, 10, 42, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 1, 0, 1), 3, 0, 2016, 10, 42, { 0 }, 2, { 0x201, 0x301, }, },
 };
 
 static struct dimm dimms1[] = {
 	{
-		DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, 2016, 10, {
+		DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, 2016, 10, 42, {
 			.f_arm = 1,
 			.f_save = 1,
 			.f_flush = 1,
@@ -2195,7 +2196,7 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
  */
 struct smart {
 	unsigned int flags, health, temperature, spares, alarm_flags,
-		     life_used, shutdown_state, vendor_size;
+		     life_used, shutdown_state, shutdown_count, vendor_size;
 };
 
 static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
@@ -2211,6 +2212,7 @@ static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		.alarm_flags = ND_SMART_SPARE_TRIP | ND_SMART_TEMP_TRIP,
 		.life_used = 5,
 		.shutdown_state = 0,
+		.shutdown_count = 42,
 		.vendor_size = 0,
 	};
 	struct ndctl_cmd *cmd = ndctl_dimm_cmd_new_smart(dimm);
@@ -2230,7 +2232,8 @@ static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		return rc;
 	}
 
-	__check_smart(dimm, cmd, flags, ~ND_SMART_CTEMP_VALID);
+	__check_smart(dimm, cmd, flags, ~(ND_SMART_CTEMP_VALID
+			| ND_SMART_SHUTDOWN_COUNT_VALID));
 	__check_smart(dimm, cmd, health, -1);
 	__check_smart(dimm, cmd, temperature, -1);
 	__check_smart(dimm, cmd, spares, -1);
@@ -2238,6 +2241,8 @@ static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	__check_smart(dimm, cmd, life_used, -1);
 	__check_smart(dimm, cmd, shutdown_state, -1);
 	__check_smart(dimm, cmd, vendor_size, -1);
+	if (ndctl_cmd_smart_get_flags(cmd) & ND_SMART_SHUTDOWN_COUNT_VALID)
+		__check_smart(dimm, cmd, shutdown_count, -1);
 
 	check->cmd = cmd;
 	return 0;
@@ -2468,6 +2473,7 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
 		unsigned long bus_commands, unsigned long dimm_commands,
 		struct ndctl_test *test)
 {
+	long long dsc;
 	int i, j, rc;
 
 	for (i = 0; i < n; i++) {
@@ -2552,6 +2558,15 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
 			}
 		}
 
+		dsc = ndctl_dimm_get_dirty_shutdown(dimm);
+		if (dsc != -ENOENT && dsc != dimms[i].dirty_shutdown) {
+			fprintf(stderr,
+				"dimm%d expected dirty shutdown: %lld got: %lld\n",
+				i, dimms[i].dirty_shutdown,
+				ndctl_dimm_get_dirty_shutdown(dimm));
+			return -ENXIO;
+		}
+
 		rc = check_commands(bus, dimm, bus_commands, dimm_commands, test);
 		if (rc)
 			return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
