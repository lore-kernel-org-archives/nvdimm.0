Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E2C2F48;
	Wed, 13 Apr 2022 18:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875094; x=1681411094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9hd4g8zIfuHktQme6cUN0eLi2pbyX+YysGO8+PPESAs=;
  b=fwe0ryLxOQf7IF9EGJpJaIlm54+QSO5dE7XzWKe+ERawQbKRhAdGjyUD
   B9iQ/ymxsShpgZ0FBj5uie0GbsVAWoRplseh8rXJmW3zDvbhAaP0csTm7
   OD9YLn/ilLEcnM4ixqUbDbwlSJHtb6gjb3Vx6rHl9gEeylrSl80dLPF8q
   J3ZLG/JxbJboT9T0M1rZfYJKheCjMq+6K8bRW2l7QWB18197dxbc9SoFD
   KOM/4xoPAXguyosPJnUvLljmU8Pglal8G0FGKeNcIPXZdW6wjMy7kTOzO
   /W//ck2Lt90+WFx0wyRfW9Iesl9x89iTQGZ9tqyJBO+nup/8VKi5noU82
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631846"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631846"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:49 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013594"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:49 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 07/15] cxl/port: Surface ram and pmem resources
Date: Wed, 13 Apr 2022 11:37:12 -0700
Message-Id: <20220413183720.2444089-8-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413183720.2444089-1-ben.widawsky@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CXL Type 2 and 3 endpoints may contain Host-managed Device Memory (HDM).
This memory can be either volatile, persistent, or some combination of
both. Similar to the root decoder the port's resources can be considered
the host memory of which decoders allocate out of. Unlike the root
decoder resource, device resources are in the device physical address
space domain.

The CXL specification mandates a specific partitioning of volatile vs.
persistent capacities. While an endpoint may contain one, or both
capacities the volatile capacity while always be first. To accommodate
this, two parameters are added to port creation, the offset of the
split, and the total capacity.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/port.c | 19 +++++++++++++++++++
 drivers/cxl/cxl.h       | 11 +++++++++++
 drivers/cxl/mem.c       |  7 +++++--
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 8dd29c97e318..0d946711685b 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/workqueue.h>
+#include <linux/genalloc.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -469,6 +470,24 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_add_port, CXL);
 
+struct cxl_port *devm_cxl_add_endpoint_port(struct device *host,
+					    struct device *uport,
+					    resource_size_t component_reg_phys,
+					    u64 capacity, u64 pmem_offset,
+					    struct cxl_port *parent_port)
+{
+	struct cxl_port *ep =
+		devm_cxl_add_port(host, uport, component_reg_phys, parent_port);
+	if (IS_ERR(ep) || !capacity)
+		return ep;
+
+	ep->capacity = capacity;
+	ep->pmem_offset = pmem_offset;
+
+	return ep;
+}
+EXPORT_SYMBOL_NS_GPL(devm_cxl_add_endpoint_port, CXL);
+
 struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port)
 {
 	/* There is no pci_bus associated with a CXL platform-root port */
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 0e1c65761ead..52295548a071 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -309,6 +309,9 @@ struct cxl_nvdimm {
  * @component_reg_phys: component register capability base address (optional)
  * @dead: last ep has been removed, force port re-creation
  * @depth: How deep this port is relative to the root. depth 0 is the root.
+ * @capacity: How much total storage the media can hold (endpoint only)
+ * @pmem_offset: Partition dividing volatile, [0, pmem_offset -1 ], and persistent
+ *		 [pmem_offset, capacity - 1] addresses.
  */
 struct cxl_port {
 	struct device dev;
@@ -320,6 +323,9 @@ struct cxl_port {
 	resource_size_t component_reg_phys;
 	bool dead;
 	unsigned int depth;
+
+	u64 capacity;
+	u64 pmem_offset;
 };
 
 /**
@@ -368,6 +374,11 @@ struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port);
 struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 				   resource_size_t component_reg_phys,
 				   struct cxl_port *parent_port);
+struct cxl_port *devm_cxl_add_endpoint_port(struct device *host,
+					    struct device *uport,
+					    resource_size_t component_reg_phys,
+					    u64 capacity, u64 pmem_offset,
+					    struct cxl_port *parent_port);
 struct cxl_port *find_cxl_root(struct device *dev);
 int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
 int cxl_bus_rescan(void);
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 49a4b1c47299..b27ce13c1872 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -50,9 +50,12 @@ static int create_endpoint(struct cxl_memdev *cxlmd,
 {
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct cxl_port *endpoint;
+	u64 partition = range_len(&cxlds->ram_range);
+	u64 size = range_len(&cxlds->ram_range) + range_len(&cxlds->pmem_range);
 
-	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
-				     cxlds->component_reg_phys, parent_port);
+	endpoint = devm_cxl_add_endpoint_port(&parent_port->dev, &cxlmd->dev,
+					      cxlds->component_reg_phys, size,
+					      partition, parent_port);
 	if (IS_ERR(endpoint))
 		return PTR_ERR(endpoint);
 
-- 
2.35.1

