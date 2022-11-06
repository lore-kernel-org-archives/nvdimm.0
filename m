Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95323D500
	for <nvdimm@lists.linux.dev>; Sun,  6 Nov 2022 23:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667778476; x=1699314476;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ELT0+xvIisPQWkCqrQz9cMzSAP++RyuBgUCuYPEldoc=;
  b=RiN5tjFXP93olACSUO8BF9D9oS+2Q07VZecX7cj3aj/EoMgwM+gmGT7n
   weM8/irK0hxClFayFky1fnc+G+zh/8ltBm8FOWem/96/jv+O8/bKXJ50g
   eGQJhXmG2YXcUuO9+UT8HCnI0hgfGX7D4axTdHsGoEgJIXN2iVq3P75K8
   4QqW/D11eKX9sTWuhBABmzvC4p96TtJDScC/CzXKuvR+pORzdA2No28gj
   81puhYvqoNwQI+yjmQFefUpxUizbTxD/IEX7oQZnn5qO/vam0beqDhR9K
   Gi5v5ganESNTjTvs3pt/7+clxqvvuuc7Wg0PGcb3hKyGARgVmTUF+LtvI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="307916125"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="307916125"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="704674844"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="704674844"
Received: from durgasin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.240.219])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:55 -0800
Subject: [ndctl PATCH 12/15] cxl/region: Trim region size by max available
 extent
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 06 Nov 2022 15:47:55 -0800
Message-ID: <166777847500.1238089.17251605673776696142.stgit@dwillia2-xfh.jf.intel.com>
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

When a size is not specified, limit the size to either the available DPA
capacity, or the max available extent in the root decoder, whichever is
smaller.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/region.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/cxl/region.c b/cxl/region.c
index e47709754447..aa0735194fa1 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -502,6 +502,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	unsigned long flags = UTIL_JSON_TARGETS;
 	struct json_object *jregion;
 	struct cxl_region *region;
+	bool default_size = true;
 	int i, rc, granularity;
 	u64 size, max_extent;
 	const char *devname;
@@ -513,6 +514,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 
 	if (p->size) {
 		size = p->size;
+		default_size = false;
 	} else if (p->ep_min_size) {
 		size = p->ep_min_size * p->ways;
 	} else {
@@ -525,13 +527,16 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 			cxl_decoder_get_devname(p->root_decoder));
 		return -EINVAL;
 	}
-	if (size > max_extent) {
+	if (!default_size && size > max_extent) {
 		log_err(&rl,
 			"%s: region size %#lx exceeds max available space\n",
 			cxl_decoder_get_devname(p->root_decoder), size);
 		return -ENOSPC;
 	}
 
+	if (size > max_extent)
+		size = ALIGN_DOWN(max_extent, SZ_256M * p->ways);
+
 	if (p->mode == CXL_DECODER_MODE_PMEM) {
 		region = cxl_decoder_create_pmem_region(p->root_decoder);
 		if (!region) {

