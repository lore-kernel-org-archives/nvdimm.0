Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D424297
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 23:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646349221; x=1677885221;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DRQdFyElA80+qPAK8IG/OfNWctGX694ZCsj0FOiMiB0=;
  b=h8ZVbCgvbR7rv6Rj64t4uO11pG+SFafwofjzGyAqXLwOcdkifx3CwqdX
   aN3YOU0fQZLrOV4JwZ83EIlHBGzMFaMESQNTmRgMbeGthMLWU7nHy4O7i
   j0WqitEVAbo+Hm+So9pixp6ef2XKT1KAC45jemZBND1+dPMoCGyplpm9Y
   amiJydrJEKPHaXASSCa7Hwrm9P/0Cj6QD0OCHvjmrI1RZRc8zMzoEgacs
   xkthZ7Cyt1blWAQI2SmXpnmzI//xUZGtIkJdPbtnMizI1ZIvGb5Wou1ou
   6l3QGJJvkeYFIqmDvPTwoLP0Qd778IQfLOPqWS8HxwQW5PFX115bpCUCu
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="251417780"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="251417780"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 15:13:40 -0800
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="810011922"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 15:13:40 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [ndctl PATCH] libcxl: Remove extraneous NULL checks when validating cmd status
Date: Thu,  3 Mar 2022 15:16:57 -0800
Message-Id: <20220303231657.1053594-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

When a cxl_cmd_new_*() function is executed the returned command
pointer is always checked for NULL. Remove extraneous NULL checks
later in the command validation path.

Coverity pointed these out as 'check_after_deref' issues.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/lib/libcxl.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index daa2bbc5a299..f111d8681669 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2283,8 +2283,6 @@ cmd_to_identify(struct cxl_cmd *cmd)
 	if (cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_IDENTIFY))
 		return NULL;
 
-	if (!cmd)
-		return NULL;
 	return cmd->output_payload;
 }
 
@@ -2429,8 +2427,6 @@ cmd_to_get_partition(struct cxl_cmd *cmd)
 	if (cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_GET_PARTITION_INFO))
 		return NULL;
 
-	if (!cmd)
-		return NULL;
 	return cmd->output_payload;
 }
 

base-commit: 3b5fb8b6428dfaab39bab58d67412427f514c1f4
-- 
2.31.1

