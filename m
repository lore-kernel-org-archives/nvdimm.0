Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832FA6AD6;
	Fri, 26 Jan 2024 02:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235387; cv=none; b=umIF+m0HDGI6FAwcvCS0p5Qj1WmzrLxrovMOnOt1wROIIkbVuJ9tTadVkjfkVI7LxMd92UuDdWnqdjopFRWYGpt8yQ3VIzwfEAudJGpLdG+5cTPcjZPZMmM/pGTYg3Ip4yd3CwyF+gMQPZ0ymx47gznTRv3Owjxzlc+wSk5DWGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235387; c=relaxed/simple;
	bh=O8Z3WDBuYwAf5sk8LKJTmewq7LERzYUHUXzLJpFMstU=;
	h=Date:To:From:Subject:Message-Id; b=k6htbaQ9FtHxkr10KoaInMij5pUFBwMhxou0UDPfcYeGQvB7qW+AkSFoFnCtTh9oyFDJXsNP5D1hMGWhC/nwLqDT8iGx1zAbhnTJxjHdcq6V0hcgEXnk94dQzqUVQcw/WvM6zKTcAxyI4oEpMODAXSJWxUCmSRdJxehDteO7Wfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HOXqOKZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HOXqOKZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B00C433C7;
	Fri, 26 Jan 2024 02:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235387;
	bh=O8Z3WDBuYwAf5sk8LKJTmewq7LERzYUHUXzLJpFMstU=;
	h=Date:To:From:Subject:From;
	b=HOXqOKZu/ykt2In6InTrNky2QgA2Wjl+ifefsRzIICOAjsc/GMsv5/arzAMX5t1e2
	 8lTLohoONWgdXlvgH4EUaKKa/gC1x6CPFtgayOyZqIOh8YdFnKblfmQC6vuB+umEu9
	 pg6KHdzOy5Dm7yup05+n9aoxFGYyYr+d4s1QodIk=
Date: Thu, 25 Jan 2024 18:16:24 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,osalvador@suse.de,nvdimm@lists.linux.dev,mhocko@suse.com,lizhijian@fujitsu.com,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-busc-replace-several-sprintf-with-sysfs_emit.patch added to mm-unstable branch
Message-Id: <20240126021626.E4B00C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>


The patch titled
     Subject: dax/bus.c: replace several sprintf() with sysfs_emit()
has been added to the -mm mm-unstable branch.  Its filename is
     dax-busc-replace-several-sprintf-with-sysfs_emit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-busc-replace-several-sprintf-with-sysfs_emit.patch

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
Subject: dax/bus.c: replace several sprintf() with sysfs_emit()
Date: Wed, 24 Jan 2024 12:03:47 -0800

There were several places where drivers/dax/bus.c uses 'sprintf' to print
sysfs data.  Since a sysfs_emit() helper is available specifically for
this purpose, replace all the sprintf() usage for sysfs with sysfs_emit()
in this file.

Link: https://lkml.kernel.org/r/20240124-vv-dax_abi-v7-2-20d16cb8d23d@intel.com
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <nvdimm@lists.linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/dax/bus.c~dax-busc-replace-several-sprintf-with-sysfs_emit
+++ a/drivers/dax/bus.c
@@ -269,7 +269,7 @@ static ssize_t id_show(struct device *de
 {
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", dax_region->id);
+	return sysfs_emit(buf, "%d\n", dax_region->id);
 }
 static DEVICE_ATTR_RO(id);
 
@@ -278,8 +278,8 @@ static ssize_t region_size_show(struct d
 {
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%llu\n", (unsigned long long)
-			resource_size(&dax_region->res));
+	return sysfs_emit(buf, "%llu\n",
+			  (unsigned long long)resource_size(&dax_region->res));
 }
 static struct device_attribute dev_attr_region_size = __ATTR(size, 0444,
 		region_size_show, NULL);
@@ -289,7 +289,7 @@ static ssize_t region_align_show(struct
 {
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%u\n", dax_region->align);
+	return sysfs_emit(buf, "%u\n", dax_region->align);
 }
 static struct device_attribute dev_attr_region_align =
 		__ATTR(align, 0400, region_align_show, NULL);
@@ -322,7 +322,7 @@ static ssize_t available_size_show(struc
 	size = dax_region_avail_size(dax_region);
 	up_read(&dax_region_rwsem);
 
-	return sprintf(buf, "%llu\n", size);
+	return sysfs_emit(buf, "%llu\n", size);
 }
 static DEVICE_ATTR_RO(available_size);
 
@@ -340,7 +340,7 @@ static ssize_t seed_show(struct device *
 	if (rc)
 		return rc;
 	seed = dax_region->seed;
-	rc = sprintf(buf, "%s\n", seed ? dev_name(seed) : "");
+	rc = sysfs_emit(buf, "%s\n", seed ? dev_name(seed) : "");
 	up_read(&dax_region_rwsem);
 
 	return rc;
@@ -361,7 +361,7 @@ static ssize_t create_show(struct device
 	if (rc)
 		return rc;
 	youngest = dax_region->youngest;
-	rc = sprintf(buf, "%s\n", youngest ? dev_name(youngest) : "");
+	rc = sysfs_emit(buf, "%s\n", youngest ? dev_name(youngest) : "");
 	up_read(&dax_region_rwsem);
 
 	return rc;
@@ -763,7 +763,7 @@ static ssize_t start_show(struct device
 	dax_range = get_dax_range(dev);
 	if (!dax_range)
 		return -ENXIO;
-	rc = sprintf(buf, "%#llx\n", dax_range->range.start);
+	rc = sysfs_emit(buf, "%#llx\n", dax_range->range.start);
 	put_dax_range();
 
 	return rc;
@@ -779,7 +779,7 @@ static ssize_t end_show(struct device *d
 	dax_range = get_dax_range(dev);
 	if (!dax_range)
 		return -ENXIO;
-	rc = sprintf(buf, "%#llx\n", dax_range->range.end);
+	rc = sysfs_emit(buf, "%#llx\n", dax_range->range.end);
 	put_dax_range();
 
 	return rc;
@@ -795,7 +795,7 @@ static ssize_t pgoff_show(struct device
 	dax_range = get_dax_range(dev);
 	if (!dax_range)
 		return -ENXIO;
-	rc = sprintf(buf, "%#lx\n", dax_range->pgoff);
+	rc = sysfs_emit(buf, "%#lx\n", dax_range->pgoff);
 	put_dax_range();
 
 	return rc;
@@ -969,7 +969,7 @@ static ssize_t size_show(struct device *
 	size = dev_dax_size(dev_dax);
 	up_write(&dax_dev_rwsem);
 
-	return sprintf(buf, "%llu\n", size);
+	return sysfs_emit(buf, "%llu\n", size);
 }
 
 static bool alloc_is_aligned(struct dev_dax *dev_dax, resource_size_t size)
@@ -1233,7 +1233,7 @@ static ssize_t align_show(struct device
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 
-	return sprintf(buf, "%d\n", dev_dax->align);
+	return sysfs_emit(buf, "%d\n", dev_dax->align);
 }
 
 static ssize_t dev_dax_validate_align(struct dev_dax *dev_dax)
@@ -1311,7 +1311,7 @@ static ssize_t target_node_show(struct d
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 
-	return sprintf(buf, "%d\n", dev_dax_target_node(dev_dax));
+	return sysfs_emit(buf, "%d\n", dev_dax_target_node(dev_dax));
 }
 static DEVICE_ATTR_RO(target_node);
 
@@ -1327,7 +1327,7 @@ static ssize_t resource_show(struct devi
 	else
 		start = dev_dax->ranges[0].range.start;
 
-	return sprintf(buf, "%#llx\n", start);
+	return sysfs_emit(buf, "%#llx\n", start);
 }
 static DEVICE_ATTR(resource, 0400, resource_show, NULL);
 
@@ -1338,14 +1338,14 @@ static ssize_t modalias_show(struct devi
 	 * We only ever expect to handle device-dax instances, i.e. the
 	 * @type argument to MODULE_ALIAS_DAX_DEVICE() is always zero
 	 */
-	return sprintf(buf, DAX_DEVICE_MODALIAS_FMT "\n", 0);
+	return sysfs_emit(buf, DAX_DEVICE_MODALIAS_FMT "\n", 0);
 }
 static DEVICE_ATTR_RO(modalias);
 
 static ssize_t numa_node_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", dev_to_node(dev));
+	return sysfs_emit(buf, "%d\n", dev_to_node(dev));
 }
 static DEVICE_ATTR_RO(numa_node);
 
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are

dax-busc-replace-driver-core-lock-usage-by-a-local-rwsem.patch
dax-busc-replace-several-sprintf-with-sysfs_emit.patch
documentatiion-abi-add-abi-documentation-for-sys-bus-dax.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory.patch
dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior.patch

