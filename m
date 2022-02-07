Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6812F2C
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 23:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644275183; x=1675811183;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UCibke1LlNk3o58hklc1YHk+2ui0lmeYc6ks3030QGM=;
  b=OSjRicJkG9BnWli6YsP+iP8FM8LWKdyq3aZfO5RHayI1DrthR/cMGO6N
   YzTu/twkKzV6AzRAM3GMLLjxc79zmLDGZVXtL/27ukXJ2/dYUcRtNEP64
   I6gBUrAeA4aZBoLyanp07ZcfdkI3pWYiKoDYUj61doNbyD6UgKqzPrL38
   YU576syDa9vU9fP/K9vW3EvPWhs5PZY8lg0n9xpNmcMkoOvFbWitOgFea
   3lbc6FBFtrdIDn24Jn70eTR5aZSXxpttHhuqjJZAvjSbj+F4tqzRLUxsd
   L9nnEmFoiiUPnizkLHQyC1Fm4fzywezwGTr5smPV5llEfVGLqYtDo5HWN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="273351898"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="273351898"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 15:06:15 -0800
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="632639209"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 15:06:14 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v4 5/6] libcxl: add interfaces for SET_PARTITION_INFO mailbox command
Date: Mon,  7 Feb 2022 15:10:19 -0800
Message-Id: <7d1ebd8316584d065133ab7343e14eba2810f98e.1644271559.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1644271559.git.alison.schofield@intel.com>
References: <cover.1644271559.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Users may want the ability to change the partition layout of a CXL
memory device.

Add interfaces to libcxl to allocate and send a SET_PARTITION_INFO
mailbox command as defined in the CXL 2.0 specification.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |  4 ++++
 cxl/lib/libcxl.c                 | 28 ++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |  2 ++
 cxl/lib/private.h                |  8 ++++++++
 cxl/libcxl.h                     | 10 ++++++++++
 5 files changed, 52 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index a6986ab..301b4d7 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -132,6 +132,8 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
 int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
 			   size_t offset);
 struct cxl_cmd *cxl_cmd_new_get_partition(struct cxl_memdev *memdev);
+struct cxl_cmd *cxl_cmd_new_set_partition(struct cxl_memdev *memdev,
+					  unsigned long long volatile_size);
 
 ----
 
@@ -148,6 +150,8 @@ this sub-class of interfaces, there are:
    a CXL standard opcode. See the potential command ids in
    /usr/include/linux/cxl_mem.h.
 
+ * 'cxl_cmd_<name>_set_<field>' interfaces that set specific fields in a cxl_cmd
+
  * 'cxl_cmd_submit' which submits the command via ioctl()
 
  * 'cxl_cmd_<name>_get_<field>' interfaces that get specific fields out of the
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 307e5c4..3f04421 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2464,6 +2464,34 @@ cxl_cmd_partition_get_next_persistent_size(struct cxl_cmd *cmd)
 	return c ? capacity_to_bytes(c->next_persistent) : ULLONG_MAX;
 }
 
+CXL_EXPORT int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
+		enum cxl_setpartition_mode mode)
+{
+	struct cxl_cmd_set_partition *setpart = cmd->input_payload;
+
+	if (mode == CXL_SETPART_IMMEDIATE)
+		setpart->flags = CXL_CMD_SET_PARTITION_FLAG_IMMEDIATE;
+	else
+		setpart->flags = !CXL_CMD_SET_PARTITION_FLAG_IMMEDIATE;
+
+	return 0;
+}
+
+CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_partition(struct cxl_memdev *memdev,
+		unsigned long long volatile_size)
+{
+	struct cxl_cmd_set_partition *setpart;
+	struct cxl_cmd *cmd;
+
+	cmd = cxl_cmd_new_generic(memdev,
+			CXL_MEM_COMMAND_ID_SET_PARTITION_INFO);
+
+	setpart = cmd->input_payload;
+	setpart->volatile_size = cpu_to_le64(volatile_size)
+					/ CXL_CAPACITY_MULTIPLIER;
+	return cmd;
+}
+
 CXL_EXPORT int cxl_cmd_submit(struct cxl_cmd *cmd)
 {
 	struct cxl_memdev *memdev = cmd->memdev;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 5ac6e9b..aab1112 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -163,4 +163,6 @@ global:
 	cxl_cmd_identify_get_total_size;
 	cxl_cmd_identify_get_volatile_only_size;
 	cxl_cmd_identify_get_persistent_only_size;
+	cxl_cmd_new_set_partition;
+	cxl_cmd_partition_set_mode;
 } LIBCXL_1;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 7f3a562..c6d88f7 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -195,6 +195,14 @@ struct cxl_cmd_get_partition {
 
 #define CXL_CAPACITY_MULTIPLIER		SZ_256M
 
+struct cxl_cmd_set_partition {
+	le64 volatile_size;
+	u8 flags;
+} __attribute__((packed));
+
+/* CXL 2.0 8.2.9.5.2 Set Partition Info */
+#define CXL_CMD_SET_PARTITION_FLAG_IMMEDIATE				BIT(0)
+
 /* CXL 2.0 8.2.9.5.3 Byte 0 Health Status */
 #define CXL_CMD_HEALTH_INFO_STATUS_MAINTENANCE_NEEDED_MASK		BIT(0)
 #define CXL_CMD_HEALTH_INFO_STATUS_PERFORMANCE_DEGRADED_MASK		BIT(1)
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 6e18e84..0063d31 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -250,6 +250,16 @@ unsigned long long cxl_cmd_partition_get_active_volatile_size(struct cxl_cmd *cm
 unsigned long long cxl_cmd_partition_get_active_persistent_size(struct cxl_cmd *cmd);
 unsigned long long cxl_cmd_partition_get_next_volatile_size(struct cxl_cmd *cmd);
 unsigned long long cxl_cmd_partition_get_next_persistent_size(struct cxl_cmd *cmd);
+struct cxl_cmd *cxl_cmd_new_set_partition(struct cxl_memdev *memdev,
+		unsigned long long volatile_size);
+
+enum cxl_setpartition_mode {
+	CXL_SETPART_NEXTBOOT,
+	CXL_SETPART_IMMEDIATE,
+};
+
+int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
+		enum cxl_setpartition_mode mode);
 
 #ifdef __cplusplus
 } /* extern "C" */
-- 
2.31.1

