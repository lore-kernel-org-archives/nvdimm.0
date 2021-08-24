Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C160C3FCE
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:07:30 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="214221048"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="214221048"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:07:13 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="426161962"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:07:13 -0700
Subject: [PATCH v3 20/28] cxl/mbox: Add exclusive kernel command support
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:07:13 -0700
Message-ID: <162982123298.1124374.22718002900700392.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The CXL_PMEM driver expects exclusive control of the label storage area
space. Similar to the LIBNVDIMM expectation that the label storage area
is only writable from userspace when the corresponding memory device is
not active in any region, the expectation is the native CXL_PCI UAPI
path is disabled while the cxl_nvdimm for a given cxl_memdev device is
active in LIBNVDIMM.

Add the ability to toggle the availability of a given command for the
UAPI path. Use that new capability to shutdown changes to partitions and
the label storage area while the cxl_nvdimm device is actively proxying
commands for LIBNVDIMM.

Acked-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/mbox.c   |    5 +++++
 drivers/cxl/core/memdev.c |   31 +++++++++++++++++++++++++++++++
 drivers/cxl/cxlmem.h      |    4 ++++
 drivers/cxl/pmem.c        |   35 ++++++++++++++++++++++++++++-------
 4 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 73107b302224..6a5c4f3679ba 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -230,6 +230,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
  *  * %-EINVAL	- Reserved fields or invalid values were used.
  *  * %-ENOMEM	- Input or output buffer wasn't sized properly.
  *  * %-EPERM	- Attempted to use a protected command.
+ *  * %-EBUSY	- Kernel has claimed exclusive access to this opcode
  *
  * The result of this command is a fully validated command in @out_cmd that is
  * safe to send to the hardware.
@@ -305,6 +306,10 @@ static int cxl_validate_cmd_from_user(struct cxl_mem *cxlm,
 	if (!test_bit(info->id, cxlm->enabled_cmds))
 		return -ENOTTY;
 
+	/* Check that the command is not claimed for exclusive kernel use */
+	if (test_bit(info->id, cxlm->exclusive_cmds))
+		return -EBUSY;
+
 	/* Check the input buffer is the expected size */
 	if (info->size_in >= 0 && info->size_in != send_cmd->in.size)
 		return -ENOMEM;
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index a2a9691568af..ee61202c7aab 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -134,6 +134,37 @@ static const struct device_type cxl_memdev_type = {
 	.groups = cxl_memdev_attribute_groups,
 };
 
+/**
+ * set_exclusive_cxl_commands() - atomically disable user cxl commands
+ * @cxlm: cxl_mem instance to modify
+ * @cmds: bitmap of commands to mark exclusive
+ *
+ * Flush the ioctl path and disable future execution of commands with
+ * the command ids set in @cmds.
+ */
+void set_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds)
+{
+	down_write(&cxl_memdev_rwsem);
+	bitmap_or(cxlm->exclusive_cmds, cxlm->exclusive_cmds, cmds,
+		  CXL_MEM_COMMAND_ID_MAX);
+	up_write(&cxl_memdev_rwsem);
+}
+EXPORT_SYMBOL_GPL(set_exclusive_cxl_commands);
+
+/**
+ * clear_exclusive_cxl_commands() - atomically enable user cxl commands
+ * @cxlm: cxl_mem instance to modify
+ * @cmds: bitmap of commands to mark available for userspace
+ */
+void clear_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds)
+{
+	down_write(&cxl_memdev_rwsem);
+	bitmap_andnot(cxlm->exclusive_cmds, cxlm->exclusive_cmds, cmds,
+		      CXL_MEM_COMMAND_ID_MAX);
+	up_write(&cxl_memdev_rwsem);
+}
+EXPORT_SYMBOL_GPL(clear_exclusive_cxl_commands);
+
 static void cxl_memdev_shutdown(struct device *dev)
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index df4f3636a999..45d5347b5d61 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -102,6 +102,7 @@ struct cxl_mbox_cmd {
  * @mbox_mutex: Mutex to synchronize mailbox access.
  * @firmware_version: Firmware version for the memory device.
  * @enabled_cmds: Hardware commands found enabled in CEL.
+ * @exclusive_cmds: Commands that are kernel-internal only
  * @pmem_range: Persistent memory capacity information.
  * @ram_range: Volatile memory capacity information.
  * @mbox_send: @dev specific transport for transmitting mailbox commands
@@ -117,6 +118,7 @@ struct cxl_mem {
 	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
 	char firmware_version[0x10];
 	DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
+	DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
 
 	struct range pmem_range;
 	struct range ram_range;
@@ -190,4 +192,6 @@ int cxl_mem_identify(struct cxl_mem *cxlm);
 int cxl_mem_enumerate_cmds(struct cxl_mem *cxlm);
 int cxl_mem_create_range_info(struct cxl_mem *cxlm);
 struct cxl_mem *cxl_mem_create(struct device *dev);
+void set_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds);
+void clear_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds);
 #endif /* __CXL_MEM_H__ */
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 9652c3ee41e7..469b984176a2 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -16,9 +16,21 @@
  */
 static struct workqueue_struct *cxl_pmem_wq;
 
-static void unregister_nvdimm(void *nvdimm)
+static __read_mostly DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
+
+static void unregister_nvdimm(void *_cxl_nvd)
 {
-	nvdimm_delete(nvdimm);
+	struct cxl_nvdimm *cxl_nvd = _cxl_nvd;
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_mem *cxlm = cxlmd->cxlm;
+	struct device *dev = &cxl_nvd->dev;
+	struct nvdimm *nvdimm;
+
+	nvdimm = dev_get_drvdata(dev);
+	if (nvdimm)
+		nvdimm_delete(nvdimm);
+
+	clear_exclusive_cxl_commands(cxlm, exclusive_cmds);
 }
 
 static int match_nvdimm_bridge(struct device *dev, const void *data)
@@ -39,9 +51,11 @@ static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
 static int cxl_nvdimm_probe(struct device *dev)
 {
 	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_mem *cxlm = cxlmd->cxlm;
 	struct cxl_nvdimm_bridge *cxl_nvb;
+	struct nvdimm *nvdimm = NULL;
 	unsigned long flags = 0;
-	struct nvdimm *nvdimm;
 	int rc = -ENXIO;
 
 	cxl_nvb = cxl_find_nvdimm_bridge();
@@ -52,17 +66,20 @@ static int cxl_nvdimm_probe(struct device *dev)
 	if (!cxl_nvb->nvdimm_bus)
 		goto out;
 
+	set_exclusive_cxl_commands(cxlm, exclusive_cmds);
+
 	set_bit(NDD_LABELING, &flags);
 	nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags, 0, 0,
 			       NULL);
-	if (!nvdimm)
-		goto out;
-
-	rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
+	dev_set_drvdata(dev, nvdimm);
+	rc = devm_add_action_or_reset(dev, unregister_nvdimm, cxl_nvd);
 out:
 	device_unlock(&cxl_nvb->dev);
 	put_device(&cxl_nvb->dev);
 
+	if (!nvdimm && rc == 0)
+		rc = -ENOMEM;
+
 	return rc;
 }
 
@@ -194,6 +211,10 @@ static __init int cxl_pmem_init(void)
 {
 	int rc;
 
+	set_bit(CXL_MEM_COMMAND_ID_SET_PARTITION_INFO, exclusive_cmds);
+	set_bit(CXL_MEM_COMMAND_ID_SET_SHUTDOWN_STATE, exclusive_cmds);
+	set_bit(CXL_MEM_COMMAND_ID_SET_LSA, exclusive_cmds);
+
 	cxl_pmem_wq = alloc_ordered_workqueue("cxl_pmem", 0);
 	if (!cxl_pmem_wq)
 		return -ENXIO;

