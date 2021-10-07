Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7906E2CA1
	for <nvdimm@lists.linux.dev>; Thu,  7 Oct 2021 08:21:59 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="249511719"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="249511719"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:56 -0700
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="568555106"
Received: from abishekh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.239])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:55 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v4 08/17] libcxl: add support for the 'GET_LSA' command
Date: Thu,  7 Oct 2021 02:21:30 -0600
Message-Id: <20211007082139.3088615-9-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007082139.3088615-1-vishal.l.verma@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3486; h=from:subject; bh=NOjkKSxbO8LZPpUkhr+5X0xQgtDPlNALdDgNMdYJ/nk=; b=owGbwMvMwCHGf25diOft7jLG02pJDIlx69izrMwyVeRcbt08v2DtqeeTY4wuRZSqTtm3p+DBt5nt K29md5SyMIhxMMiKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAinocZ/nvMdN9by+u/sKybO+CR1L ZVJbsC/kxu+5NRaqY1+2XREm9Ghi8fn3WmZ6sfCr7LKmu9I8vD3vFXUbeIoHjJreqZyrXsPAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a command allocator and accessor APIs for the 'GET_LSA' mailbox
command.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |  5 +++++
 cxl/lib/libcxl.c   | 36 ++++++++++++++++++++++++++++++++++++
 cxl/libcxl.h       |  7 +++----
 cxl/lib/libcxl.sym |  4 ++--
 4 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index f76b518..9c6317b 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -73,6 +73,11 @@ struct cxl_cmd_identify {
 	u8 qos_telemetry_caps;
 } __attribute__((packed));
 
+struct cxl_cmd_get_lsa_in {
+	le32 offset;
+	le32 length;
+} __attribute__((packed));
+
 struct cxl_cmd_get_health_info {
 	u8 health_status;
 	u8 media_status;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 413be9c..33cc462 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1028,6 +1028,42 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev,
 	return cmd;
 }
 
+CXL_EXPORT struct cxl_cmd *cxl_cmd_new_read_label(struct cxl_memdev *memdev,
+		unsigned int offset, unsigned int length)
+{
+	struct cxl_cmd_get_lsa_in *get_lsa;
+	struct cxl_cmd *cmd;
+
+	cmd = cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_GET_LSA);
+	if (!cmd)
+		return NULL;
+
+	get_lsa = (void *)cmd->send_cmd->in.payload;
+	get_lsa->offset = cpu_to_le32(offset);
+	get_lsa->length = cpu_to_le32(length);
+	return cmd;
+}
+
+CXL_EXPORT ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd,
+		void *buf, unsigned int length)
+{
+	struct cxl_cmd_get_lsa_in *get_lsa;
+	void *payload;
+	int rc;
+
+	rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_GET_LSA);
+	if (rc)
+		return rc;
+
+	get_lsa = (void *)cmd->send_cmd->in.payload;
+	if (length > le32_to_cpu(get_lsa->length))
+		return -EINVAL;
+
+	payload = (void *)cmd->send_cmd->out.payload;
+	memcpy(buf, payload, length);
+	return length;
+}
+
 CXL_EXPORT int cxl_cmd_submit(struct cxl_cmd *cmd)
 {
 	struct cxl_memdev *memdev = cmd->memdev;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 68f5bc2..7408745 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -95,11 +95,10 @@ int cxl_cmd_health_info_get_temperature(struct cxl_cmd *cmd);
 int cxl_cmd_health_info_get_dirty_shutdowns(struct cxl_cmd *cmd);
 int cxl_cmd_health_info_get_volatile_errors(struct cxl_cmd *cmd);
 int cxl_cmd_health_info_get_pmem_errors(struct cxl_cmd *cmd);
-struct cxl_cmd *cxl_cmd_new_get_lsa(struct cxl_memdev *memdev,
+struct cxl_cmd *cxl_cmd_new_read_label(struct cxl_memdev *memdev,
 		unsigned int offset, unsigned int length);
-void *cxl_cmd_get_lsa_get_payload(struct cxl_cmd *cmd);
-struct cxl_cmd *cxl_cmd_new_set_lsa(struct cxl_memdev *memdev,
-		void *buf, unsigned int offset, unsigned int length);
+ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd, void *buf,
+		unsigned int length);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index b0a3047..1b608d8 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -72,6 +72,6 @@ global:
 	cxl_cmd_health_info_get_dirty_shutdowns;
 	cxl_cmd_health_info_get_volatile_errors;
 	cxl_cmd_health_info_get_pmem_errors;
-	cxl_cmd_new_get_lsa;
-	cxl_cmd_get_lsa_get_payload;
+	cxl_cmd_new_read_label;
+	cxl_cmd_read_label_get_payload;
 } LIBCXL_2;
-- 
2.31.1

