Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA76E1DE8AF
	for <nvdimm@lists.linux.dev>; Mon,  7 Oct 2024 23:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343035; cv=none; b=fX9O5A4dW2m2ZKdjRDPf49dRg6wyqz574z1IcL6oRjG0hkhwdPLHWE1BdrpZn67Rdx2sR+PtgBRvli8vGsMFU41gva0vc/EhV5TeU1bx71O6Io7k6glqgCl07f4S0NfcLozxBT+FsvqaBrxjxOOz7jZew9CQj9+5mmWDf3xUXnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343035; c=relaxed/simple;
	bh=oySoVzqba1kb9G76fXV+2nmWRG0tWG+HBET/md+uTvc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hwqdkWWAFyJwY1y6d8RMECzXFD8/NEpUSnZINKjZEf3vSeLN2q+QKaOy8dSODT0ZSb3dqi0WKSVW5sXX4kNbES1hirkiYthZwU2vryX4Vt6X3NeveTBoINOSNxywJGeMoywqNt0yCtlzpseMacTUoozp07rW6e5KiUeFyO9o8sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U74nBX1G; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U74nBX1G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728343034; x=1759879034;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=oySoVzqba1kb9G76fXV+2nmWRG0tWG+HBET/md+uTvc=;
  b=U74nBX1G9Ogc7401fFQI5oRLkO4Y0HNl4v9xF7+Ny4ENDtB0GTPWcLgD
   wQRYzTm/Uh3X+WZ0qDpZSG1VMBAguMI1QlabVsa9RooGoHDlxLZ4ElzTo
   Gh5zPSgWpQUaA9yqUynFPWxPj7yZG/OLEEzRp4Db2pq2LttSgWHmNvGCf
   OPgBLwZq+13VDsOK9SCHtnylLrx9diGoyMPJEV+XrOnok4chpYFWXp2WY
   MnUlI+6e1Jla597cgd/Km9eCJg1MSMtmr5XzP8yj3A7vT2PBY6SkhfMGE
   eO1On9Dk/Q1cpOKHFuuIdosLOXjqTb1TM0/hthg0WFo3eG6i3honWR3hK
   Q==;
X-CSE-ConnectionGUID: SLe9wR8RQw64oNKuywK2ng==
X-CSE-MsgGUID: fn7CcAkSRnKy/QiRM/MHug==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="45036944"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="45036944"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:16:59 -0700
X-CSE-ConnectionGUID: WmluaNqnTeayYzBqIuVj8A==
X-CSE-MsgGUID: 4w1wFf9OS1qPcGB5Q7OgiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="75309139"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:16:56 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Mon, 07 Oct 2024 18:16:21 -0500
Subject: [PATCH v4 15/28] cxl/region: Refactor common create region code
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-dcd-type2-upstream-v4-15-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1728342968; l=2376;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=oySoVzqba1kb9G76fXV+2nmWRG0tWG+HBET/md+uTvc=;
 b=Z9mzbCT9+x9RtElP9/Bu7froCWyfuXRo5gKK5TR3S46FklNREcvIIDcGPomGxXia55hZhPFth
 sNOsavotjsKCE0u9gV/VLwCRbfbHJUivG4IdGLzO2hKEFW+gE5xJKIb
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

create_pmem_region_store() and create_ram_region_store() are identical
with the exception of the region mode.  With the addition of DC region
mode this would end up being 3 copies of the same code.

Refactor create_pmem_region_store() and create_ram_region_store() to use
a single common function to be used in subsequent DC code.

Suggested-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/region.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index ab00203f285a..2ca6148d108c 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2552,9 +2552,8 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
 }
 
-static ssize_t create_pmem_region_store(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t len)
+static ssize_t create_region_store(struct device *dev, const char *buf,
+				   size_t len, enum cxl_region_mode mode)
 {
 	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
 	struct cxl_region *cxlr;
@@ -2564,31 +2563,26 @@ static ssize_t create_pmem_region_store(struct device *dev,
 	if (rc != 1)
 		return -EINVAL;
 
-	cxlr = __create_region(cxlrd, CXL_REGION_PMEM, id);
+	cxlr = __create_region(cxlrd, mode, id);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
 
 	return len;
 }
+
+static ssize_t create_pmem_region_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	return create_region_store(dev, buf, len, CXL_REGION_PMEM);
+}
 DEVICE_ATTR_RW(create_pmem_region);
 
 static ssize_t create_ram_region_store(struct device *dev,
 				       struct device_attribute *attr,
 				       const char *buf, size_t len)
 {
-	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
-	struct cxl_region *cxlr;
-	int rc, id;
-
-	rc = sscanf(buf, "region%d\n", &id);
-	if (rc != 1)
-		return -EINVAL;
-
-	cxlr = __create_region(cxlrd, CXL_REGION_RAM, id);
-	if (IS_ERR(cxlr))
-		return PTR_ERR(cxlr);
-
-	return len;
+	return create_region_store(dev, buf, len, CXL_REGION_RAM);
 }
 DEVICE_ATTR_RW(create_ram_region);
 

-- 
2.46.0

