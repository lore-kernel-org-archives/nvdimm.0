Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC222CA9
	for <nvdimm@lists.linux.dev>; Mon,  3 Jan 2022 20:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641240695; x=1672776695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a4ist+wRtz5MUDFftoH8bUzPjP4x2s9lbL9nKwk7uk8=;
  b=KifmBSXoCJ9YvBLuAKqfVe3XqV51UB6JOIAqp6oO979pWkyahY59Qh+l
   35yhfCS/U5adZe67FG0gj8xg67VtETtp9rRr4yTM/uv7BdDgpFayC2H7A
   mGPMsVCP5dkwIZ/iUUZkB1CUvj6/IgqIID0NdLGnLHoA+XozqGGhcEoGs
   yDaYqbijAz3YcDDxZuSh4U7LdHyyjAvQ8VwNOu5ekN/1nQaQgR01DiJkL
   iTpXEmm0+8JM4yua88uSFGpw/YSyDRUDcZpb6n8t+qutiJbpnvcUzWKmt
   dBsBPhq/QaRWAK1ZvMsjOhJb2U5oO62tR66PxJhPHKyrl5HHDvX+zkZbT
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="302866886"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="302866886"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 12:11:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="525709392"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 12:11:33 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 2/7] libcxl: add accessors for capacity fields of the IDENTIFY command
Date: Mon,  3 Jan 2022 12:16:13 -0800
Message-Id: <577012d59f5b6b9754d2ce1147585ce5f91a3108.1641233076.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1641233076.git.alison.schofield@intel.com>
References: <cover.1641233076.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Add accessors to retrieve total capacity, volatile only capacity,
and persistent only capacity from the IDENTIFY mailbox command.
These values are useful when partitioning the device.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/libcxl.h       |  3 +++
 cxl/lib/libcxl.c   | 29 +++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  3 +++
 3 files changed, 35 insertions(+)

diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 7cf9061..d333b6d 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -68,6 +68,9 @@ int cxl_cmd_get_mbox_status(struct cxl_cmd *cmd);
 int cxl_cmd_get_out_size(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
 int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
+unsigned long long cxl_cmd_identify_get_total_capacity(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_identify_get_volatile_only_capacity(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_identify_get_persistent_only_capacity(struct cxl_cmd *cmd);
 unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
 unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_get_health_info(struct cxl_memdev *memdev);
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index f3d4022..715d8e4 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1102,6 +1102,35 @@ CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
 	return le32_to_cpu(id->lsa_size);
 }
 
+#define cmd_identify_get_capacity_field(cmd, field)			\
+do {										\
+	struct cxl_cmd_identify *c =					\
+		(struct cxl_cmd_identify *)cmd->send_cmd->out.payload;\
+	int rc = cxl_cmd_validate_status(cmd,					\
+			CXL_MEM_COMMAND_ID_IDENTIFY);			\
+	if (rc)									\
+		return ULLONG_MAX;							\
+	return le64_to_cpu(c->field) * CXL_CAPACITY_MULTIPLIER;			\
+} while (0)
+
+CXL_EXPORT unsigned long long
+cxl_cmd_identify_get_total_capacity(struct cxl_cmd *cmd)
+{
+	cmd_identify_get_capacity_field(cmd, total_capacity);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_identify_get_volatile_only_capacity(struct cxl_cmd *cmd)
+{
+	cmd_identify_get_capacity_field(cmd, volatile_capacity);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_identify_get_persistent_only_capacity(struct cxl_cmd *cmd)
+{
+	cmd_identify_get_capacity_field(cmd, persistent_capacity);
+}
+
 CXL_EXPORT struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev,
 		int opcode)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 09d6d94..bed6427 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -31,6 +31,9 @@ global:
 	cxl_cmd_get_out_size;
 	cxl_cmd_new_identify;
 	cxl_cmd_identify_get_fw_rev;
+	cxl_cmd_identify_get_total_capacity;
+	cxl_cmd_identify_get_volatile_only_capacity;
+	cxl_cmd_identify_get_persistent_only_capacity;
 	cxl_cmd_identify_get_partition_align;
 	cxl_cmd_identify_get_label_size;
 	cxl_cmd_new_get_health_info;
-- 
2.31.1

