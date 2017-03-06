Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B1968032B
 for <linux-nvdimm@lists.01.org>; Mon,  6 Mar 2017 13:38:58 -0800 (PST)
Subject: [PATCH 3/4] ndctl/test: remove the bus check functions
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 06 Mar 2017 14:38:57 -0700
Message-ID: <148883633749.72901.3091116733746057554.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148883624600.72901.16358369702902205527.stgit@djiang5-desk3.ch.intel.com>
References: <148883624600.72901.16358369702902205527.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

With the addition of support to clear poison list and badblocks on a
per region level, the bus checking functions will be moved to
devdax-error test to test directly on device dax. The command issued to
active pmem are expected to fail.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/libndctl.c |  217 -------------------------------------------------------
 1 file changed, 1 insertion(+), 216 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 8d6e492..39822ee 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2186,184 +2186,6 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 }
 #endif
 
-#ifdef HAVE_NDCTL_ARS
-static int check_ars_cap(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
-		struct check_cmd *check)
-{
-	struct ndctl_cmd *cmd;
-	int rc;
-
-	if (check->cmd != NULL) {
-		fprintf(stderr, "%s: dimm: %#x expected a NULL command, by default\n",
-				__func__, ndctl_dimm_get_handle(dimm));
-		return -ENXIO;
-	}
-
-	cmd = ndctl_bus_cmd_new_ars_cap(bus, 0, SZ_4K);
-	if (!cmd) {
-		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
-				__func__, ndctl_bus_get_provider(bus));
-		return -ENOTTY;
-	}
-
-	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
-		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
-				__func__, ndctl_bus_get_provider(bus), rc);
-		ndctl_cmd_unref(cmd);
-		return rc;
-	}
-
-	if (ndctl_cmd_ars_cap_get_size(cmd) < sizeof(struct nd_cmd_ars_status)) {
-		fprintf(stderr, "%s: bus: %s expect size >= %zd got: %d\n",
-				__func__, ndctl_bus_get_provider(bus),
-				sizeof(struct nd_cmd_ars_status),
-				ndctl_cmd_ars_cap_get_size(cmd));
-		ndctl_cmd_unref(cmd);
-		return -ENXIO;
-	}
-
-	check->cmd = cmd;
-	return 0;
-}
-
-static int check_ars_start(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
-		struct check_cmd *check)
-{
-	struct ndctl_cmd *cmd_ars_cap = check_cmds[ND_CMD_ARS_CAP].cmd;
-	struct ndctl_cmd *cmd;
-	int rc;
-
-	if (check->cmd != NULL) {
-		fprintf(stderr, "%s: dimm: %#x expected a NULL command, by default\n",
-				__func__, ndctl_dimm_get_handle(dimm));
-		return -ENXIO;
-	}
-
-	cmd = ndctl_bus_cmd_new_ars_start(cmd_ars_cap, ND_ARS_PERSISTENT);
-	if (!cmd) {
-		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
-				__func__, ndctl_bus_get_provider(bus));
-		return -ENOTTY;
-	}
-
-	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
-		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
-				__func__, ndctl_bus_get_provider(bus), rc);
-		ndctl_cmd_unref(cmd);
-		return rc;
-	}
-
-	check->cmd = cmd;
-	return 0;
-}
-
-static int check_ars_status(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
-		struct check_cmd *check)
-{
-	struct ndctl_cmd *cmd_ars_cap = check_cmds[ND_CMD_ARS_CAP].cmd;
-	struct ndctl_cmd *cmd;
-	unsigned long tmo = 5;
-	unsigned int i;
-	int rc;
-
-	if (check->cmd != NULL) {
-		fprintf(stderr, "%s: dimm: %#x expected a NULL command, by default\n",
-				__func__, ndctl_dimm_get_handle(dimm));
-		return -ENXIO;
-	}
-
- retry:
-	cmd = ndctl_bus_cmd_new_ars_status(cmd_ars_cap);
-	if (!cmd) {
-		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
-				__func__, ndctl_bus_get_provider(bus));
-		return -ENOTTY;
-	}
-
-	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
-		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
-				__func__, ndctl_bus_get_provider(bus), rc);
-		ndctl_cmd_unref(cmd);
-		return rc;
-	}
-
-	if (!tmo) {
-		fprintf(stderr, "%s: bus: %s ars timeout\n", __func__,
-				ndctl_bus_get_provider(bus));
-		return -EIO;
-	}
-
-	if (ndctl_cmd_ars_in_progress(cmd)) {
-		tmo--;
-		sleep(1);
-		goto retry;
-	}
-
-	for (i = 0; i < ndctl_cmd_ars_num_records(cmd); i++) {
-		fprintf(stderr, "%s: record[%d].addr: 0x%llx\n", __func__, i,
-			ndctl_cmd_ars_get_record_addr(cmd, i));
-		fprintf(stderr, "%s: record[%d].length: 0x%llx\n", __func__, i,
-			ndctl_cmd_ars_get_record_len(cmd, i));
-	}
-
-	check->cmd = cmd;
-	return 0;
-}
-
-#ifdef HAVE_NDCTL_CLEAR_ERROR
-static int check_clear_error(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
-		struct check_cmd *check)
-{
-	struct ndctl_cmd *ars_cap = check_cmds[ND_CMD_ARS_CAP].cmd;
-	struct ndctl_cmd *clear_err;
-	unsigned long long cleared;
-	struct ndctl_range range;
-	int rc;
-
-	if (check->cmd != NULL) {
-		fprintf(stderr, "%s: expected a NULL command, by default\n",
-				__func__);
-		return -ENXIO;
-	}
-
-	if (ndctl_cmd_ars_cap_get_range(ars_cap, &range)) {
-		fprintf(stderr, "failed to get ars_cap range\n");
-		return -ENXIO;
-	}
-
-	clear_err = ndctl_bus_cmd_new_clear_error(range.address, SZ_4K,
-			ars_cap);
-	if (!clear_err) {
-		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
-				__func__, ndctl_bus_get_provider(bus));
-		return -ENOTTY;
-	}
-
-	rc = ndctl_cmd_submit(clear_err);
-	if (rc) {
-		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
-				__func__, ndctl_bus_get_provider(bus), rc);
-		ndctl_cmd_unref(clear_err);
-		return rc;
-	}
-
-	cleared = ndctl_cmd_clear_error_get_cleared(clear_err);
-	if (cleared != SZ_4K) {
-		fprintf(stderr, "%s: bus: %s expected to clear: %d actual: %lld\n",
-				__func__, ndctl_bus_get_provider(bus), SZ_4K,
-				cleared);
-		return -ENXIO;
-	}
-
-	check->cmd = clear_err;
-	return 0;
-}
-#endif /* HAVE_NDCTL_CLEAR_ERROR */
-#endif /* HAVE_NDCTL_ARS */
-
 #define BITS_PER_LONG 32
 static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		unsigned long bus_commands, unsigned long dimm_commands,
@@ -2387,16 +2209,7 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 			.test = test,
 		},
 	};
-	static struct check_cmd __check_bus_cmds[] = {
-#ifdef HAVE_NDCTL_ARS
-		[ND_CMD_ARS_CAP] = { check_ars_cap },
-		[ND_CMD_ARS_START] = { check_ars_start },
-		[ND_CMD_ARS_STATUS] = { check_ars_status },
-#ifdef HAVE_NDCTL_CLEAR_ERROR
-		[ND_CMD_CLEAR_ERROR] = { check_clear_error },
-#endif
-#endif
-	};
+
 	unsigned int i, rc = 0;
 
 	/*
@@ -2441,34 +2254,6 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 6, 0)))
 		goto out;
 
-	/* Check Bus commands */
-	check_cmds = __check_bus_cmds;
-	for (i = 1; i < BITS_PER_LONG; i++) {
-		struct check_cmd *check = &check_cmds[i];
-
-		if ((bus_commands & (1UL << i)) == 0)
-			continue;
-		if (!ndctl_bus_is_cmd_supported(bus, i)) {
-			fprintf(stderr, "%s: bus: %s expected cmd: %s supported\n",
-					__func__,
-					ndctl_bus_get_provider(bus),
-					ndctl_bus_get_cmd_name(bus, i));
-			return -ENXIO;
-		}
-
-		if (!check->check_fn)
-			continue;
-		rc = check->check_fn(bus, dimm, check);
-		if (rc)
-			break;
-	}
-
-	for (i = 1; i < ARRAY_SIZE(__check_bus_cmds); i++) {
-		if (__check_bus_cmds[i].cmd)
-			ndctl_cmd_unref(__check_bus_cmds[i].cmd);
-		__check_bus_cmds[i].cmd = NULL;
-	}
-
  out:
 	return rc;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
