Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71258482
	for <nvdimm@lists.linux.dev>; Mon, 14 Nov 2022 20:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668458067; x=1699994067;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Js4USYcZRaJSpoXX1b4fn9SJ4aIXwvOtMXi1W+ZEWLk=;
  b=kCU8WFAWkx/j6x/btgDyXbs7NgadK/SqiUvkH5kUtiHy1WfRfsUWYytG
   Kb9PdT2VILcR0oFdEmNSmjCdz6zBd72edqzp+a3cAClzy+zdqo8ZMlb0z
   BAcPPrcbQCgYCaJX9oMHL8k7qKerrR12tjO6ABmadwzCHNNkRW0+Sfn1r
   To21yYKn81KOrDWT0FlA4mHyX/aDR/+fUGLUvkuKAm/ZmmW2/gioye9iz
   8OWTZXSnYshHHhGdMNw3ISeYYK4qYh5UNFr1YorXovjrbYUtaNjqCnL9B
   PJqqBrvw7n1v+JooNxMQw5DgPdhlLTts2F2mDq+vgOMd0XFXRzYfqGOsk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="309705303"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="309705303"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 12:34:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702155069"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702155069"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 12:34:25 -0800
Subject: [PATCH v4 14/18] cxl/pmem: add id attribute to CXL based nvdimm
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Mon, 14 Nov 2022 13:34:25 -0700
Message-ID: 
 <166845806563.2496228.18325005500020577758.stgit@djiang5-desk3.ch.intel.com>
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

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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


