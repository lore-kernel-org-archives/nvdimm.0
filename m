Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452836D17
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843296; x=1689379296;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tkxgOqLN93njdIDOPSIv2OVwmPW6481uGNMLoC79dd4=;
  b=NahUZbp6hJsX+PHifcOrSCgNNPELl9atEVOCHsKWZHhnLRJwWLxWEPWL
   YW1xG4z8uqlAxZQOh9lnypl1wj00/wLCoVi27EnxWWk9oVTyhoNGGaFEm
   CGy1J+lHTkkjCystLguZA9JrJtJrXR79lwf8W2oMLyuaIJdIFPGOVM2aw
   fzrnpRTn2iRpDhnAgTWs6NJkxsb5gcxCA20QMAlojNC79W/BOPyAUnH2g
   32Xsnf5GESUF1+SZ5aLFavdRZnhSne4nfYK0OHy6C9L4QP45Zwk3TOaO6
   48RBoPrPQcr18RNnwy2F/BN/PKnHW2AY4MFnDuYaiCBEe0YbzEYw65rQP
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="371976927"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="371976927"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:01:29 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="698993528"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:01:28 -0700
Subject: [PATCH v2 08/28] cxl/hdm: Track next decoder to allocate
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: hch@lst.de, nvdimm@lists.linux.dev, linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:01:28 -0700
Message-ID: <165784328827.1758207.9627538529944559954.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The CXL specification enforces that endpoint decoders are committed in
hw instance id order. In preparation for adding dynamic DPA allocation,
record the hw instance id in endpoint decoders, and enforce allocations
to occur in hw instance id order.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/hdm.c  |   15 +++++++++++++++
 drivers/cxl/core/port.c |    1 +
 drivers/cxl/cxl.h       |    2 ++
 3 files changed, 18 insertions(+)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index acd46b0d69c6..582f48141767 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -160,6 +160,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_dpa_debug, CXL);
 static void __cxl_dpa_release(struct cxl_endpoint_decoder *cxled)
 {
 	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_port *port = cxled_to_port(cxled);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct resource *res = cxled->dpa_res;
 
@@ -171,6 +172,7 @@ static void __cxl_dpa_release(struct cxl_endpoint_decoder *cxled)
 	cxled->skip = 0;
 	__release_region(&cxlds->dpa_res, res->start, resource_size(res));
 	cxled->dpa_res = NULL;
+	port->hdm_end--;
 }
 
 static void cxl_dpa_release(void *cxled)
@@ -201,6 +203,18 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 		return -EBUSY;
 	}
 
+	if (port->hdm_end + 1 != cxled->cxld.id) {
+		/*
+		 * Assumes alloc and commit order is always in hardware instance
+		 * order per expectations from 8.2.5.12.20 Committing Decoder
+		 * Programming that enforce decoder[m] committed before
+		 * decoder[m+1] commit start.
+		 */
+		dev_dbg(dev, "decoder%d.%d: expected decoder%d.%d\n", port->id,
+			cxled->cxld.id, port->id, port->hdm_end + 1);
+		return -EBUSY;
+	}
+
 	if (skipped) {
 		res = __request_region(&cxlds->dpa_res, base - skipped, skipped,
 				       dev_name(&cxled->cxld.dev), 0);
@@ -233,6 +247,7 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 			cxled->cxld.id, cxled->dpa_res);
 		cxled->mode = CXL_DECODER_MIXED;
 	}
+	port->hdm_end++;
 
 	return 0;
 }
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 0ac5dcd612e0..109611318760 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -502,6 +502,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
 
 	port->component_reg_phys = component_reg_phys;
 	ida_init(&port->decoder_ida);
+	port->hdm_end = -1;
 	INIT_LIST_HEAD(&port->dports);
 	INIT_LIST_HEAD(&port->endpoints);
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 3e7363dde80f..70cd24e4f3ce 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -333,6 +333,7 @@ struct cxl_nvdimm {
  * @dports: cxl_dport instances referenced by decoders
  * @endpoints: cxl_ep instances, endpoints that are a descendant of this port
  * @decoder_ida: allocator for decoder ids
+ * @hdm_end: track last allocated HDM decoder instance for allocation ordering
  * @component_reg_phys: component register capability base address (optional)
  * @dead: last ep has been removed, force port re-creation
  * @depth: How deep this port is relative to the root. depth 0 is the root.
@@ -345,6 +346,7 @@ struct cxl_port {
 	struct list_head dports;
 	struct list_head endpoints;
 	struct ida decoder_ida;
+	int hdm_end;
 	resource_size_t component_reg_phys;
 	bool dead;
 	unsigned int depth;

