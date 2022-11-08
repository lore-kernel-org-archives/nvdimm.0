Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9C28BF5
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 17:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667928442; x=1699464442;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n0/pcbE4ZjVgwMg1SOoK/dovZj1TG14tnk/8bsTdTDI=;
  b=GpgF8hHieYOVhC+L/93oZb6vCRpOQJNl4NVptQFfIZ5bXtbayv98p0ob
   6WGvKCuBxNjOHUkriMkav2tB5agfSG3E9oQJ+5j+/xR+pDI2VdEHC768H
   HecR4mu6bZMvmhkB8ezvOzSBLdqHe7Ym1g2Wh1MAU7u96Q5HIxwTdqh/p
   WWhbnx5zyXgc9FaWImRRQ+cPQtD44pkaYC8c0U0/zYzSQs2x96aSyscMl
   hU08WRvCY2pLvaUDuq+adk5Ig4Gdm58FhKbcorY/MuXiShFgnuiWWnU1V
   eGQumRCTNKARz6wKIMptAJvmsmAka7YDRRMwObZfLtNDsm+3Z08bn9T2l
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="311913992"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="311913992"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="705378666"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="705378666"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:54 -0800
Subject: [PATCH v3 16/18] cxl/pmem: add provider name to cxl pmem dimm
 attribute group
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Tue, 08 Nov 2022 10:26:54 -0700
Message-ID: 
 <166792841412.3767969.837651453603473607.stgit@djiang5-desk3.ch.intel.com>
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

Add provider name in order to associate cxl test dimm from cxl_test to the
cxl pmem device when going through sysfs for security testing.

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
 


