Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5446066DB
	for <nvdimm@lists.linux.dev>; Tue, 22 Feb 2022 19:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645559556; x=1677095556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y/VSSTrah+fp8sLz2UCfMe2qslgyf4HT2fdartoaU60=;
  b=EqcG3zHimKETHbEYmZkNDA63npOlp0EKj4HsZxmQQLdGUe+ZS677PyiK
   hq/PELJL9SaABm1D5Gk2L7TjKKUSCl/IVzqbln1ixUt0XlNaji/xpDpac
   OdtFVwpBgJMqrd2b5+6yXy3yD4n5upScj1mbv7X5yuVCjvb8TI58kPd5O
   F6S6yR/yOj74twkjr0W+P8JsU3BxB1FZNvBNkY2cutasQa4b7iuvHYDf6
   w6KerL0/WRtyJ1q0BmAIMAYj0OntqlAgs/O+gPeTYElFdCwEKu1am8y28
   JB5dWi0HeirwTxQtopP1hP6xc5PGAqcpiyqo3rLnQjQQq3S+e0eYc+TKv
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="315027641"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="315027641"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 11:52:35 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="683637800"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 11:52:35 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v6 1/6] libcxl: add GET_PARTITION_INFO mailbox command and accessors
Date: Tue, 22 Feb 2022 11:56:03 -0800
Message-Id: <6cd7fffe1a95c9a1bc2239cb342067df564401a5.1645558189.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1645558189.git.alison.schofield@intel.com>
References: <cover.1645558189.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The CXL PMEM provisioning model depends upon the values reported
in the CXL GET_PARTITION_INFO mailbox command when changing the
partitioning between volatile and persistent capacity.

Add libcxl APIs to create a new GET_PARTITION_INFO mailbox command,
the command output data structure (privately), and accessor APIs to
return the fields in the partition info output.

Per the CXL 2.0 specification, devices report partition capacities
as multiples of 256MB. Define and use a capacity multiplier to
convert the raw data into bytes for user consumption. Use byte
format as the norm for all capacity values produced or consumed
using CXL Mailbox commands.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |  1 +
 cxl/lib/libcxl.c                 | 66 ++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |  5 +++
 cxl/lib/private.h                | 10 +++++
 cxl/libcxl.h                     |  5 +++
 util/size.h                      |  1 +
 6 files changed, 88 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 4392b47e6ece..a6986abafce3 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -131,6 +131,7 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
 			  size_t offset);
 int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
 			   size_t offset);
+struct cxl_cmd *cxl_cmd_new_get_partition(struct cxl_memdev *memdev);
 
 ----
 
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index e0b443fb0aa4..4557a71de845 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1985,6 +1985,11 @@ static int cxl_cmd_validate_status(struct cxl_cmd *cmd, u32 id)
 	return 0;
 }
 
+static uint64_t cxl_capacity_to_bytes(leint64_t size)
+{
+	return le64_to_cpu(size) * CXL_CAPACITY_MULTIPLIER;
+}
+
 /* Helpers for health_info fields (no endian conversion) */
 #define cmd_get_field_u8(cmd, n, N, field)				\
 do {									\
@@ -2371,6 +2376,67 @@ CXL_EXPORT ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd,
 	return length;
 }
 
+CXL_EXPORT struct cxl_cmd *cxl_cmd_new_get_partition(struct cxl_memdev *memdev)
+{
+	return cxl_cmd_new_generic(memdev,
+				   CXL_MEM_COMMAND_ID_GET_PARTITION_INFO);
+}
+
+static struct cxl_cmd_get_partition *
+cmd_to_get_partition(struct cxl_cmd *cmd)
+{
+	if (cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_GET_PARTITION_INFO))
+		return NULL;
+
+	if (!cmd)
+		return NULL;
+	return cmd->output_payload;
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_partition_get_active_volatile_size(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_get_partition *c;
+
+	c = cmd_to_get_partition(cmd);
+	if (!c)
+		return ULLONG_MAX;
+	return cxl_capacity_to_bytes(c->active_volatile);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_partition_get_active_persistent_size(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_get_partition *c;
+
+	c = cmd_to_get_partition(cmd);
+	if (!c)
+		return ULLONG_MAX;
+	return cxl_capacity_to_bytes(c->active_persistent);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_partition_get_next_volatile_size(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_get_partition *c;
+
+	c = cmd_to_get_partition(cmd);
+	if (!c)
+		return ULLONG_MAX;
+	return cxl_capacity_to_bytes(c->next_volatile);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_partition_get_next_persistent_size(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_get_partition *c;
+
+	c = cmd_to_get_partition(cmd);
+	if (!c)
+		return ULLONG_MAX;
+	return cxl_capacity_to_bytes(c->next_persistent);
+}
+
 CXL_EXPORT int cxl_cmd_submit(struct cxl_cmd *cmd)
 {
 	struct cxl_memdev *memdev = cmd->memdev;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index e56a2bf96e22..509e62daad4b 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -155,4 +155,9 @@ global:
 	cxl_dport_get_port;
 	cxl_port_get_dport_by_memdev;
 	cxl_dport_maps_memdev;
+	cxl_cmd_new_get_partition;
+	cxl_cmd_partition_get_active_volatile_size;
+	cxl_cmd_partition_get_active_persistent_size;
+	cxl_cmd_partition_get_next_volatile_size;
+	cxl_cmd_partition_get_next_persistent_size;
 } LIBCXL_1;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index f483c308a8b5..7f3a562a7c8e 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -7,6 +7,7 @@
 #include <cxl/cxl_mem.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
+#include <util/size.h>
 
 #define CXL_EXPORT __attribute__ ((visibility("default")))
 
@@ -185,6 +186,15 @@ struct cxl_cmd_get_health_info {
 	le32 pmem_errors;
 } __attribute__((packed));
 
+struct cxl_cmd_get_partition {
+	le64 active_volatile;
+	le64 active_persistent;
+	le64 next_volatile;
+	le64 next_persistent;
+} __attribute__((packed));
+
+#define CXL_CAPACITY_MULTIPLIER		SZ_256M
+
 /* CXL 2.0 8.2.9.5.3 Byte 0 Health Status */
 #define CXL_CMD_HEALTH_INFO_STATUS_MAINTENANCE_NEEDED_MASK		BIT(0)
 #define CXL_CMD_HEALTH_INFO_STATUS_PERFORMANCE_DEGRADED_MASK		BIT(1)
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 3b2293bbee84..2c0a8d199f0a 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -242,6 +242,11 @@ ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd, void *buf,
 		unsigned int length);
 struct cxl_cmd *cxl_cmd_new_write_label(struct cxl_memdev *memdev,
 		void *buf, unsigned int offset, unsigned int length);
+struct cxl_cmd *cxl_cmd_new_get_partition(struct cxl_memdev *memdev);
+unsigned long long cxl_cmd_partition_get_active_volatile_size(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_partition_get_active_persistent_size(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_partition_get_next_volatile_size(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_partition_get_next_persistent_size(struct cxl_cmd *cmd);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/util/size.h b/util/size.h
index a0f3593df6b5..e72467f0f8b0 100644
--- a/util/size.h
+++ b/util/size.h
@@ -15,6 +15,7 @@
 #define SZ_4M     0x00400000
 #define SZ_16M    0x01000000
 #define SZ_64M    0x04000000
+#define SZ_256M	  0x10000000
 #define SZ_1G     0x40000000
 #define SZ_1T 0x10000000000ULL
 
-- 
2.31.1

