Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1C0D500
	for <nvdimm@lists.linux.dev>; Sun,  6 Nov 2022 23:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667778482; x=1699314482;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m3Y9wevBdrZle9FG1ih1WNj+BAi/g7XVzrgCeUPT/HA=;
  b=FXf3u24vuFIsFGzbCTLJtCRWQoWXpsuxsJdLEiqKiKPtxDFwYeXaLBoQ
   K7qV7FQc7ByztvTUF07WMy9iLlFCFWMHclnW9pQZGjoldJsFrU39MCVKp
   RRbbynYX7d3niOSpkwW41yt4BhBQOOuJaTzuuUmAUa2b+3B21Cvopmfkc
   PQph7K5GlW6gQVeXTE4t8qAR1lbxpZEoQpk4IUZWtqzaxLfi8Jt/Ydv5n
   R5xZM9QyPHq9Yi6yh8+A5nDM0hFpJ8Eg9WxG5dyZHHogWgn4gZJPmBWQK
   EOhyFgLZMyqiyNRRGmB29XhEi7BTw7uqWMdXwIPvAopgj6UW0ZBReySLp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="290680165"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="290680165"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:48:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="704674867"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="704674867"
Received: from durgasin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.240.219])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:48:01 -0800
Subject: [ndctl PATCH 13/15] cxl/region: Default to memdev mode for create
 with no arguments
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 06 Nov 2022 15:48:01 -0800
Message-ID: <166777848122.1238089.2150948506074701593.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Allow for:

   cxl create-region -d decoderX.Y

...to assume (-m -w $(count of memdevs beneath decoderX.Y))

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/region.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index aa0735194fa1..c0cf4ab350da 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -227,10 +227,13 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 	}
 
 	/*
-	 * For all practical purposes, -m is the default target type, but
-	 * hold off on actively making that decision until a second target
-	 * option is available.
+	 * For all practical purposes, -m is the default target type, but hold
+	 * off on actively making that decision until a second target option is
+	 * available. Unless there are no arguments then just assume memdevs.
 	 */
+	if (!count)
+		param.memdevs = true;
+
 	if (!param.memdevs) {
 		log_err(&rl,
 			"must specify option for target object types (-m)\n");
@@ -272,11 +275,8 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 		p->ways = count;
 		if (!validate_ways(p, count))
 			return -EINVAL;
-	} else {
-		log_err(&rl,
-			"couldn't determine interleave ways from options or arguments\n");
-		return -EINVAL;
-	}
+	} else
+		p->ways = p->num_memdevs;
 
 	if (param.granularity < INT_MAX) {
 		if (param.granularity <= 0) {

