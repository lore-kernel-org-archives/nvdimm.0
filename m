Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347073FF4;
	Fri, 28 Jan 2022 00:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643329649; x=1674865649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CNc2RfHJQp8YCYBaAmfP7EjNqi6QM52sPg4WlCQ49+o=;
  b=EiArtpM5AUDYhvLHF2wDS1mpWncy6jcJCyIQX3woHuPkNMAy6rdZ/l0o
   4Syqu2xC/BY16anmH2FDh3NP7qdv5SboRc5BOAoFWcWefO3dlEPkd05EW
   HEx7QuHcP+m1pVh6iIotyPE+FSfRAwtL84qbFnT+bd4vLYPiB+trZdGa3
   LGHUFgg+aBG+iwDPNUZYxKRmjV+T1N5wWnY4douEHdHcqsf/WCeCDoIEW
   GNSvdm9+YjwX2LbVFzDPxlPW916FcvOEGakrpyP38sPxVUaB76UYcIijl
   XYLC4yYNA4x9YofIFpZ91AHoDGxNMYggFN9uf8jtTmzFiuYmWgfk7Kk56
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="226982080"
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="226982080"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:28 -0800
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="674909649"
Received: from vrao2-mobl1.gar.corp.intel.com (HELO localhost.localdomain) ([10.252.129.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:27 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org
Subject: [PATCH v3 10/14] cxl/region: Collect host bridge decoders
Date: Thu, 27 Jan 2022 16:27:03 -0800
Message-Id: <20220128002707.391076-11-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220128002707.391076-1-ben.widawsky@intel.com>
References: <20220128002707.391076-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Part of host bridge verification in the CXL Type 3 Memory Device
Software Guide calculates the host bridge interleave target list (6th
step in the flow chart), ie. verification and state update are done in
the same step. Host bridge verification is already in place, so go ahead
and store the decoders with their target lists.

Switches are implemented in a separate patch.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/region.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
index 145d7bb02714..b8982be13bfe 100644
--- a/drivers/cxl/region.c
+++ b/drivers/cxl/region.c
@@ -428,6 +428,7 @@ static bool region_hb_rp_config_valid(struct cxl_region *cxlr,
 		return simple_config(cxlr, hbs[0]);
 
 	for (i = 0; i < hb_count; i++) {
+		struct cxl_decoder *cxld;
 		int idx, position_mask;
 		struct cxl_dport *rp;
 		struct cxl_port *hb;
@@ -486,6 +487,18 @@ static bool region_hb_rp_config_valid(struct cxl_region *cxlr,
 						"One or more devices are not connected to the correct Host Bridge Root Port\n");
 					goto err;
 				}
+
+				if (!state_update)
+					continue;
+
+				if (dev_WARN_ONCE(&cxld->dev,
+						  port_grouping >= cxld->nr_targets,
+						  "Invalid port grouping %d/%d\n",
+						  port_grouping, cxld->nr_targets))
+					goto err;
+
+				cxld->interleave_ways++;
+				cxld->target[port_grouping] = get_rp(ep);
 			}
 		}
 	}
@@ -538,7 +551,7 @@ static bool rootd_valid(const struct cxl_region *cxlr,
 
 struct rootd_context {
 	const struct cxl_region *cxlr;
-	struct cxl_port *hbs[CXL_DECODER_MAX_INTERLEAVE];
+	const struct cxl_port *hbs[CXL_DECODER_MAX_INTERLEAVE];
 	int count;
 };
 
@@ -564,7 +577,7 @@ static struct cxl_decoder *find_rootd(const struct cxl_region *cxlr,
 	struct rootd_context ctx;
 	struct device *ret;
 
-	ctx.cxlr = cxlr;
+	ctx.cxlr = (struct cxl_region *)cxlr;
 
 	ret = device_find_child((struct device *)&root->dev, &ctx, rootd_match);
 	if (ret)
-- 
2.35.0

