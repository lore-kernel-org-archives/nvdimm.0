Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CA43FC4
	for <nvdimm@lists.linux.dev>; Mon, 13 Sep 2021 22:19:52 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="282809418"
X-IronPort-AV: E=Sophos;i="5.85,290,1624345200"; 
   d="scan'208";a="282809418"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 15:19:51 -0700
X-IronPort-AV: E=Sophos;i="5.85,290,1624345200"; 
   d="scan'208";a="609257045"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 15:19:50 -0700
Subject: [PATCH v5 08/21] cxl/pci: Clean up cxl_mem_get_partition_info()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ira Weiny <ira.weiny@intel.com>, Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huwei.com>, nvdimm@lists.linux.dev
Date: Mon, 13 Sep 2021 15:19:49 -0700
Message-ID: <163157154183.2652718.10987214856112022775.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163116433533.2460985.14299233004385504131.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116433533.2460985.14299233004385504131.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Commit 0b9159d0ff21 ("cxl/pci: Store memory capacity values") missed
updating the kernel-doc for 'struct cxl_mem' leading to the following
warnings:

./scripts/kernel-doc -v drivers/cxl/cxlmem.h 2>&1 | grep warn
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'total_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'volatile_only_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'persistent_only_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'partition_align_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_volatile_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_persistent_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_volatile_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_persistent_bytes' not described in 'cxl_mem'

Also, it is redundant to describe those same parameters in the
kernel-doc for cxl_mem_get_partition_info(). Given the only user of that
routine updates the values in @cxlm, just do that implicitly internal to
the helper.

Cc: Ira Weiny <ira.weiny@intel.com>
Reported-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huwei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v4:
- Update the kdoc for @partition_align_bytes (Ben)
- Collect Jonathan's reviewed-by pending above update.

 drivers/cxl/cxlmem.h |   15 +++++++++++++--
 drivers/cxl/pci.c    |   35 +++++++++++------------------------
 2 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index d5334df83fb2..c6fce966084a 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -78,8 +78,19 @@ devm_cxl_add_memdev(struct cxl_mem *cxlm,
  * @mbox_mutex: Mutex to synchronize mailbox access.
  * @firmware_version: Firmware version for the memory device.
  * @enabled_cmds: Hardware commands found enabled in CEL.
- * @pmem_range: Persistent memory capacity information.
- * @ram_range: Volatile memory capacity information.
+ * @pmem_range: Active Persistent memory capacity configuration
+ * @ram_range: Active Volatile memory capacity configuration
+ * @total_bytes: sum of all possible capacities
+ * @volatile_only_bytes: hard volatile capacity
+ * @persistent_only_bytes: hard persistent capacity
+ * @partition_align_bytes: soft setting for configurable capacity
+ * @active_volatile_bytes: sum of hard + soft volatile
+ * @active_persistent_bytes: sum of hard + soft persistent
+ * @next_volatile_bytes: volatile capacity change pending device reset
+ * @next_persistent_bytes: persistent capacity change pending device reset
+ *
+ * See section 8.2.9.5.2 Capacity Configuration and Label Storage for
+ * details on capacity parameters.
  */
 struct cxl_mem {
 	struct device *dev;
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index c1e1d12e24b6..8077d907e7d3 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -1262,11 +1262,7 @@ static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
 
 /**
  * cxl_mem_get_partition_info - Get partition info
- * @cxlm: The device to act on
- * @active_volatile_bytes: returned active volatile capacity
- * @active_persistent_bytes: returned active persistent capacity
- * @next_volatile_bytes: return next volatile capacity
- * @next_persistent_bytes: return next persistent capacity
+ * @cxlm: cxl_mem instance to update partition info
  *
  * Retrieve the current partition info for the device specified.  If not 0, the
  * 'next' values are pending and take affect on next cold reset.
@@ -1275,11 +1271,7 @@ static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
  *
  * See CXL @8.2.9.5.2.1 Get Partition Info
  */
-static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
-				      u64 *active_volatile_bytes,
-				      u64 *active_persistent_bytes,
-				      u64 *next_volatile_bytes,
-				      u64 *next_persistent_bytes)
+static int cxl_mem_get_partition_info(struct cxl_mem *cxlm)
 {
 	struct cxl_mbox_get_partition_info {
 		__le64 active_volatile_cap;
@@ -1294,15 +1286,14 @@ static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
 	if (rc)
 		return rc;
 
-	*active_volatile_bytes = le64_to_cpu(pi.active_volatile_cap);
-	*active_persistent_bytes = le64_to_cpu(pi.active_persistent_cap);
-	*next_volatile_bytes = le64_to_cpu(pi.next_volatile_cap);
-	*next_persistent_bytes = le64_to_cpu(pi.next_volatile_cap);
-
-	*active_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
-	*active_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
-	*next_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
-	*next_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
+	cxlm->active_volatile_bytes =
+		le64_to_cpu(pi.active_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->active_persistent_bytes =
+		le64_to_cpu(pi.active_persistent_cap) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->next_volatile_bytes =
+		le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->next_persistent_bytes =
+		le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
 
 	return 0;
 }
@@ -1443,11 +1434,7 @@ static int cxl_mem_create_range_info(struct cxl_mem *cxlm)
 		return 0;
 	}
 
-	rc = cxl_mem_get_partition_info(cxlm,
-					&cxlm->active_volatile_bytes,
-					&cxlm->active_persistent_bytes,
-					&cxlm->next_volatile_bytes,
-					&cxlm->next_persistent_bytes);
+	rc = cxl_mem_get_partition_info(cxlm);
 	if (rc < 0) {
 		dev_err(cxlm->dev, "Failed to query partition information\n");
 		return rc;

