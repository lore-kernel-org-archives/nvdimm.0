Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649523FE4;
	Wed, 12 Jan 2022 23:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642031294; x=1673567294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NGhTlz6K842nSSifnB2cI703CM5Bl7Bq3y/bzctyC5Y=;
  b=fdVF1wS2sUd96ky7Y3vTIrYDsXPh92QlRd0eBxsEY9ONLeRruA9C2dDM
   14kML9vhC1FjOub08HhQzbZ1WBFsCk77xkWIY6gNcyx6Jk1S5DtH4xOH7
   v7pHWh7DYbYDIRgSygjVHFvhE4se5ZxEPWcKQZeJtwO6uM9PdfNYu5VxP
   QTFnphN1xWLk+8cjWZMn8FgHzlQbC+bZ3SGNi7KiANeLoqDzdONXVSqJH
   EoTHqhW1dYa5kqdB1uc84uAqqUKSYowhgRHpnhrELYXz7y491/apABKWN
   F0IjqKjXs3Q7Ox5eaOQ4PfkBk4CGPNiHQ86VzD+Jw25VKzv63dcpQRxYO
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="243673339"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="243673339"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:48:13 -0800
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="670324219"
Received: from jmaclean-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.136.131])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:48:12 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 14/15] cxl/pmem: Convert nvdimm bridge API to use memdev
Date: Wed, 12 Jan 2022 15:47:48 -0800
Message-Id: <20220112234749.1965960-15-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220112234749.1965960-1-ben.widawsky@intel.com>
References: <20220112234749.1965960-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cxl_pmem driver specific cxl_nvdimm structure isn't a suitable
parameter for an exported API that can be used by other drivers.
Instead, use a memdev structure, which should be woven into any caller
using this API.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/pmem.c | 3 +--
 drivers/cxl/cxl.h       | 2 +-
 drivers/cxl/pmem.c      | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index f21e5ce9619a..bfcf51fbda5d 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -62,9 +62,8 @@ static int match_nvdimm_bridge(struct device *dev, void *data)
 	return is_cxl_nvdimm_bridge(dev);
 }
 
-struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd)
+struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_memdev *cxlmd)
 {
-	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
 	struct cxl_port *port;
 	struct device *dev;
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 1130165dfc8d..6f9cabb77c08 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -433,7 +433,7 @@ struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm_bridge(struct device *dev);
 int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
-struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd);
+struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_memdev *cxlmd);
 
 /*
  * Unit test builds overrides this to __weak, find the 'strong' version
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index b65a272a2d6d..420ace433a01 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -39,7 +39,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 	struct nvdimm *nvdimm;
 	int rc;
 
-	cxl_nvb = cxl_find_nvdimm_bridge(cxl_nvd);
+	cxl_nvb = cxl_find_nvdimm_bridge(cxl_nvd->cxlmd);
 	if (!cxl_nvb)
 		return -ENXIO;
 
-- 
2.34.1

