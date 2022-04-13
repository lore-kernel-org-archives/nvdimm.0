Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF9923CA
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829716; x=1681365716;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iZkEJiezDzZSvDLuQ4QlHaZeACSH7DvqyONtGcXuk/g=;
  b=Vu+sVrjX/nZZaD4lDok8hO5jKe4UaTK4yTTBeEQYp1H/4XyqOm0Rko4B
   WquZfZuAZ+TeZJjCSgSWTj3BWYevMf1SyVVQrvXPeDrl5DmfWWGNWZm11
   Lya62pmAFCHnXXE2AtlShyGg9Wuocz/2hVSwPXGe4Q74wnKd2CIkv4s6I
   IwOWtUn2xQ1US7HZDqH3FMs4VWe6gDnnyFeEOx0/r/yxKaOPzllCHq0e8
   26CpGNZX0Fb78Xxk8kQ5iabrikcIgqx1/Rwsf31FHakWK6YeLAJoviYRN
   fdhTOYXWHzOGlxEYuoUi9rT3lIbn1mikbkGsW2vqeIsBC6JIRxzMvIzgi
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="262763107"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="262763107"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:01:55 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="724768554"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:01:55 -0700
Subject: [PATCH v2 05/12] cxl/core: Clamp max lock_class
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Ben Widawsky <ben.widawsky@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, peterz@infradead.org,
 gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:01:55 -0700
Message-ID: <164982971542.684294.12980151056534955888.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

MAX_LOCKDEP_SUBCLASSES limits the depth of the CXL topology that can be
validated by lockdep. Given that the cxl_test topology is already at
this limit collapse some of the levels and clamp the max depth.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/cxl.h |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index a6c1a027e389..b86aac8cde4f 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -410,20 +410,37 @@ enum cxl_lock_class {
 	CXL_ANON_LOCK,
 	CXL_NVDIMM_LOCK,
 	CXL_NVDIMM_BRIDGE_LOCK,
-	CXL_PORT_LOCK,
+	/*
+	 * Collapse the compatible port and nvdimm-bridge lock classes
+	 * to save space
+	 */
+	CXL_PORT_LOCK = CXL_NVDIMM_BRIDGE_LOCK,
 	/*
 	 * Be careful to add new lock classes here, CXL_PORT_LOCK is
 	 * extended by the port depth, so a maximum CXL port topology
-	 * depth would need to be defined first.
+	 * depth would need to be defined first. Also, the max
+	 * validation depth is limited by MAX_LOCKDEP_SUBCLASSES.
 	 */
 };
 
+static inline int clamp_lock_class(struct device *dev, int lock_class)
+{
+	if (lock_class >= MAX_LOCKDEP_SUBCLASSES) {
+		dev_warn_once(dev,
+			      "depth: %d, disabling lockdep for this device\n",
+			      lock_class);
+		return -1;
+	}
+
+	return lock_class;
+}
+
 static inline int cxl_lock_class(struct device *dev)
 {
 	if (is_cxl_port(dev)) {
 		struct cxl_port *port = to_cxl_port(dev);
 
-		return CXL_PORT_LOCK + port->depth;
+		return clamp_lock_class(dev, CXL_PORT_LOCK + port->depth);
 	} else if (is_cxl_decoder(dev)) {
 		struct cxl_port *port = to_cxl_port(dev->parent);
 
@@ -431,7 +448,7 @@ static inline int cxl_lock_class(struct device *dev)
 		 * A decoder is the immediate child of a port, so set
 		 * its lock class equal to other child device siblings.
 		 */
-		return CXL_PORT_LOCK + port->depth + 1;
+		return clamp_lock_class(dev, CXL_PORT_LOCK + port->depth + 1);
 	} else if (is_cxl_nvdimm_bridge(dev))
 		return CXL_NVDIMM_BRIDGE_LOCK;
 	else if (is_cxl_nvdimm(dev))

