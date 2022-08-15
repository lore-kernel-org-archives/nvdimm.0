Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C66F5395
	for <nvdimm@lists.linux.dev>; Mon, 15 Aug 2022 19:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660591345; x=1692127345;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yYRPJ8O/nI5XLYfuqFzW+C2ugl+ImE/phG1tck5CQp0=;
  b=n2gomBjNLqchuMwH+WdTMcoJvcmq6eic9k7lzZPfsCoqOHmkMx5mq8fl
   x7xesWmQqCfCA8/SSgf/wmz/SR+nQwh+89jjSA5Te5NTxcx/A9JNmffmV
   LlT/vgmaskv0ittJ21L+PeO37tkQEx2rWzLXqOaWnRSLJC5eI//wxKXT/
   Tdk3+mICOfy04y+ahzplJT7XKwgDtaP1yPPjHM8p8+SqcvBLhn6t2ciXz
   9huv0Cx7oO7IdLLyW731T3cDgtkq8fGTAuBH7IOOjMlrhXJU32mFCm6HS
   dtXM8hmc6ktyONBP3AhNFI3vsWcuFfElLDATL969eSt9S3n+cbUfhD0sX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="292038727"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="292038727"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:21 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="606758264"
Received: from smadiset-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.5.99])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:21 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 09/11] cxl/list: make memdevs and regions the default listing
Date: Mon, 15 Aug 2022 13:22:12 -0600
Message-Id: <20220815192214.545800-10-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220815192214.545800-1-vishal.l.verma@intel.com>
References: <20220815192214.545800-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1039; h=from:subject; bh=yYRPJ8O/nI5XLYfuqFzW+C2ugl+ImE/phG1tck5CQp0=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm/5jx7cK5bfeUdwWf5jRGysYe1xS/ueyJ2kKOMbZnLdb2k Gfb8HaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiI4lVGhiVnG3f1aaS1RWyfsvTgTy 6Lz4wSvJ0NL2c+SAw85aplbcvI8Pev9/aOWdM6Ww/MipPW/uB2zvRbYPJcg/J0qQKuPTP/MAAA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Instead of only listing regions by default (which can often be empty if
no regions have been configured), change the default listing mode to
both memdevs and regions. This will allow a plain 'cxl-list' to be a
quick health check of whether all the expected memdevs have enumerated
correctly, and see any regions that have been configured.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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
2.37.1

