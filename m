Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDA78BF5
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 17:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667928404; x=1699464404;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rgBfxGOSIuZBdf1HzmO2rYPXOAWXLHIYVXQVQnsF3H4=;
  b=R3x1Iyye33KLrp7mLEiUpmadTs5aHx0ikkCWHxpLZexBHz5NFYnSHvdk
   GiCQk1vhEtiDmbnR+6b4mppaJLhuEF5umJ0trJ49SHKLtYy621gE+BRoF
   ouNmwSZNsjzb27op3slVc5p+xHkDkgKbAo9sXDgrOjVorpF++IeFLPS3w
   2sTUJF0TvHlkKwuMwtKi9IG6uLpveVh9UP/FaAcnIBNHDU6+Wn1HYURzg
   kQOaG+U+9tb0/fAJw9pHkJvhSoSzxsHuyLI3wfXmnffY1kMFPR1ZEhkza
   1g0su7pLGvDSYEKNSatseH3nY/v38PTGC/08ZdQHOKDTRnsqKokA7/90R
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="310756027"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="310756027"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="669629906"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="669629906"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:42 -0800
Subject: [PATCH v3 14/18] cxl/pmem: add id attribute to CXL based nvdimm
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Tue, 08 Nov 2022 10:26:42 -0700
Message-ID: 
 <166792840255.3767969.7931186352678182941.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add an id group attribute for CXL based nvdimm object. The addition allows
ndctl to display the "unique id" for the nvdimm. The serial number for the
CXL memory device will be used for this id.

[
  {
      "dev":"nmem10",
      "id":"0x4",
      "security":"disabled"
  },
]

The id attribute is needed by the ndctl security key management to setup a
keyblob with a unique file name tied to the mem device.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-nvdimm |    6 ++++++
 drivers/cxl/pmem.c                         |   28 +++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-nvdimm b/Documentation/ABI/testing/sysfs-bus-nvdimm
index 1c1f5acbf53d..91945211e53b 100644
--- a/Documentation/ABI/testing/sysfs-bus-nvdimm
+++ b/Documentation/ABI/testing/sysfs-bus-nvdimm
@@ -41,3 +41,9 @@ KernelVersion:  5.18
 Contact:        Kajol Jain <kjain@linux.ibm.com>
 Description:	(RO) This sysfs file exposes the cpumask which is designated to
 		to retrieve nvdimm pmu event counter data.
+
+What:		/sys/bus/nd/devices/nmemX/id
+Date:		November 2022
+KernelVersion:	6.2
+Contact:	Dave Jiang <dave.jiang@intel.com>
+Description:	(RO) Show the id (serial) of the device.
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 24bec4ca3866..9209c7dd72d0 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -48,6 +48,31 @@ static void unregister_nvdimm(void *nvdimm)
 	cxl_nvd->bridge = NULL;
 }
 
+static ssize_t id_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+	struct cxl_dev_state *cxlds = cxl_nvd->cxlmd->cxlds;
+
+	return sysfs_emit(buf, "%lld\n", cxlds->serial);
+}
+static DEVICE_ATTR_RO(id);
+
+static struct attribute *cxl_dimm_attributes[] = {
+	&dev_attr_id.attr,
+	NULL
+};
+
+static const struct attribute_group cxl_dimm_attribute_group = {
+	.name = "cxl",
+	.attrs = cxl_dimm_attributes,
+};
+
+static const struct attribute_group *cxl_dimm_attribute_groups[] = {
+	&cxl_dimm_attribute_group,
+	NULL
+};
+
 static int cxl_nvdimm_probe(struct device *dev)
 {
 	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
@@ -77,7 +102,8 @@ static int cxl_nvdimm_probe(struct device *dev)
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
 	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
-	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags,
+	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd,
+				 cxl_dimm_attribute_groups, flags,
 				 cmd_mask, 0, NULL, NULL, cxl_security_ops, NULL);
 	if (!nvdimm) {
 		rc = -ENOMEM;


