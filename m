Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4196362
	for <nvdimm@lists.linux.dev>; Wed,  1 Jun 2022 00:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654042195; x=1685578195;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KbUFUKa0xNNrwnWIg7wRXELbPC4TrapU+Kx1YFcXwGE=;
  b=dcONkxLx7jVcwQJ33ROKlkaypA8PAYKXWlm3hgSAIYIsyb7lM1gYvUI4
   xizVsH7EYqsF/fV5zqt5Z1xBA4qSTfFOdnAC4eJ2SBA4VMP0P547F0sHe
   Bah6DJASPbT/mB3ne7amtOTJBIXnYHk9NPg1rgUkFGDXMfBUnzRbAVb1U
   NmYRAgjfAbMJLDesr3IX6XpPJU1+SjQSzA7Ij9ts1nOvdcyOMhGHLL8e9
   RfqcgpD+i/oTfurkQknPeG/pcaNy3qeWa0cZKoLTs/++kaYe1bErt0ROy
   gxsIGEgn/ESECynrEhWqlpcKkQQnT588+WSJSdjCbDRYROWPKECrfgUVE
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="275431169"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="275431169"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 17:09:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="562554678"
Received: from weesiong-mobl.amr.corp.intel.com (HELO [192.168.1.137]) ([10.209.41.108])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 17:09:55 -0700
Subject: [PATCH] nvdimm: Fix badblocks clear off-by-one error
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: stable@vger.kernel.org, Chris Ye <chris.ye@intel.com>
Date: Tue, 31 May 2022 17:09:54 -0700
Message-ID: <165404219489.2445897.9792886413715690399.stgit@dwillia2-xfh>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Chris Ye <chris.ye@intel.com>

nvdimm_clear_badblocks_region() validates badblock clearing requests
against the span of the region, however it compares the inclusive
badblock request range to the exclusive region range. Fix up the
off-by-one error.

Fixes: 23f498448362 ("libnvdimm: rework region badblocks clearing")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Ye <chris.ye@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 7b0d1443217a..5db16857b80e 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -182,8 +182,8 @@ static int nvdimm_clear_badblocks_region(struct device *dev, void *data)
 	ndr_end = nd_region->ndr_start + nd_region->ndr_size - 1;
 
 	/* make sure we are in the region */
-	if (ctx->phys < nd_region->ndr_start
-			|| (ctx->phys + ctx->cleared) > ndr_end)
+	if (ctx->phys < nd_region->ndr_start ||
+	    (ctx->phys + ctx->cleared - 1) > ndr_end)
 		return 0;
 
 	sector = (ctx->phys - nd_region->ndr_start) / 512;

