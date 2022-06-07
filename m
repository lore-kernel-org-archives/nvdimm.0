Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAAF7F
	for <nvdimm@lists.linux.dev>; Tue,  7 Jun 2022 16:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654620580; x=1686156580;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ByfqHSUyr5zD+LfMcI0HbBfFVGYb2wsqtAn5SPC4XIA=;
  b=WtukaBzS4Fj4aSknsh04eo0nx3RhC1wdAJq/BVQLrdUoez8S/eOnvKl+
   ih8Bb/mK4fDZJWdVPqcX5A/X4I8RQjJDP4744UgPcTCJPXOek9uQu66ac
   KtThrz9Lchdq4CXzsI2vGx4slvGiAZXrjuI45rw2eYWAtDgbJvHelAdIM
   W2p+IcoiPxgx8cTURw7IKaB7w9Lll1U423Ue5nYH+d261gW1lrVtz1bQI
   0NWBr28ESXhuG6Ef+6Y6gQjU/g1xB1S2W38ed6y4UpT02nfnDtorUKIuN
   LLmjU4M2ck4NjzsY46n83Q1jn7mpYucfSUFVU6i9jL56uvFq57Si7bygy
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="363071883"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="363071883"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 09:49:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="565504289"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 07 Jun 2022 09:49:35 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id D4D65109; Tue,  7 Jun 2022 19:49:38 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v1 1/1] nvdimm/namespace: drop nested variable in create_namespace_pmem()
Date: Tue,  7 Jun 2022 19:49:37 +0300
Message-Id: <20220607164937.33967-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel build bot reported:

  namespace_devs.c:1991:10: warning: Local variable 'uuid' shadows outer variable [shadowVariable]

Refactor create_namespace_pmem() by dropping a nested version of
the same variable.

Fixes: d1c6e08e7503 ("libnvdimm/labels: Add uuid helpers")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nvdimm/namespace_devs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 0f863fda56e6..dfade66bab73 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1704,8 +1704,6 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 	res->flags = IORESOURCE_MEM;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
-		uuid_t uuid;
-
 		nsl_get_uuid(ndd, nd_label, &uuid);
 		if (has_uuid_at_pos(nd_region, &uuid, cookie, i))
 			continue;
-- 
2.35.1

