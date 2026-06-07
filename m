Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BD04071C4
	for <nvdimm@lists.linux.dev>; Sun,  7 Jun 2026 15:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780846675; cv=none; b=ltjFYoI/QCpDHdsjRadskBgC4ln2kePM47abyvbLcTTAhtjfRdvSkto6U7bzmLnw4LeVaT3dQ/vJJNSKWH1YDqb5+MHoX7iWs1RxmSMZSAK1WVDjGKXKG7+fDxYphCKaraxISArB96Ytpy/VSXPaykmuO7Rpi/O34ZuW76fAJz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780846675; c=relaxed/simple;
	bh=I3xpqGki/jVPTkKMeUkNacqBa7plK+wPJFwglEmxa88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtaRikFkoPEvB1pecqhFEaPTYDr9wpWg1g8PRbh2gCA3IKzs9f+JQpNOknrIuFuCiVBYvqprJFbbhDtWjX3aHF096xr1mUmSBe8onKDrSomhOn5cQxQE9V9KpYOTsUs3DeRsXb45AsVbWG8vI7YoJt2mgUeB3TajtLarNr8mkcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2AEDE1C2592;
	Sun,  7 Jun 2026 15:37:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf09.hostedemail.com (Postfix) with ESMTPA id 780A420025;
	Sun,  7 Jun 2026 15:37:42 +0000 (UTC)
Date: Sun, 7 Jun 2026 10:37:41 -0500
From: John Groves <John@groves.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V3 7/9] dax: fix holder_ops race in fs_put_dax()
Message-ID: <aiWPXOoL-6mfSEOd@groves.net>
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165115.6704-1-john@jagalactic.com>
 <0100019e79cc1d9e-d39ff70d-4f1d-4a02-8b8e-e01c70272c0c-000000@email.amazonses.com>
 <2908dc0f-5790-4801-89b8-7f53dff9e320@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2908dc0f-5790-4801-89b8-7f53dff9e320@intel.com>
X-Stat-Signature: z6m3m34hptqmnxwks3nrj8144in4stgh
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 780A420025
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+4Ju3Xb9EQCjeqwDKDhGjI3Xal/MDOaMg=
X-HE-Tag: 1780846662-22245
X-HE-Meta: U2FsdGVkX19zE8k8f1FytdjNS3WINRUHJys33eeNON9fdgzVh2CV+5EIQOmDp0rS8lodbee0ho4cqwrIzTqKM0bhTCEjUgE0AKRunfm+bN0YIbV/zAXPD1xVQHX9/WQ4neSInouXw1bdQfh1ToJslBtYdriVu0KxNODem/JgStYLoOcloxYPy9fffE+Eu4GlLOO2KjeG6ncHcH9fuueDqSTkuu4YisAFlw36ZFoOqLetGlnh2KG4cCbE0kle4U7e61d3QIfRAMRh3jI6fFcrUuHxDNzq4IFK+6zRpUdRHEHOqhqChOvQIliS1loVFUFUWZFa9iVUWDRK84G2F+GvCC5cswaqHy4ZyAalXO3/YHcykw2384yarXhaVI2mw9L3t0G8IkSQIg9VQBUIWoPv9Q==

On 26/06/01 05:03PM, Dave Jiang wrote:
> 
> 
> On 5/30/26 9:51 AM, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Clear holder_ops before holder_data so that a concurrent fs_dax_get()
> > cannot have its newly installed holder_ops overwritten. cmpxchg()
> > provides release ordering on weakly-ordered architectures, ensuring the
> > WRITE_ONCE(holder_ops, NULL) store is visible to any CPU that observes
> > the holder_data release.
> > 
> > Add WARN_ON() on the cmpxchg result to catch two API contract
> > violations: fs_put_dax() called by a non-holder, or called twice by
> > the same holder (double-put). Either way holder_ops has already been
> > cleared, so WARN_ON() does not prevent the damage but makes the bug
> > visible. (Note: "damage" is only if a non-holder causes holder_ops
> > to be cleared)
> > 
> > Also add a kerneldoc comment documenting that fs_put_dax() must only
> > be called by the current holder.
> > 
> > Fixes: eec38f5d86d27 ("dax: Add fs_dax_get() func to prepare dax for fs-dax usage")
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  drivers/dax/super.c | 35 ++++++++++++++++++++++++++++++++---
> >  1 file changed, 32 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 25cf99dd9360b..4c56ac2faacdb 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -116,11 +116,40 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
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
> > +		/*
> > +		 * Clear holder_ops before releasing holder_data. A concurrent
> > +		 * dax_holder_notify_failure() that sees NULL ops returns
> > +		 * -EOPNOTSUPP cleanly. A concurrent fs_dax_get() that acquires
> > +		 * holder_data after the cmpxchg below is guaranteed to observe
> > +		 * holder_ops=NULL first (cmpxchg provides release ordering), so
> > +		 * its subsequent store of new ops will not be overwritten.
> > +		 *
> > +		 * Two cases will trigger the WARN_ON():
> > +		 * - Caller is not the current holder; this is an API contract
> > +		 *   violation, and the holder will no longer get callbacks
> > +		 * - Holder calls this function twice; also a contract violation
> > +		 *
> > +		 * A lock would be necessary to guard against the contract
> > +		 * violations, but we WARN_ON() instead since violating the
> > +		 * contract is a bug
> > +		 */
> > +		WRITE_ONCE(dax_dev->holder_ops, NULL);
> > +		WARN_ON(cmpxchg(&dax_dev->holder_data, holder, NULL) != holder);
> > +	}
> >  	put_dax(dax_dev);
> >  }
> >  EXPORT_SYMBOL_GPL(fs_put_dax);
> 
> 
> This is what Claude Opus 4.8 said:
> 
>   The added WARN_ON(cmpxchg(...) != holder) fires on the supported
>   device-removal-while-mounted path. kill_dax() (super.c:457) clears holder_data
>   = NULL while a holder is still attached — it explicitly tests holder_data !=
>   NULL to deliver MF_MEM_PRE_REMOVE first. For xfs on pmem:
> 
>   1. pmem_remove() → kill_dax() → MF_MEM_PRE_REMOVE →
>   xfs_force_shutdown(SHUTDOWN_FORCE_UMOUNT); the handler does not call
>   fs_put_dax. kill_dax then clears holder_data.
>   2. Forced unmount → xfs_free_buftarg() → fs_put_dax(bt_daxdev, mp).
>   3. cmpxchg(&holder_data, mp, NULL) returns NULL (already cleared) != mp → WARN
>   fires, despite xfs being the legitimate holder doing a single put.
> 
>   The old == holder form skipped silently in this case. On panic_on_warn systems
>   this turns a supported device removal into a panic.
> 
>   The commit message's claim that the WARN catches only "non-holder" or
>   "double-put" contract violations is incomplete — it also catches the holder
>   racing with kill_dax(), which is not a contract violation.
> 
> This is the suggested fix:
>   void fs_put_dax(struct dax_device *dax_dev, void *holder)
>   {
>         if (dax_dev && holder) {
>                 void *prev;
> 
>                 /*
>                  * Clear holder_ops before releasing holder_data so a
>                  * concurrent fs_dax_get() that wins holder_data observes
>                  * holder_ops == NULL and its store is not overwritten.
>                  */
>                 WRITE_ONCE(dax_dev->holder_ops, NULL);
>                 prev = cmpxchg(&dax_dev->holder_data, holder, NULL);
> 
>                 /*
>                  * prev == holder: normal release.
>                  * prev == NULL:   already released by kill_dax() when the
>                  *                 device was removed under a live holder;
>                  *                 not a bug.
>                  * prev != holder (non-NULL): fs_put_dax() called by something
>                  *                 that is not the current holder.
>                  */
>                 WARN_ON(prev && prev != holder);
>         }
>         put_dax(dax_dev);
>   }
> 
> 

Looks good - going with this approach.

Thanks!
John

