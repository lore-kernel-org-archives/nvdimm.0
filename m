Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542C12CA9
	for <nvdimm@lists.linux.dev>; Wed, 12 Jan 2022 06:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641968916; x=1673504916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X4vyc81ks1FKetNmznAiO7ACwvf7cWXdvPd/K5QQq90=;
  b=NjtCOBMZgESdeCrTeKd06hhmEGpre+em20+UqnGiJGN+7+hBpgjwXP2G
   QamqgKXAjGYDPQfKquL/49OTLcWnpPtXLNdyjQWy/uX2Kq+CSEZlMXYho
   ZTrsfYDkCVaix1YQ8fghWLYw4jkYRNN4nTwxCFOwSxRTd3MZ7rkUsHzFJ
   ekAykZCh0gTlBWK8osT0O7Wv5n3x+XUW5xyJf/TOmvXpQk+RTUOoV5cBr
   WUSZG/j5531ytHggmz7rwS/O3ZtWxc99E0CvlTYRJ9tLL2UjM2C396Tbs
   11JrjF78YFH44uy2znMtUB2jvsGTWmXxEmmREPYQtyiyJ8Q9Ccn7eI5OO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="304407181"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="304407181"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 22:28:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="529051354"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 22:28:33 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 3/6] libcxl: return the partition alignment field in bytes
Date: Tue, 11 Jan 2022 22:33:31 -0800
Message-Id: <ca1821eee9f8e2372e378165d5c24bbf9161e6fe.1641965853.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1641965853.git.alison.schofield@intel.com>
References: <cover.1641965853.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Per the CXL specification, the partition alignment field reports
the alignment value in multiples of 256MB. In the libcxl API, values
for all capacity fields are defined to return bytes.

Update the partition alignment accessor to return bytes so that it
is in sync with other capacity related fields.

Rename the function to reflect the new return value:
cxl_cmd_identify_get_partition_align_bytes()

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/lib/libcxl.c   | 4 ++--
 cxl/lib/libcxl.sym | 2 +-
 cxl/libcxl.h       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 1fd584a..823bcb0 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1078,7 +1078,7 @@ CXL_EXPORT int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev,
 	return 0;
 }
 
-CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
+CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align_bytes(
 		struct cxl_cmd *cmd)
 {
 	struct cxl_cmd_identify *id =
@@ -1089,7 +1089,7 @@ CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
 	if (cmd->status < 0)
 		return cmd->status;
 
-	return le64_to_cpu(id->partition_align);
+	return le64_to_cpu(id->partition_align) * CXL_CAPACITY_MULTIPLIER;
 }
 
 CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index b7e969f..1e2cf05 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -34,7 +34,7 @@ global:
 	cxl_cmd_identify_get_total_bytes;
 	cxl_cmd_identify_get_volatile_only_bytes;
 	cxl_cmd_identify_get_persistent_only_bytes;
-	cxl_cmd_identify_get_partition_align;
+	cxl_cmd_identify_get_partition_align_bytes;
 	cxl_cmd_identify_get_label_size;
 	cxl_cmd_new_get_health_info;
 	cxl_cmd_health_info_get_maintenance_needed;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 46f99fb..f19ed4f 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -71,7 +71,7 @@ int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
 unsigned long long cxl_cmd_identify_get_total_bytes(struct cxl_cmd *cmd);
 unsigned long long cxl_cmd_identify_get_volatile_only_bytes(struct cxl_cmd *cmd);
 unsigned long long cxl_cmd_identify_get_persistent_only_bytes(struct cxl_cmd *cmd);
-unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_identify_get_partition_align_bytes(struct cxl_cmd *cmd);
 unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_get_health_info(struct cxl_memdev *memdev);
 int cxl_cmd_health_info_get_maintenance_needed(struct cxl_cmd *cmd);
-- 
2.31.1

