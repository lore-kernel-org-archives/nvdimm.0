Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D8623A6;
	Fri, 24 Jun 2022 04:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656044412; x=1687580412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HUsFMVeTjVGLdCwrcUoS1fkV2YbMF30CWyhsa214UuI=;
  b=CBLaxvUML/zGhVsz0hk2tC/rR7mKT+mGVVjlckicOkJyj0hy+Ov8ssVa
   4NlY9SIBQgPOw9RzV4w3gEfSdjTc6+uE7uvavJhGCiUYkWNlFXU7rkRfA
   kRGP9Y+GV/1M/lMI3iskcMgQfPIzueYFicyXyH24RyZBTydPoRJr77LCC
   zjnvB+hTbKEoaMENdQRmRmfmDS9vVMaxuzMUBmV6Wvd//+f7v7Mws9Q7v
   M4VVEhYqXOLXyNHrp31VZJFKoj7MTJ/Mh/Uawe1cLCXdqQ55d1qCu+2w6
   c9Z8Aj2vyVpVlb8UUuKlwd2LIrb8qu3TY9MejVwMskPUIxR9DG+HZrlUF
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344912788"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344912788"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="645092906"
Received: from daharell-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.intel.com) ([10.209.66.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:10 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org,
	patches@lists.linux.dev,
	hch@lst.de,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 29/46] cxl/port: Cache CXL host bridge data
Date: Thu, 23 Jun 2022 21:19:33 -0700
Message-Id: <20220624041950.559155-4-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Region creation has need for checking host-bridge connectivity when
adding endpoints to regions. Record, at port creation time, the
host-bridge to provide a useful shortcut from any location in the
topology to the most-significant ancestor.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/port.c | 16 +++++++++++++++-
 drivers/cxl/cxl.h       |  2 ++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index d2f6898940fa..c48f217e689a 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -546,6 +546,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
 	if (rc < 0)
 		goto err;
 	port->id = rc;
+	port->uport = uport;
 
 	/*
 	 * The top-level cxl_port "cxl_root" does not have a cxl_port as
@@ -556,14 +557,27 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
 	dev = &port->dev;
 	if (parent_dport) {
 		struct cxl_port *parent_port = parent_dport->port;
+		struct cxl_port *iter;
 
 		port->depth = parent_port->depth + 1;
 		port->parent_dport = parent_dport;
 		dev->parent = &parent_port->dev;
+		/*
+		 * walk to the host bridge, or the first ancestor that knows
+		 * the host bridge
+		 */
+		iter = port;
+		while (!iter->host_bridge &&
+		       !is_cxl_root(to_cxl_port(iter->dev.parent)))
+			iter = to_cxl_port(iter->dev.parent);
+		if (iter->host_bridge)
+			port->host_bridge = iter->host_bridge;
+		else
+			port->host_bridge = iter->uport;
+		dev_dbg(uport, "host-bridge: %s\n", dev_name(port->host_bridge));
 	} else
 		dev->parent = uport;
 
-	port->uport = uport;
 	port->component_reg_phys = component_reg_phys;
 	ida_init(&port->decoder_ida);
 	port->dpa_end = -1;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 8e2c1b393552..0211cf0d3574 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -331,6 +331,7 @@ struct cxl_nvdimm {
  * @component_reg_phys: component register capability base address (optional)
  * @dead: last ep has been removed, force port re-creation
  * @depth: How deep this port is relative to the root. depth 0 is the root.
+ * @host_bridge: Shortcut to the platform attach point for this port
  */
 struct cxl_port {
 	struct device dev;
@@ -344,6 +345,7 @@ struct cxl_port {
 	resource_size_t component_reg_phys;
 	bool dead;
 	unsigned int depth;
+	struct device *host_bridge;
 };
 
 static inline struct cxl_dport *cxl_dport_load(struct cxl_port *port,
-- 
2.36.1

