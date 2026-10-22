Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792698979;
	b=Dqqlh7n5cJwE+u1MnxyMTFE/yKphNEDoU8JSEgTkQk21x7pXXKhIMYSO3XN/lJ29JvCr
	 9q0cMDelbT9HLZqmcnbey3foF39TF1Q7IRHESB8/bhrIfoa+nI57vf/btCV50N6LWr8I2
	 xzgIa5FbK9/gqiKdGCdHYV1qMwCwciz4cXr+qZHbHwkMbS+E09lBVctTUNA1rdkuNoc0x
	 EGG3yh8kohimETHu8gqVatB4d/7mk5YY85nwr2R5izJtRj3BWc7yNHQbXzHsaTFDl4eaY
	 EqWFPaJNB0eLG9BZu3RzfDvGEO5Mrh6OA6VKJzv1T2lyFimFFXJNbERZpPphaKZPrCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792698979;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VCcl/HYnCwHmpJGyXY7hNoTt27osOIu6zxBGaq/VIw4=;
	b=dPXstF3MX5YRvyulGIIUfKF/g1bBk+hIC8Kf71SIb6CN2Up7lB5+KSgPWFy+/uc6KWHN
	 rhxy9uW6Jzzl7XrQaV8+MJ0mXAqHo/08PGmUuQOJYAG4xvjg+il1lOHL7Ux+FcgT5eM/e
	 USLYRkot2tvMVwKxLuSStpTKCrNsDedHi/UvYVZQzrglsmBDQHb/eT7yQNSH2RO1zrPz3
	 sQFT3BDwnXCagfRqynqbcJ0J8bV2rHMZLK3cdnpmm7HsZuwP6ODepsNTVpY4xIi0vA95P
	 F9telz2ctQbXa7lKGLXJs33QoUwbuEOO9ZkP052u6cb9b60a5MAzqav/nCfQKviNd0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TIOo0Xdn;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9E6606A320
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 19:56:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF9E6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TIOo0Xdn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792698979; x=1824234979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KopajrRM1T8jMSl3Dj4YuVFtbspqWdSeiZJiPQc+VZ0=;
  b=TIOo0Xdny8ZyylUwDaRPqzeRr6dKbkoKmivgVzqeDhzAqmV31z1ZJ9TD
   D5KQCBRYR5EjOvutDGAHAVsvZyXZkKpF9jkZgzRcZa7VZSjDcgDg6jOD2
   vDS7N7m/9oonTKnzR8wZrmXlbLc2RL82xPMFh7w9qhSFK3p2RHuLTbZk6
   SnQRzSoniGi3NCgCh/TcO1WklJZ/KoqdncOazaYanFDhQsgQinq4Kpss9
   wR6R8Qh0UnTWAfXox0Kq7xhLJTiaDW4M7n0ZKS1JDyBqvdDLhjxt+s+6r
   PO/cuqgPZp85kd8mGjVVE02UT+Bh2xtZRXfiZg9BZD4pZxVxnZM1DESd/
   Q==;
X-CSE-ConnectionGUID: YYEvW/GWQLmWT2SY4PU4uw==
X-CSE-MsgGUID: EXGAR/QgSBWxmLXXyNUBog==
X-IronPort-AV: E=McAfee;i="6800,10657,11943"; a="1356735"
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="1356735"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 12:56:18 -0700
X-CSE-ConnectionGUID: 4V4ngkMrRQe92HwAmb69+Q==
X-CSE-MsgGUID: CCF1i54hR1WN+OPXjZNHCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="3839582"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.111.215])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 12:56:18 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	Gregory Price <gourry@gourry.net>
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 2/4] libdaxctl: tie mapping cache lifetime to the device
Date: Thu, 22 Oct 2026 12:56:11 -0700
Message-ID: <6b3b42e253c4aca3f4c080d0a7698a09ef24465e.1792695259.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1792695259.git.alison.schofield@intel.com>
References: <cover.1792695259.git.alison.schofield@intel.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cached mappings are not freed when a device is destroyed or invalidated
when its ranges change. This leaks memory and can leave callers using
obsolete physical address ranges, potentially operating on memory blocks
that no longer belong to the device.

Free mappings on device destruction and invalidate the cache when device
ranges may have changed.

Fixes: 5a31bf710399 ("libdaxctl: add mapping iterator APIs")
Fixes: 52a2653098a5 ("libdaxctl: add daxctl_dev_set_mapping()")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 daxctl/lib/libdaxctl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index f630f4791f59..f7cbf3fa12e7 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -241,6 +241,7 @@ static void free_dev(struct daxctl_dev *dev, struct list_head *head)
 	free(dev->dev_buf);
 	free(dev->dev_path);
 	free_mem(dev);
+	free_mappings(dev);
 	free(dev);
 }
 
@@ -593,14 +594,15 @@ static void *add_dax_dev(void *parent, int id, const char *daxdev_base)
 	else
 		dev->target_node = -1;
 
+	dev->num_mappings = -1;
+	list_head_init(&dev->mappings);
+
 	daxctl_dev_foreach(region, dev_dup)
 		if (dev_dup->id == dev->id) {
 			free_dev(dev, NULL);
 			free(path);
 			return dev_dup;
 		}
-	dev->num_mappings = -1;
-	list_head_init(&dev->mappings);
 	list_add(&region->devices, &dev->list);
 	free(path);
 	return dev;
@@ -1186,6 +1188,7 @@ DAXCTL_EXPORT int daxctl_dev_set_size(struct daxctl_dev *dev, unsigned long long
 	}
 
 	sprintf(buf, "%#llx\n", size);
+	free_mappings(dev);
 	if (sysfs_write_attr(ctx, path, buf) < 0) {
 		err(ctx, "%s: failed to set size\n",
 				daxctl_dev_get_devname(dev));
@@ -1242,6 +1245,7 @@ DAXCTL_EXPORT int daxctl_dev_set_mapping(struct daxctl_dev *dev,
 	}
 
 	sprintf(buf, "%#llx-%#llx\n", start, end);
+	free_mappings(dev);
 	if (sysfs_write_attr(ctx, path, buf) < 0) {
 		err(ctx, "%s: failed to set mapping\n",
 				daxctl_dev_get_devname(dev));
-- 
2.37.3

