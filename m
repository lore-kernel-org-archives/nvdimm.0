Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B4623A7;
	Fri, 24 Jun 2022 04:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656044414; x=1687580414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kf9CFFgXOGWToq/1lPLAO9HeAEErdsvWCZKaBOcE9Vo=;
  b=W5H/iDy64gZmVGYNvw1bb8hiYEcw5qH7w2bkFbwopMmFnzs6+ChC9Cu/
   s3CDqAGjo+qPrJmOL2yiCKi9Tox0deli6/BQVsfQywRLNob+gQ6iaQUnE
   ixb41EsuSu2biigV0/5i/E7ILCmQPSzHYKZBiTdnmLYmC3p+ewnt2WdU/
   bPB3j6C8ROmQdkmupTiTibZvnh5wsiNJAQUGXqTrWS2ywbVAP55lNYCEh
   2W1ma7tGnXcuOW7vGj6lEnhZ79mii1r3WlCA6p0AMN75oD2ActctNm+rs
   TXdZLfCnpWZZIf9FZLHOU6RuO3uXqnx183pB83wbeKrz2x087wrGKz9mP
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344912792"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344912792"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:11 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="645092916"
Received: from daharell-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.intel.com) ([10.209.66.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:10 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org,
	patches@lists.linux.dev,
	hch@lst.de,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 31/46] cxl/hdm: Initialize decoder type for memory expander devices
Date: Thu, 23 Jun 2022 21:19:35 -0700
Message-Id: <20220624041950.559155-6-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unless and until accelerator (type-2) drivers start registering for
CXL.mem mapping services from the CXL subsystem core, initialize idle
HDM decoders to the "expander" type. I.e. the only CXL devices using the
CXL core presently are those implementing the CXL 2.0 Type-3 memory
expander device class code that the cxl_pci driver claims.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/hdm.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 672bf3e97811..7b58f6911523 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -474,6 +474,17 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 		cxld->flags |= CXL_DECODER_F_ENABLE;
 		if (ctrl & CXL_HDM_DECODER0_CTRL_LOCK)
 			cxld->flags |= CXL_DECODER_F_LOCK;
+		if (FIELD_GET(CXL_HDM_DECODER0_CTRL_TYPE, ctrl))
+			cxld->target_type = CXL_DECODER_EXPANDER;
+		else
+			cxld->target_type = CXL_DECODER_ACCELERATOR;
+	} else {
+		/* unless / until type-2 drivers arrive, assume type-3 */
+		if (FIELD_GET(CXL_HDM_DECODER0_CTRL_TYPE, ctrl) == 0) {
+			ctrl |= CXL_HDM_DECODER0_CTRL_TYPE;
+			writel(ctrl, hdm + CXL_HDM_DECODER0_CTRL_OFFSET(which));
+		}
+		cxld->target_type = CXL_DECODER_EXPANDER;
 	}
 	rc = cxl_to_ways(FIELD_GET(CXL_HDM_DECODER0_CTRL_IW_MASK, ctrl),
 			 &cxld->interleave_ways);
@@ -488,11 +499,6 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 	if (rc)
 		return rc;
 
-	if (FIELD_GET(CXL_HDM_DECODER0_CTRL_TYPE, ctrl))
-		cxld->target_type = CXL_DECODER_EXPANDER;
-	else
-		cxld->target_type = CXL_DECODER_ACCELERATOR;
-
 	if (!cxled) {
 		target_list.value =
 			ioread64_hi_lo(hdm + CXL_HDM_DECODER0_TL_LOW(which));
-- 
2.36.1

