Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D18FC203B8BFB
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 11:00:33 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/4] libndctl,
 inject: inject fewer bytes per block by default
Date: Tue,  1 May 2018 12:00:21 -0600
Message-Id: <20180501180023.30193-3-vishal.l.verma@intel.com>
In-Reply-To: <20180501180023.30193-1-vishal.l.verma@intel.com>
References: <20180501180023.30193-1-vishal.l.verma@intel.com>
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

Theoretically a single poisoned byte per block is enough for Linux to
mark it as a badblock. For each block, instead of injecting a range
covering the entire badblock, reduce it to clear_err_unit bytes, which
is obtained from an ars_cap command. If multiple blocks are being
injected, inject the above number of bytes at the start of each block
separately. Make the same changes for uninject as well.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-inject-error.txt |   7 ++
 ndctl/lib/inject.c                         | 181 +++++++++++++++++++++--------
 2 files changed, 138 insertions(+), 50 deletions(-)

diff --git a/Documentation/ndctl/ndctl-inject-error.txt b/Documentation/ndctl/ndctl-inject-error.txt
index 94c4e69..07c992a 100644
--- a/Documentation/ndctl/ndctl-inject-error.txt
+++ b/Documentation/ndctl/ndctl-inject-error.txt
@@ -18,6 +18,13 @@ ndctl-inject-error can be used to ask the platform to simulate media errors
 in the NVDIMM address space to aid debugging and development of features
 related to error handling.
 
+By default, injecting an error actually only injects an error to the first 'n'
+bytes of the block, where 'n' is the output of ndctl_cmd_ars_cap_get_size().
+In other words, we only inject one 'ars_unit' per sector. This is sufficient
+for Linux to mark the whole sector as bad, and will show up as such in the
+various 'badblocks' lists in the kernel. If multiple blocks are being injected,
+only the first 'n' bytes of each block specified will be injected as errors.
+
 WARNING: These commands are DANGEROUS and can cause data loss. They are
 only provided for testing and debugging purposes.
 
diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
index 8bfb5c9..2865a7d 100644
--- a/ndctl/lib/inject.c
+++ b/ndctl/lib/inject.c
@@ -89,86 +89,167 @@ static int translate_status(u32 status)
 	return 0;
 }
 
-NDCTL_EXPORT int ndctl_namespace_inject_error(struct ndctl_namespace *ndns,
-		unsigned long long block, unsigned long long count, bool notify)
+static int ndctl_namespace_get_clear_unit(struct ndctl_namespace *ndns)
+{
+	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	unsigned long long ns_offset, ns_size;
+	unsigned int clear_unit;
+	struct ndctl_cmd *cmd;
+	int rc;
+
+	ndctl_namespace_get_injection_bounds(ndns, &ns_offset,
+		&ns_size);
+	cmd = ndctl_bus_cmd_new_ars_cap(bus, ns_offset, ns_size);
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		dbg(ctx, "Error submitting ars_cap: %d\n", rc);
+		return rc;
+	}
+	clear_unit = ndctl_cmd_ars_cap_get_clear_unit(cmd);
+	if (clear_unit == 0) {
+		dbg(ctx, "Got an invalid clear_err_unit from ars_cap\n");
+		return -EINVAL;
+	}
+
+	ndctl_cmd_unref(cmd);
+	return clear_unit;
+}
+
+static int ndctl_namespace_inject_one_error(struct ndctl_namespace *ndns,
+		unsigned long long block, bool notify)
 {
 	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
 	struct nd_cmd_ars_err_inj *err_inj;
 	struct nd_cmd_pkg *pkg;
 	struct ndctl_cmd *cmd;
-	int rc = -EOPNOTSUPP;
+	u64 offset, length;
+	int rc, clear_unit;
 
-	if (!ndctl_bus_has_error_injection(bus))
-		return -EOPNOTSUPP;
+	rc = block_to_spa_offset(ndns, block, 1, &offset, &length);
+	if (rc)
+		return rc;
 
-	if (ndctl_bus_has_nfit(bus)) {
-		u64 offset, length;
+	clear_unit = ndctl_namespace_get_clear_unit(ndns);
+	if (clear_unit < 0)
+		return clear_unit;
 
-		rc = block_to_spa_offset(ndns, block, count, &offset, &length);
-		if (rc)
-			return rc;
-		cmd = ndctl_bus_cmd_new_err_inj(bus);
-		if (!cmd)
-			return -ENOMEM;
+	/* clamp injection length per block to the clear_unit */
+	if (length > (unsigned int)clear_unit)
+		length = clear_unit;
 
-		pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
-		err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
-		err_inj->err_inj_spa_range_base = offset;
-		err_inj->err_inj_spa_range_length = length;
-		if (notify)
-			err_inj->err_inj_options |=
-				(1 << ND_ARS_ERR_INJ_OPT_NOTIFY);
+	cmd = ndctl_bus_cmd_new_err_inj(bus);
+	if (!cmd)
+		return -ENOMEM;
 
-		rc = ndctl_cmd_submit(cmd);
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
+	err_inj->err_inj_spa_range_base = offset;
+	err_inj->err_inj_spa_range_length = length;
+	if (notify)
+		err_inj->err_inj_options |=
+			(1 << ND_ARS_ERR_INJ_OPT_NOTIFY);
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		dbg(ctx, "Error submitting command: %d\n", rc);
+		goto out;
+	}
+	rc = translate_status(err_inj->status);
+ out:
+	ndctl_cmd_unref(cmd);
+	return rc;
+}
+
+NDCTL_EXPORT int ndctl_namespace_inject_error(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count, bool notify)
+{
+	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	unsigned long long i;
+	int rc = -EINVAL;
+
+	if (!ndctl_bus_has_error_injection(bus))
+		return -EOPNOTSUPP;
+	if (!ndctl_bus_has_nfit(bus))
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < count; i++) {
+		rc = ndctl_namespace_inject_one_error(ndns, block + i, notify);
 		if (rc) {
-			dbg(ctx, "Error submitting command: %d\n", rc);
-			goto out;
+			err(ctx, "Injection failed at block %llx\n",
+				block + i);
+			return rc;
 		}
-		rc = translate_status(err_inj->status);
- out:
-		ndctl_cmd_unref(cmd);
 	}
 	return rc;
 }
 
-NDCTL_EXPORT int ndctl_namespace_uninject_error(struct ndctl_namespace *ndns,
-		unsigned long long block, unsigned long long count)
+static int ndctl_namespace_uninject_one_error(struct ndctl_namespace *ndns,
+		unsigned long long block)
 {
 	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
 	struct nd_cmd_ars_err_inj_clr *err_inj_clr;
 	struct nd_cmd_pkg *pkg;
 	struct ndctl_cmd *cmd;
-	int rc = -EOPNOTSUPP;
+	u64 offset, length;
+	int rc, clear_unit;
 
-	if (!ndctl_bus_has_error_injection(bus))
-		return -EOPNOTSUPP;
+	rc = block_to_spa_offset(ndns, block, 1, &offset, &length);
+	if (rc)
+		return rc;
 
-	if (ndctl_bus_has_nfit(bus)) {
-		u64 offset, length;
+	clear_unit = ndctl_namespace_get_clear_unit(ndns);
+	if (clear_unit < 0)
+		return clear_unit;
 
-		rc = block_to_spa_offset(ndns, block, count, &offset, &length);
-		if (rc)
-			return rc;
-		cmd = ndctl_bus_cmd_new_err_inj_clr(bus);
-		if (!cmd)
-			return -ENOMEM;
+	/* clamp injection length per block to the clear_unit */
+	if (length > (unsigned int)clear_unit)
+		length = clear_unit;
 
-		pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
-		err_inj_clr =
-			(struct nd_cmd_ars_err_inj_clr *)&pkg->nd_payload[0];
-		err_inj_clr->err_inj_clr_spa_range_base = offset;
-		err_inj_clr->err_inj_clr_spa_range_length = length;
+	cmd = ndctl_bus_cmd_new_err_inj_clr(bus);
+	if (!cmd)
+		return -ENOMEM;
 
-		rc = ndctl_cmd_submit(cmd);
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	err_inj_clr =
+		(struct nd_cmd_ars_err_inj_clr *)&pkg->nd_payload[0];
+	err_inj_clr->err_inj_clr_spa_range_base = offset;
+	err_inj_clr->err_inj_clr_spa_range_length = length;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		dbg(ctx, "Error submitting command: %d\n", rc);
+		goto out;
+	}
+	rc = translate_status(err_inj_clr->status);
+ out:
+	ndctl_cmd_unref(cmd);
+	return rc;
+}
+
+NDCTL_EXPORT int ndctl_namespace_uninject_error(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count)
+{
+	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	unsigned long long i;
+	int rc = -EINVAL;
+
+	if (!ndctl_bus_has_error_injection(bus))
+		return -EOPNOTSUPP;
+	if (!ndctl_bus_has_nfit(bus))
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < count; i++) {
+		rc = ndctl_namespace_uninject_one_error(ndns, block + i);
 		if (rc) {
-			dbg(ctx, "Error submitting command: %d\n", rc);
-			goto out;
+			err(ctx, "Un-injection failed at block %llx\n",
+				block + i);
+			return rc;
 		}
-		rc = translate_status(err_inj_clr->status);
- out:
-		ndctl_cmd_unref(cmd);
 	}
 	return rc;
 }
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
