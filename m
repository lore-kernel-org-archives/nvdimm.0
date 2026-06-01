Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7671535E1CE
	for <nvdimm@lists.linux.dev>; Mon,  1 Jun 2026 23:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780355442; cv=none; b=lzetDkMCQzjLD7f1HPSubnqhYbYQYvGmmEvqEDSlf2hyl/3iUdzR+Yv6RJdf3FlIrK5lIlZnb+T1ngLfqenPAYkhece6piG9FZ1cZsDnf26ldLdHxDBAdGDP7GmgHzJrao7358h0/N0+PV1sJv7sxr4ipEFBqEAg+adp9LY8OVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780355442; c=relaxed/simple;
	bh=QkDDYHL1L9uH/stCYZ+/QN6adgi29Br4Kiq31HwRUV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JmagB/846W5PdhNkJYUfIyNMXMrILi+LndYUwgbTsk/dPKt/+DK2PoqmiXZDZ+zdsvzxWTuGs9xJyNqEGw8pjDjrVQa4CcV7u/Q/reSHV4JS7AVdSKyMobihNMTdiI20tHIdszfC8Q9X0Y56JtmC94I7NPrbpGAoxU3smXKljBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iyxi5jgy; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iyxi5jgy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780355442; x=1811891442;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QkDDYHL1L9uH/stCYZ+/QN6adgi29Br4Kiq31HwRUV4=;
  b=iyxi5jgyrueXTSzCq2LW2Ase6HvwxE6h206k0i22JpN9gazvHzX0CRt5
   xjw5Gg90bwQAv4FxIKpuhjeZbJKrSKTP1GhWiPwkJurxZeEdCc/akSymB
   JnywNtRllQ7R9eBBfOQh7Y0AR65HFbohKqoT+VYpElqlgeZLsMny6ASgc
   yXcjPRb1cnLbqdmfhFf1VdDKN4IWMZPKeC9C+73ZaCTMnSCu1tYvTVYZR
   /N8XzseFo5nGwjT6KY07pjBKjX2IP/Ayf8/JGpgUVI6Tvyg+2WLK74cSJ
   YJiArMF6urD1lxnof0SuFEzrqT2nWgZsgAHrHp23cSwF/nR0c2fqA4t3j
   g==;
X-CSE-ConnectionGUID: gqYSHw3nSUSp3otJo+n9wQ==
X-CSE-MsgGUID: rYOwARa3Qw+eWxmXIkuo6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="84750068"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="84750068"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 16:10:42 -0700
X-CSE-ConnectionGUID: z0Lr6ZjySLGR0UFlVJ1g6g==
X-CSE-MsgGUID: vEbU0vCUSgOHdbGEdh433A==
X-ExtLoop1: 1
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.108.24]) ([10.125.108.24])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 16:10:38 -0700
Message-ID: <26189ee7-1fba-49c2-94f5-0902a77772ba@intel.com>
Date: Mon, 1 Jun 2026 16:10:37 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 4/9] dax/fsdev: clear dev_dax->pgmap on probe failure
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Dan Williams <djbw@kernel.org>
Cc: John Groves <jgroves@micron.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165053.6653-1-john@jagalactic.com>
 <0100019e79cbc3fa-cdb45b69-de84-4cc0-8aeb-71d0673c1a9c-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e79cbc3fa-cdb45b69-de84-4cc0-8aeb-71d0673c1a9c-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/30/26 9:50 AM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Clear dev_dax->pgmap on probe failure for dynamic devices. After the dynamic
> path sets dev_dax->pgmap, if a later probe step fails, devres frees the
> devm_kzalloc'd pgmap but leaves dev_dax->pgmap dangling.  Subsequent probe
> attempts would hit the "dynamic-dax with pre-populated page map" check and fail
> permanently. Use a goto cleanup to NULL dev_dax->pgmap on error.
> 
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/fsdev.c | 32 +++++++++++++++++++++++---------
>  1 file changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index dbd722ed7ab05..42aac7e952516 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -223,6 +223,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  {
>  	struct dax_device *dax_dev = dev_dax->dax_dev;
>  	struct device *dev = &dev_dax->dev;
> +	bool pgmap_allocated = false;
>  	struct dev_pagemap *pgmap;
>  	struct inode *inode;
>  	u64 data_offset = 0;
> @@ -253,6 +254,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  
>  		pgmap->nr_range = dev_dax->nr_range;
>  		dev_dax->pgmap = pgmap;
> +		pgmap_allocated = true;
>  
>  		for (i = 0; i < dev_dax->nr_range; i++) {
>  			struct range *range = &dev_dax->ranges[i].range;
> @@ -268,7 +270,8 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  					range_len(range), dev_name(dev))) {
>  			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve range\n",
>  				 i, range->start, range->end);
> -			return -EBUSY;
> +			rc = -EBUSY;
> +			goto err_pgmap;
>  		}
>  	}
>  
> @@ -288,8 +291,10 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  	pgmap->owner = dev_dax;
>  
>  	addr = devm_memremap_pages(dev, pgmap);
> -	if (IS_ERR(addr))
> -		return PTR_ERR(addr);
> +	if (IS_ERR(addr)) {
> +		rc = PTR_ERR(addr);
> +		goto err_pgmap;
> +	}
>  
>  	/*
>  	 * Clear any stale compound folio state left over from a previous
> @@ -301,7 +306,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  	rc = devm_add_action_or_reset(dev, fsdev_clear_folio_state_action,
>  				      dev_dax);
>  	if (rc)
> -		return rc;
> +		goto err_pgmap;
>  
>  	/* Detect whether the data is at a non-zero offset into the memory */
>  	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
> @@ -323,23 +328,32 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  	cdev_set_parent(cdev, &dev->kobj);
>  	rc = cdev_add(cdev, dev->devt, 1);
>  	if (rc)
> -		return rc;
> +		goto err_pgmap;
>  
>  	rc = devm_add_action_or_reset(dev, fsdev_cdev_del, cdev);
>  	if (rc)
> -		return rc;
> +		goto err_pgmap;
>  
>  	/* Set the dax operations for fs-dax access path */
>  	rc = dax_set_ops(dax_dev, &dev_dax_ops);
>  	if (rc)
> -		return rc;
> +		goto err_pgmap;
>  
>  	rc = devm_add_action_or_reset(dev, fsdev_clear_ops, dev_dax);
>  	if (rc)
> -		return rc;
> +		goto err_pgmap;
>  
>  	run_dax(dax_dev);
> -	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
> +	rc = devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
> +	if (rc)
> +		goto err_pgmap;
> +
> +	return 0;
> +
> +err_pgmap:
> +	if (pgmap_allocated)
> +		dev_dax->pgmap = NULL;
> +	return rc;
>  }
>  
>  static struct dax_device_driver fsdev_dax_driver = {


How about something like this to ditch the gotos?

---

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index dbd722ed7ab0..cb309847e685 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -219,6 +219,41 @@ static const struct file_operations fsdev_fops = {
 	.release = fsdev_release,
 };
 
+static struct dev_pagemap *fsdev_acquire_pgmap(struct dev_dax *dev_dax)
+{
+	struct device *dev = &dev_dax->dev;
+	struct dev_pagemap *pgmap;
+	size_t pgmap_size;
+
+	if (static_dev_dax(dev_dax)) {
+		if (dev_dax->nr_range > 1) {
+			dev_warn(dev,
+				 "static vs multi-range device conflict\n");
+			return ERR_PTR(-EINVAL);
+		}
+
+		pgmap = dev_dax->pgmap;
+		pgmap->vmemmap_shift = 0;
+		return pgmap;
+	}
+
+	if (dev_dax->pgmap) {
+		dev_warn(dev, "dynamic-dax with pre-populated page map\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
+	pgmap = devm_kzalloc(dev, pgmap_size, GFP_KERNEL);
+	if (!pgmap)
+		return ERR_PTR(-ENOMEM);
+
+	pgmap->nr_range = dev_dax->nr_range;
+	for (int i = 0; i < dev_dax->nr_range; i++)
+		pgmap->ranges[i] = dev_dax->ranges[i].range;
+
+	return pgmap;
+}
+
 static int fsdev_dax_probe(struct dev_dax *dev_dax)
 {
 	struct dax_device *dax_dev = dev_dax->dax_dev;
@@ -230,36 +265,9 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	void *addr;
 	int rc, i;
 
-	if (static_dev_dax(dev_dax)) {
-		if (dev_dax->nr_range > 1) {
-			dev_warn(dev, "static pgmap / multi-range device conflict\n");
-			return -EINVAL;
-		}
-
-		pgmap = dev_dax->pgmap;
-		pgmap->vmemmap_shift = 0;
-	} else {
-		size_t pgmap_size;
-
-		if (dev_dax->pgmap) {
-			dev_warn(dev, "dynamic-dax with pre-populated page map\n");
-			return -EINVAL;
-		}
-
-		pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
-		pgmap = devm_kzalloc(dev, pgmap_size, GFP_KERNEL);
-		if (!pgmap)
-			return -ENOMEM;
-
-		pgmap->nr_range = dev_dax->nr_range;
-		dev_dax->pgmap = pgmap;
-
-		for (i = 0; i < dev_dax->nr_range; i++) {
-			struct range *range = &dev_dax->ranges[i].range;
-
-			pgmap->ranges[i] = *range;
-		}
-	}
+	pgmap = fsdev_acquire_pgmap(dev_dax);
+	if (IS_ERR(pgmap))
+		return PTR_ERR(pgmap);
 
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range *range = &dev_dax->ranges[i].range;
@@ -306,7 +314,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	/* Detect whether the data is at a non-zero offset into the memory */
 	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
 		u64 phys = dev_dax->ranges[0].range.start;
-		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
+		u64 pgmap_phys = pgmap[0].range.start;
 
 		if (!WARN_ON(pgmap_phys > phys))
 			data_offset = phys - pgmap_phys;
@@ -339,7 +347,12 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		return rc;
 
 	run_dax(dax_dev);
-	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
+	rc = devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
+	if (rc)
+		return rc;
+
+	dev_dax->pgmap = pgmap;
+	return 0;
 }
 
 static struct dax_device_driver fsdev_dax_driver = {

