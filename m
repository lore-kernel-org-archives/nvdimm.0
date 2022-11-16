Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1A112290
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 21:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668633560; x=1700169560;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tSd4pI/aJIfzbjPmYNaJo/fOcKhBZhna/+CZzU+JRsk=;
  b=mxk3FJRcuSBOOArOnZbJRhUzIW/J0bH2CKItXJFQEGckMzBGTP5skOpB
   UPkajI4WVeN3tNdnw+anWKl7UJy/WTLtFWDPKc1xWbdvtAELAn5IkxbwY
   BDhi9mwLN3T/obfRZOUJkhAUrLNfCHz7D/zeitg3iwkdWCYs/N+HO/0SH
   BYD18uGdpgV1D6zb+3KxaPWhgcbGYSln72wFjb847RSF3k0mlNhMCSxYT
   Y8CDctjIZq2CA2FWuzobQnnzD1TIGArCadNexedHdQBE3SYrN7VsDU8Mf
   W81+UulgynEvI4UWWBzR0CIzoX2FhEPlLBEQmSXp1gpaodquyLOGzHxAs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="312686471"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="312686471"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:19:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="670654279"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="670654279"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:19:18 -0800
Subject: [PATCH v5 16/18] cxl/pmem: add provider name to cxl pmem dimm
 attribute group
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net,
 benjamin.cheatham@amd.com
Date: Wed, 16 Nov 2022 14:19:18 -0700
Message-ID: 
 <166863355850.80269.1180196889555844539.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
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
 


