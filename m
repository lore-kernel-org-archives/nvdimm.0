Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC5D17E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 02:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646102968; x=1677638968;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WSASaml+/DezX9y2ikDtAn54SMESZKM5xL0R4lEghco=;
  b=IFcXJqSC/34THnkfvN48HWLDESm8965xknZNHD2SUUjlxPz154mOBWJ1
   a2XutaZmmMZ+zHJk4MnUmKf8SfLkCXfkqgTlUX3VgjD55V3zwjheshVwd
   4mCiQdyEqojjEKQ9f7yg4HoBtBSinCDzoe+lT+ohBc+vYN2vhe2SYNQqv
   2MTJoXRCZ3SE6l5vJAzYA0crzYhaMnwVASunzTmWqb4JpG8bfZ6JJZVnl
   WXG/Tnf4E+OFkE6GBAY9859QezGRK4l+DRQDUHU7F10bze7TFtH7AfYXZ
   PYlwejT09foisUfSMa8K9XosZNrG+a27wC6UXO5zf873EvuQxAhVgzLQH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="233659258"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="233659258"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:27 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="507645876"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:27 -0800
Subject: [PATCH 07/11] libnvdimm: Refactor an nvdimm_lock_class() helper
From: Dan Williams <dan.j.williams@intel.com>
To: gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, alison.schofield@intel.com,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Mon, 28 Feb 2022 18:49:27 -0800
Message-ID: <164610296761.2682974.11157102809606978208.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for moving to the device-core device_lock lockdep
validation, refactor an nvdimm_lock_class() helper to be used with
device_set_lock_class().

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/nd-core.h |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 2650a852eeaf..772568ffb9d6 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -197,22 +197,27 @@ enum {
 	LOCK_CLAIM,
 };
 
-static inline void debug_nvdimm_lock(struct device *dev)
+static inline int nvdimm_lock_class(struct device *dev)
 {
 	if (is_nd_region(dev))
-		mutex_lock_nested(&dev->lockdep_mutex, LOCK_REGION);
+		return LOCK_REGION;
 	else if (is_nvdimm(dev))
-		mutex_lock_nested(&dev->lockdep_mutex, LOCK_DIMM);
+		return LOCK_DIMM;
 	else if (is_nd_btt(dev) || is_nd_pfn(dev) || is_nd_dax(dev))
-		mutex_lock_nested(&dev->lockdep_mutex, LOCK_CLAIM);
+		return LOCK_CLAIM;
 	else if (dev->parent && (is_nd_region(dev->parent)))
-		mutex_lock_nested(&dev->lockdep_mutex, LOCK_NAMESPACE);
+		return LOCK_NAMESPACE;
 	else if (is_nvdimm_bus(dev))
-		mutex_lock_nested(&dev->lockdep_mutex, LOCK_BUS);
+		return LOCK_BUS;
 	else if (dev->class && dev->class == nd_class)
-		mutex_lock_nested(&dev->lockdep_mutex, LOCK_NDCTL);
+		return LOCK_NDCTL;
 	else
-		dev_WARN(dev, "unknown lock level\n");
+		return -1;
+}
+
+static inline void debug_nvdimm_lock(struct device *dev)
+{
+	mutex_lock_nested(&dev->lockdep_mutex, nvdimm_lock_class(dev));
 }
 
 static inline void debug_nvdimm_unlock(struct device *dev)

