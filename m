Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE0C2C9E
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 20:44:58 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233253833"
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="233253833"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:55 -0800
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="504579073"
Received: from dmamols-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.255.92.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:54 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v5 08/16] libcxl: add support for the 'GET_LSA' command
Date: Thu, 11 Nov 2021 13:44:28 -0700
Message-Id: <20211111204436.1560365-9-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211111204436.1560365-1-vishal.l.verma@intel.com>
References: <20211111204436.1560365-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3271; h=from:subject; bh=KL+mZb/zTiKx0Spl2aV2/6zZdLHYRRCkqbfwDH+X9po=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm9DZumeC35xbm6nM1g1cKuCq3K2lr/L/fEUvqP60Xa7Hk5 52dvRykLgxgHg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACZy+xojw5UlRo4cHV1sT5tWVi1KTL MSW/qjWvHR5J3nLh/tnO6z1ovhn2kka6hw8oeDzYe/u8kmhC5RD3+6rnCL2Jtl3mcP2bw35QQA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a command allocator and accessor APIs for the 'GET_LSA' mailbox
command.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |  5 +++++
 cxl/lib/libcxl.c   | 36 ++++++++++++++++++++++++++++++++++++
 cxl/libcxl.h       |  4 ++++
 cxl/lib/libcxl.sym |  2 ++
 4 files changed, 47 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 885553a..bf3a897 100644
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
index 065824d..76913a2 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1036,6 +1036,42 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev,
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
+	get_lsa = (struct cxl_cmd_get_lsa_in *)cmd->send_cmd->in.payload;
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
+	get_lsa = (struct cxl_cmd_get_lsa_in *)cmd->send_cmd->in.payload;
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
index eae2db8..7408745 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -95,6 +95,10 @@ int cxl_cmd_health_info_get_temperature(struct cxl_cmd *cmd);
 int cxl_cmd_health_info_get_dirty_shutdowns(struct cxl_cmd *cmd);
 int cxl_cmd_health_info_get_volatile_errors(struct cxl_cmd *cmd);
 int cxl_cmd_health_info_get_pmem_errors(struct cxl_cmd *cmd);
+struct cxl_cmd *cxl_cmd_new_read_label(struct cxl_memdev *memdev,
+		unsigned int offset, unsigned int length);
+ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd, void *buf,
+		unsigned int length);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index c83bc28..629322c 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -62,6 +62,8 @@ global:
 	cxl_cmd_health_info_get_dirty_shutdowns;
 	cxl_cmd_health_info_get_volatile_errors;
 	cxl_cmd_health_info_get_pmem_errors;
+	cxl_cmd_new_read_label;
+	cxl_cmd_read_label_get_payload;
 local:
         *;
 };
-- 
2.31.1

