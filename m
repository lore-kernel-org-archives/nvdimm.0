Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id CA4721A1F2D
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 14:47:58 -0800 (PST)
Subject: [PATCH 1/3] nfit, libnvdimm: clear poison command support
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 14:47:18 -0800
Message-ID: <20160308224718.16298.47066.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160308224713.16298.33547.stgit@dwillia2-desk3.jf.intel.com>
References: <20160308224713.16298.33547.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add the boiler-plate for a 'clear error' command based on section
9.20.7.6 "Function Index 4 - Clear Uncorrectable Error" from the ACPI
6.1 specification, and add a reference implementation in nfit_test.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c              |   12 +++++++++++-
 drivers/nvdimm/bus.c             |   19 +++++++++++++++++++
 include/uapi/linux/ndctl.h       |   13 +++++++++++++
 tools/testing/nvdimm/test/nfit.c |   29 +++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 0def4ebf5d43..c067d7414007 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -87,6 +87,7 @@ static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
 
 static int xlat_status(void *buf, unsigned int cmd)
 {
+	struct nd_cmd_clear_error *clear_err;
 	struct nd_cmd_ars_status *ars_status;
 	struct nd_cmd_ars_start *ars_start;
 	struct nd_cmd_ars_cap *ars_cap;
@@ -149,6 +150,15 @@ static int xlat_status(void *buf, unsigned int cmd)
 		if (ars_status->status >> 16)
 			return -EIO;
 		break;
+	case ND_CMD_CLEAR_ERROR:
+		clear_err = buf;
+		if (clear_err->status & 0xffff)
+			return -EIO;
+		if (!clear_err->cleared)
+			return -EIO;
+		if (clear_err->length > clear_err->cleared)
+			return clear_err->cleared;
+		break;
 	default:
 		break;
 	}
@@ -1002,7 +1012,7 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 	if (!adev)
 		return;
 
-	for (i = ND_CMD_ARS_CAP; i <= ND_CMD_ARS_STATUS; i++)
+	for (i = ND_CMD_ARS_CAP; i <= ND_CMD_CLEAR_ERROR; i++)
 		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
 			set_bit(i, &nd_desc->dsm_mask);
 }
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 2e9ac22595ec..cb6fd64b13e3 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -421,6 +421,12 @@ static const struct nd_cmd_desc __nd_cmd_bus_descs[] = {
 		.out_num = 3,
 		.out_sizes = { 4, 4, UINT_MAX, },
 	},
+	[ND_CMD_CLEAR_ERROR] = {
+		.in_num = 2,
+		.in_sizes = { 8, 8, },
+		.out_num = 3,
+		.out_sizes = { 4, 4, 8, },
+	},
 };
 
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd)
@@ -489,6 +495,13 @@ void wait_nvdimm_bus_probe_idle(struct device *dev)
 	} while (true);
 }
 
+static int pmem_active(struct device *dev, void *data)
+{
+	if (is_nd_pmem(dev) && dev->driver)
+		return -EBUSY;
+	return 0;
+}
+
 /* set_config requires an idle interleave set */
 static int nd_cmd_clear_to_send(struct nvdimm_bus *nvdimm_bus,
 		struct nvdimm *nvdimm, unsigned int cmd)
@@ -503,6 +516,11 @@ static int nd_cmd_clear_to_send(struct nvdimm_bus *nvdimm_bus,
 			return rc;
 	}
 
+	/* require clear error to go through the pmem driver */
+	if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR)
+		return device_for_each_child(&nvdimm_bus->dev, NULL,
+				pmem_active);
+
 	if (!nvdimm || cmd != ND_CMD_SET_CONFIG_DATA)
 		return 0;
 
@@ -551,6 +569,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		case ND_CMD_VENDOR:
 		case ND_CMD_SET_CONFIG_DATA:
 		case ND_CMD_ARS_START:
+		case ND_CMD_CLEAR_ERROR:
 			dev_dbg(&nvdimm_bus->dev, "'%s' command while read-only.\n",
 					nvdimm ? nvdimm_cmd_name(cmd)
 					: nvdimm_bus_cmd_name(cmd));
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index cc68b92124d4..0f001c571cdd 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -98,6 +98,14 @@ struct nd_cmd_ars_status {
 	} __packed records[0];
 } __packed;
 
+struct nd_cmd_clear_error {
+	__u64 address;
+	__u64 length;
+	__u32 status;
+	__u8 reserved[4];
+	__u64 cleared;
+} __packed;
+
 enum {
 	ND_CMD_IMPLEMENTED = 0,
 
@@ -105,6 +113,7 @@ enum {
 	ND_CMD_ARS_CAP = 1,
 	ND_CMD_ARS_START = 2,
 	ND_CMD_ARS_STATUS = 3,
+	ND_CMD_CLEAR_ERROR = 4,
 
 	/* per-dimm commands */
 	ND_CMD_SMART = 1,
@@ -129,6 +138,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
 		[ND_CMD_ARS_CAP] = "ars_cap",
 		[ND_CMD_ARS_START] = "ars_start",
 		[ND_CMD_ARS_STATUS] = "ars_status",
+		[ND_CMD_CLEAR_ERROR] = "clear_error",
 	};
 
 	if (cmd < ARRAY_SIZE(names) && names[cmd])
@@ -187,6 +197,9 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 #define ND_IOCTL_ARS_STATUS		_IOWR(ND_IOCTL, ND_CMD_ARS_STATUS,\
 					struct nd_cmd_ars_status)
 
+#define ND_IOCTL_CLEAR_ERROR		_IOWR(ND_IOCTL, ND_CMD_CLEAR_ERROR,\
+					struct nd_cmd_ars_status)
+
 #define ND_DEVICE_DIMM 1            /* nd_dimm: container for "config data" */
 #define ND_DEVICE_REGION_PMEM 2     /* nd_region: (parent of PMEM namespaces) */
 #define ND_DEVICE_REGION_BLK 3      /* nd_region: (parent of BLK namespaces) */
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 1555c09efba1..3187322eeed7 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -223,6 +223,7 @@ static int nfit_test_cmd_set_config_data(struct nd_cmd_set_config_hdr *nd_cmd,
 }
 
 #define NFIT_TEST_ARS_RECORDS 4
+#define NFIT_TEST_CLEAR_ERR_UNIT 256
 
 static int nfit_test_cmd_ars_cap(struct nd_cmd_ars_cap *nd_cmd,
 		unsigned int buf_len)
@@ -233,6 +234,7 @@ static int nfit_test_cmd_ars_cap(struct nd_cmd_ars_cap *nd_cmd,
 	nd_cmd->max_ars_out = sizeof(struct nd_cmd_ars_status)
 		+ NFIT_TEST_ARS_RECORDS * sizeof(struct nd_ars_record);
 	nd_cmd->status = (ND_ARS_PERSISTENT | ND_ARS_VOLATILE) << 16;
+	nd_cmd->clear_err_unit = NFIT_TEST_CLEAR_ERR_UNIT;
 
 	return 0;
 }
@@ -306,6 +308,28 @@ static int nfit_test_cmd_ars_status(struct ars_state *ars_state,
 	return 0;
 }
 
+static int nfit_test_cmd_clear_error(struct nd_cmd_clear_error *clear_err,
+		unsigned int buf_len, int *cmd_rc)
+{
+	const u64 mask = NFIT_TEST_CLEAR_ERR_UNIT - 1;
+	if (buf_len < sizeof(*clear_err))
+		return -EINVAL;
+
+	if ((clear_err->address & mask) || (clear_err->length & mask))
+		return -EINVAL;
+
+	/*
+	 * Report 'all clear' success for all commands even though a new
+	 * scrub will find errors again.  This is enough to have the
+	 * error removed from the 'badblocks' tracking in the pmem
+	 * driver.
+	 */
+	clear_err->status = 0;
+	clear_err->cleared = clear_err->length;
+	*cmd_rc = 0;
+	return 0;
+}
+
 static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
@@ -365,6 +389,9 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 			rc = nfit_test_cmd_ars_status(ars_state, buf, buf_len,
 					cmd_rc);
 			break;
+		case ND_CMD_CLEAR_ERROR:
+			rc = nfit_test_cmd_clear_error(buf, buf_len, cmd_rc);
+			break;
 		default:
 			return -ENOTTY;
 		}
@@ -1230,6 +1257,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_dsm_force_en);
+	set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_dsm_force_en);
 }
 
 static void nfit_test1_setup(struct nfit_test *t)
@@ -1290,6 +1318,7 @@ static void nfit_test1_setup(struct nfit_test *t)
 	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_dsm_force_en);
+	set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_dsm_force_en);
 }
 
 static int nfit_test_blk_do_io(struct nd_blk_region *ndbr, resource_size_t dpa,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
