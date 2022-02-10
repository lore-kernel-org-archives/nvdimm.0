Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A102F28
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 02:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644458476; x=1675994476;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OmUG16NjzS8dLRugEQI60eydFLLr0J4PwLjBw9SAeUg=;
  b=HAdaQ0Y+751TbG/H1pdcTNDvnyOhWvoRrW8/W6l8CLja0nYujx234Q6X
   tXdkHCDBfgqHT4p+MJ1I75A7g58H3HwvWLGFuex3eZlsZBH0LAyxLq+Vt
   PvhjhONmWGl1PQc7ycpZZzrAxiBtYZBBIVD0LIFG+jX8mIJW2HabfbUmd
   LS1Ngh4a4sYJvRKhK/6DFMuOJK2avx9fPDmGXQfCyNC9l/vnoEqkiJWbt
   SHFkJ6nvlrJwzw0ttlpmhQ22L5GqrY3+4zS47eoXEgJF21HMJZgKxwkjk
   3pNKGq8u2locqPbdVuWYUGhJOQrO3HDb3YsPnI6OZm0wS9Zmq+aCd6+k2
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="236792132"
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="236792132"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 18:01:15 -0800
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="585799610"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 18:01:14 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v5 5/6] libcxl: add interfaces for SET_PARTITION_INFO mailbox command
Date: Wed,  9 Feb 2022 18:05:13 -0800
Message-Id: <c7407f68c9fefd3cfa1c4ef9903130207689272b.1644455619.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1644455619.git.alison.schofield@intel.com>
References: <cover.1644455619.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The CXL PMEM provisioning model depends upon the CXL mailbox command
SET_PARTITION_INFO to change a device's partitioning between volatile
and persistent capacity.

Add interfaces to libcxl to allocate and send a SET_PARTITION_INFO
mailbox command as defined in the CXL 2.0 specification.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/cxl/lib/libcxl.txt | 11 +++++++++++
 cxl/lib/libcxl.c                 | 28 ++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |  2 ++
 cxl/lib/private.h                |  8 ++++++++
 cxl/libcxl.h                     | 10 ++++++++++
 5 files changed, 59 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index a6986ab..7b223cb 100644
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
@@ -167,6 +171,13 @@ cxl_memdev{read,write,zero}_label() are helpers for marshaling multiple
 label access commands over an arbitrary extent of the device's label
 area.
 
+cxl_cmd_partition_set_mode() supports selecting NEXTBOOT or IMMEDIATE
+mode. When CXL_SETPART_IMMEDIATE mode is set, it is the caller’s
+responsibility to avoid immediate changes to partitioning when the
+device is in use. When CXL_SETPART_NEXTBOOT mode is set, the change
+in partitioning shall become the “next” configuration, to become
+active on the next device reset.
+
 BUSES
 -----
 The CXL Memory space is CPU and Device coherent. The address ranges that
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index c05c13c..daa2bbc 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2478,6 +2478,34 @@ cxl_cmd_partition_get_next_persistent_size(struct cxl_cmd *cmd)
 	return cxl_capacity_to_bytes(c->next_persistent);
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

