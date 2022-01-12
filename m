Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDBA3FE7;
	Wed, 12 Jan 2022 23:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642031294; x=1673567294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sz0q31fHqc0I1mJSaBX93aEzTlZDmtfU2Ln63uj8NIM=;
  b=DaSIxZN7VR2dmpLtuYd2UKRxZAcVocm71o9CRMd1wMeRJ5Nl2peq+21Z
   Yotwp11xKvR/aZIKP7vAn9KDy9QcMxwFE3JS2ZkN3OfDqSF+Bg5R3gKDE
   eSF+YNDzngtyVA0p8kIjk8iIXoiV3rRIkmIcNs3O/2fuZsjX2hJnsWt/7
   iQSQ9lb66OesA88jZ8RPFY2VFRq9BhlSLSfu1sghk2AjPnqcOXtX6OYYO
   gJpIaDttXBDDy/XSfD1JWuwgLWzLy48ca6GcxzdXEckMF7MWIIrGYPiJy
   d61/hC1yOgmfYLrkxWZSuct9nIzUY1sf8aECnLwVv8Yu0Aszp5BJzjTsz
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="243673342"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="243673342"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:48:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="670324222"
Received: from jmaclean-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.136.131])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:48:13 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 15/15] cxl/region: Create an nd_region
Date: Wed, 12 Jan 2022 15:47:49 -0800
Message-Id: <20220112234749.1965960-16-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220112234749.1965960-1-ben.widawsky@intel.com>
References: <20220112234749.1965960-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LIBNVDIMM supports the creation of regions for both persistent and
volatile memory ranges. The cxl_region driver is capable of handling the
CXL side of region creation but will reuse LIBVDIMM for interfacing with
the rest of the kernel.

TODO: CXL regions can go away. As a result the nd_region must also be
torn down.

TODO2: Handle mappings. LIBNVDIMM is capable of being informed about
which parts of devices contribute to a region and validating whether or
not the region is configured properly. To do this properly requires
tracking allocations per device.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/pmem.c | 16 +++++++++++++
 drivers/cxl/cxl.h       |  1 +
 drivers/cxl/region.c    | 52 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index bfcf51fbda5d..762a08c6f073 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -213,6 +213,22 @@ struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(to_cxl_nvdimm, CXL);
 
+static int match_cxl_nvdimm(struct device *dev, void *data)
+{
+	return is_cxl_nvdimm(dev);
+}
+
+struct cxl_nvdimm *cxl_find_nvdimm(struct cxl_memdev *cxlmd)
+{
+	struct device *dev;
+
+	dev = device_find_child(&cxlmd->dev, NULL, match_cxl_nvdimm);
+	if (!dev)
+		return NULL;
+	return to_cxl_nvdimm(dev);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_find_nvdimm, CXL);
+
 static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
 {
 	struct cxl_nvdimm *cxl_nvd;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 6f9cabb77c08..a7b90356914d 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -434,6 +434,7 @@ bool is_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm_bridge(struct device *dev);
 int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_memdev *cxlmd);
+struct cxl_nvdimm *cxl_find_nvdimm(struct cxl_memdev *cxlmd);
 
 /*
  * Unit test builds overrides this to __weak, find the 'strong' version
diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
index d00305655f5a..d4a7e8d47c11 100644
--- a/drivers/cxl/region.c
+++ b/drivers/cxl/region.c
@@ -623,6 +623,52 @@ static int bind_region(struct cxl_region *region)
 	return rc;
 }
 
+static int connect_to_libnvdimm(struct cxl_region *region)
+{
+	struct nd_region_desc ndr_desc;
+	struct cxl_nvdimm_bridge *nvb;
+	struct nd_region *ndr;
+	int rc = 0;
+
+	nvb = cxl_find_nvdimm_bridge(region->config.targets[0]);
+	device_lock(&nvb->dev);
+	if (!nvb->nvdimm_bus) {
+		rc = -ENXIO;
+		goto out;
+	}
+
+	memset(&ndr_desc, 0, sizeof(ndr_desc));
+
+	ndr_desc.res = region->res;
+
+	ndr_desc.numa_node = memory_add_physaddr_to_nid(region->res->start);
+	ndr_desc.target_node = phys_to_target_node(region->res->start);
+	if (ndr_desc.numa_node == NUMA_NO_NODE) {
+		ndr_desc.numa_node =
+			memory_add_physaddr_to_nid(region->res->start);
+		dev_info(&region->dev,
+			 "changing numa node from %d to %d for CXL region %pR",
+			 NUMA_NO_NODE, ndr_desc.numa_node, region->res);
+	}
+	if (ndr_desc.target_node == NUMA_NO_NODE) {
+		ndr_desc.target_node = ndr_desc.numa_node;
+		dev_info(&region->dev,
+			 "changing target node from %d to %d for CXL region %pR",
+			 NUMA_NO_NODE, ndr_desc.target_node, region->res);
+	}
+
+	ndr = nvdimm_pmem_region_create(nvb->nvdimm_bus, &ndr_desc);
+	if (IS_ERR(ndr))
+		rc = PTR_ERR(ndr);
+	else
+		dev_set_drvdata(&region->dev, ndr);
+
+out:
+	device_unlock(&nvb->dev);
+	put_device(&nvb->dev);
+	return rc;
+}
+
 static void region_unregister(void *dev)
 {
 	struct cxl_region *region = to_cxl_region(dev);
@@ -704,6 +750,12 @@ static int cxl_region_probe(struct device *dev)
 		return ret;
 	}
 
+	ret = connect_to_libnvdimm(region);
+	if (ret) {
+		region_unregister(dev);
+		return ret;
+	}
+
 
 	region->active = true;
 	dev_info(dev, "Bound");
-- 
2.34.1

