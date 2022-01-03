Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186A62CA7
	for <nvdimm@lists.linux.dev>; Mon,  3 Jan 2022 20:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641240694; x=1672776694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=deLhvT2rkO5L/SLA7rPyzJse0nz+c7TFWMdZ+dd8Fz8=;
  b=n5HdY1smPu8ykkxFisHHBJ9ogA31HYp3X+BtS10ujHlLsDyrGbqfnmZB
   0kTKRrk8DLkNlL8MOpgc2wEYmFYzLqwFsocqHCuJoB5wuuzxVLuegPDhs
   wzwKrcSCaGUg/UmBp1/NXRYzg4v5Hi2vs6ZIT6i2fppgX6emLp7cuNzi2
   dj+iYzHQYnAZQxtxCNc4YhpxRq/mls4SzcgssOD7GjtejVt4mJ6PEINZO
   Hh34XJCCbVe0mKBbdHDkbL13JLgVEbq/TNcN3AzOJ40ROLetHskO1WadR
   HkmIFN3uUFHQRkERwMXXTwXz5UZv547U5fz8gaIy1E+5i+hl65+JiQK0O
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="302866885"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="302866885"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 12:11:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="525709387"
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
Subject: [ndctl PATCH 1/7] libcxl: add GET_PARTITION_INFO mailbox command and accessors
Date: Mon,  3 Jan 2022 12:16:12 -0800
Message-Id: <9d3c55cbd36efb6eabec075cc8596a6382f1f145.1641233076.git.alison.schofield@intel.com>
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

Add libcxl APIs to create a new GET_PARTITION_INFO mailbox command, the
command output data structure (privately), and accessor APIs to return
the different fields in the partition info output.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/lib/private.h  | 10 ++++++++++
 cxl/libcxl.h       |  5 +++++
 util/size.h        |  1 +
 cxl/lib/libcxl.c   | 41 +++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  5 +++++
 5 files changed, 62 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index a1b8b50..dd9234f 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -7,6 +7,7 @@
 #include <cxl/cxl_mem.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
+#include <util/size.h>
 
 #define CXL_EXPORT __attribute__ ((visibility("default")))
 
@@ -104,6 +105,15 @@ struct cxl_cmd_get_health_info {
 	le32 pmem_errors;
 } __attribute__((packed));
 
+struct cxl_cmd_get_partition_info {
+	le64 active_volatile_cap;
+	le64 active_persistent_cap;
+	le64 next_volatile_cap;
+	le64 next_persistent_cap;
+} __attribute__((packed));
+
+#define CXL_CAPACITY_MULTIPLIER		SZ_256M
+
 /* CXL 2.0 8.2.9.5.3 Byte 0 Health Status */
 #define CXL_CMD_HEALTH_INFO_STATUS_MAINTENANCE_NEEDED_MASK		BIT(0)
 #define CXL_CMD_HEALTH_INFO_STATUS_PERFORMANCE_DEGRADED_MASK		BIT(1)
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 89d35ba..7cf9061 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -109,6 +109,11 @@ ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd, void *buf,
 		unsigned int length);
 struct cxl_cmd *cxl_cmd_new_write_label(struct cxl_memdev *memdev,
 		void *buf, unsigned int offset, unsigned int length);
+struct cxl_cmd *cxl_cmd_new_get_partition_info(struct cxl_memdev *memdev);
+unsigned long long cxl_cmd_get_partition_info_get_active_volatile_cap(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_get_partition_info_get_active_persistent_cap(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_get_partition_info_get_next_volatile_cap(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_get_partition_info_get_next_persistent_cap(struct cxl_cmd *cmd);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/util/size.h b/util/size.h
index a0f3593..e72467f 100644
--- a/util/size.h
+++ b/util/size.h
@@ -15,6 +15,7 @@
 #define SZ_4M     0x00400000
 #define SZ_16M    0x01000000
 #define SZ_64M    0x04000000
+#define SZ_256M	  0x10000000
 #define SZ_1G     0x40000000
 #define SZ_1T 0x10000000000ULL
 
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index f0664be..f3d4022 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1157,6 +1157,47 @@ CXL_EXPORT ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd,
 	return length;
 }
 
+CXL_EXPORT struct cxl_cmd *cxl_cmd_new_get_partition_info(struct cxl_memdev *memdev)
+{
+	return cxl_cmd_new_generic(memdev,
+				   CXL_MEM_COMMAND_ID_GET_PARTITION_INFO);
+}
+
+#define cmd_partition_get_capacity_field(cmd, field)			\
+do {										\
+	struct cxl_cmd_get_partition_info *c =					\
+		(struct cxl_cmd_get_partition_info *)cmd->send_cmd->out.payload;\
+	int rc = cxl_cmd_validate_status(cmd,					\
+			CXL_MEM_COMMAND_ID_GET_PARTITION_INFO);			\
+	if (rc)									\
+		return ULLONG_MAX;							\
+	return le64_to_cpu(c->field) * CXL_CAPACITY_MULTIPLIER;			\
+} while (0)
+
+CXL_EXPORT unsigned long long
+cxl_cmd_get_partition_info_get_active_volatile_cap(struct cxl_cmd *cmd)
+{
+	cmd_partition_get_capacity_field(cmd, active_volatile_cap);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_get_partition_info_get_active_persistent_cap(struct cxl_cmd *cmd)
+{
+	cmd_partition_get_capacity_field(cmd, active_persistent_cap);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_get_partition_info_get_next_volatile_cap(struct cxl_cmd *cmd)
+{
+	cmd_partition_get_capacity_field(cmd, next_volatile_cap);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_get_partition_info_get_next_persistent_cap(struct cxl_cmd *cmd)
+{
+	cmd_partition_get_capacity_field(cmd, next_persistent_cap);
+}
+
 CXL_EXPORT int cxl_cmd_submit(struct cxl_cmd *cmd)
 {
 	struct cxl_memdev *memdev = cmd->memdev;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 077d104..09d6d94 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -70,6 +70,11 @@ global:
 	cxl_memdev_zero_label;
 	cxl_memdev_write_label;
 	cxl_memdev_read_label;
+	cxl_cmd_new_get_partition_info;
+	cxl_cmd_get_partition_info_get_active_volatile_cap;
+	cxl_cmd_get_partition_info_get_active_persistent_cap;
+	cxl_cmd_get_partition_info_get_next_volatile_cap;
+	cxl_cmd_get_partition_info_get_next_persistent_cap;
 local:
         *;
 };
-- 
2.31.1

