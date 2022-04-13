Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A35320B;
	Wed, 13 Apr 2022 18:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875097; x=1681411097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ueQH3WwkSvY8y69EXKcXNLoaONnTPsnAVGBYWnEIn+E=;
  b=DdG60cki6n9rlDEuEN92LDlNMMBQKC3aciNSB9A+HI2bPbDCBp0qBxel
   YyTkEbTJobpW+ttMvN+FxlWEvumtDzPtipuxtqLL37mQnazTGEB783xMb
   rLpPm5/VM5jP1pGDIGEDoahWmpVrMjnjSVxuJuFWglna1TFpccoWklwC8
   3xoF/jqoHgGrbne0LTplVbkaZQAnXIXUl1jksYF0vBZCvMYszV5MTEPUd
   PocrMdQKZ+lFPFlPWZIOs0V6Hq8ofdNcRykw85edMogr4VnMIdFEf5/CY
   xuHBCHUenaS2GXZkSn+YPVC0lQdKXDNvEvIcyCF96T6hoOcGZWpzMeRzi
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631844"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631844"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:49 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013586"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:48 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 05/15] cxl/acpi: Reserve CXL resources from request_free_mem_region
Date: Wed, 13 Apr 2022 11:37:10 -0700
Message-Id: <20220413183720.2444089-6-ben.widawsky@intel.com>
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

Define an API which allows CXL drivers to manage CXL address space.
CXL is unique in that the address space and various properties are only
known after CXL drivers come up, and therefore cannot be part of core
memory enumeration.

Compute Express Link 2.0 [ECN] defines a concept called CXL Fixed Memory
Window Structures (CFMWS). Each CFMWS conveys a region of host physical
address (HPA) space which has certain properties that are familiar to
CXL, mainly interleave properties, and restrictions, such as
persistence. The HPA ranges therefore should be owned, or at least
guided by the relevant CXL driver, cxl_acpi [1].

It would be desirable to simply insert this address space into
iomem_resource with a new flag to denote this is CXL memory. This would
permit request_free_mem_region() to be reused for CXL memory provided it
learned some new tricks. For that, it is tempting to simply use
insert_resource(). The API was designed specifically for cases where new
devices may offer new address space. This cannot work in the general
case. Boot firmware can pass, some, none, or all of the CFMWS range as
various types of memory to the kernel, and this may be left alone,
merged, or even expanded. As a result iomem_resource may intersect CFMWS
regions in ways insert_resource cannot handle [2]. Similar reasoning
applies to allocate_resource().

With the insert_resource option out, the only reasonable approach left
is to let the CXL driver manage the address space independently of
iomem_resource and attempt to prevent users of device private memory
APIs from using CXL memory. In the case where cxl_acpi comes up first,
the new API allows cxl to block use of any CFMWS defined address space
by assuming everything above the highest CFMWS entry is fair game. It is
expected that this effectively will prevent usage of device private
memory, but if such behavior is undesired, cxl_acpi can be blocked from
loading, or unloaded. When device private memory is used before CXL
comes up, or, there are intersections as described above, the CXL driver
will have to make sure to not reuse sysram that is BUSY.

[1]: The specification defines enumeration via ACPI, however, one could
envision devicetree, or some other hardcoded mechanisms for doing the
same thing.

[2]: A common way to hit this case is when BIOS creates a volatile
region with extra space for hotplug. In this case, you're likely to have

|<--------------HPA space---------------------->|
|<---iomem_resource -->|
| DDR  | CXL Volatile  |
|      | CFMWS for volatile w/ hotplug |

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/acpi.c     | 26 ++++++++++++++++++++++++++
 include/linux/ioport.h |  1 +
 kernel/resource.c      | 11 ++++++++++-
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 9b69955b90cb..0870904fe4b5 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -76,6 +76,7 @@ static int cxl_acpi_cfmws_verify(struct device *dev,
 struct cxl_cfmws_context {
 	struct device *dev;
 	struct cxl_port *root_port;
+	struct acpi_cedt_cfmws *high_cfmws;
 };
 
 static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
@@ -126,6 +127,14 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 			cfmws->base_hpa + cfmws->window_size - 1);
 		return 0;
 	}
+
+	if (ctx->high_cfmws) {
+		if (cfmws->base_hpa > ctx->high_cfmws->base_hpa)
+			ctx->high_cfmws = cfmws;
+	} else {
+		ctx->high_cfmws = cfmws;
+	}
+
 	dev_dbg(dev, "add: %s node: %d range %#llx-%#llx\n",
 		dev_name(&cxld->dev), phys_to_target_node(cxld->range.start),
 		cfmws->base_hpa, cfmws->base_hpa + cfmws->window_size - 1);
@@ -299,6 +308,7 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 	ctx = (struct cxl_cfmws_context) {
 		.dev = host,
 		.root_port = root_port,
+		.high_cfmws = NULL,
 	};
 	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CFMWS, cxl_parse_cfmws, &ctx);
 
@@ -317,10 +327,25 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 	if (rc < 0)
 		return rc;
 
+	if (ctx.high_cfmws) {
+		resource_size_t end =
+			ctx.high_cfmws->base_hpa + ctx.high_cfmws->window_size;
+		dev_dbg(host,
+			"Disabling free device private regions below %#llx\n",
+			end);
+		set_request_free_min_base(end);
+	}
+
 	/* In case PCI is scanned before ACPI re-trigger memdev attach */
 	return cxl_bus_rescan();
 }
 
+static int cxl_acpi_remove(struct platform_device *pdev)
+{
+	set_request_free_min_base(0);
+	return 0;
+}
+
 static const struct acpi_device_id cxl_acpi_ids[] = {
 	{ "ACPI0017" },
 	{ },
@@ -329,6 +354,7 @@ MODULE_DEVICE_TABLE(acpi, cxl_acpi_ids);
 
 static struct platform_driver cxl_acpi_driver = {
 	.probe = cxl_acpi_probe,
+	.remove = cxl_acpi_remove,
 	.driver = {
 		.name = KBUILD_MODNAME,
 		.acpi_match_table = cxl_acpi_ids,
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index ec5f71f7135b..dc41e4be5635 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -325,6 +325,7 @@ extern int
 walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start, u64 end,
 		    void *arg, int (*func)(struct resource *, void *));
 
+void set_request_free_min_base(resource_size_t val);
 struct resource *devm_request_free_mem_region(struct device *dev,
 		struct resource *base, unsigned long size);
 struct resource *request_free_mem_region(struct resource *base,
diff --git a/kernel/resource.c b/kernel/resource.c
index 34eaee179689..a4750689e529 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1774,6 +1774,14 @@ void resource_list_free(struct list_head *head)
 EXPORT_SYMBOL(resource_list_free);
 
 #ifdef CONFIG_DEVICE_PRIVATE
+static resource_size_t request_free_min_base;
+
+void set_request_free_min_base(resource_size_t val)
+{
+	request_free_min_base = val;
+}
+EXPORT_SYMBOL_GPL(set_request_free_min_base);
+
 static struct resource *__request_free_mem_region(struct device *dev,
 		struct resource *base, unsigned long size, const char *name)
 {
@@ -1799,7 +1807,8 @@ static struct resource *__request_free_mem_region(struct device *dev,
 	}
 
 	write_lock(&resource_lock);
-	for (; addr > size && addr >= base->start; addr -= size) {
+	for (; addr > size && addr >= max(base->start, request_free_min_base);
+	     addr -= size) {
 		if (__region_intersects(addr, size, 0, IORES_DESC_NONE) !=
 				REGION_DISJOINT)
 			continue;
-- 
2.35.1

