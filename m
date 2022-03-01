Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA4C17E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 02:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646102957; x=1677638957;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xBvxSz2YU+OsRHmlwREZP7FJC9naWNMR23kWinHs1ws=;
  b=GOJHpmGc/4QV48tyaXrO24/lFRxwEzhwa0GnCn0POADDZkw6hBit/W+3
   BPF2SPgMB09VYbV8p31/qbLO7Db1p6myf0gFYpvy6YYbc0NFQYz1pIWSY
   rmmQHnCMBZEpnk4aHZkxEAtUO1fs12KoDWs+BCYcvZxpDN+f9Q9+NsnPi
   k//NTJi7yOdlI4cUb9rR2jdYNHnG7XELFrXi9fTNSLEb6HkVn7kfIsQfC
   slIqR/8LDOh2bsC2MPp6pVqyNGVxoOs26C1S4+tjfq+Ui5e8tHrYZdws+
   jRnwLCCq4evZo/pRIFklVtZrsjAc6Ev7tgC3+n80jgnH3azvfzl80JqBt
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="236550265"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="236550265"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:17 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="641105483"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:17 -0800
Subject: [PATCH 05/11] cxl/core: Introduce cxl_set_lock_class()
From: Dan Williams <dan.j.williams@intel.com>
To: gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com
Cc: Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Ben Widawsky <ben.widawsky@intel.com>, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Mon, 28 Feb 2022 18:49:17 -0800
Message-ID: <164610295699.2682974.3646198829625502263.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Update CONFIG_PROVE_CXL_LOCKING to use the common device-core helpers
for device_lock validation.

When CONFIG_PROVE_LOCKING is enabled and device_set_lock_class() is
passed a non-zero lock class the core acquires the 'struct device'
@lockdep_mutex everywhere it acquires the device_lock. Where
lockdep_mutex does not skip lockdep validation like device_lock.

cxl_set_lock_class() wraps device_set_lock_class() as to not collide
with other subsystems that may also support this lockdep validation
scheme. See the 'choice' for the various CONFIG_PROVE_$SUBSYS_LOCKING
options in lib/Kconfig.debug.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/memdev.c |    1 +
 drivers/cxl/core/pmem.c   |    2 ++
 drivers/cxl/core/port.c   |    2 ++
 drivers/cxl/core/region.c |    1 +
 drivers/cxl/cxl.h         |    9 +++++++++
 5 files changed, 15 insertions(+)

diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 1f76b28f9826..ad8c9f61c38a 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -343,6 +343,7 @@ struct cxl_memdev *devm_cxl_add_memdev(struct cxl_dev_state *cxlds)
 	cxlmd->cxlds = cxlds;
 
 	cdev = &cxlmd->cdev;
+	cxl_set_lock_class(dev);
 	rc = cdev_device_add(cdev, dev);
 	if (rc)
 		goto err;
diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index c3d7e6ce3fdf..e0bdda788b01 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -171,6 +171,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
 	if (rc)
 		goto err;
 
+	cxl_set_lock_class(dev);
 	rc = device_add(dev);
 	if (rc)
 		goto err;
@@ -283,6 +284,7 @@ int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
 	if (rc)
 		goto err;
 
+	cxl_set_lock_class(dev);
 	rc = device_add(dev);
 	if (rc)
 		goto err;
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 44006d8eb64d..5eee7de1c7f9 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -507,6 +507,7 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 	if (rc)
 		goto err;
 
+	cxl_set_lock_class(dev);
 	rc = device_add(dev);
 	if (rc)
 		goto err;
@@ -1389,6 +1390,7 @@ int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
 	if (is_root_decoder(dev))
 		cxld->platform_res.name = dev_name(dev);
 
+	cxl_set_lock_class(dev);
 	return device_add(dev);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_decoder_add_locked, CXL);
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index b1a4ba622739..f0a821de94cf 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -476,6 +476,7 @@ int cxl_add_region(struct cxl_decoder *cxld, struct cxl_region *cxlr)
 	if (rc)
 		goto err;
 
+	cxl_set_lock_class(dev);
 	rc = device_add(dev);
 	if (rc)
 		goto err;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 1357a245037d..f94eff659cce 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -543,5 +543,14 @@ static inline int cxl_lock_class(struct device *dev)
 	else
 		return CXL_ANON_LOCK;
 }
+
+static inline void cxl_set_lock_class(struct device *dev)
+{
+	device_set_lock_class(dev, cxl_lock_class(dev));
+}
+#else
+static inline void cxl_set_lock_class(struct device *dev)
+{
+}
 #endif
 #endif /* __CXL_H__ */

