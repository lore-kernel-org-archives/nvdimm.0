Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253577460
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843328; x=1689379328;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7GZsp765NhD7A40eOR8AtSk30NgIqkrFvVTX1pphqJ8=;
  b=cOViZmCM6bEts/i52GQZd2vADq5SW1rfuz/eNkSr0pJN+CkV/hgBuruB
   lrrRdKAtiqmk/zdKbGjOXXe1W1gADYGcw7SHR3tIjjBHn49EkZarm5crh
   gIHCA2cHr/vHc0suwsRkibSiA7G6j0YGOf+LjtVkDifGYoC+v4/AxuEhk
   k1ezT5uGTPlzvlP9O0JrdfAh+1fdf+DerkeSsXS/65kF4wG2UHcTltEkX
   p5Nk6//qft6A5RugnTrLvvpde8KCwuwN65OTQZJZp8P3UyBU6SlZFg6c/
   y3rVUFIAhVUGgMU6t3p+3+rKDl/vrLm6NFEJCXM2PwnO/VRpg+4vFX0A2
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="284417819"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="284417819"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:01:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="923290629"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:01:56 -0700
Subject: [PATCH v2 13/28] cxl/port: Move dport tracking to an xarray
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: hch@lst.de, nvdimm@lists.linux.dev, linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:01:56 -0700
Message-ID: <165784331647.1758207.6345820282285119339.stgit@dwillia2-xfh.jf.intel.com>
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

Reduce the complexity and the overhead of walking the topology to
determine endpoint connectivity to root decoder interleave
configurations.

Note that cxl_detach_ep(), after it determines that the last @ep has
departed and decides to delete the port, now needs to walk the dport
array with the device_lock() held to remove entries. Previously
list_splice_init() could be used atomically delete all dport entries at
once and then perform entry tear down outside the lock. There is no
list_splice_init() equivalent for the xarray.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/hdm.c  |    6 ++-
 drivers/cxl/core/port.c |   85 ++++++++++++++++++++---------------------------
 drivers/cxl/cxl.h       |   12 ++++---
 3 files changed, 47 insertions(+), 56 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 596b57fb60df..4a0325b02ca4 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -50,8 +50,9 @@ static int add_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 int devm_cxl_add_passthrough_decoder(struct cxl_port *port)
 {
 	struct cxl_switch_decoder *cxlsd;
-	struct cxl_dport *dport;
+	struct cxl_dport *dport = NULL;
 	int single_port_map[1];
+	unsigned long index;
 
 	cxlsd = cxl_switch_decoder_alloc(port, 1);
 	if (IS_ERR(cxlsd))
@@ -59,7 +60,8 @@ int devm_cxl_add_passthrough_decoder(struct cxl_port *port)
 
 	device_lock_assert(&port->dev);
 
-	dport = list_first_entry(&port->dports, typeof(*dport), list);
+	xa_for_each(&port->dports, index, dport)
+		break;
 	single_port_map[0] = dport->port_id;
 
 	return add_hdm_decoder(port, &cxlsd->cxld, single_port_map);
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 727d861e21db..b2c44e7ef6a8 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -452,6 +452,7 @@ static void cxl_port_release(struct device *dev)
 	xa_for_each(&port->endpoints, index, ep)
 		cxl_ep_remove(port, ep);
 	xa_destroy(&port->endpoints);
+	xa_destroy(&port->dports);
 	ida_free(&cxl_port_ida, port->id);
 	kfree(port);
 }
@@ -581,7 +582,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
 	port->component_reg_phys = component_reg_phys;
 	ida_init(&port->decoder_ida);
 	port->hdm_end = -1;
-	INIT_LIST_HEAD(&port->dports);
+	xa_init(&port->dports);
 	xa_init(&port->endpoints);
 
 	device_initialize(dev);
@@ -711,17 +712,13 @@ static int match_root_child(struct device *dev, const void *match)
 		return 0;
 
 	port = to_cxl_port(dev);
-	device_lock(dev);
-	list_for_each_entry(dport, &port->dports, list) {
-		iter = match;
-		while (iter) {
-			if (iter == dport->dport)
-				goto out;
-			iter = iter->parent;
-		}
+	iter = match;
+	while (iter) {
+		dport = cxl_find_dport_by_dev(port, iter);
+		if (dport)
+			break;
+		iter = iter->parent;
 	}
-out:
-	device_unlock(dev);
 
 	return !!iter;
 }
@@ -745,9 +742,10 @@ EXPORT_SYMBOL_NS_GPL(find_cxl_root, CXL);
 static struct cxl_dport *find_dport(struct cxl_port *port, int id)
 {
 	struct cxl_dport *dport;
+	unsigned long index;
 
 	device_lock_assert(&port->dev);
-	list_for_each_entry (dport, &port->dports, list)
+	xa_for_each(&port->dports, index, dport)
 		if (dport->port_id == id)
 			return dport;
 	return NULL;
@@ -759,15 +757,15 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
 
 	device_lock_assert(&port->dev);
 	dup = find_dport(port, new->port_id);
-	if (dup)
+	if (dup) {
 		dev_err(&port->dev,
 			"unable to add dport%d-%s non-unique port id (%s)\n",
 			new->port_id, dev_name(new->dport),
 			dev_name(dup->dport));
-	else
-		list_add_tail(&new->list, &port->dports);
-
-	return dup ? -EEXIST : 0;
+		return -EBUSY;
+	}
+	return xa_insert(&port->dports, (unsigned long)new->dport, new,
+			 GFP_KERNEL);
 }
 
 /*
@@ -794,10 +792,8 @@ static void cxl_dport_remove(void *data)
 	struct cxl_dport *dport = data;
 	struct cxl_port *port = dport->port;
 
+	xa_erase(&port->dports, (unsigned long) dport->dport);
 	put_device(dport->dport);
-	cond_cxl_root_lock(port);
-	list_del(&dport->list);
-	cond_cxl_root_unlock(port);
 }
 
 static void cxl_dport_unlink(void *data)
@@ -849,7 +845,6 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
 	if (!dport)
 		return ERR_PTR(-ENOMEM);
 
-	INIT_LIST_HEAD(&dport->list);
 	dport->dport = dport_dev;
 	dport->port_id = port_id;
 	dport->component_reg_phys = component_reg_phys;
@@ -1040,19 +1035,27 @@ EXPORT_SYMBOL_NS_GPL(cxl_endpoint_autoremove, CXL);
  * for a port to be unregistered is when all memdevs beneath that port have gone
  * through ->remove(). This "bottom-up" removal selectively removes individual
  * child ports manually. This depends on devm_cxl_add_port() to not change is
- * devm action registration order.
+ * devm action registration order, and for dports to have already been
+ * destroyed by reap_dports().
  */
-static void delete_switch_port(struct cxl_port *port, struct list_head *dports)
+static void delete_switch_port(struct cxl_port *port)
+{
+	devm_release_action(port->dev.parent, cxl_unlink_uport, port);
+	devm_release_action(port->dev.parent, unregister_port, port);
+}
+
+static void reap_dports(struct cxl_port *port)
 {
-	struct cxl_dport *dport, *_d;
+	struct cxl_dport *dport;
+	unsigned long index;
 
-	list_for_each_entry_safe(dport, _d, dports, list) {
+	device_lock_assert(&port->dev);
+
+	xa_for_each(&port->dports, index, dport) {
 		devm_release_action(&port->dev, cxl_dport_unlink, dport);
 		devm_release_action(&port->dev, cxl_dport_remove, dport);
 		devm_kfree(&port->dev, dport);
 	}
-	devm_release_action(port->dev.parent, cxl_unlink_uport, port);
-	devm_release_action(port->dev.parent, unregister_port, port);
 }
 
 static struct cxl_ep *cxl_ep_load(struct cxl_port *port,
@@ -1069,8 +1072,8 @@ static void cxl_detach_ep(void *data)
 	for (iter = &cxlmd->dev; iter; iter = grandparent(iter)) {
 		struct device *dport_dev = grandparent(iter);
 		struct cxl_port *port, *parent_port;
-		LIST_HEAD(reap_dports);
 		struct cxl_ep *ep;
+		bool died = false;
 
 		if (!dport_dev)
 			break;
@@ -1110,15 +1113,16 @@ static void cxl_detach_ep(void *data)
 			 * enumerated port. Block new cxl_add_ep() and garbage
 			 * collect the port.
 			 */
+			died = true;
 			port->dead = true;
-			list_splice_init(&port->dports, &reap_dports);
+			reap_dports(port);
 		}
 		device_unlock(&port->dev);
 
-		if (!list_empty(&reap_dports)) {
+		if (died) {
 			dev_dbg(&cxlmd->dev, "delete %s\n",
 				dev_name(&port->dev));
-			delete_switch_port(port, &reap_dports);
+			delete_switch_port(port);
 		}
 		put_device(&port->dev);
 		device_unlock(&parent_port->dev);
@@ -1297,23 +1301,6 @@ struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd,
 }
 EXPORT_SYMBOL_NS_GPL(cxl_mem_find_port, CXL);
 
-struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
-					const struct device *dev)
-{
-	struct cxl_dport *dport;
-
-	device_lock(&port->dev);
-	list_for_each_entry(dport, &port->dports, list)
-		if (dport->dport == dev) {
-			device_unlock(&port->dev);
-			return dport;
-		}
-
-	device_unlock(&port->dev);
-	return NULL;
-}
-EXPORT_SYMBOL_NS_GPL(cxl_find_dport_by_dev, CXL);
-
 static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
 				    struct cxl_port *port, int *target_map)
 {
@@ -1324,7 +1311,7 @@ static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
 
 	device_lock_assert(&port->dev);
 
-	if (list_empty(&port->dports))
+	if (xa_empty(&port->dports))
 		return -EINVAL;
 
 	write_seqlock(&cxlsd->target_lock);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index de5cb8288cd4..bf5f0c305115 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -344,7 +344,7 @@ struct cxl_port {
 	struct device *uport;
 	struct device *host_bridge;
 	int id;
-	struct list_head dports;
+	struct xarray dports;
 	struct xarray endpoints;
 	struct cxl_dport *parent_dport;
 	struct ida decoder_ida;
@@ -354,20 +354,24 @@ struct cxl_port {
 	unsigned int depth;
 };
 
+static inline struct cxl_dport *
+cxl_find_dport_by_dev(struct cxl_port *port, const struct device *dport_dev)
+{
+	return xa_load(&port->dports, (unsigned long)dport_dev);
+}
+
 /**
  * struct cxl_dport - CXL downstream port
  * @dport: PCI bridge or firmware device representing the downstream link
  * @port_id: unique hardware identifier for dport in decoder target list
  * @component_reg_phys: downstream port component registers
  * @port: reference to cxl_port that contains this downstream port
- * @list: node for a cxl_port's list of cxl_dport instances
  */
 struct cxl_dport {
 	struct device *dport;
 	int port_id;
 	resource_size_t component_reg_phys;
 	struct cxl_port *port;
-	struct list_head list;
 };
 
 /**
@@ -410,8 +414,6 @@ bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd);
 struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
 				     struct device *dport, int port_id,
 				     resource_size_t component_reg_phys);
-struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
-					const struct device *dev);
 
 struct cxl_decoder *to_cxl_decoder(struct device *dev);
 struct cxl_root_decoder *to_cxl_root_decoder(struct device *dev);

