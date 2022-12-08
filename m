Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4497A460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534985; x=1702070985;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3OU1Zhr+kSFl/v9LDM+Jr3IzctANZ/iBrs+GWEVydZU=;
  b=V/yF1F2jgn2MYtbQMj+Itz3m0sH2T5jUCOiC4BCPO4PBHMVN2QscGQOW
   d4nUoSY6TCOhvJ/uWKQx60nmy6EJE6gGYSKgtN0GOfzQbjlOS8TfMBkMU
   wADfnAwGUgB3yluMxvYUuCTJpQJPLrB/JL2xqiLp06SPk70bVal/EMc9m
   Z5cL9Y4bMOaji333xZkbKAgO4pN5AfQJ12MAN2Ogg3R5Lh8Wwg+iyuswO
   dpq8pGGe4DGaEqV045RwcUCnHWVy3q/irf3kpLjJLcD4T4inZ/j/tLOBo
   LxejzlQBDoiJtdmymV1majVn18bdmN5JTTgbH20kSakKlBB5H15X+Zuys
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="344343321"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="344343321"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="647170307"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="647170307"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:44 -0800
Subject: [ndctl PATCH v2 18/18] cxl/test: Test single-port host-bridge
 region creation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Bobo WL <lmw.bobo@gmail.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Alison Schofield <alison.schofield@intel.com>, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:29:44 -0800
Message-ID: <167053498406.582963.2052790353158387141.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The original port decoder programming algorithm in the kernel failed to
acommodate the corner case of a passthrough port connected to a fan-out
port. Use the 5th cxl_test decoder to regression test this scenario.

Reported-by: Bobo WL <lmw.bobo@gmail.com>
Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: http://lore.kernel.org/r/20221010172057.00001559@huawei.com
Tested-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/cxl-create-region.sh |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index 82aad3a7285a..47aed44848ab 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -110,6 +110,34 @@ create_subregions()
 	done
 }
 
+create_single()
+{
+	# the 5th cxl_test decoder is expected to target a single-port
+	# host-bridge. Older cxl_test implementations may not define it,
+	# so skip the test in that case.
+	decoder=$($CXL list -b cxl_test -D -d root |
+		  jq -r ".[4] |
+		  select(.pmem_capable == true) |
+		  select(.nr_targets == 1) |
+		  .decoder")
+
+        if [[ ! $decoder ]]; then
+                echo "no single-port host-bridge decoder found, skipping"
+                return
+        fi
+
+	region=$($CXL create-region -d "$decoder" | jq -r ".region")
+	if [[ ! $region ]]; then
+		echo "failed to create single-port host-bridge region"
+		err "$LINENO"
+	fi
+
+	destroy_regions "$region"
+}
+
+# test region creation on devices behind a single-port host-bridge
+create_single
+
 # test reading labels directly through cxl-cli
 readarray -t mems < <("$CXL" list -b cxl_test -M | jq -r '.[].memdev')
 

