Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2D23D4
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829741; x=1681365741;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WeXGisg3F5xd5CDMy9xUZA6jIDX7Clw9WAukSk7hrxY=;
  b=kTCeSE/5XAvigLUqn+HFbYs89/RWl/ultYr/2T/8Ll+LzFsUw51Tqgjx
   ctl9GmrQP5Sfn4B2jeBECFUbq1g8Y0Vx1p8C9bNK+928NjKYWuJHg7B78
   GExqhhFDPT46uU1z7fq3Ri6CGR5jzFQzUwM++L4CqIsJOn5TiWR59zRoc
   17Vgh4PgxF32Cn1sSonNj9bmY1EV3DyDaQmqgE5n90GUKpMEaRtYObXZI
   Vx13dTD+uGFGQxo23goHEQBYTvtPlod8cGRyJs0OhhqoDXpZ5EaSIC4ZB
   DXrVp4RZGbrgpb+HF0IPuOQMYgrqD7vk1fjuHehE3U+zpPulXiEATgj6C
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="262335017"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="262335017"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="623559249"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:01:44 -0700
Subject: [PATCH v2 03/12] cxl/core: Refactor a cxl_lock_class() out of
 cxl_nested_lock()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Dave Jiang <dave.jiang@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 peterz@infradead.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:01:44 -0700
Message-ID: <164982970436.684294.12004091884213856239.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for upleveling device_lock() lockdep annotation support into
the core, provide a helper to retrieve the lock class. This lock_class
will be used with device_set_lock_class() to identify the CXL nested
locking rules.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/cxl.h |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 990b6670222e..c9fda9304c54 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -418,13 +418,12 @@ enum cxl_lock_class {
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
 
@@ -432,14 +431,18 @@ static inline void cxl_nested_lock(struct device *dev)
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

