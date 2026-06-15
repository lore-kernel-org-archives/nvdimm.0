Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43323F1669
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 13:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529200; cv=none; b=r4jUkcYr61sz68+RETUrwFHptbIJ8TRJKEm0fbWgiBL6+do3vSesFohZXK7ZxKFV+L0kAUFXI4zYegDo4XCz/BM+nJcTqXpjxYHo4X1f9ZaN96iIeKIoOvR+JloNwZVYtTIVZiTraGbmDeWFk2R6gVwivAIZB+7/KNHuiLgZLbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529200; c=relaxed/simple;
	bh=JV5pPp6Ka8g+FtRyhYZAk+cFACXv8FmBu4KaMmweoIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JaJWu+yi5ZIYVWXK33YzjMLMWSTl79fJ/nGtefPTF3Aoc/v/RrakitobcVnyDBjcixkAmkCUOJkRJzyn8Am3NwX5bGBZhKd9JNwiXvzRA8v7XSneVEmtZMm/4N4yjdjYTAwkaJSWz4lECuvwsQwFKp8GHSc4cQnEL1wbChdltTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E56F11409A6;
	Mon, 15 Jun 2026 13:13:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf18.hostedemail.com (Postfix) with ESMTPA id DA26F2F;
	Mon, 15 Jun 2026 13:13:05 +0000 (UTC)
Date: Mon, 15 Jun 2026 08:13:04 -0500
From: John Groves <John@groves.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V5 2/9] dax/fsdev: fix multi-range offset in
 memory_failure handler
Message-ID: <ai_2FPTYQZGh8wRT@groves.net>
References: <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
 <20260611173152.65905-1-john@jagalactic.com>
 <0100019eb7bda506-6ba24207-b1c0-4eeb-9b04-61940cf3f80c-000000@email.amazonses.com>
 <ait3Bg68J-NfOKhZ@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ait3Bg68J-NfOKhZ@MWDK4CY14F>
X-Rspamd-Queue-Id: DA26F2F
X-Stat-Signature: br7gpe7ykxc87cnd5zdzixzizgipowo1
X-Rspamd-Server: rspamout07
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX190jmeGDiYtKH58RT+LXLFFeuhh4HjMp70=
X-HE-Tag: 1781529185-789936
X-HE-Meta: U2FsdGVkX188rpa2CmzJAY4dvaB8jkWkTYzEWLBg9f+m8UElArWHcq4cODM6EPVa6MnsDXqC+u35sfg4cdMyQnGSxc8VGzvf5lcrSKVHyxKKOj1/aPpjX345lfq3zaNCo2Y1T7m19mMZtzq/NnNHW85t9AWLOFEX894vIoO0uwG3S+KES034SZVA1xMOym5x5biW4FgQePDPJ40eUGKQNf9mQDN8vwKM9+ItHqFOhUL4Fpdvv5NIO2Qo9JGXfHtf3Ry4CHYKC55xrkmh9EN6fvHjcGvgkJl2uMTdnKBo9gzaEQi8SbEfOu55Tiz3PpS+zIhHuEEfSBzH9ty3wvH/PPkFYk8qqqzWXTYcgKKuW4E1sqeYdtRNWT5EKFr+lUr15mhl7HhKON4newnbjcUHflN1kr+MR9RwcTndfLTeJ5k=

On 26/06/12 11:08AM, Richard Cheng wrote:
> On Thu, Jun 11, 2026 at 05:31:59PM +0800, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Fix memory_failure offset calculation for multi-range devices. The old code
> > subtracted ranges[0].range.start from the faulting PFN's physical address,
> > which produces an incorrect (inflated) logical offset when the PFN falls in
> > ranges[1] or beyond due to physical gaps between ranges. Add
> > fsdev_pfn_to_offset() to walk the range list and compute the correct
> > device-linear byte offset.
> > 
> > Walk the pagemap's own range array (pgmap->ranges[]) rather than
> > dev_dax->ranges[]. The pgmap copy is the immutable snapshot populated at
> > probe and is never mutated afterwards, whereas dev_dax->ranges[] can be
> > krealloc()'d by a concurrent sysfs mapping_store() (under dax_region_rwsem,
> > which this ->memory_failure callback does not hold). For dynamic devices the
> > two arrays are identical, so the reported offset is unchanged for the
> > multi-range case this targets.
> > 
> > Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> > 
> > Suggested-by: Richard Cheng <icheng@nvidia.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  drivers/dax/fsdev.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> > index 188b2526bee45..2c5de3d80a618 100644
> > --- a/drivers/dax/fsdev.c
> > +++ b/drivers/dax/fsdev.c
> > @@ -135,11 +135,26 @@ static void fsdev_clear_ops(void *data)
> >   * The core mm code in free_zone_device_folio() handles the wake_up_var()
> >   * directly for this memory type.
> >   */
> > +static u64 fsdev_pfn_to_offset(struct dev_pagemap *pgmap, unsigned long pfn)
> > +{
> > +	phys_addr_t phys = PFN_PHYS(pfn);
> > +	u64 offset = 0;
> > +
> > +	for (int i = 0; i < pgmap->nr_range; i++) {
> > +		struct range *range = &pgmap->ranges[i];
> > +
> > +		if (phys >= range->start && phys <= range->end)
> > +			return offset + (phys - range->start);
> > +		offset += range_len(range);
> > +	}
> > +	return -1ULL;
> > +}
> > +
> >  static int fsdev_pagemap_memory_failure(struct dev_pagemap *pgmap,
> >  		unsigned long pfn, unsigned long nr_pages, int mf_flags)
> >  {
> >  	struct dev_dax *dev_dax = pgmap->owner;
> > -	u64 offset = PFN_PHYS(pfn) - dev_dax->ranges[0].range.start;
> > +	u64 offset = fsdev_pfn_to_offset(pgmap, pfn);
> 
> Hi John,
> 
> I think this regresses static devices. pgmap->ranges[0].start can sit
> data_offset below it on a static device, so the new offset = old + data_offset,
> and XFS poisons the wrong blocks.
> 
> The gap walk only helps dynamic devices where data_offset ==0 . Maybe walking pgmap->ranges and
> substract the probe's data_offset.
> 
> --Richard

Ugh, right.

Subtracting the data_offset would require newly stashing it somewhere the
->memory_failure callback could reach.

So I'm reverting to walking dev_dax->ranges[] -- the maybe-race there is the
same one the pre-existing single-range code already had.

I'd like to land this series before going too much farther down the suspected
pre-existing issues rabbit hole :D

Note: the current version of this patch (switching to pgmap->ranges) might 
have been a bit much for keeping Dave and Alison's RB tags - but I'm 
reverting back to what they reviewed for V6.

Thanks,
John

<snip>

