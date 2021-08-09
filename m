Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252C56D00
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 22:29:14 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="236796817"
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="236796817"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 15:29:13 -0700
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="421000208"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 15:29:13 -0700
Subject: [PATCH 16/23] cxl/mbox: Convert 'enabled_cmds' to DECLARE_BITMAP
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Jonathan.Cameron@huawei.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, ira.weiny@intel.com
Date: Mon, 09 Aug 2021 15:29:13 -0700
Message-ID: <162854815299.1980150.3524640653829717905.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Define enabled_cmds as an embedded member of 'struct cxl_mem' rather
than a pointer to another dynamic allocation.

As this leaves only one user of cxl_cmd_count, just open code it and
delete the helper.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/mbox.c |   10 +---------
 drivers/cxl/cxlmem.h    |    2 +-
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 40f051956990..23100231e246 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -322,8 +322,6 @@ static int cxl_validate_cmd_from_user(struct cxl_mem *cxlm,
 	return 0;
 }
 
-#define cxl_cmd_count ARRAY_SIZE(cxl_mem_commands)
-
 int cxl_query_cmd(struct cxl_memdev *cxlmd,
 		  struct cxl_mem_query_commands __user *q)
 {
@@ -339,7 +337,7 @@ int cxl_query_cmd(struct cxl_memdev *cxlmd,
 
 	/* returns the total number if 0 elements are requested. */
 	if (n_commands == 0)
-		return put_user(cxl_cmd_count, &q->n_commands);
+		return put_user(ARRAY_SIZE(cxl_mem_commands), &q->n_commands);
 
 	/*
 	 * otherwise, return max(n_commands, total commands) cxl_command_info
@@ -803,12 +801,6 @@ struct cxl_mem *cxl_mem_create(struct device *dev)
 
 	mutex_init(&cxlm->mbox_mutex);
 	cxlm->dev = dev;
-	cxlm->enabled_cmds =
-		devm_kmalloc_array(dev, BITS_TO_LONGS(cxl_cmd_count),
-				   sizeof(unsigned long),
-				   GFP_KERNEL | __GFP_ZERO);
-	if (!cxlm->enabled_cmds)
-		return ERR_PTR(-ENOMEM);
 
 	return cxlm;
 }
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index b7122ded3a04..df4f3636a999 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -116,7 +116,7 @@ struct cxl_mem {
 	size_t lsa_size;
 	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
 	char firmware_version[0x10];
-	unsigned long *enabled_cmds;
+	DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
 
 	struct range pmem_range;
 	struct range ram_range;

