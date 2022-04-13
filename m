Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B9323AD;
	Wed, 13 Apr 2022 18:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875090; x=1681411090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9JmB6oJKPBBDOztp/9A53kUt0HnYQkAsrrNo+Sut5u0=;
  b=WDK14tT7Uk3Knm4zUL8vpuFVJGonlK3WOJC3k9UTlhLxk/l0aR8tRxhU
   p19YMHBYSzp15gzhyMBNm5hGkNmyJAlMtADpoxlRnX3shGr8c7Szn9RJH
   /ktu6hSP2R9D1MnpS/GASaSC718jIQtdUOfHmrxAl6u9tTRPc00O+pEAb
   y3Xt4Up/U0qTrwKFjIsnfOPEzS+IotEva+knmX4tVHb3n5zPpRErLb9dY
   UPiLRvvPXWQqMomSnkHPvmGZuX8gMFD81+vk7eV0MayACx4sWIAHB22yw
   zl27XX3qswQgUImPqSx1aK2aoG+L6M+i+8q5xeOnZuGNCDXWkV1sjG7aV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631839"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631839"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013569"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:47 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 02/15] cxl/core/hdm: Bail on endpoint init fail
Date: Wed, 13 Apr 2022 11:37:07 -0700
Message-Id: <20220413183720.2444089-3-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413183720.2444089-1-ben.widawsky@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Endpoint decoder enumeration is the only way in which we can determine
Device Physical Address (DPA) -> Host Physical Address (HPA) mappings.
Information is obtained only when the register state can be read
sequentially. If when enumerating the decoders a failure occurs, all
other decoders must also fail since the decoders can no longer be
accurately managed (unless it's the last decoder in which case it can
still work).

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/hdm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index bfc8ee876278..c3c021b54079 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -255,6 +255,8 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 				      cxlhdm->regs.hdm_decoder, i);
 		if (rc) {
 			put_device(&cxld->dev);
+			if (is_endpoint_decoder(&cxld->dev))
+				return rc;
 			failed++;
 			continue;
 		}
-- 
2.35.1

