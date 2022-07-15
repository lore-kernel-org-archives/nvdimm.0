Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B61F20F7
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 06:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657866374; x=1689402374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ec1UsofLsT2zBzMmelAJpaxsmG95QiYW6WxxL7sD3Wk=;
  b=Rk8YRA+Sd6/kf1v/UIVX5BJrR+xEEwi1cR9268CIIu+s94tE+6VlWsmL
   OrvENi1foVAzfGYU3+6oF9LMW5p9wyT5tgGWhcPpGfkM5LglunbUainGj
   Xwdf019yPU9xcdy9vlfLF4gH1WjWHe8hVSFXpV77Ddm+JU/LpL5CfrPGm
   17NlSAW/Hgc42mbb+BBxsi3s0f0wjP1h2MRLWkzgcHBeB2UlFeleKhNY/
   j0TzPBLZYKAJlA+KrS682ciWz18W3QMtjlTKlqiR8vOsKRRePoCrxsMpj
   Xc4/6obWvFuggiFTy5DbkD5gW/aV/yqaSRTqYvmQOHPpiSU1Qc8ta57F4
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="266125548"
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="266125548"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 23:26:13 -0700
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="546544634"
Received: from saseiper-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.71.32])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 23:26:12 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 8/8] cxl/list: make memdevs and regions the default listing
Date: Fri, 15 Jul 2022 00:25:50 -0600
Message-Id: <20220715062550.789736-9-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220715062550.789736-1-vishal.l.verma@intel.com>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=985; h=from:subject; bh=Ec1UsofLsT2zBzMmelAJpaxsmG95QiYW6WxxL7sD3Wk=; b=owGbwMvMwCXGf25diOft7jLG02pJDEkXOfIay+rvFuTq6XM01bqe9TjCcYj9kJrFXI6QxRJnZJum fvDvKGVhEONikBVTZPm75yPjMbnt+TyBCY4wc1iZQIYwcHEKwETSLjMy/HK5Z/YgdYLbv5j85iNps+ /t9Y6v6/d78rOyO5LDobHtJyPDvhU/S9NzOUyOL4s8FGI50fFDH9MW2zrd9Ttzs07MkTjADwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Instead of only listing regions by default (which can often be empty if
no regions have been configured), change the default listing mode to
both memdevs and regions. This will allow a plain 'cxl-list' to be a
quick health check of whether all the expected memdevs have enumerated
correctly, and see any regions that have been configured.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/list.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cxl/list.c b/cxl/list.c
index 88ca9d9..5f604ec 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -100,9 +100,10 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 			param.regions = true;
 	}
 
-	/* List regions by default */
+	/* List regions and memdevs by default */
 	if (num_list_flags() == 0) {
 		param.regions = true;
+		param.memdevs = true;
 	}
 
 	log_init(&param.ctx, "cxl list", "CXL_LIST_LOG");
-- 
2.36.1

