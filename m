Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3138482
	for <nvdimm@lists.linux.dev>; Mon, 14 Nov 2022 20:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668458078; x=1699994078;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tSd4pI/aJIfzbjPmYNaJo/fOcKhBZhna/+CZzU+JRsk=;
  b=Y8TdbKfGGQmCwUb3DUYbavpAmBzO21GzngIuTDVfzyPRb8+/5H00NWcL
   t/mlfejvqVm8G/TLNtX3tP9PGULopOYU+EPjCmFryBPCgstQnoPj1DDJM
   y6d5HduTvXl98rK+MoKo3IrOUtchEW+gJ7a7fkIC31y3yCYjUXY+sWGc9
   KHwc9/MHdxgiNMqDyoiWbKV9LffbcpAV4p4YAyCkapGXtfjWoyvksXTEM
   mavbeE8QaLkWW8RQKEFjqs9zOe75moRm6torHNZaihnUN0QuLd1mmTgKJ
   CF4cPFvVc6wuaE8e8pUZJ+oVz/tlQY/143LRsvnYaWXqKbxnp0gJ36+05
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="292474878"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="292474878"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 12:34:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702155112"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702155112"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 12:34:37 -0800
Subject: [PATCH v4 16/18] cxl/pmem: add provider name to cxl pmem dimm
 attribute group
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Mon, 14 Nov 2022 13:34:37 -0700
Message-ID: 
 <166845807706.2496228.28014749187387664.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add provider name in order to associate cxl test dimm from cxl_test to the
cxl pmem device when going through sysfs for security testing.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-nvdimm |    6 ++++++
 drivers/cxl/pmem.c                         |   10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-nvdimm b/Documentation/ABI/testing/sysfs-bus-nvdimm
index 91945211e53b..d78e4553d9af 100644
--- a/Documentation/ABI/testing/sysfs-bus-nvdimm
+++ b/Documentation/ABI/testing/sysfs-bus-nvdimm
@@ -47,3 +47,9 @@ Date:		November 2022
 KernelVersion:	6.2
 Contact:	Dave Jiang <dave.jiang@intel.com>
 Description:	(RO) Show the id (serial) of the device.
+
+What:		/sys/bus/nd/devices/nmemX/provider
+Date:		November 2022
+KernelVersion:	6.2
+Contact:	Dave Jiang <dave.jiang@intel.com>
+Description:	(RO) Shows the provider for the device. (i.e. ACPI.NFIT, ACPI.CXL)
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 9209c7dd72d0..322f834cc27d 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -48,6 +48,15 @@ static void unregister_nvdimm(void *nvdimm)
 	cxl_nvd->bridge = NULL;
 }
 
+static ssize_t provider_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+
+	return sysfs_emit(buf, "%s\n", dev_name(&cxl_nvd->dev));
+}
+static DEVICE_ATTR_RO(provider);
+
 static ssize_t id_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
@@ -60,6 +69,7 @@ static DEVICE_ATTR_RO(id);
 
 static struct attribute *cxl_dimm_attributes[] = {
 	&dev_attr_id.attr,
+	&dev_attr_provider.attr,
 	NULL
 };
 


