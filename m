Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id B4F4A1A1E9E
 for <linux-nvdimm@lists.01.org>; Sat,  9 Apr 2016 12:40:26 -0700 (PDT)
Subject: [ndctl PATCH 1/4] ndctl: fix compile in the
 HAVE_NDCTL_{ARS|CLEAR_ERROR}=n cases
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Apr 2016 12:39:35 -0700
Message-ID: <20160409193935.2002.28836.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160409193930.2002.71855.stgit@dwillia2-desk3.jf.intel.com>
References: <20160409193930.2002.71855.stgit@dwillia2-desk3.jf.intel.com>
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

While we have stub routines for the library apis in libndctl-ars.c we do
not have any protection against usage of the ARS or CLEAR_ERROR
definitions.  Arrange for those usages to be conditionally compiled.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/libndctl-ars.c |   18 ++++++++++++++---
 lib/libndctl.c     |   10 +++++++++
 test/libndctl.c    |   55 ++++++++++++++++++++--------------------------------
 3 files changed, 46 insertions(+), 37 deletions(-)

diff --git a/lib/libndctl-ars.c b/lib/libndctl-ars.c
index b53fe4c1dd8f..9b1a0cb6e1d6 100644
--- a/lib/libndctl-ars.c
+++ b/lib/libndctl-ars.c
@@ -43,20 +43,32 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
 	return cmd;
 }
 
+#ifdef HAVE_NDCTL_CLEAR_ERROR
 static bool is_power_of_2(unsigned int v)
 {
 	return v && ((v & (v - 1)) == 0);
 }
 
+static bool validate_clear_error(struct ndctl_cmd *ars_cap)
+{
+	if (!is_power_of_2(ars_cap->ars_cap->clear_err_unit))
+		return false;
+	return true;
+}
+#else
+static bool validate_clear_error(struct ndctl_cmd *ars_cap)
+{
+	return true;
+}
+#endif
+
 static bool __validate_ars_cap(struct ndctl_cmd *ars_cap)
 {
 	if (ars_cap->type != ND_CMD_ARS_CAP || ars_cap->status != 0)
 		return false;
 	if ((*ars_cap->firmware_status & ARS_STATUS_MASK) != 0)
 		return false;
-	if (!is_power_of_2(ars_cap->ars_cap->clear_err_unit))
-		return false;
-	return true;
+	return validate_clear_error(ars_cap);
 }
 
 #define validate_ars_cap(ctx, ars_cap) \
diff --git a/lib/libndctl.c b/lib/libndctl.c
index c25107f3eba7..1014da2aa8a9 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -813,7 +813,13 @@ static int to_dsm_index(const char *name, int dimm)
 		end_cmd = ND_CMD_VENDOR;
 		cmd_name_fn = nvdimm_cmd_name;
 	} else {
+		end_cmd = 0;
+#ifdef HAVE_NDCTL_ARS
+		end_cmd = ND_CMD_ARS_STATUS;
+#endif
+#ifdef HAVE_NDCTL_CLEAR_ERROR
 		end_cmd = ND_CMD_CLEAR_ERROR;
+#endif
 		cmd_name_fn = nvdimm_bus_cmd_name;
 	}
 
@@ -2143,10 +2149,14 @@ static int to_ioctl_cmd(int cmd, int dimm)
 {
 	if (!dimm) {
 		switch (cmd) {
+#ifdef HAVE_NDCTL_ARS
 		case ND_CMD_ARS_CAP:         return ND_IOCTL_ARS_CAP;
 		case ND_CMD_ARS_START:       return ND_IOCTL_ARS_START;
 		case ND_CMD_ARS_STATUS:      return ND_IOCTL_ARS_STATUS;
+#endif
+#ifdef HAVE_NDCTL_CLEAR_ERROR
 		case ND_CMD_CLEAR_ERROR:     return ND_IOCTL_CLEAR_ERROR;
+#endif
 		default:
 						       return 0;
 		};
diff --git a/test/libndctl.c b/test/libndctl.c
index 6cd8e62476fb..dcd4d509659e 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -380,10 +380,20 @@ static unsigned long dimm_commands0 = 1UL << ND_CMD_GET_CONFIG_SIZE
 		| 1UL << ND_CMD_SET_CONFIG_DATA | 1UL << ND_CMD_SMART
 		| 1UL << ND_CMD_SMART_THRESHOLD;
 
-static unsigned long bus_commands0 = 1UL << ND_CMD_ARS_CAP
-		| 1UL << ND_CMD_ARS_START
-		| 1UL << ND_CMD_ARS_STATUS
-		| 1UL << ND_CMD_CLEAR_ERROR;
+#ifdef HAVE_NDCTL_CLEAR_ERROR
+#define CLEAR_ERROR_CMDS (1UL << ND_CMD_CLEAR_ERROR)
+#else
+#define CLEAR_ERROR_CMDS 0
+#endif
+
+#ifdef HAVE_NDCTL_ARS
+#define ARS_CMDS (1UL << ND_CMD_ARS_CAP | 1UL << ND_CMD_ARS_START \
+		| 1UL << ND_CMD_ARS_STATUS)
+#else
+#define ARS_CMDS 0
+#endif
+
+static unsigned long bus_commands0 = CLEAR_ERROR_CMDS | ARS_CMDS;
 
 static struct ndctl_dimm *get_dimm_by_handle(struct ndctl_bus *bus, unsigned int handle)
 {
@@ -1830,6 +1840,7 @@ static int check_ars_status(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	return 0;
 }
 
+#ifdef HAVE_NDCTL_CLEAR_ERROR
 static int check_clear_error(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		struct check_cmd *check)
 {
@@ -1877,36 +1888,8 @@ static int check_clear_error(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	check->cmd = clear_err;
 	return 0;
 }
-
-#else
-static int check_ars_cap(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
-		struct check_cmd *check)
-{
-	fprintf(stderr, "%s: HAVE_NDCTL_ARS disabled, skipping\n", __func__);
-	return 0;
-}
-
-static int check_ars_start(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
-		struct check_cmd *check)
-{
-	fprintf(stderr, "%s: HAVE_NDCTL_ARS disabled, skipping\n", __func__);
-	return 0;
-}
-
-static int check_ars_status(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
-		struct check_cmd *check)
-{
-	fprintf(stderr, "%s: HAVE_NDCTL_ARS disabled, skipping\n", __func__);
-	return 0;
-}
-
-static int check_clear_error(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
-		struct check_cmd *check)
-{
-	fprintf(stderr, "%s: HAVE_NDCTL_ARS disabled, skipping\n", __func__);
-	return 0;
-}
-#endif
+#endif /* HAVE_NDCTL_CLEAR_ERROR */
+#endif /* HAVE_NDCTL_ARS */
 
 #define BITS_PER_LONG 32
 static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
@@ -1929,10 +1912,14 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		[ND_CMD_SMART_THRESHOLD] = { check_smart_threshold },
 	};
 	static struct check_cmd __check_bus_cmds[] = {
+#ifdef HAVE_NDCTL_ARS
 		[ND_CMD_ARS_CAP] = { check_ars_cap },
 		[ND_CMD_ARS_START] = { check_ars_start },
 		[ND_CMD_ARS_STATUS] = { check_ars_status },
+#ifdef HAVE_NDCTL_CLEAR_ERROR
 		[ND_CMD_CLEAR_ERROR] = { check_clear_error },
+#endif
+#endif
 	};
 	unsigned int i, rc = 0;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
