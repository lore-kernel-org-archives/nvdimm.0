Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9832CA5
	for <nvdimm@lists.linux.dev>; Tue, 18 Jan 2022 20:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642537231; x=1674073231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rXeIZWlZ4MaR5SiTd9P5N37auWUvFhOUNkOo5BEkuak=;
  b=S9q8JuKHqMYJKLQyXWnD7O9WKwnsyw/lLh5U0HffCoSuq2Sapjgb8GYl
   RbX0P8RFvsKc2MnLZPiD7DqCJU5kM50hYsMPnTKZy35his3Ejjhp0veIl
   MxXn7Fbeo1KB9cFAIEU7c3at60QX3WF30N3E0dzo7oKDJ2102vJbd75Sa
   art9YGxonuslt9+8IlhFyFSQsIfSgVBifoHYZm6StVKf/UNkV+WUjRwsZ
   1yvW0vDMC8ldOVqMiDqJ0hP2I400Gdvj1qS0AKsEyNYmBb/ITiF7evKq+
   oOQRRJaXSJLFRN+j1+wBy8648aWkGOYWeIlruUzeXEIB6T8KshpSOyzXg
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="331259485"
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="331259485"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 12:20:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="671953854"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 12:20:30 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v3 2/6] libcxl: add accessors for capacity fields of the IDENTIFY command
Date: Tue, 18 Jan 2022 12:25:11 -0800
Message-Id: <55800f227e4d72f90fcdd49affb352fe4386f628.1642535478.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1642535478.git.alison.schofield@intel.com>
References: <cover.1642535478.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Users need access to a few additional fields reported by the IDENTIFY
mailbox command: total, volatile_only, and persistent_only capacities.
These values are useful when defining partition layouts.

Add accessors to the libcxl API to retrieve these values from the
IDENTIFY command.

The fields are specified in multiples of 256MB per the CXL 2.0 spec.
Use the capacity multiplier to convert the raw data into bytes for user
consumption.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/lib/libcxl.c   | 29 +++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  3 +++
 cxl/libcxl.h       |  3 +++
 3 files changed, 35 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 58181c0..1fd584a 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1105,6 +1105,35 @@ CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
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
+cxl_cmd_identify_get_total_bytes(struct cxl_cmd *cmd)
+{
+	cmd_identify_get_capacity_field(cmd, total_capacity);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_identify_get_volatile_only_bytes(struct cxl_cmd *cmd)
+{
+	cmd_identify_get_capacity_field(cmd, volatile_capacity);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_identify_get_persistent_only_bytes(struct cxl_cmd *cmd)
+{
+	cmd_identify_get_capacity_field(cmd, persistent_capacity);
+}
+
 CXL_EXPORT struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev,
 		int opcode)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index e019c3c..b7e969f 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -31,6 +31,9 @@ global:
 	cxl_cmd_get_out_size;
 	cxl_cmd_new_identify;
 	cxl_cmd_identify_get_fw_rev;
+	cxl_cmd_identify_get_total_bytes;
+	cxl_cmd_identify_get_volatile_only_bytes;
+	cxl_cmd_identify_get_persistent_only_bytes;
 	cxl_cmd_identify_get_partition_align;
 	cxl_cmd_identify_get_label_size;
 	cxl_cmd_new_get_health_info;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 08fd840..46f99fb 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -68,6 +68,9 @@ int cxl_cmd_get_mbox_status(struct cxl_cmd *cmd);
 int cxl_cmd_get_out_size(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
 int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
+unsigned long long cxl_cmd_identify_get_total_bytes(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_identify_get_volatile_only_bytes(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_identify_get_persistent_only_bytes(struct cxl_cmd *cmd);
 unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
 unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_get_health_info(struct cxl_memdev *memdev);
-- 
2.31.1

