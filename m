Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5794717E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 02:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646102947; x=1677638947;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I2OFBbygNRQGBO74DammV/3EkKdTLDNqydRcC46ubas=;
  b=E+gFQZurs5d5sDwOWufNH2ILwc1Vt9xUo76n2QpymR+UEBAiKGhNcyDx
   +fk+R4Uf8LVtufGAB5nxL95v48JRrVnEabHfWt1WWvXQxvwb8rhowUboe
   2wvBO73NJ0loSGipSkZ8mDdZq6oaqECrc6e5yBN1mz14z+Ardyvv+Ww7l
   odhFGCSNNm0Faph+cv88AiglZmh35YvkZ038srBdTDAIPoRKEkEp39/nF
   T4TcZUeFinL0AB+g0r5m0EogdGAep9smgrwRoOF8EfH97HFa9pErCB3C0
   cnjfcsiwS52RQPSpoe5KtZRLzlF7vbLFQ7JjcS+v7wz3eqWE7EAvx3ik4
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="253232833"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="253232833"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:06 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="685560509"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:06 -0800
Subject: [PATCH 03/11] cxl/core: Remove cxl_device_lock()
From: Dan Williams <dan.j.williams@intel.com>
To: gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com
Cc: Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Ben Widawsky <ben.widawsky@intel.com>, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Mon, 28 Feb 2022 18:49:06 -0800
Message-ID: <164610294604.2682974.11169622387063183603.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for moving lockdep_mutex nested lock acquisition into the
core, remove the cxl_device_lock() wrapper, but preserve
cxl_lock_class() that will be used to inform the core of the subsystem's
lock ordering rules.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/pmem.c |    4 ++--
 drivers/cxl/core/port.c |   50 ++++++++++++++++++++++-------------------------
 drivers/cxl/cxl.h       |   46 -------------------------------------------
 drivers/cxl/mem.c       |    4 ++--
 drivers/cxl/pmem.c      |   12 ++++++-----
 lib/Kconfig.debug       |    2 +-
 6 files changed, 34 insertions(+), 84 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 58dc6fba3130..c3d7e6ce3fdf 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -127,10 +127,10 @@ static void unregister_nvb(void *_cxl_nvb)
 	 * work to flush. Once the state has been changed to 'dead' then no new
 	 * work can be queued by user-triggered bind.
 	 */
-	cxl_device_lock(&cxl_nvb->dev);
+	device_lock(&cxl_nvb->dev);
 	flush = cxl_nvb->state != CXL_NVB_NEW;
 	cxl_nvb->state = CXL_NVB_DEAD;
-	cxl_device_unlock(&cxl_nvb->dev);
+	device_unlock(&cxl_nvb->dev);
 
 	/*
 	 * Even though the device core will trigger device_release_driver()
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index d48d44e911c1..44006d8eb64d 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -350,10 +350,10 @@ static void cxl_port_release(struct device *dev)
 	struct cxl_port *port = to_cxl_port(dev);
 	struct cxl_ep *ep, *_e;
 
-	cxl_device_lock(dev);
+	device_lock(dev);
 	list_for_each_entry_safe(ep, _e, &port->endpoints, list)
 		cxl_ep_release(ep);
-	cxl_device_unlock(dev);
+	device_unlock(dev);
 	ida_free(&cxl_port_ida, port->id);
 	kfree(port);
 }
@@ -592,7 +592,7 @@ static int match_root_child(struct device *dev, const void *match)
 		return 0;
 
 	port = to_cxl_port(dev);
-	cxl_device_lock(dev);
+	device_lock(dev);
 	list_for_each_entry(dport, &port->dports, list) {
 		iter = match;
 		while (iter) {
@@ -602,7 +602,7 @@ static int match_root_child(struct device *dev, const void *match)
 		}
 	}
 out:
-	cxl_device_unlock(dev);
+	device_unlock(dev);
 
 	return !!iter;
 }
@@ -661,13 +661,13 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
 static void cond_cxl_root_lock(struct cxl_port *port)
 {
 	if (is_cxl_root(port))
-		cxl_device_lock(&port->dev);
+		device_lock(&port->dev);
 }
 
 static void cond_cxl_root_unlock(struct cxl_port *port)
 {
 	if (is_cxl_root(port))
-		cxl_device_unlock(&port->dev);
+		device_unlock(&port->dev);
 }
 
 static void cxl_dport_remove(void *data)
@@ -775,15 +775,15 @@ static int add_ep(struct cxl_port *port, struct cxl_ep *new)
 {
 	struct cxl_ep *dup;
 
-	cxl_device_lock(&port->dev);
+	device_lock(&port->dev);
 	if (port->dead) {
-		cxl_device_unlock(&port->dev);
+		device_unlock(&port->dev);
 		return -ENXIO;
 	}
 	dup = find_ep(port, new->ep);
 	if (!dup)
 		list_add_tail(&new->list, &port->endpoints);
-	cxl_device_unlock(&port->dev);
+	device_unlock(&port->dev);
 
 	return dup ? -EEXIST : 0;
 }
@@ -893,12 +893,12 @@ static void delete_endpoint(void *data)
 		goto out;
 	parent = &parent_port->dev;
 
-	cxl_device_lock(parent);
+	device_lock(parent);
 	if (parent->driver && endpoint->uport) {
 		devm_release_action(parent, cxl_unlink_uport, endpoint);
 		devm_release_action(parent, unregister_port, endpoint);
 	}
-	cxl_device_unlock(parent);
+	device_unlock(parent);
 	put_device(parent);
 out:
 	put_device(&endpoint->dev);
@@ -956,7 +956,7 @@ static void cxl_detach_ep(void *data)
 		}
 
 		parent_port = to_cxl_port(port->dev.parent);
-		cxl_device_lock(&parent_port->dev);
+		device_lock(&parent_port->dev);
 		if (!parent_port->dev.driver) {
 			/*
 			 * The bottom-up race to delete the port lost to a
@@ -964,12 +964,12 @@ static void cxl_detach_ep(void *data)
 			 * parent_port ->remove() will have cleaned up all
 			 * descendants.
 			 */
-			cxl_device_unlock(&parent_port->dev);
+			device_unlock(&parent_port->dev);
 			put_device(&port->dev);
 			continue;
 		}
 
-		cxl_device_lock(&port->dev);
+		device_lock(&port->dev);
 		ep = find_ep(port, &cxlmd->dev);
 		dev_dbg(&cxlmd->dev, "disconnect %s from %s\n",
 			ep ? dev_name(ep->ep) : "", dev_name(&port->dev));
@@ -984,7 +984,7 @@ static void cxl_detach_ep(void *data)
 			port->dead = true;
 			list_splice_init(&port->dports, &reap_dports);
 		}
-		cxl_device_unlock(&port->dev);
+		device_unlock(&port->dev);
 
 		if (!list_empty(&reap_dports)) {
 			dev_dbg(&cxlmd->dev, "delete %s\n",
@@ -992,7 +992,7 @@ static void cxl_detach_ep(void *data)
 			delete_switch_port(port, &reap_dports);
 		}
 		put_device(&port->dev);
-		cxl_device_unlock(&parent_port->dev);
+		device_unlock(&parent_port->dev);
 	}
 }
 
@@ -1040,7 +1040,7 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
 		return -EAGAIN;
 	}
 
-	cxl_device_lock(&parent_port->dev);
+	device_lock(&parent_port->dev);
 	if (!parent_port->dev.driver) {
 		dev_warn(&cxlmd->dev,
 			 "port %s:%s disabled, failed to enumerate CXL.mem\n",
@@ -1058,7 +1058,7 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
 			get_device(&port->dev);
 	}
 out:
-	cxl_device_unlock(&parent_port->dev);
+	device_unlock(&parent_port->dev);
 
 	if (IS_ERR(port))
 		rc = PTR_ERR(port);
@@ -1169,14 +1169,14 @@ struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
 {
 	struct cxl_dport *dport;
 
-	cxl_device_lock(&port->dev);
+	device_lock(&port->dev);
 	list_for_each_entry(dport, &port->dports, list)
 		if (dport->dport == dev) {
-			cxl_device_unlock(&port->dev);
+			device_unlock(&port->dev);
 			return dport;
 		}
 
-	cxl_device_unlock(&port->dev);
+	device_unlock(&port->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_NS_GPL(cxl_find_dport_by_dev, CXL);
@@ -1419,9 +1419,9 @@ int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map)
 
 	port = to_cxl_port(cxld->dev.parent);
 
-	cxl_device_lock(&port->dev);
+	device_lock(&port->dev);
 	rc = cxl_decoder_add_locked(cxld, target_map);
-	cxl_device_unlock(&port->dev);
+	device_unlock(&port->dev);
 
 	return rc;
 }
@@ -1566,7 +1566,6 @@ static int cxl_bus_probe(struct device *dev)
 	 * Take the CXL nested lock since the driver core only holds
 	 * @dev->mutex and not @dev->lockdep_mutex.
 	 */
-	cxl_nested_lock(dev);
 	if (id == CXL_DEVICE_REGION) {
 		/* Regions cannot bind until parameters are set */
 		struct cxl_region *cxlr = to_cxl_region(dev);
@@ -1576,7 +1575,6 @@ static int cxl_bus_probe(struct device *dev)
 	} else {
 		rc = to_cxl_drv(dev->driver)->probe(dev);
 	}
-	cxl_nested_unlock(dev);
 
 	dev_dbg(dev, "probe: %d\n", rc);
 
@@ -1587,10 +1585,8 @@ static void cxl_bus_remove(struct device *dev)
 {
 	struct cxl_driver *cxl_drv = to_cxl_drv(dev->driver);
 
-	cxl_nested_lock(dev);
 	if (cxl_drv->remove)
 		cxl_drv->remove(dev);
-	cxl_nested_unlock(dev);
 }
 
 static struct workqueue_struct *cxl_bus_wq;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index ca8a61a623b7..97e6ca7e4940 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -530,51 +530,5 @@ static inline int cxl_lock_class(struct device *dev)
 	else
 		return CXL_ANON_LOCK;
 }
-
-static inline void cxl_nested_lock(struct device *dev)
-{
-	mutex_lock_nested(&dev->lockdep_mutex, cxl_lock_class(dev));
-}
-
-static inline void cxl_nested_unlock(struct device *dev)
-{
-	mutex_unlock(&dev->lockdep_mutex);
-}
-
-static inline void cxl_device_lock(struct device *dev)
-{
-	/*
-	 * For double lock errors the lockup will happen before lockdep
-	 * warns at cxl_nested_lock(), so assert explicitly.
-	 */
-	lockdep_assert_not_held(&dev->lockdep_mutex);
-
-	device_lock(dev);
-	cxl_nested_lock(dev);
-}
-
-static inline void cxl_device_unlock(struct device *dev)
-{
-	cxl_nested_unlock(dev);
-	device_unlock(dev);
-}
-#else
-static inline void cxl_nested_lock(struct device *dev)
-{
-}
-
-static inline void cxl_nested_unlock(struct device *dev)
-{
-}
-
-static inline void cxl_device_lock(struct device *dev)
-{
-	device_lock(dev);
-}
-
-static inline void cxl_device_unlock(struct device *dev)
-{
-	device_unlock(dev);
-}
 #endif
 #endif /* __CXL_H__ */
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 415f351629c8..a68c8f203626 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -207,7 +207,7 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
-	cxl_device_lock(&parent_port->dev);
+	device_lock(&parent_port->dev);
 	if (!parent_port->dev.driver) {
 		dev_err(dev, "CXL port topology %s not enabled\n",
 			dev_name(&parent_port->dev));
@@ -226,7 +226,7 @@ static int cxl_mem_probe(struct device *dev)
 
 	rc = devm_add_action_or_reset(dev, delete_memdev, cxlmd);
 out:
-	cxl_device_unlock(&parent_port->dev);
+	device_unlock(&parent_port->dev);
 	put_device(&parent_port->dev);
 	return rc;
 }
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index fabdb0c6dbf2..564d125d25ef 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -43,7 +43,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 	if (!cxl_nvb)
 		return -ENXIO;
 
-	cxl_device_lock(&cxl_nvb->dev);
+	device_lock(&cxl_nvb->dev);
 	if (!cxl_nvb->nvdimm_bus) {
 		rc = -ENXIO;
 		goto out;
@@ -68,7 +68,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 	dev_set_drvdata(dev, nvdimm);
 	rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
 out:
-	cxl_device_unlock(&cxl_nvb->dev);
+	device_unlock(&cxl_nvb->dev);
 	put_device(&cxl_nvb->dev);
 
 	return rc;
@@ -233,7 +233,7 @@ static void cxl_nvb_update_state(struct work_struct *work)
 	struct nvdimm_bus *victim_bus = NULL;
 	bool release = false, rescan = false;
 
-	cxl_device_lock(&cxl_nvb->dev);
+	device_lock(&cxl_nvb->dev);
 	switch (cxl_nvb->state) {
 	case CXL_NVB_ONLINE:
 		if (!online_nvdimm_bus(cxl_nvb)) {
@@ -251,7 +251,7 @@ static void cxl_nvb_update_state(struct work_struct *work)
 	default:
 		break;
 	}
-	cxl_device_unlock(&cxl_nvb->dev);
+	device_unlock(&cxl_nvb->dev);
 
 	if (release)
 		device_release_driver(&cxl_nvb->dev);
@@ -327,9 +327,9 @@ static int cxl_nvdimm_bridge_reset(struct device *dev, void *data)
 		return 0;
 
 	cxl_nvb = to_cxl_nvdimm_bridge(dev);
-	cxl_device_lock(dev);
+	device_lock(dev);
 	cxl_nvb->state = CXL_NVB_NEW;
-	cxl_device_unlock(dev);
+	device_unlock(dev);
 
 	return 0;
 }
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7dea203964f7..5942b22d7f1b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1535,7 +1535,7 @@ config PROVE_CXL_LOCKING
 	bool "CXL"
 	depends on CXL_BUS
 	help
-	  Enable lockdep to validate cxl_device_lock() usage.
+	  Enable lockdep to validate CXL subsystem usage of the device lock.
 
 endchoice
 

