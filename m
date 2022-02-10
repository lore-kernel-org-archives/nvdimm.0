Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31382C80
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 02:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644458474; x=1675994474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g6llTrHh/ojmCw4TL9zhIeN/sHiK2+9zbAVpKY+VN2c=;
  b=dA5zbvh2i4g5aj7XtzZ6odbaNUUWCk/lV4v4EqhDirBm1Te6gzT7ZiEs
   RB9ZzdshAF+n/PCQ1Gyo3/dA9BOgWLqzNqim5p8SzvZjMxXxgJUfYLGKb
   qHjzpa5CdHrHlf+gLjnN+PwkgNk7kmTiCsTeRDohqyAJLNQyVsUdF981F
   eYM66qX+fvjPzwLITCHyGWPA42WUZOsu+c9SgIuy5Ane8tRVyB4QZudjd
   EVJ1KwnPv1Kbw+WoGdqgN5h2cSnwVe5ueg2gHBubgRnA1+2R75BbVJFS+
   e8iE+CqyhdlNTWJgd1BZmR8InNQbLr0Gv9HAtPouE943IFUXCBlI1a6T6
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="236792114"
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="236792114"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 18:01:13 -0800
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="585799513"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 18:01:13 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v5 2/6] libcxl: add accessors for capacity fields of the IDENTIFY command
Date: Wed,  9 Feb 2022 18:05:10 -0800
Message-Id: <58dec40b15a68f134466f61421751994735e55c1.1644455619.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1644455619.git.alison.schofield@intel.com>
References: <cover.1644455619.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The CXL PMEM provisioning model depends upon the values reported
in the CXL IDENTIFY mailbox command when changing the partitioning
between volatile and persistent capacity.

Add accessors to the libcxl API to retrieve the total, volatile only,
and persistent only capacities from the IDENTIFY command.

The fields are specified in multiples of 256MB per the CXL 2.0 spec.
Use the capacity multiplier to convert the raw data into bytes for user
consumption.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/lib/libcxl.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  3 +++
 cxl/libcxl.h       |  3 +++
 3 files changed, 50 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 4557a71..9413384 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2277,6 +2277,17 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev)
 	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_IDENTIFY);
 }
 
+static struct cxl_cmd_identify *
+cmd_to_identify(struct cxl_cmd *cmd)
+{
+	if (cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_IDENTIFY))
+		return NULL;
+
+	if (!cmd)
+		return NULL;
+	return cmd->output_payload;
+}
+
 CXL_EXPORT int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev,
 		int fw_len)
 {
@@ -2321,6 +2332,39 @@ CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
 	return le32_to_cpu(id->lsa_size);
 }
 
+CXL_EXPORT unsigned long long
+cxl_cmd_identify_get_total_size(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_identify *c;
+
+	c = cmd_to_identify(cmd);
+	if (!c)
+		return ULLONG_MAX;
+	return cxl_capacity_to_bytes(c->total_capacity);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_identify_get_volatile_only_size(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_identify *c;
+
+	c = cmd_to_identify(cmd);
+	if (!c)
+		return ULLONG_MAX;
+	return cxl_capacity_to_bytes(c->volatile_capacity);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_identify_get_persistent_only_size(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_identify *c;
+
+	c = cmd_to_identify(cmd);
+	if (!c)
+		return ULLONG_MAX;
+	return cxl_capacity_to_bytes(c->persistent_capacity);
+}
+
 CXL_EXPORT struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev,
 		int opcode)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 509e62d..5ac6e9b 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -160,4 +160,7 @@ global:
 	cxl_cmd_partition_get_active_persistent_size;
 	cxl_cmd_partition_get_next_volatile_size;
 	cxl_cmd_partition_get_next_persistent_size;
+	cxl_cmd_identify_get_total_size;
+	cxl_cmd_identify_get_volatile_only_size;
+	cxl_cmd_identify_get_persistent_only_size;
 } LIBCXL_1;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 2c0a8d1..6e18e84 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -201,6 +201,9 @@ int cxl_cmd_get_mbox_status(struct cxl_cmd *cmd);
 int cxl_cmd_get_out_size(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
 int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
+unsigned long long cxl_cmd_identify_get_total_size(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_identify_get_volatile_only_size(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_identify_get_persistent_only_size(struct cxl_cmd *cmd);
 unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
 unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_get_health_info(struct cxl_memdev *memdev);
-- 
2.31.1

