Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE6A23CA
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829739; x=1681365739;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=71SXlL7E70/JQd0lNPz9C9v0IgR6KTTs4c9CnrGttxc=;
  b=FoxYLUkG/CJxQjsyx7Erep9GdMOI59QMWYRAOvH9f3tNR+kcMLOdClQC
   K2Y+IvK2S7ZomAQqG6qvXKh4ZtBv4iNq/cylOmypSM9NRGk6LVg4JWfzF
   xw0aUkmz/OszxMVpB+i56efiOz3aFkN6a01kWfCjr3CMe1jT7gdfz+RUL
   3ySmkmxuqt6YwXynXEYMxfl6Y+uP3MuonzDtkfwfsRWALd4Qv6tuntDsR
   cFt24185JsoZseoZQeCN0EUnmQaIcRQW0MkcukYycDrtyQZdmVuiBdy1S
   so7vSXfW6zVZ56eVSH/9w8n5dIlO9U/2nTmcqDf8vlUUx2PVtf5wdBuPT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="262334996"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="262334996"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:00 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="507854405"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:00 -0700
Subject: [PATCH v2 06/12] cxl/core: Use dev->lock_class for device_lock()
 lockdep validation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Ben Widawsky <ben.widawsky@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, peterz@infradead.org,
 gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:02:00 -0700
Message-ID: <164982972055.684294.1452258386098745666.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Update CONFIG_PROVE_CXL_LOCKING to use the common device-core helpers
for device_lock validation.

When CONFIG_PROVE_LOCKING is enabled, and device_set_lock_class() is
passed a non-zero lock class , the core acquires the 'struct device'
@lockdep_mutex everywhere it acquires the device_lock. Where
lockdep_mutex does not skip lockdep validation like device_lock.

cxl_set_lock_class() arranges to turn off CXL lock validation depending
on the value of CONFIG_PROVE_CXL_LOCKING, which is a Kconfig 'choice'
between the all subsystems that want to use dev->lockdep_mutex for
lockdep validation. For now, that 'choice' is just between the NVDIMM
and CXL subsystems.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/memdev.c |    1 +
 drivers/cxl/core/pmem.c   |    2 ++
 drivers/cxl/core/port.c   |    2 ++
 drivers/cxl/cxl.h         |    9 +++++++++
 4 files changed, 14 insertions(+)

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
index 60f71caa5dbd..b0eb0b795140 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -165,6 +165,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
 	if (rc)
 		goto err;
 
+	cxl_set_lock_class(dev);
 	rc = device_add(dev);
 	if (rc)
 		goto err;
@@ -261,6 +262,7 @@ int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
 	if (rc)
 		goto err;
 
+	cxl_set_lock_class(dev);
 	rc = device_add(dev);
 	if (rc)
 		goto err;
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 437e8a71e5dc..eb450397104b 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -469,6 +469,7 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 	if (rc)
 		goto err;
 
+	cxl_set_lock_class(dev);
 	rc = device_add(dev);
 	if (rc)
 		goto err;
@@ -1349,6 +1350,7 @@ int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
 	if (is_root_decoder(dev))
 		cxld->platform_res.name = dev_name(dev);
 
+	cxl_set_lock_class(dev);
 	return device_add(dev);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_decoder_add_locked, CXL);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index b86aac8cde4f..fddbcb380e84 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -456,5 +456,14 @@ static inline int cxl_lock_class(struct device *dev)
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

