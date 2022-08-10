Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C914A06
	for <nvdimm@lists.linux.dev>; Wed, 10 Aug 2022 23:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660172975; x=1691708975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yYRPJ8O/nI5XLYfuqFzW+C2ugl+ImE/phG1tck5CQp0=;
  b=HzUHjUu3Yi9o00eKCm4xyfXoGU1BLziGr3BkWpeEBjIP+G53Lp8E56hw
   t0BG4JpGCk4qjQBYeWaHP2lPr5vaYCC+WyQ+QiTv/zi7BsZLmc0Xbv96N
   bKhXcmPuhtsY99ukyvefQeoHfupaJ1+7wwDj+pY3N77mhPeLmREAdkog3
   yJ5w63H/n7JiOqf2Ed6FE0EoUBqxTOonZvy3PTK1x6StM6ctbd+YTJ9ST
   3xHl78sa8h0ilpfd1JEB+CjPC31FCA4YrMk6NMOSAO85AjLEfDSdBbRJW
   FYYtZUGkB0Z5G/YvwobO7MrLuVtp2RzQflxwZFlrdjwjNYuy9GXeumK/b
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="377506180"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="377506180"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 16:09:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="581429455"
Received: from maughenb-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.94.5])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 16:09:34 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 08/10] cxl/list: make memdevs and regions the default listing
Date: Wed, 10 Aug 2022 17:09:12 -0600
Message-Id: <20220810230914.549611-9-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810230914.549611-1-vishal.l.verma@intel.com>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1039; h=from:subject; bh=yYRPJ8O/nI5XLYfuqFzW+C2ugl+ImE/phG1tck5CQp0=; b=owGbwMvMwCXGf25diOft7jLG02pJDElfrGY+ONetvvKO4LP8xgjZ2MPa4hf3PRE7yFHGtszlul7S DHv+jlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEwk7CrDP/11LlGiwT8PWW3bvZP77w Zp0wivTzr97eE53wxXLMqUOM3IcFI+Pu6e84049zl5svzzKydvZOAQOjZDo/muT62DZb0IPwA=
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

