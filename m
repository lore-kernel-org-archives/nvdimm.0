Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F5F7C
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 20:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646426307; x=1677962307;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Qs3a6PKS/vw255yCbjn82naIiLf6goziVSIh6w6iGzQ=;
  b=BSWOvMw82E4N27P9ZYG1cnNznJYFK70Vz77x/OIhfSGCpCQdqedMLg8o
   38m14SRZfn3y/uRjoSSNpWPLXTdqeUfwwAX3HPijKDSJj+6237PMZl8ok
   RxM9r/s9aqSzeSkA9gSn51Ujszyki+iuy0RmuYI/Wr7JxI/KMMWuKMKqG
   t09C9NEn6jgEA4UVuAAevY8j+S/ktEyjKOxWGQ+Ot+EPvCwF1+KlvbkKr
   FgyFq+DUohr+5ulBdN2IJDuHaAs7bWzElEf29KteEgTliPv78ml5WGHbf
   BM2BNktw0vQnaTalpugHbbDvSKHYAXjCTemw1cIqHvdnat0FF/E/x6fQO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="317290878"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="317290878"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 12:38:26 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="536399443"
Received: from fushengl-mobl1.amr.corp.intel.com (HELO localhost) ([10.212.64.239])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 12:38:26 -0800
From: ira.weiny@intel.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] fs/dax: Fix run_dax() missing prototype
Date: Fri,  4 Mar 2022 12:37:56 -0800
Message-Id: <20220304203756.3487910-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

The function run_dax() was missing a prototype when compiling with
warnings.

Add bus.h to fix this.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/dax/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e3029389d809..5c003cc73d04 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -14,6 +14,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include "dax-private.h"
+#include "bus.h"
 
 /**
  * struct dax_device - anchor object for dax services
-- 
2.35.1

