Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C27B4C77B0
	for <nvdimm@lists.linux.dev>; Tue,  9 Jun 2026 17:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781026623; cv=none; b=XEJY+j+UtxBHrWwJiCVcNmxte5Z9X9MziYDSXuRQsFCOC58AMjd9f4tqca/MRzwI4YCoufkELr7i6Nrj9t7kVT6EckkiL30Nua/sHqk3m2j8+jSeGbC9CPxUqZ2LZxpc430ppPE9arWlS5ivacqrci6xFSxqquwY1wQC69TYaXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781026623; c=relaxed/simple;
	bh=vavNM7moY3n3VNcGUUtx7MqSJcRjo/bcv0mXe5i9aVU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sQobeCr8JENYWlkeZSuPExCG1F5IQxjae65GdzjwArDl53OM2tjKow2FR93v1OHYmQnKtm08P2AIcnX7DroFOokRCKGOPTUSzxqCqHVYOyfgk9Qa2IBzNN9YbdcubkqgLP7jxeMWL46KtHrrtTWdKuPwQu3gNFTIiD+Ro+UWQpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ThHl2Yxt; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ThHl2Yxt"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1382533d428so1497725c88.1
        for <nvdimm@lists.linux.dev>; Tue, 09 Jun 2026 10:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781026620; x=1781631420; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tDlrc6D1HRGhO459Nn7xM8gMvPAG5dSKCi+Lk19ZCXY=;
        b=ThHl2YxtohJWVB3G3ZkSPV1+EuHqgnpga9F8NTChpCVMGfcR1Y6D7eRS+LqXK1jr9A
         gc4A1BNOOr++a2GjcFUpvqjadkW8eRC7dEQqhVubSlE+z6+JdjFjyKZ6MsQVJTVtYscs
         RwmhXdHN51jXwUadGPIK6xFvayo5EaT0/vKQp2WViyhwKYQZX43PsBqEad6hYtMeDLLU
         i0tnb7JE4a9kEIC9Q4o7+CZtu8LbgsCQhEichSzR+BRGmbWyNFmDlxlk+5KOBWqX2vCV
         s44EQjsDjesVj9M9pB4Dt1yW3zNoCniU7V26PsQJiDffPkOag6EaVmSeOBejm/lKedh6
         uk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781026620; x=1781631420;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tDlrc6D1HRGhO459Nn7xM8gMvPAG5dSKCi+Lk19ZCXY=;
        b=TvnZVgeCmH6r5YZ4jL6fbGv/OB6Ngt/S4M14grYDW1E12NrHCiIbEJsKviPNQ0erYD
         S9cUX51E/ZGu4xJkYZY5rRpRQX4JcJ6hdXZuAYvS7V5JsY0yUZyXmAs/D3EI03Ai1pMs
         92dUY7HxqPleIUCuDtq5kv9V0WNq88jdL9IHT0avOmyPFuLGTOOILl4+dG0mbxBj6+0X
         qBivg1HPFfd/+K1Zd8qRM8aJL8CODBi0M49JwLDJMqb/AdbCps50ZiEBxXKw33Zue5Kw
         RIPKm/pw36d5G6oJEj4Xg4c+JqK/RB+b6B1iKLRwFxJViDAGP8hA462PQZv32ywRL30E
         3sJQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Wj8IyWw9F9FCmAEkh5LwIMpmOy/h/mCCI5lxVvdHctDl6/hiKD3eRBcnS6q4phP8uuTeWNdI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5KLUFppTGZ2JLAeCYKc8KlNldpjjqs+95ZjGtQsoKuyfgbvG4
	NDeRHNI9fz+l2xpTQQ3oNJ04udFqo4lnotFm1eK5Jfo7xQqdFj4vN5yQ
X-Gm-Gg: Acq92OH2gOIGVzPyluUWRZvyMlzDiBTwMMr+XrxZYODvziJPJWliRWacnihBuUtRfNf
	XBvtSFLXbDxRnGmjBo+PTZiYIO108lCi+zL4itHaSuHpPUchxRsUFVYDIj0ly/ZivhaVetgRj+G
	0nRAJmVCJmTsDHEe4X6CWYgBg73A1eCFIEfoYFcQpITY+DMqq06GkKCtvVATmWojWZl4yauxUUG
	mpB1rprr6JrbS+E13ybeBU+1LBlTldrgiMVxObZ5ST/1ssVTkkc2MhmojxjnYNJPOcJo8w8F98B
	w3z7QFny8MINVB7S9qjJIjTFfcZ6eVYE/xK2MOr5l3WL1M7B6jHKQe7ILWufgSK41IeGt3IKA8Y
	hHJrMi/yP+XkdtH+FSup98E8dPlQklaR7seQqXtshzNbpHvHfRej9wToLA2uqltwBhCMy1yAmYM
	cUJK8GPQN3p5WqggnJymaDkfkWJcVuFCBsFOVF0y8ECkShQltJSlAzv4JzyChioKZkENz5+Q5Xh
	Wt9KKHI7xNdwQxI/w==
X-Received: by 2002:a05:7022:603:b0:127:33e0:ea44 with SMTP id a92af1059eb24-1380671cac0mr12471985c88.29.1781026619328;
        Tue, 09 Jun 2026 10:36:59 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137f5489d17sm15425445c88.1.2026.06.09.10.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 10:36:59 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 9 Jun 2026 10:36:57 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v10 13/31] cxl/mem: Add 20 second timeout for stalled
 DC_ADD_CAPACITY chains
Message-ID: <aihPOdcicE9yGO8I@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <68caa60e758cb8ad5c9d0870cace911829ac965d.1779528761.git.anisa.su@samsung.com>
 <6fb98a05-2c44-4f97-b078-a0a65a2d07e6@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6fb98a05-2c44-4f97-b078-a0a65a2d07e6@intel.com>

On Thu, May 28, 2026 at 09:57:25AM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > A DC_ADD_CAPACITY event can span multiple event records grouped together
> > by the CXL_DCD_EVENT_MORE flag. Extents are staged in the pending list until
> > the last event record ('More'=0) is received, at which point the pending
> > list is processed. If the device opens such a chain (More=1) but never
> > sends the closing record, the staged list sits indefinitely.
> > 
> > Add a delayed-work watchdog that, on expiry, refuses the chain with an
> > empty ADD_DC_RESPONSE and drops the staged list.
> > 
> > The 20s timeout is a conservative upper bound and may be tightened
> > later. The timeout is purely defensive — the spec does not require it,
> > but prevents issues from a lost mailbox response or a crashed fabric manager.
> > 
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > ---
> >  drivers/cxl/core/mbox.c | 73 ++++++++++++++++++++++++++++++++++++++++-
> >  drivers/cxl/cxlmem.h    | 23 ++++++++++---
> >  2 files changed, 91 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 1b38f34538f3..c376492fa166 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1219,6 +1219,48 @@ static void clear_pending_extents(void *_mds)
> >  	mds->add_ctx.group = NULL;
> >  }
> >  
> > +/*
> > + * Bound on how long the host will wait for a device to finish a
> > + * multi-record DC_ADD_CAPACITY chain (More=1 ... More=0) before
> > + * refusing the chain.
> > + * The timeout is not defined in the spec, but added for defensive purposes.
> > + * Since there is no spec-defined timeout, 20s is chosen as a generous
> > + * upper bound and matches the GPF timeout.
> > + */
> > +#define CXL_DC_ADD_TIMEOUT	(20 * HZ)
> > +
> > +static void cxl_dc_add_timeout(struct work_struct *work)
> > +{
> > +	struct pending_add_ctx *ctx = container_of(to_delayed_work(work),
> > +						   struct pending_add_ctx,
> > +						   timeout_work);
> > +	struct cxl_memdev_state *mds = container_of(ctx,
> > +						    struct cxl_memdev_state,
> > +						    add_ctx);
> > +	struct device *dev = mds->cxlds.dev;
> > +
> > +	guard(mutex)(&ctx->lock);
> > +
> > +	if (!ctx->armed)
> > +		return;
> > +
> > +	dev_warn(dev, "DC add chain timed out; refusing staged extents\n");
> > +
> > +	if (cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> > +				 &ctx->pending_extents, 0))
> > +		dev_dbg(dev, "Failed to send empty ADD_DC_RESPONSE on timeout\n");
> > +
> > +	clear_pending_extents(mds);
> > +	ctx->armed = false;
> > +}
> > +
> > +static void cxl_cancel_dcd_add_chain_work(void *_mds)
> > +{
> > +	struct cxl_memdev_state *mds = _mds;
> > +
> > +	cancel_delayed_work_sync(&mds->add_ctx.timeout_work);
> > +}
> > +
> >  static int add_to_pending_list(struct list_head *pending_list,
> >  			       struct cxl_extent *to_add)
> >  {
> > @@ -1246,18 +1288,34 @@ static int add_to_pending_list(struct list_head *pending_list,
> >  static int handle_add_event(struct cxl_memdev_state *mds,
> >  			    struct cxl_event_dcd *event)
> >  {
> > +	struct pending_add_ctx *ctx = &mds->add_ctx;
> >  	struct device *dev = mds->cxlds.dev;
> >  	int rc;
> >  
> > -	rc = add_to_pending_list(&mds->add_ctx.pending_extents, &event->extent);
> > +	guard(mutex)(&ctx->lock);
> > +
> > +	rc = add_to_pending_list(&ctx->pending_extents, &event->extent);
> >  	if (rc)
> >  		return rc;
> >  
> >  	if (event->flags & CXL_DCD_EVENT_MORE) {
> >  		dev_dbg(dev, "more bit set; delay the surfacing of extent\n");
> > +		mod_delayed_work(system_wq, &ctx->timeout_work,
> > +						 CXL_DC_ADD_TIMEOUT);
> > +		ctx->armed = true;
> >  		return 0;
> >  	}
> >  
> > +	/*
> > +	 * Chain is closing.  Disarm before flushing so a pending watchdog
> > +	 * (queued but blocked on @ctx->lock) sees !armed and bails out.
> > +	 * cancel_delayed_work() — not _sync — because handle_add_event()
> > +	 * itself runs on system_wq and a sync cancel of same-wq work can
> > +	 * deadlock.
> > +	 */
> 
> Don't think this comment is correct. handle_add_event() is launched from threaded irq and does not run in system_wq. Just drop that second part of the comments.
> 
Oh I see. Done!
> > +	ctx->armed = false;
> > +	cancel_delayed_work(&ctx->timeout_work);
> > +
> >  	rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> >  				  &mds->add_ctx.pending_extents, 0);
> >  	clear_pending_extents(mds);
> > @@ -2009,11 +2067,24 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
> >  
> >  	mutex_init(&mds->event.log_lock);
> >  	INIT_LIST_HEAD(&mds->add_ctx.pending_extents);
> > +	mutex_init(&mds->add_ctx.lock);
> > +	INIT_DELAYED_WORK(&mds->add_ctx.timeout_work,
> > +			  cxl_dc_add_timeout);
> > +	mds->add_ctx.armed = false;
> 
> Not needed. Allocated memory zeroed.
> 
Dropped

> DJ
> 
Thanks,
Anisa
> >  
> >  	rc = devm_add_action_or_reset(dev, clear_pending_extents, mds);
> >  	if (rc)
> >  		return ERR_PTR(rc);
> >  
> > +	/*
> > +	 * Registered after clear_pending_extents so devm's reverse-order
> > +	 * unwind cancels (and waits for) the watchdog first, then the list
> > +	 * cleanup runs with the watchdog guaranteed not to refire.
> > +	 */
> > +	rc = devm_add_action_or_reset(dev, cxl_cancel_dcd_add_chain_work, mds);
> > +	if (rc)
> > +		return ERR_PTR(rc);
> > +
> >  	rc = devm_cxl_register_mce_notifier(dev, &mds->mce_notifier);
> >  	if (rc == -EOPNOTSUPP)
> >  		dev_warn(dev, "CXL MCE unsupported\n");
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 592c8e3b611c..d992cc9b7811 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -8,6 +8,8 @@
> >  #include <linux/uuid.h>
> >  #include <linux/node.h>
> >  #include <linux/list.h>
> > +#include <linux/mutex.h>
> > +#include <linux/workqueue.h>
> >  #include <cxl/event.h>
> >  #include <cxl/mailbox.h>
> >  #include "cxl.h"
> > @@ -402,19 +404,32 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
> >  
> >  /**
> >   * struct pending_add_ctx - Staging state for an in-progress
> > - *			    DCD_ADD_CAPACITY event chain
> > + *							DCD_ADD_CAPACITY event chain
> >   * @pending_extents: extents received so far in the chain; flushed when
> > - *		     the chain closes (More=0)
> > + *					 the chain closes (More=0)
> >   * @group: tag group being assembled from the chain
> > + * @timeout_work: watchdog that fires if a chain is opened with
> > + *				  CXL_DCD_EVENT_MORE but the closing record never arrives
> > + * @lock: serialises updates to the chain state against the watchdog
> > + * @armed: set when a More=1 chain opens; cleared when the chain closes,
> > + *		   either by a More=0 event record or by the watchdog firing.
> >   *
> >   * A DCD_ADD_CAPACITY notification can span multiple event records
> >   * stitched together by the CXL_DCD_EVENT_MORE flag.  Records are staged
> > - * here until the device clears More, at which point the staged batch is
> > - * processed and responded to as a single Add_DC_Response.
> > + * here until an event record with 'More'=0 is received, at which point the
> > + * staged batch is processed and responded to as a single Add_DC_Response.
> > + *
> > + * If a chain is opened (More=1) but the device never sends the closing
> > + * record, the staged list would otherwise sit indefinitely.  @timeout_work
> > + * is a defensive watchdog that refuses such a chain with an empty response
> > + * and drops the staged list.
> >   */
> >  struct pending_add_ctx {
> >  	struct list_head pending_extents;
> >  	struct cxl_dc_tag_group *group;
> > +	struct delayed_work timeout_work;
> > +	struct mutex lock;
> > +	bool armed;
> >  };
> >  
> >  /**
> 
