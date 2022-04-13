Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED37E23CA
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829710; x=1681365710;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vtmksge+PxxfmYNS5fXJl4pdxkZNhem2rCAEcMLmAY4=;
  b=Vvwh2z/57j12jkG1xB+kE4A4e2EmyYGCCN71jGIHyb/ppnGDbDIPnEdc
   azX681coxCjVgI3bY5c7vN+IRiHL5ZDpFhdI8IUzervTbDZvwY992YpLd
   /GVlsMXt78vKw8PFh91g8sL5sMLCOGsdsJtANVDUR8T00nueWhPsnlLIF
   WqP3zgTRylq/380wy1xpbaaS4uizjF3aK7ZQVXjW2FnwfEfpcCGFS6K9z
   qpsvKmHo67+nVaxUprYT8FeSQMPvuJfbp9EW7e3izgVFfSRz6O9SWBzQz
   dWyv553exCTva8swb1eBEZZmemrAmyURQyHC83gsR+BsIxUrvPNSG2ajJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="287608119"
X-IronPort-AV: E=Sophos;i="5.90,255,1643702400"; 
   d="scan'208";a="287608119"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:01:50 -0700
X-IronPort-AV: E=Sophos;i="5.90,255,1643702400"; 
   d="scan'208";a="645039160"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:01:50 -0700
Subject: [PATCH v2 04/12] cxl/core: Remove cxl_device_lock()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Dave Jiang <dave.jiang@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 peterz@infradead.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:01:49 -0700
Message-ID: <164982970986.684294.11190977495722089239.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for moving lockdep_mutex nested lock acquisition into the
core, remove the cxl_device_lock() wrapper, but preserve
cxl_lock_class() that will be used to inform the core of the subsystem's
lock ordering rules.

Note that this reverts back to the default state of unvalidated
device_lock(). A follow-on change to use the new dev->lock_class
facility re-enables lockdep validation.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/pmem.c |    4 ++-
 drivers/cxl/core/port.c |   54 ++++++++++++++++++++---------------------------
 drivers/cxl/cxl.h       |   46 ----------------------------------------
 drivers/cxl/mem.c       |    4 ++-
 drivers/cxl/pmem.c      |   12 +++++-----
 lib/Kconfig.debug       |    2 +-
 6 files changed, 34 insertions(+), 88 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 8de240c4d96b..60f71caa5dbd 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -121,10 +121,10 @@ static void unregister_nvb(void *_cxl_nvb)
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
index 2ab1ba4499b3..437e8a71e5dc 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -312,10 +312,10 @@ static void cxl_port_release(struct device *dev)
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
@@ -554,7 +554,7 @@ static int match_root_child(struct device *dev, const void *match)
 		return 0;
 
 	port = to_cxl_port(dev);
-	cxl_device_lock(dev);
+	device_lock(dev);
 	list_for_each_entry(dport, &port->dports, list) {
 		iter = match;
 		while (iter) {
@@ -564,7 +564,7 @@ static int match_root_child(struct device *dev, const void *match)
 		}
 	}
 out:
-	cxl_device_unlock(dev);
+	device_unlock(dev);
 
 	return !!iter;
 }
@@ -623,13 +623,13 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
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
@@ -736,15 +736,15 @@ static int add_ep(struct cxl_port *port, struct cxl_ep *new)
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
@@ -854,12 +854,12 @@ static void delete_endpoint(void *data)
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
@@ -920,7 +920,7 @@ static void cxl_detach_ep(void *data)
 		}
 
 		parent_port = to_cxl_port(port->dev.parent);
-		cxl_device_lock(&parent_port->dev);
+		device_lock(&parent_port->dev);
 		if (!parent_port->dev.driver) {
 			/*
 			 * The bottom-up race to delete the port lost to a
@@ -928,12 +928,12 @@ static void cxl_detach_ep(void *data)
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
@@ -948,7 +948,7 @@ static void cxl_detach_ep(void *data)
 			port->dead = true;
 			list_splice_init(&port->dports, &reap_dports);
 		}
-		cxl_device_unlock(&port->dev);
+		device_unlock(&port->dev);
 
 		if (!list_empty(&reap_dports)) {
 			dev_dbg(&cxlmd->dev, "delete %s\n",
@@ -956,7 +956,7 @@ static void cxl_detach_ep(void *data)
 			delete_switch_port(port, &reap_dports);
 		}
 		put_device(&port->dev);
-		cxl_device_unlock(&parent_port->dev);
+		device_unlock(&parent_port->dev);
 	}
 }
 
@@ -1004,7 +1004,7 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
 		return -EAGAIN;
 	}
 
-	cxl_device_lock(&parent_port->dev);
+	device_lock(&parent_port->dev);
 	if (!parent_port->dev.driver) {
 		dev_warn(&cxlmd->dev,
 			 "port %s:%s disabled, failed to enumerate CXL.mem\n",
@@ -1022,7 +1022,7 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
 			get_device(&port->dev);
 	}
 out:
-	cxl_device_unlock(&parent_port->dev);
+	device_unlock(&parent_port->dev);
 
 	if (IS_ERR(port))
 		rc = PTR_ERR(port);
@@ -1133,14 +1133,14 @@ struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
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
@@ -1379,9 +1379,9 @@ int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map)
 
 	port = to_cxl_port(cxld->dev.parent);
 
-	cxl_device_lock(&port->dev);
+	device_lock(&port->dev);
 	rc = cxl_decoder_add_locked(cxld, target_map);
-	cxl_device_unlock(&port->dev);
+	device_unlock(&port->dev);
 
 	return rc;
 }
@@ -1452,13 +1452,7 @@ static int cxl_bus_probe(struct device *dev)
 {
 	int rc;
 
-	/*
-	 * Take the CXL nested lock since the driver core only holds
-	 * @dev->mutex and not @dev->lockdep_mutex.
-	 */
-	cxl_nested_lock(dev);
 	rc = to_cxl_drv(dev->driver)->probe(dev);
-	cxl_nested_unlock(dev);
 
 	dev_dbg(dev, "probe: %d\n", rc);
 	return rc;
@@ -1468,10 +1462,8 @@ static void cxl_bus_remove(struct device *dev)
 {
 	struct cxl_driver *cxl_drv = to_cxl_drv(dev->driver);
 
-	cxl_nested_lock(dev);
 	if (cxl_drv->remove)
 		cxl_drv->remove(dev);
-	cxl_nested_unlock(dev);
 }
 
 static struct workqueue_struct *cxl_bus_wq;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index c9fda9304c54..a6c1a027e389 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -439,51 +439,5 @@ static inline int cxl_lock_class(struct device *dev)
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
index 49a4b1c47299..91fb8d5b21a7 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -195,7 +195,7 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
-	cxl_device_lock(&parent_port->dev);
+	device_lock(&parent_port->dev);
 	if (!parent_port->dev.driver) {
 		dev_err(dev, "CXL port topology %s not enabled\n",
 			dev_name(&parent_port->dev));
@@ -205,7 +205,7 @@ static int cxl_mem_probe(struct device *dev)
 
 	rc = create_endpoint(cxlmd, parent_port);
 out:
-	cxl_device_unlock(&parent_port->dev);
+	device_unlock(&parent_port->dev);
 	put_device(&parent_port->dev);
 	return rc;
 }
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 15ad666ab03e..b65a272a2d6d 100644
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
index 075cd25363ac..333d41da7621 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1563,7 +1563,7 @@ config PROVE_CXL_LOCKING
 	bool "CXL"
 	depends on CXL_BUS
 	help
-	  Enable lockdep to validate cxl_device_lock() usage.
+	  Enable lockdep to validate CXL subsystem usage of the device lock.
 
 endchoice
 

