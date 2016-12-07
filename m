Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E40BD81FCF
 for <linux-nvdimm@lists.01.org>; Tue,  6 Dec 2016 16:43:55 -0800 (PST)
Subject: [PATCH 5/5] tools/testing/nvdimm: unit test acpi_nfit_ctl()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 06 Dec 2016 16:39:46 -0800
Message-ID: <148107118664.25138.7932764598907066634.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148107115997.25138.3445497812509173966.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148107115997.25138.3445497812509173966.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

A recent flurry of bug discoveries in the nfit driver's DSM marshalling
routine has highlighted the fact that we do not have unit test coverage
for this routine. Add a self-test of acpi_nfit_ctl() routine before
probing the "nfit_test.0" device. This mocks stimulus to acpi_nfit_ctl()
and if any of the tests fail "nfit_test.0" will be unavailable causing
the rest of the tests to not run / fail.

This unit test will also be a place to land reproductions of quirky BIOS
behavior discovered in the field and ensure the kernel does not regress
against implementations it has seen in practice.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c              |    6 -
 drivers/acpi/nfit/nfit.h              |    2 
 tools/testing/nvdimm/Kbuild           |    1 
 tools/testing/nvdimm/test/iomap.c     |   23 +++
 tools/testing/nvdimm/test/nfit.c      |  236 ++++++++++++++++++++++++++++++++-
 tools/testing/nvdimm/test/nfit_test.h |    8 +
 6 files changed, 267 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 9690b28f0da7..09e5bc9e65ac 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -184,9 +184,8 @@ static int xlat_status(struct nvdimm *nvdimm, void *buf, unsigned int cmd,
 		return -EIO;
 }
 
-static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
-		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
-		unsigned int buf_len, int *cmd_rc)
+int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
+		unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
 	union acpi_object in_obj, in_buf, *out_obj;
@@ -363,6 +362,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(acpi_nfit_ctl);
 
 static const char *spa_type_name(u16 type)
 {
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 14296f5267c8..fc29c2e9832e 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -240,5 +240,7 @@ const u8 *to_nfit_uuid(enum nfit_uuids id);
 int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *nfit, acpi_size sz);
 void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event);
 void __acpi_nvdimm_notify(struct device *dev, u32 event);
+int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
+		unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc);
 void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev);
 #endif /* __NFIT_H__ */
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 582db95127ed..405212be044a 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -14,6 +14,7 @@ ldflags-y += --wrap=devm_memremap_pages
 ldflags-y += --wrap=insert_resource
 ldflags-y += --wrap=remove_resource
 ldflags-y += --wrap=acpi_evaluate_object
+ldflags-y += --wrap=acpi_evaluate_dsm
 
 DRIVERS := ../../../drivers
 NVDIMM_SRC := $(DRIVERS)/nvdimm
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index 3ccef732fce9..64cae1a5deff 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -26,14 +26,17 @@ static LIST_HEAD(iomap_head);
 
 static struct iomap_ops {
 	nfit_test_lookup_fn nfit_test_lookup;
+	nfit_test_evaluate_dsm_fn evaluate_dsm;
 	struct list_head list;
 } iomap_ops = {
 	.list = LIST_HEAD_INIT(iomap_ops.list),
 };
 
-void nfit_test_setup(nfit_test_lookup_fn lookup)
+void nfit_test_setup(nfit_test_lookup_fn lookup,
+		nfit_test_evaluate_dsm_fn evaluate)
 {
 	iomap_ops.nfit_test_lookup = lookup;
+	iomap_ops.evaluate_dsm = evaluate;
 	list_add_rcu(&iomap_ops.list, &iomap_head);
 }
 EXPORT_SYMBOL(nfit_test_setup);
@@ -367,4 +370,22 @@ acpi_status __wrap_acpi_evaluate_object(acpi_handle handle, acpi_string path,
 }
 EXPORT_SYMBOL(__wrap_acpi_evaluate_object);
 
+union acpi_object * __wrap_acpi_evaluate_dsm(acpi_handle handle, const u8 *uuid,
+		u64 rev, u64 func, union acpi_object *argv4)
+{
+	union acpi_object *obj = ERR_PTR(-ENXIO);
+	struct iomap_ops *ops;
+
+	rcu_read_lock();
+	ops = list_first_or_null_rcu(&iomap_head, typeof(*ops), list);
+	if (ops)
+		obj = ops->evaluate_dsm(handle, uuid, rev, func, argv4);
+	rcu_read_unlock();
+
+	if (IS_ERR(obj))
+		return acpi_evaluate_dsm(handle, uuid, rev, func, argv4);
+	return obj;
+}
+EXPORT_SYMBOL(__wrap_acpi_evaluate_dsm);
+
 MODULE_LICENSE("GPL v2");
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index c9a6458cb63e..71620fa95953 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -23,6 +23,7 @@
 #include <linux/sizes.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <nd-core.h>
 #include <nfit.h>
 #include <nd.h>
 #include "nfit_test.h"
@@ -1506,6 +1507,225 @@ static int nfit_test_blk_do_io(struct nd_blk_region *ndbr, resource_size_t dpa,
 	return 0;
 }
 
+static unsigned long nfit_ctl_handle;
+
+union acpi_object *result;
+
+static union acpi_object *nfit_test_evaluate_dsm(acpi_handle handle,
+		const u8 *uuid, u64 rev, u64 func, union acpi_object *argv4)
+{
+	if (handle != &nfit_ctl_handle)
+		return ERR_PTR(-ENXIO);
+
+	return result;
+}
+
+static int setup_result(void *buf, size_t size)
+{
+	result = kmalloc(sizeof(union acpi_object) + size, GFP_KERNEL);
+	if (!result)
+		return -ENOMEM;
+	result->package.type = ACPI_TYPE_BUFFER,
+	result->buffer.pointer = (void *) (result + 1);
+	result->buffer.length = size;
+	memcpy(result->buffer.pointer, buf, size);
+	memset(buf, 0, size);
+	return 0;
+}
+
+static int nfit_ctl_test(struct device *dev)
+{
+	int rc, cmd_rc;
+	struct nvdimm *nvdimm;
+	struct acpi_device *adev;
+	struct nfit_mem *nfit_mem;
+	struct nd_ars_record *record;
+	struct acpi_nfit_desc *acpi_desc;
+	const u64 test_val = 0x0123456789abcdefULL;
+	unsigned long mask, cmd_size, offset;
+	union {
+		struct nd_cmd_get_config_size cfg_size;
+		struct nd_cmd_ars_status ars_stat;
+		struct nd_cmd_ars_cap ars_cap;
+		char buf[sizeof(struct nd_cmd_ars_status)
+			+ sizeof(struct nd_ars_record)];
+	} cmds;
+
+	adev = devm_kzalloc(dev, sizeof(*adev), GFP_KERNEL);
+	if (!adev)
+		return -ENOMEM;
+	*adev = (struct acpi_device) {
+		.handle = &nfit_ctl_handle,
+		.dev = {
+			.init_name = "test-adev",
+		},
+	};
+
+	acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
+	if (!acpi_desc)
+		return -ENOMEM;
+	*acpi_desc = (struct acpi_nfit_desc) {
+		.nd_desc = {
+			.cmd_mask = 1UL << ND_CMD_ARS_CAP
+				| 1UL << ND_CMD_ARS_START
+				| 1UL << ND_CMD_ARS_STATUS
+				| 1UL << ND_CMD_CLEAR_ERROR,
+			.module = THIS_MODULE,
+			.provider_name = "ACPI.NFIT",
+			.ndctl = acpi_nfit_ctl,
+		},
+		.dev = &adev->dev,
+	};
+
+	nfit_mem = devm_kzalloc(dev, sizeof(*nfit_mem), GFP_KERNEL);
+	if (!nfit_mem)
+		return -ENOMEM;
+
+	mask = 1UL << ND_CMD_SMART | 1UL << ND_CMD_SMART_THRESHOLD
+		| 1UL << ND_CMD_DIMM_FLAGS | 1UL << ND_CMD_GET_CONFIG_SIZE
+		| 1UL << ND_CMD_GET_CONFIG_DATA | 1UL << ND_CMD_SET_CONFIG_DATA
+		| 1UL << ND_CMD_VENDOR;
+	*nfit_mem = (struct nfit_mem) {
+		.adev = adev,
+		.family = NVDIMM_FAMILY_INTEL,
+		.dsm_mask = mask,
+	};
+
+	nvdimm = devm_kzalloc(dev, sizeof(*nvdimm), GFP_KERNEL);
+	if (!nvdimm)
+		return -ENOMEM;
+	*nvdimm = (struct nvdimm) {
+		.provider_data = nfit_mem,
+		.cmd_mask = mask,
+		.dev = {
+			.init_name = "test-dimm",
+		},
+	};
+
+
+	/* basic checkout of a typical 'get config size' command */
+	cmd_size = sizeof(cmds.cfg_size);
+	cmds.cfg_size = (struct nd_cmd_get_config_size) {
+		.status = 0,
+		.config_size = SZ_128K,
+		.max_xfer = SZ_4K,
+	};
+	rc = setup_result(cmds.buf, cmd_size);
+	if (rc)
+		return rc;
+	rc = acpi_nfit_ctl(&acpi_desc->nd_desc, nvdimm, ND_CMD_GET_CONFIG_SIZE,
+			cmds.buf, cmd_size, &cmd_rc);
+
+	if (rc < 0 || cmd_rc || cmds.cfg_size.status != 0
+			|| cmds.cfg_size.config_size != SZ_128K
+			|| cmds.cfg_size.max_xfer != SZ_4K) {
+		dev_dbg(dev, "%s: failed at: %d rc: %d cmd_rc: %d\n",
+				__func__, __LINE__, rc, cmd_rc);
+		return -EIO;
+	}
+
+
+	/* test ars_status with zero output */
+	cmd_size = offsetof(struct nd_cmd_ars_status, address);
+	cmds.ars_stat = (struct nd_cmd_ars_status) {
+		.out_length = 0,
+	};
+	rc = setup_result(cmds.buf, cmd_size);
+	if (rc)
+		return rc;
+	rc = acpi_nfit_ctl(&acpi_desc->nd_desc, NULL, ND_CMD_ARS_STATUS,
+			cmds.buf, cmd_size, &cmd_rc);
+
+	if (rc < 0 || cmd_rc) {
+		dev_dbg(dev, "%s: failed at: %d rc: %d cmd_rc: %d\n",
+				__func__, __LINE__, rc, cmd_rc);
+		return -EIO;
+	}
+
+
+	/* test ars_cap with benign extended status */
+	cmd_size = sizeof(cmds.ars_cap);
+	cmds.ars_cap = (struct nd_cmd_ars_cap) {
+		.status = ND_ARS_PERSISTENT << 16,
+	};
+	offset = offsetof(struct nd_cmd_ars_cap, status);
+	rc = setup_result(cmds.buf + offset, cmd_size - offset);
+	if (rc)
+		return rc;
+	rc = acpi_nfit_ctl(&acpi_desc->nd_desc, NULL, ND_CMD_ARS_CAP,
+			cmds.buf, cmd_size, &cmd_rc);
+
+	if (rc < 0 || cmd_rc) {
+		dev_dbg(dev, "%s: failed at: %d rc: %d cmd_rc: %d\n",
+				__func__, __LINE__, rc, cmd_rc);
+		return -EIO;
+	}
+
+
+	/* test ars_status with 'status' trimmed from 'out_length' */
+	cmd_size = sizeof(cmds.ars_stat) + sizeof(struct nd_ars_record);
+	cmds.ars_stat = (struct nd_cmd_ars_status) {
+		.out_length = cmd_size - 4,
+	};
+	record = &cmds.ars_stat.records[0];
+	*record = (struct nd_ars_record) {
+		.length = test_val,
+	};
+	rc = setup_result(cmds.buf, cmd_size);
+	if (rc)
+		return rc;
+	rc = acpi_nfit_ctl(&acpi_desc->nd_desc, NULL, ND_CMD_ARS_STATUS,
+			cmds.buf, cmd_size, &cmd_rc);
+
+	if (rc < 0 || cmd_rc || record->length != test_val) {
+		dev_dbg(dev, "%s: failed at: %d rc: %d cmd_rc: %d\n",
+				__func__, __LINE__, rc, cmd_rc);
+		return -EIO;
+	}
+
+
+	/* test ars_status with 'Output (Size)' including 'status' */
+	cmd_size = sizeof(cmds.ars_stat) + sizeof(struct nd_ars_record);
+	cmds.ars_stat = (struct nd_cmd_ars_status) {
+		.out_length = cmd_size,
+	};
+	record = &cmds.ars_stat.records[0];
+	*record = (struct nd_ars_record) {
+		.length = test_val,
+	};
+	rc = setup_result(cmds.buf, cmd_size);
+	if (rc)
+		return rc;
+	rc = acpi_nfit_ctl(&acpi_desc->nd_desc, NULL, ND_CMD_ARS_STATUS,
+			cmds.buf, cmd_size, &cmd_rc);
+
+	if (rc < 0 || cmd_rc || record->length != test_val) {
+		dev_dbg(dev, "%s: failed at: %d rc: %d cmd_rc: %d\n",
+				__func__, __LINE__, rc, cmd_rc);
+		return -EIO;
+	}
+
+
+	/* test extended status for get_config_size results in failure */
+	cmd_size = sizeof(cmds.cfg_size);
+	cmds.cfg_size = (struct nd_cmd_get_config_size) {
+		.status = 1 << 16,
+	};
+	rc = setup_result(cmds.buf, cmd_size);
+	if (rc)
+		return rc;
+	rc = acpi_nfit_ctl(&acpi_desc->nd_desc, nvdimm, ND_CMD_GET_CONFIG_SIZE,
+			cmds.buf, cmd_size, &cmd_rc);
+
+	if (rc < 0 || cmd_rc >= 0) {
+		dev_dbg(dev, "%s: failed at: %d rc: %d cmd_rc: %d\n",
+				__func__, __LINE__, rc, cmd_rc);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static int nfit_test_probe(struct platform_device *pdev)
 {
 	struct nvdimm_bus_descriptor *nd_desc;
@@ -1516,6 +1736,12 @@ static int nfit_test_probe(struct platform_device *pdev)
 	union acpi_object *obj;
 	int rc;
 
+	if (strcmp(dev_name(&pdev->dev), "nfit_test.0") == 0) {
+		rc = nfit_ctl_test(&pdev->dev);
+		if (rc)
+			return rc;
+	}
+
 	nfit_test = to_nfit_test(&pdev->dev);
 
 	/* common alloc */
@@ -1639,11 +1865,13 @@ static __init int nfit_test_init(void)
 {
 	int rc, i;
 
-	nfit_test_dimm = class_create(THIS_MODULE, "nfit_test_dimm");
-	if (IS_ERR(nfit_test_dimm))
-		return PTR_ERR(nfit_test_dimm);
+	nfit_test_setup(nfit_test_lookup, nfit_test_evaluate_dsm);
 
-	nfit_test_setup(nfit_test_lookup);
+	nfit_test_dimm = class_create(THIS_MODULE, "nfit_test_dimm");
+	if (IS_ERR(nfit_test_dimm)) {
+		rc = PTR_ERR(nfit_test_dimm);
+		goto err_register;
+	}
 
 	for (i = 0; i < NUM_NFITS; i++) {
 		struct nfit_test *nfit_test;
diff --git a/tools/testing/nvdimm/test/nfit_test.h b/tools/testing/nvdimm/test/nfit_test.h
index c281dd2e5e2d..f54c0032c6ff 100644
--- a/tools/testing/nvdimm/test/nfit_test.h
+++ b/tools/testing/nvdimm/test/nfit_test.h
@@ -31,11 +31,17 @@ struct nfit_test_resource {
 	void *buf;
 };
 
+union acpi_object;
+typedef void *acpi_handle;
+
 typedef struct nfit_test_resource *(*nfit_test_lookup_fn)(resource_size_t);
+typedef union acpi_object *(*nfit_test_evaluate_dsm_fn)(acpi_handle handle,
+		const u8 *uuid, u64 rev, u64 func, union acpi_object *argv4);
 void __iomem *__wrap_ioremap_nocache(resource_size_t offset,
 		unsigned long size);
 void __wrap_iounmap(volatile void __iomem *addr);
-void nfit_test_setup(nfit_test_lookup_fn lookup);
+void nfit_test_setup(nfit_test_lookup_fn lookup,
+		nfit_test_evaluate_dsm_fn evaluate);
 void nfit_test_teardown(void);
 struct nfit_test_resource *get_nfit_res(resource_size_t resource);
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
