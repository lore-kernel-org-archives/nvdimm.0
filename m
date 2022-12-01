Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C1410782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 22:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669932205; x=1701468205;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G87j60lcFOm0XsAJRAjlLp3GM7+SMlxSvtRmCcnF0xk=;
  b=RwF2EIAqmzuYcQW8ZCW0467v8A+629B4bTcIFa7y3oBjzN7L7OECfH2Y
   AZ34g7iszzec+L1D+IoLkHAN9DHgaVoc9NE6JSW91dfWJJlqtUtxJup11
   ifpnQVDw3TqwEU15bGvXyE55NfOPXfORDsF6qd1j48P/pJQt7ta86aykc
   zOLP7/G0fmzi1KamOsaUmukmwwzsRhGUM4HsRSksfUY1H/i+iMSzRSvXJ
   xDy5GCMQuIgJWskaKvUP5FcRielM+FMP19q+9JG1oEL1m/v3hUJYC5F3T
   eWH0tXuHV49h+4bZC/EIhyWDNFVOcPs1tRSuMZLio1GIkqSb1tIqgZZE3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="295503657"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="295503657"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638545015"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="638545015"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:24 -0800
Subject: [PATCH 2/5] cxl/region: Fix missing probe failure
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: stable@vger.kernel.org, Jonathan.Cameron@huawei.com, dave.jiang@intel.com,
 nvdimm@lists.linux.dev, dave@stgolabs.net
Date: Thu, 01 Dec 2022 14:03:24 -0800
Message-ID: <166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

cxl_region_probe() allows for regions not in the 'commit' state to be
enabled. Fail probe when the region is not committed otherwise the
kernel may indicate that an address range is active when none of the
decoders are active.

Fixes: 8d48817df6ac ("cxl/region: Add region driver boiler plate")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/region.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index f9ae5ad284ff..1bc2ebefa2a5 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1923,6 +1923,9 @@ static int cxl_region_probe(struct device *dev)
 	 */
 	up_read(&cxl_region_rwsem);
 
+	if (rc)
+		return rc;
+
 	switch (cxlr->mode) {
 	case CXL_DECODER_PMEM:
 		return devm_cxl_add_pmem_region(cxlr);

