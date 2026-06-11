Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F2D47DF8E
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 17:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781197323; cv=none; b=LS2PezfkLc0FET5mDUdtVYCWQxhP8JR7du/nXpJ+YNTOXunZcvGEVg4bUJCGuUw1jUfLoqw4SCqinhey+nontYGMjWgVHvU8cI4H3ZhWBfkeBW/S2Uw0sIS/a6S/ceP4XYx+qcj2N118IoahCY7/lHNpbm5MMT0M6CH7Qp0ihcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781197323; c=relaxed/simple;
	bh=KMh/mtHDXIo+rUiDJ/NhzUP9bhikfjbFj1UnRrU6nZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7VKbTd+XvkmW1jqLg8X73EQWd+FPHty0bHbIMr1RBWFvUYjYiit/uJSSIXIKT6yd4MO/PuEgWIHnagMaOMCS0WCw/fedxV5kFvkgsIo/qrd6X3ihuw1LK/83ITLD/WnF8AmeP6SqgmQtuj1EViK91Kq+eJNZBv12h8TZZ2GRbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0331F1C2539;
	Thu, 11 Jun 2026 17:01:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf13.hostedemail.com (Postfix) with ESMTPA id 8633F20016;
	Thu, 11 Jun 2026 17:01:43 +0000 (UTC)
Date: Thu, 11 Jun 2026 12:01:42 -0500
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
Subject: Re: [PATCH V4 7/9] dax: fix holder_ops race in fs_put_dax()
Message-ID: <airpeRKxMewYR5yc@groves.net>
References: <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
 <20260607193405.94390-1-john@jagalactic.com>
 <0100019ea3941018-519230fa-2897-41b8-9677-dabc8d1124ca-000000@email.amazonses.com>
 <aiaeCdwZEP7o1Q5M@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiaeCdwZEP7o1Q5M@MWDK4CY14F>
X-Rspamd-Queue-Id: 8633F20016
X-Rspamd-Server: rspamout01
X-Stat-Signature: chb7d47k3w1af5g81r6bd3q4sp3uwtzt
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+LQw6JS1WBqmpMkfxEkazhT2jL1zGk7z0=
X-HE-Tag: 1781197303-13568
X-HE-Meta: U2FsdGVkX18tpzCV4eXTn7FEUyLmxDuAsNVOpAKiGdbyzQwwMAQrz4VHQ2l/XfVQvtvoLqYU1wyF9YdgznNpNfpKd5jQHQOfw4LYBL7/5iD7bHNep4ZSvXwdFAcjUiESxNjCkDLPC5h6T+UNRrdEhy0BNJgJqwgV7NKULuX1U/cqms6ZXsbgxXJp1DrxTtzARsCqJj0RKfOpgJopQNLbxB1fvuuqWoVJSaTsXNtsZwKJ3eDAwyJG9Z8WOLOcPxxlUF9/gNlrJvn8nDQK33zFdRPmE5guvMae/zlFycGi0DVBaUKv8/aZ/2/vEft1Pab3gGXcMV+7xSGBSbqHZeAFjDQuDHm+ZLzLkE12ACa36fw/mDeMAdt8j3FxFdYC25dy

On 26/06/08 06:52PM, Richard Cheng wrote:
> On Sun, Jun 07, 2026 at 07:34:10PM +0800, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Clear holder_ops before holder_data so that a concurrent fs_dax_get()
> > cannot have its newly installed holder_ops overwritten. cmpxchg()
> > provides release ordering on weakly-ordered architectures, ensuring the
> > WRITE_ONCE(holder_ops, NULL) store is visible to any CPU that observes
> > the holder_data release.
> > 
> > Add a WARN_ON() that fires only when the cmpxchg observes a non-NULL
> > value that is not @holder, i.e. fs_put_dax() called by something that
> > is not the current holder. That is an API contract violation; the
> > WARN_ON() does not prevent the damage but makes the bug visible.
> > 
> > A NULL cmpxchg result is deliberately tolerated: kill_dax() clears
> > holder_data while a holder is still attached when a device is removed
> > out from under a mounted filesystem (after delivering MF_MEM_PRE_REMOVE).
> > The holder's subsequent fs_put_dax() - e.g. xfs_free_buftarg() after a
> > forced shutdown - then legitimately finds holder_data already NULL, so
> > warning on that case would turn supported device removal into a splat
> > (or a panic with panic_on_warn).
> > 
> > Also add a kerneldoc comment documenting that fs_put_dax() must only
> > be called by the current holder.
> > 
> > Fixes: eec38f5d86d27 ("dax: Add fs_dax_get() func to prepare dax for fs-dax usage")
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  drivers/dax/super.c | 42 +++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 39 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 25cf99dd9360b..96f778dcde50b 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -116,11 +116,47 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> >  
> >  #if IS_ENABLED(CONFIG_FS_DAX)
> >  
> > +/**
> > + * fs_put_dax() - release holder ownership of a dax_device
> > + * @dax_dev: dax device to release (may be NULL)
> > + * @holder: the holder pointer previously passed to fs_dax_get() or
> > + *          fs_dax_get_by_bdev(); must match exactly, as it is used
> > + *          in a cmpxchg to atomically release ownership
> > + *
> > + * Must only be called by the current holder. Clears holder_ops before
> > + * holder_data to avoid a race where a concurrent fs_dax_get() could have
> > + * its newly installed holder_ops overwritten.
> > + */
> >  void fs_put_dax(struct dax_device *dax_dev, void *holder)
> >  {
> > -	if (dax_dev && holder &&
> > -	    cmpxchg(&dax_dev->holder_data, holder, NULL) == holder)
> > -		dax_dev->holder_ops = NULL;
> > +	if (dax_dev && holder) {
> > +		void *prev;
> > +
> > +		/*
> > +		 * Clear holder_ops before releasing holder_data. A concurrent
> > +		 * dax_holder_notify_failure() that sees NULL ops returns
> > +		 * -EOPNOTSUPP cleanly. A concurrent fs_dax_get() that acquires
> > +		 * holder_data after the cmpxchg below is guaranteed to observe
> > +		 * holder_ops=NULL first (cmpxchg provides release ordering), so
> > +		 * its subsequent store of new ops will not be overwritten.
> > +		 */
> 
> This isn't guaranteed today. dax-holder_notify_failure() reads
> dax_dev->holder_ops twice without READ_ONCE(). With your WRITE_ONCE()
> racing in between, the second read "dax_dev->holder_ops->notify_failure()" can
> return NULL and result in NULL deref, so the "see NULL cleanly" property the comment relies
> on doesn't hold.
> 
> Or reading it once into a local would make it tru
> """
> const struct dax_holder_operations *ops = READ_ONCE(dax_dev->holder_ops);
> 
> if (!ops)
> 	return -EOPNOTSUPP;
> rc = ops->notify_failure(dax_dev, off, len, mf_flags);
> """
> 
> What do you think ?

Another good catch. Adding a fix to dax_holder_notify_failure(), to get
the ops via READ_ONCE().

Thanks,
John

<snip>

