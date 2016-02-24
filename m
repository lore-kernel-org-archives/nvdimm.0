Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 1/8] libnvdimm, nfit: centralize command status translation
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Feb 2016 18:17:03 -0800
Message-ID: <20160224021703.22776.46077.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The return value from an 'ndctl_fn' reports the command execution
status, i.e. was the command properly formatted and was it successfully
submitted to the bus provider.  The new 'cmd_rc' parameter allows the bus
provider to communicate command specific results, translated into
common error codes.

Convert the ARS commands to this scheme to:

1/ Consolidate status reporting

2/ Prepare for for expanding ars unit test cases

3/ Make the implementation more generic

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c              |  176 ++++++++++++++++++++++++++------------
 drivers/acpi/nfit.h              |   11 ++
 drivers/nvdimm/bus.c             |    2 
 drivers/nvdimm/dimm_devs.c       |    6 +
 include/linux/libnvdimm.h        |    2 
 tools/testing/nvdimm/test/nfit.c |    5 +
 6 files changed, 140 insertions(+), 62 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index fb53db187854..4dd2b6808df5 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -72,9 +72,80 @@ static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
 	return to_acpi_device(acpi_desc->dev);
 }
 
+static int xlat_status(void *buf, unsigned int cmd)
+{
+	struct nd_cmd_ars_status *ars_status;
+	struct nd_cmd_ars_start *ars_start;
+	struct nd_cmd_ars_cap *ars_cap;
+	u16 flags;
+
+	switch (cmd) {
+	case ND_CMD_ARS_CAP:
+		ars_cap = buf;
+		if ((ars_cap->status & 0xffff) == NFIT_ARS_CAP_NONE)
+			return -ENOTTY;
+
+		/* Command failed */
+		if (ars_cap->status & 0xffff)
+			return -EIO;
+
+		/* No supported scan types for this range */
+		flags = ND_ARS_PERSISTENT | ND_ARS_VOLATILE;
+		if ((ars_cap->status >> 16 & flags) == 0)
+			return -ENOTTY;
+		break;
+	case ND_CMD_ARS_START:
+		ars_start = buf;
+		/* ARS is in progress */
+		if ((ars_start->status & 0xffff) == NFIT_ARS_START_BUSY)
+			return -EBUSY;
+
+		/* Command failed */
+		if (ars_start->status & 0xffff)
+			return -EIO;
+		break;
+	case ND_CMD_ARS_STATUS:
+		ars_status = buf;
+		/* Command failed */
+		if (ars_status->status & 0xffff)
+			return -EIO;
+		/* Check extended status (Upper two bytes) */
+		if (ars_status->status == NFIT_ARS_STATUS_DONE)
+			return 0;
+
+		/* ARS is in progress */
+		if (ars_status->status == NFIT_ARS_STATUS_BUSY)
+			return -EBUSY;
+
+		/* No ARS performed for the current boot */
+		if (ars_status->status == NFIT_ARS_STATUS_NONE)
+			return -EAGAIN;
+
+		/*
+		 * ARS interrupted, either we overflowed or some other
+		 * agent wants the scan to stop.  If we didn't overflow
+		 * then just continue with the returned results.
+		 */
+		if (ars_status->status == NFIT_ARS_STATUS_INTR) {
+			if (ars_status->flags & NFIT_ARS_F_OVERFLOW)
+				return -ENOSPC;
+			return 0;
+		}
+
+		/* Unknown status */
+		if (ars_status->status >> 16)
+			return -EIO;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
-		unsigned int buf_len)
+		unsigned int buf_len, int *cmd_rc)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
 	const struct nd_cmd_desc *desc = NULL;
@@ -185,6 +256,8 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 			 * unfilled in the output buffer
 			 */
 			rc = buf_len - offset - in_buf.buffer.length;
+			if (cmd_rc)
+				*cmd_rc = xlat_status(buf, cmd);
 		} else {
 			dev_err(dev, "%s:%s underrun cmd: %s buf_len: %d out_len: %d\n",
 					__func__, dimm_name, cmd_name, buf_len,
@@ -1105,7 +1178,7 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
 	writeq(cmd, mmio->addr.base + offset);
 	wmb_blk(nfit_blk);
 
-	if (nfit_blk->dimm_flags & ND_BLK_DCR_LATCH)
+	if (nfit_blk->dimm_flags & NFIT_BLK_DCR_LATCH)
 		readq(mmio->addr.base + offset);
 }
 
@@ -1141,7 +1214,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 			memcpy_to_pmem(mmio->addr.aperture + offset,
 					iobuf + copied, c);
 		else {
-			if (nfit_blk->dimm_flags & ND_BLK_READ_FLUSH)
+			if (nfit_blk->dimm_flags & NFIT_BLK_READ_FLUSH)
 				mmio_flush_range((void __force *)
 					mmio->addr.aperture + offset, c);
 
@@ -1328,13 +1401,13 @@ static int acpi_nfit_blk_get_flags(struct nvdimm_bus_descriptor *nd_desc,
 
 	memset(&flags, 0, sizeof(flags));
 	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_DIMM_FLAGS, &flags,
-			sizeof(flags));
+			sizeof(flags), NULL);
 
 	if (rc >= 0 && flags.status == 0)
 		nfit_blk->dimm_flags = flags.flags;
 	else if (rc == -ENOTTY) {
 		/* fall back to a conservative default */
-		nfit_blk->dimm_flags = ND_BLK_DCR_LATCH | ND_BLK_READ_FLUSH;
+		nfit_blk->dimm_flags = NFIT_BLK_DCR_LATCH | NFIT_BLK_READ_FLUSH;
 		rc = 0;
 	} else
 		rc = -ENXIO;
@@ -1473,19 +1546,27 @@ static void acpi_nfit_blk_region_disable(struct nvdimm_bus *nvdimm_bus,
 	/* devm will free nfit_blk */
 }
 
-static int ars_get_cap(struct nvdimm_bus_descriptor *nd_desc,
+static int ars_get_cap(struct acpi_nfit_desc *acpi_desc,
 		struct nd_cmd_ars_cap *cmd, u64 addr, u64 length)
 {
+	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
+	int cmd_rc, rc;
+
 	cmd->address = addr;
 	cmd->length = length;
-
-	return nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_CAP, cmd,
-			sizeof(*cmd));
+	rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_CAP, cmd,
+			sizeof(*cmd), &cmd_rc);
+	if (rc < 0)
+		return rc;
+	if (cmd_rc < 0)
+		return cmd_rc;
+	return 0;
 }
 
 static int ars_do_start(struct nvdimm_bus_descriptor *nd_desc,
 		struct nd_cmd_ars_start *cmd, u64 addr, u64 length)
 {
+	int cmd_rc;
 	int rc;
 
 	cmd->address = addr;
@@ -1494,52 +1575,49 @@ static int ars_do_start(struct nvdimm_bus_descriptor *nd_desc,
 
 	while (1) {
 		rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_START, cmd,
-				sizeof(*cmd));
-		if (rc)
+				sizeof(*cmd), &cmd_rc);
+
+		if (rc < 0)
 			return rc;
-		switch (cmd->status) {
-		case 0:
-			return 0;
-		case 1:
-			/* ARS unsupported, but we should never get here */
-			return 0;
-		case 6:
+
+		if (cmd_rc == -EBUSY) {
 			/* ARS is in progress */
 			msleep(1000);
-			break;
-		default:
-			return -ENXIO;
+			continue;
 		}
+
+		if (cmd_rc < 0)
+			return cmd_rc;
+
+		return 0;
 	}
 }
 
 static int ars_get_status(struct nvdimm_bus_descriptor *nd_desc,
 		struct nd_cmd_ars_status *cmd, u32 size)
 {
-	int rc;
+	int rc, cmd_rc;
 
 	while (1) {
 		rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_STATUS, cmd,
-			size);
-		if (rc || cmd->status & 0xffff)
-			return -ENXIO;
+			size, &cmd_rc);
+		if (rc < 0)
+			return rc;
 
-		/* Check extended status (Upper two bytes) */
-		switch (cmd->status >> 16) {
-		case 0:
-			return 0;
-		case 1:
-			/* ARS is in progress */
+		/* FIXME make async and have a timeout */
+		if (cmd_rc == -EBUSY) {
 			msleep(1000);
-			break;
-		case 2:
-			/* No ARS performed for the current boot */
+			continue;
+		}
+
+		if (cmd_rc == -EAGAIN || cmd_rc == 0)
 			return 0;
-		case 3:
-			/* TODO: error list overflow support */
-		default:
+
+		/* TODO: error list overflow support */
+		if (cmd_rc == -ENOSPC)
 			return -ENXIO;
-		}
+
+		return cmd_rc;
 	}
 }
 
@@ -1590,19 +1668,9 @@ static int acpi_nfit_find_poison(struct acpi_nfit_desc *acpi_desc,
 	start = ndr_desc->res->start;
 	len = ndr_desc->res->end - ndr_desc->res->start + 1;
 
-	rc = ars_get_cap(nd_desc, ars_cap, start, len);
-	if (rc)
-		goto out;
-
-	/*
-	 * If ARS is unsupported, or if the 'Persistent Memory Scrub' flag in
-	 * extended status is not set, skip this but continue initialization
-	 */
-	if ((ars_cap->status & 0xffff) ||
-		!(ars_cap->status >> 16 & ND_ARS_PERSISTENT)) {
-		dev_warn(acpi_desc->dev,
-			"ARS unsupported (status: 0x%x), won't create an error list\n",
-			ars_cap->status);
+	rc = ars_get_cap(acpi_desc, ars_cap, start, len);
+	if (rc == -ENOTTY) {
+		rc = 0;
 		goto out;
 	}
 
@@ -1644,15 +1712,15 @@ static int acpi_nfit_find_poison(struct acpi_nfit_desc *acpi_desc,
 		u64 done, end;
 
 		rc = ars_do_start(nd_desc, ars_start, cur, remaining);
-		if (rc)
+		if (rc < 0)
 			goto out;
 
 		rc = ars_get_status(nd_desc, ars_status, ars_status_size);
-		if (rc)
+		if (rc < 0)
 			goto out;
 
 		rc = ars_status_process_records(nvdimm_bus, ars_status, cur);
-		if (rc)
+		if (rc < 0)
 			goto out;
 
 		end = min(cur + remaining,
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 6689b0aaf194..f45b7d9b1d9e 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -47,8 +47,15 @@ enum nfit_fic {
 };
 
 enum {
-	ND_BLK_READ_FLUSH = 1,
-	ND_BLK_DCR_LATCH = 2,
+	NFIT_BLK_READ_FLUSH = 1,
+	NFIT_BLK_DCR_LATCH = 2,
+	NFIT_ARS_STATUS_DONE = 0,
+	NFIT_ARS_STATUS_BUSY = 1 << 16,
+	NFIT_ARS_STATUS_NONE = 2 << 16,
+	NFIT_ARS_STATUS_INTR = 3 << 16,
+	NFIT_ARS_START_BUSY = 6,
+	NFIT_ARS_CAP_NONE = 1,
+	NFIT_ARS_F_OVERFLOW = 1,
 };
 
 struct nfit_spa {
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 5d28e9405f32..c3ba888e3e3a 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -587,7 +587,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	if (rc)
 		goto out_unlock;
 
-	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len);
+	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len, NULL);
 	if (rc < 0)
 		goto out_unlock;
 	if (copy_to_user(p, buf, buf_len))
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 651b8d19d324..c56f88217924 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -75,7 +75,7 @@ int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd)
 	memset(cmd, 0, sizeof(*cmd));
 	nd_desc = nvdimm_bus->nd_desc;
 	return nd_desc->ndctl(nd_desc, to_nvdimm(ndd->dev),
-			ND_CMD_GET_CONFIG_SIZE, cmd, sizeof(*cmd));
+			ND_CMD_GET_CONFIG_SIZE, cmd, sizeof(*cmd), NULL);
 }
 
 int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
@@ -120,7 +120,7 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
 		cmd->in_offset = offset;
 		rc = nd_desc->ndctl(nd_desc, to_nvdimm(ndd->dev),
 				ND_CMD_GET_CONFIG_DATA, cmd,
-				cmd->in_length + sizeof(*cmd));
+				cmd->in_length + sizeof(*cmd), NULL);
 		if (rc || cmd->status) {
 			rc = -ENXIO;
 			break;
@@ -171,7 +171,7 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 		status = ((void *) cmd) + cmd_size - sizeof(u32);
 
 		rc = nd_desc->ndctl(nd_desc, to_nvdimm(ndd->dev),
-				ND_CMD_SET_CONFIG_DATA, cmd, cmd_size);
+				ND_CMD_SET_CONFIG_DATA, cmd, cmd_size, NULL);
 		if (rc || *status) {
 			rc = rc ? rc : -ENXIO;
 			break;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 141ffdd59960..f398953270d1 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -48,7 +48,7 @@ struct nvdimm;
 struct nvdimm_bus_descriptor;
 typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
-		unsigned int buf_len);
+		unsigned int buf_len, int *cmd_rc);
 
 struct nd_namespace_label;
 struct nvdimm_drvdata;
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 27b808e0489a..9ead77970546 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -261,7 +261,7 @@ static int nfit_test_cmd_ars_status(struct nd_cmd_ars_status *nd_cmd,
 
 static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
-		unsigned int buf_len)
+		unsigned int buf_len, int *cmd_rc)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 	struct nfit_test *t = container_of(acpi_desc, typeof(*t), acpi_desc);
@@ -315,6 +315,9 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		}
 	}
 
+	/* TODO: error status tests */
+	if (cmd_rc)
+		*cmd_rc = 0;
 	return rc;
 }
 
