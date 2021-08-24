Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70713FC0
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:08:03 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="196918514"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="196918514"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:07:44 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="464484403"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:07:44 -0700
Subject: [PATCH v3 26/28] cxl/mbox: Move command definitions to common
 location
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:07:44 -0700
Message-ID: <162982126452.1124374.96436147395192046.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for cxl_test to mock responses to mailbox command
requests, move some definitions from core/mbox.c to cxlmem.h.

No functional changes intended.

Acked-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/mbox.c |   45 +++++--------------------------------
 drivers/cxl/cxlmem.h    |   57 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/pmem.c      |   11 ++-------
 3 files changed, 65 insertions(+), 48 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 6a5c4f3679ba..48a07cf2deb4 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -494,11 +494,7 @@ static int cxl_xfer_log(struct cxl_mem *cxlm, uuid_t *uuid, u32 size, u8 *out)
 
 	while (remaining) {
 		u32 xfer_size = min_t(u32, remaining, cxlm->payload_size);
-		struct cxl_mbox_get_log {
-			uuid_t uuid;
-			__le32 offset;
-			__le32 length;
-		} __packed log = {
+		struct cxl_mbox_get_log log = {
 			.uuid = *uuid,
 			.offset = cpu_to_le32(offset),
 			.length = cpu_to_le32(xfer_size)
@@ -529,14 +525,11 @@ static int cxl_xfer_log(struct cxl_mem *cxlm, uuid_t *uuid, u32 size, u8 *out)
  */
 static void cxl_walk_cel(struct cxl_mem *cxlm, size_t size, u8 *cel)
 {
-	struct cel_entry {
-		__le16 opcode;
-		__le16 effect;
-	} __packed * cel_entry;
+	struct cxl_cel_entry *cel_entry;
 	const int cel_entries = size / sizeof(*cel_entry);
 	int i;
 
-	cel_entry = (struct cel_entry *)cel;
+	cel_entry = (struct cxl_cel_entry *) cel;
 
 	for (i = 0; i < cel_entries; i++) {
 		u16 opcode = le16_to_cpu(cel_entry[i].opcode);
@@ -552,15 +545,6 @@ static void cxl_walk_cel(struct cxl_mem *cxlm, size_t size, u8 *cel)
 	}
 }
 
-struct cxl_mbox_get_supported_logs {
-	__le16 entries;
-	u8 rsvd[6];
-	struct gsl_entry {
-		uuid_t uuid;
-		__le32 size;
-	} __packed entry[];
-} __packed;
-
 static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
 {
 	struct cxl_mbox_get_supported_logs *ret;
@@ -587,10 +571,8 @@ enum {
 
 /* See CXL 2.0 Table 170. Get Log Input Payload */
 static const uuid_t log_uuid[] = {
-	[CEL_UUID] = UUID_INIT(0xda9c0b5, 0xbf41, 0x4b78, 0x8f, 0x79, 0x96,
-			       0xb1, 0x62, 0x3b, 0x3f, 0x17),
-	[VENDOR_DEBUG_UUID] = UUID_INIT(0xe1819d9, 0x11a9, 0x400c, 0x81, 0x1f,
-					0xd6, 0x07, 0x19, 0x40, 0x3d, 0x86),
+	[CEL_UUID] = DEFINE_CXL_CEL_UUID,
+	[VENDOR_DEBUG_UUID] = DEFINE_CXL_VENDOR_DEBUG_UUID,
 };
 
 /**
@@ -711,22 +693,7 @@ static int cxl_mem_get_partition_info(struct cxl_mem *cxlm)
 int cxl_mem_identify(struct cxl_mem *cxlm)
 {
 	/* See CXL 2.0 Table 175 Identify Memory Device Output Payload */
-	struct cxl_mbox_identify {
-		char fw_revision[0x10];
-		__le64 total_capacity;
-		__le64 volatile_capacity;
-		__le64 persistent_capacity;
-		__le64 partition_align;
-		__le16 info_event_log_size;
-		__le16 warning_event_log_size;
-		__le16 failure_event_log_size;
-		__le16 fatal_event_log_size;
-		__le32 lsa_size;
-		u8 poison_list_max_mer[3];
-		__le16 inject_poison_limit;
-		u8 poison_caps;
-		u8 qos_telemetry_caps;
-	} __packed id;
+	struct cxl_mbox_identify id;
 	int rc;
 
 	rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_IDENTIFY, NULL, 0, &id,
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 45d5347b5d61..811b24451604 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -161,6 +161,63 @@ enum cxl_opcode {
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
+#define DEFINE_CXL_CEL_UUID                                                    \
+	UUID_INIT(0xda9c0b5, 0xbf41, 0x4b78, 0x8f, 0x79, 0x96, 0xb1, 0x62,     \
+		  0x3b, 0x3f, 0x17)
+
+#define DEFINE_CXL_VENDOR_DEBUG_UUID                                           \
+	UUID_INIT(0xe1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
+		  0x40, 0x3d, 0x86)
+
+struct cxl_mbox_get_supported_logs {
+	__le16 entries;
+	u8 rsvd[6];
+	struct cxl_gsl_entry {
+		uuid_t uuid;
+		__le32 size;
+	} __packed entry[];
+}  __packed;
+
+struct cxl_cel_entry {
+	__le16 opcode;
+	__le16 effect;
+} __packed;
+
+struct cxl_mbox_get_log {
+	uuid_t uuid;
+	__le32 offset;
+	__le32 length;
+} __packed;
+
+/* See CXL 2.0 Table 175 Identify Memory Device Output Payload */
+struct cxl_mbox_identify {
+	char fw_revision[0x10];
+	__le64 total_capacity;
+	__le64 volatile_capacity;
+	__le64 persistent_capacity;
+	__le64 partition_align;
+	__le16 info_event_log_size;
+	__le16 warning_event_log_size;
+	__le16 failure_event_log_size;
+	__le16 fatal_event_log_size;
+	__le32 lsa_size;
+	u8 poison_list_max_mer[3];
+	__le16 inject_poison_limit;
+	u8 poison_caps;
+	u8 qos_telemetry_caps;
+} __packed;
+
+struct cxl_mbox_get_lsa {
+	u32 offset;
+	u32 length;
+} __packed;
+
+struct cxl_mbox_set_lsa {
+	u32 offset;
+	u32 reserved;
+	u8 data[];
+} __packed;
+
 /**
  * struct cxl_mem_command - Driver representation of a memory device command
  * @info: Command information as it exists for the UAPI
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 743e2d2fdbb5..a6be72a68960 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -97,10 +97,7 @@ static int cxl_pmem_get_config_data(struct cxl_mem *cxlm,
 				    struct nd_cmd_get_config_data_hdr *cmd,
 				    unsigned int buf_len, int *cmd_rc)
 {
-	struct cxl_mbox_get_lsa {
-		u32 offset;
-		u32 length;
-	} get_lsa;
+	struct cxl_mbox_get_lsa get_lsa;
 	int rc;
 
 	if (sizeof(*cmd) > buf_len)
@@ -126,11 +123,7 @@ static int cxl_pmem_set_config_data(struct cxl_mem *cxlm,
 				    struct nd_cmd_set_config_hdr *cmd,
 				    unsigned int buf_len, int *cmd_rc)
 {
-	struct cxl_mbox_set_lsa {
-		u32 offset;
-		u32 reserved;
-		u8 data[];
-	} *set_lsa;
+	struct cxl_mbox_set_lsa *set_lsa;
 	int rc;
 
 	if (sizeof(*cmd) > buf_len)

