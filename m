Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB40E8005E
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 19:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V7iFVHfo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702408132; x=1733944132;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=vTibnNia0m6NhSJs+iWLq3VahLdeYpQQkT1+4mwIgB4=;
  b=V7iFVHfoY/MIg33HtgU9ziQ0NjbKkWEBGEdnQdXNK+QliSFm+RRvP1Pt
   jx9RnnnH0lE3ngEPpscNk0RHjNW52epdOCuP5fVy2NHhCf798hU3qMbvv
   7QhjAVmTq2PPfnGFSMF+yz7aILseKc/Zqh24sjeKqqPLK8xlG/p1GcSAU
   7GDPOxRlHp6lpsaGZxPzMuJ/Ya/VVLJOY383nQin3GQgEZjuJCIk7FvAs
   u8M1/CN1ImeStvrtrDBUI40+sPSRqoofQ0VYu/nr8wWDJjWYM8DRC9EFZ
   COdtOi8ouBfp/sV3t1CjMx8xHZS41o3dqCE+v2ko7RN77mTxY7uja2WNe
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="13550599"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="13550599"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 11:08:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="844017864"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="844017864"
Received: from cmperez2-mobl2.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.66.25])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 11:08:47 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 12 Dec 2023 12:08:32 -0700
Subject: [PATCH v4 3/3] dax: add a sysfs knob to control memmap_on_memory
 behavior
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231212-vv-dax_abi-v4-3-1351758f0c92@intel.com>
References: <20231212-vv-dax_abi-v4-0-1351758f0c92@intel.com>
In-Reply-To: <20231212-vv-dax_abi-v4-0-1351758f0c92@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Huang Ying <ying.huang@intel.com>, Li Zhijian <lizhijian@fujitsu.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
X-Mailer: b4 0.13-dev-433a8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3733;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=vTibnNia0m6NhSJs+iWLq3VahLdeYpQQkT1+4mwIgB4=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKkV6/eGzgvpDIjI2VB4MUV8v1HGFaXvqUqPjRxU7QQCG
 y6fvfmyo5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABNx2cvwz1j+5PvunqhiqR3P
 mjfIVipLnm6YtOpDe4iNsoWtxoPzLIwMlx02Ru3YvTtjqfq+sg6NPF3butUeWav+XPN8E+q7c6I
 3KwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Add a sysfs knob for dax devices to control the memmap_on_memory setting
if the dax device were to be hotplugged as system memory.

The default memmap_on_memory setting for dax devices originating via
pmem or hmem is set to 'false' - i.e. no memmap_on_memory semantics, to
preserve legacy behavior. For dax devices via CXL, the default is on.
The sysfs control allows the administrator to override the above
defaults if needed.

Cc: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c                       | 32 ++++++++++++++++++++++++++++++++
 Documentation/ABI/testing/sysfs-bus-dax | 17 +++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index ce1356ac6dc2..423adee6f802 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1245,6 +1245,37 @@ static ssize_t numa_node_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(numa_node);
 
+static ssize_t memmap_on_memory_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sprintf(buf, "%d\n", dev_dax->memmap_on_memory);
+}
+
+static ssize_t memmap_on_memory_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	struct dax_device_driver *dax_drv = to_dax_drv(dev->driver);
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	ssize_t rc;
+	bool val;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return rc;
+
+	guard(device)(dev);
+	if (dev_dax->memmap_on_memory != val &&
+	    dax_drv->type == DAXDRV_KMEM_TYPE)
+		return -EBUSY;
+	dev_dax->memmap_on_memory = val;
+
+	return len;
+}
+static DEVICE_ATTR_RW(memmap_on_memory);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1271,6 +1302,7 @@ static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_memmap_on_memory.attr,
 	NULL,
 };
 
diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index a61a7b186017..b1fd8bf8a7de 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -149,3 +149,20 @@ KernelVersion:	v5.1
 Contact:	nvdimm@lists.linux.dev
 Description:
 		(RO) The id attribute indicates the region id of a dax region.
+
+What:		/sys/bus/dax/devices/daxX.Y/memmap_on_memory
+Date:		October, 2023
+KernelVersion:	v6.8
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Control the memmap_on_memory setting if the dax device
+		were to be hotplugged as system memory. This determines whether
+		the 'altmap' for the hotplugged memory will be placed on the
+		device being hotplugged (memmap_on_memory=1) or if it will be
+		placed on regular memory (memmap_on_memory=0). This attribute
+		must be set before the device is handed over to the 'kmem'
+		driver (i.e.  hotplugged into system-ram). Additionally, this
+		depends on CONFIG_MHP_MEMMAP_ON_MEMORY, and a globally enabled
+		memmap_on_memory parameter for memory_hotplug. This is
+		typically set on the kernel command line -
+		memory_hotplug.memmap_on_memory set to 'true' or 'force'."

-- 
2.41.0

