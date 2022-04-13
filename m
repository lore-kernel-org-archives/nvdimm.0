Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6A723D2
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829746; x=1681365746;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=faqWslrqMKaVyC0Fx4CcmYrY8vRuemnJ7TWhZUeAea8=;
  b=aeZxg+kwMgXsWpv7eIHdo8rpe3K+a88ZOtOZEOgyA/6l/rZm4aCNiPRB
   DSHlLDvqukmkQDNbHP/5/3Yq0eNqLnr9gYFrZ36Q1Bols2L3OZaDfcpjO
   /UBsPKmTstlAGQ2E66GIvC9cgit7Z5FPvbVasX+Vj9/piRZbSRZPQCbId
   5ZzxniirD819p3GGf587KZrrdb62A6Gf7gaA2ftzYWyX0l+6IiU+ehzX8
   Fhl5WY6mnzgkk2RzxBaLTBahtN6pswqXlycNClDCY2Klq8n0S5veyoj9z
   3xsAzuklPstpDOluz3uP097KyVZj6Oq+oF3poapeXIR1DIxXtQ3gNgUbE
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="325489898"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="325489898"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="590632349"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:10 -0700
Subject: [PATCH v2 08/12] libnvdimm: Refactor an nvdimm_lock_class() helper
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, peterz@infradead.org,
 alison.schofield@intel.com, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:02:10 -0700
Message-ID: <164982973080.684294.10727665061649724835.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for moving to the device-core device_lock lockdep
validation, refactor an nvdimm_lock_class() helper to be used with
device_set_lock_class().

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/nd-core.h |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 448f9dcb4bb7..deb3d047571e 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -174,22 +174,27 @@ enum {
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

