Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BC76AD6;
	Fri, 26 Jan 2024 02:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235402; cv=none; b=X4rIjYVji+hAvWiTpfLryEk1tiGqyTSPYu5lbkAGI3ASi1D/TDtiYYh+cDr/PmCOXYJ/WZnXWUGql/kmdTsaUL2o0cZvkxSr5teWwSCUJaB4Q6C9Pvr5c/+sQ3+zyshsbWFvyc9Kpd8r4KvnIV35LB9iwGUN9B2RoKXb2iA35mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235402; c=relaxed/simple;
	bh=KX1g7BnrjO9YTYHP+jTCG8fwDO7do9KS0BWOGiHsFyM=;
	h=Date:To:From:Subject:Message-Id; b=tScDBkzEwgojAgBwMyGCT1AEvExU6Ti7019lC9FM7Uqry/Ro+fieu8P+4RUBMxWHDJYMR8ooF5fwbaGci4VPRL/tYVQXbX7mF2bcHnut9oKFuVGUMoi5oFXU9kdZmx+8kQLrGFrdoAbEmnsHLdLtg0tBxi2v33z41/TWm/Nm4Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ChaeGbYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ChaeGbYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E92C433C7;
	Fri, 26 Jan 2024 02:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235402;
	bh=KX1g7BnrjO9YTYHP+jTCG8fwDO7do9KS0BWOGiHsFyM=;
	h=Date:To:From:Subject:From;
	b=ChaeGbYaw/Cf0FZvztKg8iF3coLH3EXPAop4zQQhOdkxVmonKWWW/SBtz1L50+QJG
	 tfEcqI3hk8/IQ+JMIvRWC4k95PSsbTDgXZRhKHZAKp02/5wKNzqilhun5ybkt8bcut
	 axljmpbgCUFHXpf/A/+Ae/VT1GA1G1su/F7/Gloc=
Date: Thu, 25 Jan 2024 18:16:39 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,osalvador@suse.de,nvdimm@lists.linux.dev,mhocko@suse.com,lizhijian@fujitsu.com,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior.patch added to mm-unstable branch
Message-Id: <20240126021642.31E92C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>


The patch titled
     Subject: dax: add a sysfs knob to control memmap_on_memory behavior
has been added to the -mm mm-unstable branch.  Its filename is
     dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: dax: add a sysfs knob to control memmap_on_memory behavior
Date: Wed, 24 Jan 2024 12:03:50 -0800

Add a sysfs knob for dax devices to control the memmap_on_memory setting
if the dax device were to be hotplugged as system memory.

The default memmap_on_memory setting for dax devices originating via pmem
or hmem is set to 'false' - i.e.  no memmap_on_memory semantics, to
preserve legacy behavior.  For dax devices via CXL, the default is on. 
The sysfs control allows the administrator to override the above defaults
if needed.

Link: https://lkml.kernel.org/r/20240124-vv-dax_abi-v7-5-20d16cb8d23d@intel.com
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Huang, Ying <ying.huang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <nvdimm@lists.linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-bus-dax |   17 ++++++++
 drivers/dax/bus.c                       |   43 ++++++++++++++++++++++
 2 files changed, 60 insertions(+)

--- a/Documentation/ABI/testing/sysfs-bus-dax~dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior
+++ a/Documentation/ABI/testing/sysfs-bus-dax
@@ -134,3 +134,20 @@ KernelVersion:	v5.1
 Contact:	nvdimm@lists.linux.dev
 Description:
 		(RO) The id attribute indicates the region id of a dax region.
+
+What:		/sys/bus/dax/devices/daxX.Y/memmap_on_memory
+Date:		January, 2024
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
--- a/drivers/dax/bus.c~dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior
+++ a/drivers/dax/bus.c
@@ -1349,6 +1349,48 @@ static ssize_t numa_node_show(struct dev
 }
 static DEVICE_ATTR_RO(numa_node);
 
+static ssize_t memmap_on_memory_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sysfs_emit(buf, "%d\n", dev_dax->memmap_on_memory);
+}
+
+static ssize_t memmap_on_memory_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	bool val;
+	int rc;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return rc;
+
+	if (val == true && !mhp_supports_memmap_on_memory()) {
+		dev_dbg(dev, "memmap_on_memory is not available\n");
+		return -EOPNOTSUPP;
+	}
+
+	rc = down_write_killable(&dax_dev_rwsem);
+	if (rc)
+		return rc;
+
+	if (dev_dax->memmap_on_memory != val && dev->driver &&
+	    to_dax_drv(dev->driver)->type == DAXDRV_KMEM_TYPE) {
+		up_write(&dax_dev_rwsem);
+		return -EBUSY;
+	}
+
+	dev_dax->memmap_on_memory = val;
+	up_write(&dax_dev_rwsem);
+
+	return len;
+}
+static DEVICE_ATTR_RW(memmap_on_memory);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1375,6 +1417,7 @@ static struct attribute *dev_dax_attribu
 	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_memmap_on_memory.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are

dax-busc-replace-driver-core-lock-usage-by-a-local-rwsem.patch
dax-busc-replace-several-sprintf-with-sysfs_emit.patch
documentatiion-abi-add-abi-documentation-for-sys-bus-dax.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory.patch
dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior.patch

