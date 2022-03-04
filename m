Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546B07C
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 20:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646426825; x=1677962825;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ict0jxzPJmapZnhPCTB+x92+MWtPTodSWIzHBKCsT9k=;
  b=LGcnLQOOyxxPV441P8BnaS7Ojzs6HqkYzip5929SNricnARHosTg71G1
   A6Wjm3gYTVjTD1Mfq1bcX7K3/edDjzzUPJchnzXecAPSJqAZkFwjrzeAg
   clpGvX4ZXMAzHBNri+U07aOlrzQ8nO2YCVa/PB0Uw9MjjTO+TK/YcBbLI
   Tmt0mOQVijKUnTeRlw2LMiqhLO2mRKE0VtoSm/NNBsFpCL/7mhHZRLzV1
   +EoSBlt62kVmEMi9Q5Fo7Zu4kd05xG8KxpSgY+DgBI3wNwA6olWwBGvwZ
   2ZwvtawxqnuzzsyMyPROYDsXrVYdeQSHRJpXQLTok1aESB5MsdvsbdKo0
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="252888186"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="252888186"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 12:47:04 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="509093700"
Received: from fushengl-mobl1.amr.corp.intel.com (HELO localhost) ([10.212.64.239])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 12:47:04 -0800
From: ira.weiny@intel.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] fs/dax: Fix missing kdoc for dax_device
Date: Fri,  4 Mar 2022 12:46:55 -0800
Message-Id: <20220304204655.3489216-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

struct dax_device has a member named ops which was undocumented.

Add the kdoc.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/dax/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 5c003cc73d04..2fd3a01ba34b 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -22,6 +22,7 @@
  * @cdev: optional character interface for "device dax"
  * @private: dax driver private data
  * @flags: state and boolean properties
+ * @ops: operations for this device
  */
 struct dax_device {
 	struct inode inode;
-- 
2.35.1

