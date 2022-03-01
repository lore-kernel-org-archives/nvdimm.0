Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8734417E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 02:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646102941; x=1677638941;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6h6XOuo1KBYcSCELn/W7UA4CZHnFX+nOTaNEQAzs5/U=;
  b=LKzoxkuv6MI9Vk5malreqPEFQpcV282vPbZNX95QgcrMygtAULMgVDLv
   QwSgNAL3/od0Pi8BjFPgl4cF+Ep+VUttoZHAzkcMVzPT0L5w7txZAkLsc
   dpQ1TQjPK74u9fAfxiZdYcyzERN5HofB/JH1xnOyK13R8/9MrX+vm7MQt
   t+drvyFZaOuPJFNnPRA6uh9cxLgegH0PUXpBBaFMAyFqFNsAlDnOjXJex
   xtUBaFGqSaJCSzloCSw2Aihkjre/lORQSKlh/rnUP80f7cGpjHExqyY/G
   7a7vMFs8K6jgNHZXiRp0Nu5Cr9E0knQ1wYGVw4C6izuFWEXX6BEHi/1pe
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="236550197"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="236550197"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:01 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="685560474"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:00 -0800
Subject: [PATCH 02/11] cxl/core: Refactor a cxl_lock_class() out of
 cxl_nested_lock()
From: Dan Williams <dan.j.williams@intel.com>
To: gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com
Cc: Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Ben Widawsky <ben.widawsky@intel.com>, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Mon, 28 Feb 2022 18:49:00 -0800
Message-ID: <164610294030.2682974.642590821548098371.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for upleveling device_lock() lockdep annotation support into
the core, provide a helper to retrieve the lock class. This lock_class
will be used with device_set_lock_class() to idenify the CXL nested
locking rules.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/cxl.h |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 5486fb6aebd4..ca8a61a623b7 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -509,13 +509,12 @@ enum cxl_lock_class {
 	 */
 };
 
-static inline void cxl_nested_lock(struct device *dev)
+static inline int cxl_lock_class(struct device *dev)
 {
 	if (is_cxl_port(dev)) {
 		struct cxl_port *port = to_cxl_port(dev);
 
-		mutex_lock_nested(&dev->lockdep_mutex,
-				  CXL_PORT_LOCK + port->depth);
+		return CXL_PORT_LOCK + port->depth;
 	} else if (is_cxl_decoder(dev)) {
 		struct cxl_port *port = to_cxl_port(dev->parent);
 
@@ -523,14 +522,18 @@ static inline void cxl_nested_lock(struct device *dev)
 		 * A decoder is the immediate child of a port, so set
 		 * its lock class equal to other child device siblings.
 		 */
-		mutex_lock_nested(&dev->lockdep_mutex,
-				  CXL_PORT_LOCK + port->depth + 1);
+		return CXL_PORT_LOCK + port->depth + 1;
 	} else if (is_cxl_nvdimm_bridge(dev))
-		mutex_lock_nested(&dev->lockdep_mutex, CXL_NVDIMM_BRIDGE_LOCK);
+		return CXL_NVDIMM_BRIDGE_LOCK;
 	else if (is_cxl_nvdimm(dev))
-		mutex_lock_nested(&dev->lockdep_mutex, CXL_NVDIMM_LOCK);
+		return CXL_NVDIMM_LOCK;
 	else
-		mutex_lock_nested(&dev->lockdep_mutex, CXL_ANON_LOCK);
+		return CXL_ANON_LOCK;
+}
+
+static inline void cxl_nested_lock(struct device *dev)
+{
+	mutex_lock_nested(&dev->lockdep_mutex, cxl_lock_class(dev));
 }
 
 static inline void cxl_nested_unlock(struct device *dev)

