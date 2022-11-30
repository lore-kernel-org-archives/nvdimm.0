Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8BA79C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836183; x=1701372183;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v9NcrftJV0sMf2lmBb5rWylE4XCZdgrIGmE1Wzyw8K4=;
  b=l/XsQLtw92sW0Mw+TYV3aFUFzp3k1Bh8afhulTVE76iN75vgw9DAf3nj
   oPxkQAoxYDmcK7KIL0xV2XOl3VS9xhKVIc1BIiDOnh/6Gthp0WnMXP+Je
   5PU0yp8ddECkr1kfdMv0t/rsz+g850uktySFUhHvobIGn0m8zXAQG3rrB
   O5Zjb7IryMJQSExU72xZKC9LZQOlQR8J6YSEgrpPs8nptg/h/iZpRkOa2
   /oy0rL51OkNsevDzHuUe0J2diq2C/dAdeWJtmyFIqcZWIFePmhcN4Pfv3
   wu3E3+jvkmnY3hTrW47tbQcakH3FgWm3+FOED+NxY8UkdvPNTZAORTUik
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313118672"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="313118672"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:23:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="889415366"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="889415366"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:23:02 -0800
Subject: [PATCH v7 16/20] cxl/pmem: add provider name to cxl pmem dimm
 attribute group
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:23:01 -0700
Message-ID: 
 <166983618174.2734609.15600031015423828810.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
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
Link: https://lore.kernel.org/r/166863355850.80269.1180196889555844539.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-nvdimm |    8 ++++++++
 drivers/cxl/pmem.c                         |   10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-nvdimm b/Documentation/ABI/testing/sysfs-bus-nvdimm
index 178ce207413d..de8c5a59c77f 100644
--- a/Documentation/ABI/testing/sysfs-bus-nvdimm
+++ b/Documentation/ABI/testing/sysfs-bus-nvdimm
@@ -47,3 +47,11 @@ Date:		November 2022
 KernelVersion:	6.2
 Contact:	Dave Jiang <dave.jiang@intel.com>
 Description:	(RO) Show the id (serial) of the device. This is CXL specific.
+
+What:		/sys/bus/nd/devices/nmemX/cxl/provider
+Date:		November 2022
+KernelVersion:	6.2
+Contact:	Dave Jiang <dave.jiang@intel.com>
+Description:	(RO) Shows the CXL bridge device that ties to a CXL memory device
+		to this NVDIMM device. I.e. the parent of the device returned is
+		a /sys/bus/cxl/devices/memX instance.
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 0493ddcfe32c..403e41bcbf2b 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -51,6 +51,15 @@ static void unregister_nvdimm(void *nvdimm)
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
@@ -63,6 +72,7 @@ static DEVICE_ATTR_RO(id);
 
 static struct attribute *cxl_dimm_attributes[] = {
 	&dev_attr_id.attr,
+	&dev_attr_provider.attr,
 	NULL
 };
 


