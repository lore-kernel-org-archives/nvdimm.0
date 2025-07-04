Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9792C15AE
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 11:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751628548; cv=none; b=sOLsKTIImD1wor/9XGGoOAM+VL5lpKAboF8ofko0X6aUZT3FD/d6Z2TMMVkB67Hg4WU9WEaeie3cZsZ4jwqK4vWssxeLZ5Fi4kG4ort8vPmJad2+88IhzIM5r+Z10EazUmaEm44qsQQL8WWUj0UIYsj6+gs56ic6ZuW31Ep0qhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751628548; c=relaxed/simple;
	bh=d6izWEeJk2kJa5GSgadR6b2xMlIhvrbazcDk3EqyLmc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jcc/oDYGVbW84+Z0T4wMgxExsmY6G2hqy2q9lQiora/SPMVlJzSkHxNeFKrHjbtJ5dt2ZPcg4qjsy0ZfwEEqr359kA+AworHQgRXUFvCWC24XuLdZNXc1WSq/4ro/HFbRIKVSMGTcTjuixV4LBmQ3aMQshmDsxvsBnew5z/wZ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bYW8R3VnVz6L5dh;
	Fri,  4 Jul 2025 19:08:23 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 36B8E1404C5;
	Fri,  4 Jul 2025 19:11:22 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 4 Jul
 2025 13:11:20 +0200
Date: Fri, 4 Jul 2025 12:11:19 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: John Groves <John@Groves.net>
CC: Dan Williams <dan.j.williams@intel.com>, Miklos Szeredi
	<miklos@szeredb.hu>, Bernd Schubert <bschubert@ddn.com>, John Groves
	<jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Matthew
 Wilcox" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Darrick J
 . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, "Jeff
 Layton" <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, "Stefan
 Hajnoczi" <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef
 Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, Ajay
 Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 03/18] dev_dax_iomap: Save the kva from memremap
Message-ID: <20250704121119.00002846@huawei.com>
In-Reply-To: <20250703185032.46568-4-john@groves.net>
References: <20250703185032.46568-1-john@groves.net>
	<20250703185032.46568-4-john@groves.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Thu,  3 Jul 2025 13:50:17 -0500
John Groves <John@Groves.net> wrote:

> Save the kva from memremap because we need it for iomap rw support.
> 
> Prior to famfs, there were no iomap users of /dev/dax - so the virtual
> address from memremap was not needed.
> 
> Also: in some cases dev_dax_probe() is called with the first
> dev_dax->range offset past the start of pgmap[0].range. In those cases
> we need to add the difference to virt_addr in order to have the physaddr's
> in dev_dax->ranges match dev_dax->virt_addr.
> 
> This happens with devdax devices that started as pmem and got converted
> to devdax. I'm not sure whether the offset is due to label storage, or
> page tables, but this works in all known cases.

Clearly a question we need to resolve to understand if this is correct
handling.

> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/dax-private.h |  1 +
>  drivers/dax/device.c      | 15 +++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 0867115aeef2..2a6b07813f9f 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -81,6 +81,7 @@ struct dev_dax_range {
>  struct dev_dax {
>  	struct dax_region *region;
>  	struct dax_device *dax_dev;
> +	void *virt_addr;
>  	unsigned int align;
>  	int target_node;
>  	bool dyn_id;
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 29f61771fef0..583150478dcc 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -372,6 +372,7 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
>  	struct dax_device *dax_dev = dev_dax->dax_dev;
>  	struct device *dev = &dev_dax->dev;
>  	struct dev_pagemap *pgmap;
> +	u64 data_offset = 0;
>  	struct inode *inode;
>  	struct cdev *cdev;
>  	void *addr;
> @@ -426,6 +427,20 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
>  	if (IS_ERR(addr))
>  		return PTR_ERR(addr);
>  
> +	/* Detect whether the data is at a non-zero offset into the memory */
> +	if (pgmap->range.start != dev_dax->ranges[0].range.start) {

Using pgmap->range.start here but then getting to the same (I think)
with  dev_dax->pgmap[0].range.start is rather inconsistent.

Also, perhaps drag the assignment of phys and pgmap_phys out of this
scope so that you can use them for the condition check above and
then reuse the same in here.


> +		u64 phys = dev_dax->ranges[0].range.start;
> +		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
> +		u64 vmemmap_shift = dev_dax->pgmap[0].vmemmap_shift;
> +
> +		if (!WARN_ON(pgmap_phys > phys))
> +			data_offset = phys - pgmap_phys;

In the event of the condition above being false.
phys == pgmap_phys and data_offset == 0.

So why not do this unconditionally replacing this block with something like

	/* Apply necessary offset */

	dev_dax->virt_addr = addr +
		(dev_dax->ranges[0].range.start - pgmap->range.start);
> +
> +		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx shift=%llx\n",
> +		       __func__, phys, pgmap_phys, data_offset, vmemmap_shift);

If it's only used in the print, I'd just put the path to vmemmap_shift directly in here
and probably get to it via pgmap->vmemmap_shift



> +	}
> +	dev_dax->virt_addr = addr + data_offset;
> +
>  	inode = dax_inode(dax_dev);
>  	cdev = inode->i_cdev;
>  	cdev_init(cdev, &dax_fops);

