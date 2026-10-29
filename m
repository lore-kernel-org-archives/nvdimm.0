Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793317479;
	b=n1yV4S77ey9ZF7nUnXCU1+Dok71gE1eE5nQXbhL84FcR9HLk3q5wLixgUNPp4856KNwU
	 E4zW6aB2+mhW3oL/hzO8oJ9+ecyv5iTEeqOk/4X2+ZTKZ5T7929+LtF6e/Hg7Q9szy1YK
	 unvPkCYP8p4BLRMLlY0PQ0YhIN/0ePRhG0CvV01wcY3sybJnR05Nqkf+6EqmvR7Gb6by9
	 fikV1en4dlWa7jyP9r8SiF3iP3yToCp0q1+EY3FHvu+ZFgKQUazZg4oCkpK95CsSSPsia
	 Pvw3qWRhYvNOigLi5MBxtc3KjiAj2zOaElAyoQO9/DTug5nx4+6alWd6zHGWcxp7OAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793317479;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UJWUF6wnWZroGQ6VwPZOk5pgOTGsd13Wc4WcOsUFh9I=;
	b=ur4yNx4yKSTBKWHb6ZD8q/MG/mfkqnhq7Cd1MZzVHgA2OBVSjfPiClyFcOleiy5VUQ1t
	 ac+W4V/8IZbfdzTaMxT8EwUazCi3AfKRcHhWw9t3XjpBCoAJyREDhCJtFmvPAi6ejVTbw
	 8Tl/+jwtGdJ4VcP6xqcdJaZMKL6IZdP9ngDzaFS2QLLH+YWGpKC55fjLmUlenYmRlu0uW
	 I0rK7G3oYDGw0xL4zQEXKl6Vhs3YcYqI3kD4brR+x56Q5TA0VIrS68fSLZgF1Lixkkv3v
	 pEB8iRvk9bVVYs0z/TY/JmCInPwQ/oYNqDRWhB+nePg1cRRRL7BNvOplW5JnP+YSnTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jxcQQ5OB;
	arc=none smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194A7606A321
	for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 23:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 194A7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jxcQQ5OB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793317461; x=1824853461;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pv+1MBTdrlSH34YF3X0K2DbJu0bsHdKnDSl+JmAWO8Q=;
  b=jxcQQ5OBPGfF25LzSx6//ZyCme7kqvfKjiSuEk/9I7zPiPzU8dhDE+L3
   1VtXaiWT2p0jbiSGjI+CcazKW80OEiXmRtZqfoELSbDN1barJkBEkp5uQ
   3T/ejj3Kqd4u1ddlHJtuwiFr9tSVmx7FJTC4DltxmfSqaFDx3DJlleFg2
   +KDDlXguExMKxt8MbQkzlV1Gr9iPatjkIL5jGVhbkQUO+wneSxGsjtuW6
   2lqacwPmeLahUy4SAVn7DS7r9f9tMU0TNIx8cZbX7H5L2kAl3zekf4yTW
   1BXA5uCGNNFGYR7fLIUffm5bPxlvVfPd5bNV4gcAqnr1BhmKi1pgidAR2
   g==;
X-CSE-ConnectionGUID: HyM55lUfSJ2PsbpHUFVlmg==
X-CSE-MsgGUID: 5lSH4E0bQ5CMCKbAFZsI0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2100445"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="2100445"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:44:09 -0700
X-CSE-ConnectionGUID: 7M13LsodTM2iiTGcRxz71A==
X-CSE-MsgGUID: WAo+hQcASQGAFs+Ggb0qMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="5385218"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.57])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:44:09 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	Gregory Price <gourry@gourry.net>
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 2/4] libdaxctl: tie mapping cache lifetime to the device
Date: Thu, 29 Oct 2026 16:44:01 -0700
Message-ID: <f69d432b0d91c247a801112252db4dfe57a9f8b3.1793315621.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1793315621.git.alison.schofield@intel.com>
References: <cover.1793315621.git.alison.schofield@intel.com>
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
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
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

