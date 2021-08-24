Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0CD3FC0
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:07:10 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="204541379"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="204541379"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:07:09 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="515510177"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:07:07 -0700
Subject: [PATCH v3 19/28] cxl/mbox: Convert 'enabled_cmds' to DECLARE_BITMAP
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:07:07 -0700
Message-ID: <162982122744.1124374.6742215706893563515.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Define enabled_cmds as an embedded member of 'struct cxl_mem' rather
than a pointer to another dynamic allocation.

As this leaves only one user of cxl_cmd_count, just open code it and
delete the helper.

Acked-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/mbox.c |   10 +---------
 drivers/cxl/cxlmem.h    |    2 +-
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 706fe007c8d6..73107b302224 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -324,8 +324,6 @@ static int cxl_validate_cmd_from_user(struct cxl_mem *cxlm,
 	return 0;
 }
 
-#define cxl_cmd_count ARRAY_SIZE(cxl_mem_commands)
-
 int cxl_query_cmd(struct cxl_memdev *cxlmd,
 		  struct cxl_mem_query_commands __user *q)
 {
@@ -341,7 +339,7 @@ int cxl_query_cmd(struct cxl_memdev *cxlmd,
 
 	/* returns the total number if 0 elements are requested. */
 	if (n_commands == 0)
-		return put_user(cxl_cmd_count, &q->n_commands);
+		return put_user(ARRAY_SIZE(cxl_mem_commands), &q->n_commands);
 
 	/*
 	 * otherwise, return max(n_commands, total commands) cxl_command_info
@@ -805,12 +803,6 @@ struct cxl_mem *cxl_mem_create(struct device *dev)
 
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

