Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B347C2ED866
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781197478; cv=none; b=X1+Ds0tq2rYcBylRD7DbvBERhGc84kmNlXh1n1p01We4FpgM2/PK2xK5aRTprxYJeTEL/5FhK+yKbyNpSkov8P+ZAh6eJvKes/B+nA5FkLY1RGFrWvcM4q2Ukt0CQ5tNix89uuxHu+QpqE/KQ4aKdVAKpQZk9480bfjGWDHP6VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781197478; c=relaxed/simple;
	bh=8H5LpKzD03n99I+lGSVIBTJwhXA/uHimZYsVdWCk/2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+wnRo1Q4RZQIYEzz6LDPBYHBUUe2+8/+jzU9gQ8Qla2KKAX9FfP/VOXR3R6aM1FffSRr0cBu2rD4S8AlV0zt4y+l3OTpttqQ9EMlMIUTtfJL8XKFJWToXV0nSdkk5xGDGHVKAK+ueSY/TiuJbl22jI9MLOp+JtWVwv0nbCZSPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76B031406FE;
	Thu, 11 Jun 2026 16:59:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf05.hostedemail.com (Postfix) with ESMTPA id 5A06C20011;
	Thu, 11 Jun 2026 16:59:17 +0000 (UTC)
Date: Thu, 11 Jun 2026 11:59:15 -0500
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
Subject: Re: [PATCH V4 2/9] dax/fsdev: fix multi-range offset in
 memory_failure handler
Message-ID: <airpFzvwQhx_KoKD@groves.net>
References: <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
 <20260607193314.94291-1-john@jagalactic.com>
 <0100019ea3934be1-ce7c2c13-b9fd-40b2-9284-14bc42d5cb08-000000@email.amazonses.com>
 <aiafDCGP0mI3IhrY@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiafDCGP0mI3IhrY@MWDK4CY14F>
X-Rspamd-Queue-Id: 5A06C20011
X-Rspamd-Server: rspamout01
X-Stat-Signature: ctweu9cdfsxj6hazwmeirduq3ybub3p5
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/Kgex3958l7Fl9/QwAv4satewivFouAMM=
X-HE-Tag: 1781197157-925519
X-HE-Meta: U2FsdGVkX1964EgNpXtRpm6CDOUXzcItVFtYU3r7fAqfHXO2x4cReEB+fn0VbT1mKz6yzZr76Y6IZiiqDcamL1FHuNe06NClarhqYZq+DJ7ulMQf13IkAu/iHktLozwgvls6vcIIoyyTnCbNa3jwGH4Zyjj3zd/4I1olS/rghrMyhHbaI7oRX8DhpXMT7+rpXgurcDAXNqaYGtO8Yw0+EGUxD4afDfBmfh85bbFzwE+Gc68YS+G250nGxNCN1kpVO7zK4X4cI96EQD0Whfdqouq2slfd14isaEa+4hVpAOJcZUDSSF7UQP5Pjyj6YBiBSLYO5txA2cVLWF+mmVRlseIBQdguj8fSGENBJpWVAS9OABG56g0XErVkLeE78kWP9yebPplSGo5fOE3ma8LryA==

On 26/06/08 06:56PM, Richard Cheng wrote:
> On Sun, Jun 07, 2026 at 07:33:19PM +0800, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Fix memory_failure offset calculation for multi-range devices. The old code
> > subtracted ranges[0].range.start from the faulting PFN's physical address,
> > which produces an incorrect (inflated) logical offset when the PFN falls in
> > ranges[1] or beyond due to physical gaps between ranges. Add
> > fsdev_pfn_to_offset() to walk the range list and compute the correct
> > device-linear byte offset.
> > 
> > Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> > 
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  drivers/dax/fsdev.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> > index 188b2526bee45..f315533b299e9 100644
> > --- a/drivers/dax/fsdev.c
> > +++ b/drivers/dax/fsdev.c
> > @@ -135,11 +135,26 @@ static void fsdev_clear_ops(void *data)
> >   * The core mm code in free_zone_device_folio() handles the wake_up_var()
> >   * directly for this memory type.
> >   */
> > +static u64 fsdev_pfn_to_offset(struct dev_dax *dev_dax, unsigned long pfn)
> > +{
> > +	phys_addr_t phys = PFN_PHYS(pfn);
> > +	u64 offset = 0;
> > +
> > +	for (int i = 0; i < dev_dax->nr_range; i++) {
> > +		struct range *range = &dev_dax->ranges[i].range;
> > +
> 
> IMHO, this walks dev_dax->ranges[] locklessly from the memory_failure callback.
> mapping_store() can krealloc() that array via alloc_dev_dax_range() without
> checking dev->driver, so a sysfs mapping write concurrent with a HW poison event
> can move/free it under this walk.
> 
> We have pgmap->ranges[], the imuutable copy populated at probe and never mutated
> afterwards, right here in the callback, and its accumulated range_len() is exactly
> the device-linear offset.
> Maybe walking that instread closes the race.
> 
> What do you think?

Good idea. Revising to use the pgmap->ranges instead. Thanks Richard!

Regards,
John

<snip>

