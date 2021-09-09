Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0997E72
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 05:12:27 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="284384376"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="284384376"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:12:27 -0700
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="466239050"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:12:27 -0700
Subject: [PATCH v4 10/21] cxl/pci: Drop idr.h
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, ben.widawsky@intel.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, Jonathan.Cameron@huawei.com
Date: Wed, 08 Sep 2021 22:12:26 -0700
Message-ID: <163116434668.2460985.12264757586266849616.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Commit 3d135db51024 ("cxl/core: Move memdev management to core") left
this straggling include for cxl_memdev setup. Clean it up.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/pci.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index e2f27671c6b2..9d8050fdd69c 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -8,7 +8,6 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/cdev.h>
-#include <linux/idr.h>
 #include <linux/pci.h>
 #include <linux/io.h>
 #include <linux/io-64-nonatomic-lo-hi.h>

