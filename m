Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03B963CD
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 04:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dvzCuBV+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701923396; x=1733459396;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=GLP9N2ferQtSs1kZ5RuoBDkk5vqBcdypuQXPjkQVI40=;
  b=dvzCuBV+2m/MZW4OrsAE9c7LO5pFb0QClWWtDBLsboeUwmcGFW4s8Mv/
   z1gqkKD78mxKDuMZJIUhp6d2OMafY8n/FS47qQdhG/zErkSosW88OTLpn
   1oF/Tv+5wAJhO1FTWIV9mSrSCTzrFyXgIfu2KO/SWh03m6YELawmyNMiT
   Jm/G/8ejt66nXiDvc+W6EP6dZjFMvks0Z0Kq9gwyIoGBmS3KghYsFQk/1
   5oWtlQKYPt7lenSASWajcU7GoequkOeLs7a7q7YnO55mGe4h/O4tIB1k7
   jpX/Ede6dNCyqo1ln7llOzZ7rI1kHO0iN0UEfewSxosAJ1hx1CRg7aqhl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="398052150"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="398052150"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 20:29:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="800586760"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="800586760"
Received: from apbrezen-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.160.175])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 20:29:51 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 06 Dec 2023 21:29:16 -0700
Subject: [PATCH 2/2] dax: add a sysfs knob to control memmap_on_memory
 behavior
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231206-vv-dax_abi-v1-2-474eb88e201c@intel.com>
References: <20231206-vv-dax_abi-v1-0-474eb88e201c@intel.com>
In-Reply-To: <20231206-vv-dax_abi-v1-0-474eb88e201c@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
Cc: David Hildenbrand <david@redhat.com>, Dave Jiang <dave.jiang@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Huang Ying <ying.huang@intel.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-26615
X-Developer-Signature: v=1; a=openpgp-sha256; l=3572;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=GLP9N2ferQtSs1kZ5RuoBDkk5vqBcdypuQXPjkQVI40=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKmFXnb7t2/e3FLkaOb683l6p6ECpxrvy73SHnFeidL3m
 rcz3grqKGVhEONikBVTZPm75yPjMbnt+TyBCY4wc1iZQIYwcHEKwES0rjMy/PgvpXYp+Ha7iP1z
 s4ruc4v3a83UfH78RE4J+9pnhYIHjRj+1yk9/GruyV7o3JjjIBa9lJlfySZsRQvLuoCrTy/Yf2/
 iAQA=
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
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c                       | 40 +++++++++++++++++++++++++++++++++
 Documentation/ABI/testing/sysfs-bus-dax | 13 +++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1ff1ab5fa105..11abb57cc031 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1270,6 +1270,45 @@ static ssize_t numa_node_show(struct device *dev,
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
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_region *dax_region = dev_dax->region;
+	ssize_t rc;
+	bool val;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return rc;
+
+	if (dev_dax->memmap_on_memory == val)
+		return len;
+
+	device_lock(dax_region->dev);
+	if (!dax_region->dev->driver) {
+		device_unlock(dax_region->dev);
+		return -ENXIO;
+	}
+
+	device_lock(dev);
+	dev_dax->memmap_on_memory = val;
+	device_unlock(dev);
+
+	device_unlock(dax_region->dev);
+	return rc == 0 ? len : rc;
+}
+static DEVICE_ATTR_RW(memmap_on_memory);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1296,6 +1335,7 @@ static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_memmap_on_memory.attr,
 	NULL,
 };
 
diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index a61a7b186017..bb063a004e41 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -149,3 +149,16 @@ KernelVersion:	v5.1
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
+		device being hotplugged (memmap_on+memory=1) or if it will be
+		placed on regular memory (memmap_on_memory=0). This attribute
+		must be set before the device is handed over to the 'kmem'
+		driver (i.e.  hotplugged into system-ram).

-- 
2.41.0

