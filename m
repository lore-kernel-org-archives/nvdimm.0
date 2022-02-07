Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BDB2C9C
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 23:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644275182; x=1675811182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F44UHN3rHqegtj2FoCEG5GqNLVnIuqt9mQoN6J5UurI=;
  b=Bw3U3POQ1uKCetpjU/pBq+7HZ1Yuv8y3kFMQtmpZWjVOcuQAUOVk/tWe
   tVKRJdIUjMqSf95WrivdXBILK5LLRvGcib6El5fv4ayOj4/YNJoUV4EN3
   CP+lAKu8dD5Nxh8VHUF33Hh0+hgZCRhde1PktgrPZrmV1hybLm18Pgque
   GeRYNBaxZNZx2PSufjKwsH0TV1Rg+dhz+FoUwDEihI1H/5O3izwi0C9G9
   9doG+eZ6Uix9pYm8cjIdaGtr3XuO9UowdA4GLo8iysxmq1tG0OUbZNAqZ
   PF2BwmQtaAvRaux75IbNfnEjMaFqOJOny8a7BZTT5Q4jjE/JJJcirEa1l
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="273351894"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="273351894"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 15:06:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="632639204"
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
Subject: [ndctl PATCH v4 3/6] libcxl: return the partition alignment field in bytes
Date: Mon,  7 Feb 2022 15:10:17 -0800
Message-Id: <fad634a7912265e87a8e7f3c3c9db21c1494d9ad.1644271559.git.alison.schofield@intel.com>
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

Per the CXL specification, the partition alignment field reports
the alignment value in multiples of 256MB. In the libcxl API, values
for all capacity fields are defined to return bytes.

Update the partition alignment accessor to return bytes so that it
is in sync with other capacity related fields.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/lib/libcxl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index e9d7762..307e5c4 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2306,7 +2306,7 @@ CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
 	if (cmd->status < 0)
 		return cmd->status;
 
-	return le64_to_cpu(id->partition_align);
+	return capacity_to_bytes(id->partition_align);
 }
 
 CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
-- 
2.31.1

