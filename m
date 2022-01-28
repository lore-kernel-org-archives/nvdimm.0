Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226302C9E;
	Fri, 28 Jan 2022 00:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643329651; x=1674865651;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qnDCWzwqZN3I15w/s8Qb2KClLbLckceUFz3RVBc72fw=;
  b=hA3O46E7AOzj4Nvho6GaB0Ib+oD1+jidJBRA+gN7O1SCSV7G5cSMjgxq
   lh7hbfLheMI0q0juI+gWPN9QJ/t8FoKeOYadB1R3pqfClJfMwc/hodYkF
   ch+pIqrW2XIdOrdEofCNJd6+hq6SKTSZwwEt5L4hFxAARrDPQ/yvI8wos
   VGczjXnPJpQMkdYiOf3TF4zzCamUfIzIspxP60zDpGgc7Ohm8g1HkqJxv
   x+bUaGVwzxY2r4d/t9rUcfLHaMPyKMd9mGv9dpouQDqyRvY4dHwYy4od5
   15nMgeZXfWnHbzRABwopsxagf120NGRwdD/tUoAcAQAB1uBNbPnWNcoRa
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="226982096"
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="226982096"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="674909665"
Received: from vrao2-mobl1.gar.corp.intel.com (HELO localhost.localdomain) ([10.252.129.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:30 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	kernel test robot <lkp@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org
Subject: [PATCH v3 14/14] cxl/region: Create an nd_region
Date: Thu, 27 Jan 2022 16:27:07 -0800
Message-Id: <20220128002707.391076-15-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220128002707.391076-1-ben.widawsky@intel.com>
References: <20220128002707.391076-1-ben.widawsky@intel.com>
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

Reported-by: kernel test robot <lkp@intel.com> (v2)
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
Changes since v2:
- Check nvb is non-null
- Give a dev_dbg for non-existent nvdimm_bus
---
 drivers/cxl/Kconfig     |  3 ++-
 drivers/cxl/core/pmem.c | 16 ++++++++++++
 drivers/cxl/cxl.h       |  1 +
 drivers/cxl/region.c    | 58 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index 742847503c16..054dc78d6f7d 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -99,7 +99,8 @@ config CXL_PORT
 	tristate
 
 config CXL_REGION
-	default CXL_PORT
+	depends on CXL_PMEM
+	default CXL_BUS
 	tristate
 
 endif
diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 7e431667ade1..58dc6fba3130 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -220,6 +220,22 @@ struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev)
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
index 062654204eca..7eb8f36af30b 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -480,6 +480,7 @@ bool is_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm_bridge(struct device *dev);
 int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct device *dev);
+struct cxl_nvdimm *cxl_find_nvdimm(struct cxl_memdev *cxlmd);
 
 /*
  * Unit test builds overrides this to __weak, find the 'strong' version
diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
index ac290677534d..be472560fc6a 100644
--- a/drivers/cxl/region.c
+++ b/drivers/cxl/region.c
@@ -708,6 +708,58 @@ static int bind_region(struct cxl_region *cxlr)
 	return rc;
 }
 
+static int connect_to_libnvdimm(struct cxl_region *region)
+{
+	struct nd_region_desc ndr_desc;
+	struct cxl_nvdimm_bridge *nvb;
+	struct nd_region *ndr;
+	int rc = 0;
+
+	nvb = cxl_find_nvdimm_bridge(&region->config.targets[0]->dev);
+	if (!nvb) {
+		dev_dbg(&region->dev, "Couldn't find nvdimm bridge\n");
+		return -ENODEV;
+	}
+
+	device_lock(&nvb->dev);
+	if (!nvb->nvdimm_bus) {
+		dev_dbg(&nvb->dev, "Couldn't find nvdimm bridge's bus\n");
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
@@ -791,6 +843,12 @@ static int cxl_region_probe(struct device *dev)
 		return ret;
 	}
 
+	ret = connect_to_libnvdimm(cxlr);
+	if (ret) {
+		region_unregister(dev);
+		return ret;
+	}
+
 	cxlr->active = true;
 	dev_info(dev, "Bound");
 	return devm_add_action_or_reset(dev, region_unregister, dev);
-- 
2.35.0

