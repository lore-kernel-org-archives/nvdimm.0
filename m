Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BFC2DB7B7
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 21:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782853883; cv=none; b=dOFTv04O10UyrLjtJw0fsxxAWzqgugXmvQDCIJD4nsghRTJhPxpjiVLN1UvKNKDh5EsLEWGg/qg+bc2drRxKJOHaebMH9g3Ja4DP551RYHxAAnZhwVEKbN1RDSg1LZM69UEPB86Sa/w7vgAAy6x4qfqVwaBIqPBNSjmlEWdeqNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782853883; c=relaxed/simple;
	bh=XOuUYNkbU08UMzh+2EcGdlVL+RGtCXfW76d5MEiHVaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NP8a+ze+wxfMRiPNDGkNZQtLpR+kZJonl6ErlvnSMe1dLXXTpsZTBg3qkXAmq9zNBxqBVyjV4CnDOHGV1Y9Z855Y1Je+LCtYSGdsyvMXU9TvX/VFZH7ICE5w9gNnAqKQmUFCpIWOtJHhEgZmUxW0fdlxHoPJDAze1T84gr2tgGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ct8ZXJdG; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ct8ZXJdG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782853880; x=1814389880;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XOuUYNkbU08UMzh+2EcGdlVL+RGtCXfW76d5MEiHVaY=;
  b=Ct8ZXJdG23BkvX14wC4qIl8Od23y/P+79xg2sBiOa/EwJRGoSVOOnp8G
   oMLomhW6rtL9tW1x9xYNyILX/far8JubaXASiWVW359zn6z4x3m5yLxUh
   avQ9WMN1MaN4/uSl3qdZxIguEV4O3gWWfm7VDS+6J9cusxHo1gRcrvcko
   oeT28Ha7zr1Ri5s1RmRQ1+c6hp8R1E2VhABIwUOUbUqXVSAg7M0004uS3
   VcVmIoscKVy61iihZTL0PuKkvdu2zsbREOgyZNQgmhRvPt2itBiflszZv
   mjBV70CdZEfUAMnlW53M+aYJj306zizlo2tKC6HwZn73kjUi6CQANA+Y/
   g==;
X-CSE-ConnectionGUID: bkjaKS/VQVy6D7D/xe2yHw==
X-CSE-MsgGUID: z3KK1O42Te2GEwx/fvFFYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="83635545"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="83635545"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 14:11:19 -0700
X-CSE-ConnectionGUID: MtX5GfStT86Jim0XSlmlBg==
X-CSE-MsgGUID: nzRFazn4QduQKOaNW+4LxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="255954430"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.254]) ([10.125.109.254])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 14:11:18 -0700
Message-ID: <3fb3b2c2-9be6-483b-94bd-d0515d5df9b2@intel.com>
Date: Tue, 30 Jun 2026 14:11:12 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 13/31] cxl/mem: Add 20 second timeout for stalled
 DC_ADD_CAPACITY chains
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-14-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260625112638.550691-14-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 6/25/26 4:04 AM, Anisa Su wrote:
> A DC_ADD_CAPACITY event can span multiple event records grouped together
> by the CXL_DCD_EVENT_MORE flag. Extents are staged in the pending list until
> the last event record ('More'=0) is received, at which point the pending
> list is processed. If the device opens such a chain (More=1) but never
> sends the closing record, the staged list sits indefinitely.
> 
> Add a delayed-work watchdog that, on expiry, refuses the chain with an
> empty ADD_DC_RESPONSE and drops the staged list.
> 
> The 20s timeout is a conservative upper bound and may be tightened
> later. The timeout is purely defensive — the spec does not require it,
> but prevents issues from a lost mailbox response or a crashed fabric manager.
> 
> The watchdog bounds how long a chain may stall, but a device could still
> defeat it by streaming More=1 records faster than the timeout, growing the
> staged list without bound. Also cap a runtime chain at
> CXL_DC_MAX_PENDING_EXTENTS and refuse it once exceeded; existing-extent
> recovery is bounded separately by the device's reported extent count.
> 
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Minor comment below in addition to sashiko

> 
> ---
> Changes:
> 1. mbox.c: Fix comment in handle_add_event(), before closing the 'More'
>    chain and disabling the watchdog. The comment incorrectly claimed
>    handle_add_event() runs in system_wq.
> 2. mbox.c: Drop unnecessary initialization of add_ctx.armed=false in
>    cxl_memdev_state_create(), as allocated memory is already zeroed
> 3. mbox.c: assert add_ctx.lock is held in add_to_pending_list(); it
>    serializes access to add_ctx.pending_extents.
> 4. mbox.c: cap a runtime More=1 chain at CXL_DC_MAX_PENDING_EXTENTS in
>    handle_add_event() so a buggy device cannot grow the staged list
>    without bound (the watchdog bounds time, not memory).
> ---
>  drivers/cxl/core/mbox.c | 98 ++++++++++++++++++++++++++++++++++++++++-
>  drivers/cxl/cxlmem.h    | 24 ++++++++--
>  2 files changed, 117 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 7dd40fb8d613..4e887b5cdc3e 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1208,15 +1208,78 @@ static void clear_pending_extents(void *_mds)
>  
>  	list_for_each_entry_safe(pos, tmp, &mds->add_ctx.pending_extents, list)
>  		delete_extent_node(pos);
> +	mds->add_ctx.nr_pending = 0;
>  	mds->add_ctx.group = NULL;
>  }
>  
> +/*
> + * Defensive cap on extents staged in one runtime More=1 chain: a buggy
> + * device could otherwise grow the list without bound.  Not spec-defined.
> + */
> +#define CXL_DC_MAX_PENDING_EXTENTS	100
> +
> +/*
> + * Bound on how long the host will wait for a device to finish a
> + * multi-record DC_ADD_CAPACITY chain (More=1 ... More=0) before
> + * refusing the chain.
> + * The timeout is not defined in the spec, but added for defensive purposes.
> + * Since there is no spec-defined timeout, 20s is chosen as a generous
> + * upper bound and matches the GPF timeout.
> + */
> +#define CXL_DC_ADD_TIMEOUT	(20 * HZ)
> +
> +static void cxl_dc_add_timeout(struct work_struct *work)
> +{
> +	struct pending_add_ctx *ctx = container_of(to_delayed_work(work),
> +						   struct pending_add_ctx,
> +						   timeout_work);
> +	struct cxl_memdev_state *mds = container_of(ctx,
> +						    struct cxl_memdev_state,
> +						    add_ctx);
> +	struct device *dev = mds->cxlds.dev;
> +
> +	guard(mutex)(&ctx->lock);
> +
> +	/*
> +	 * handle_add_event() cancels this work non-synchronously (a sync
> +	 * cancel would deadlock on @ctx->lock, which the chain-close path
> +	 * holds), so a callback that already started running can reach here
> +	 * after its chain has moved on.  Abort only if a chain is still armed
> +	 * AND the timer has not been re-armed since this expiry fired: a fresh
> +	 * mod_delayed_work() (a later extent in this chain, or a new chain)
> +	 * makes delayed_work_pending() true, meaning this expiry belongs to a
> +	 * superseded deadline and must not abort the current chain.
> +	 */
> +	if (!ctx->armed || delayed_work_pending(&ctx->timeout_work))
> +		return;
> +
> +	dev_warn(dev, "DC add chain timed out; refusing staged extents\n");
> +
> +	if (cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> +				 &ctx->pending_extents, 0))
> +		dev_dbg(dev, "Failed to send empty ADD_DC_RESPONSE on timeout\n");
> +
> +	clear_pending_extents(mds);
> +	ctx->armed = false;
> +}
> +
> +static void cxl_cancel_dcd_add_chain_work(void *_mds)
> +{
> +	struct cxl_memdev_state *mds = _mds;
> +
> +	cancel_delayed_work_sync(&mds->add_ctx.timeout_work);
> +}
> +
>  static int add_to_pending_list(struct list_head *pending_list,
>  			       struct cxl_extent *to_add)
>  {
> +	struct pending_add_ctx *ctx =
> +		container_of(pending_list, struct pending_add_ctx, pending_extents);
>  	struct cxl_extent_list_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
>  	struct cxl_extent *extent;
>  
> +	lockdep_assert_held(&ctx->lock);
> +
>  	if (!node)
>  		return -ENOMEM;
>  	extent = kmemdup(to_add, sizeof(*extent), GFP_KERNEL);
> @@ -1227,6 +1290,7 @@ static int add_to_pending_list(struct list_head *pending_list,
>  
>  	node->extent = extent;
>  	list_add_tail(&node->list, pending_list);
> +	ctx->nr_pending++;
>  	return 0;
>  }
>  
> @@ -1239,10 +1303,20 @@ static int add_to_pending_list(struct list_head *pending_list,
>  static int handle_add_event(struct cxl_memdev_state *mds,
>  			    struct cxl_event_dcd *event)
>  {
> +	struct pending_add_ctx *ctx = &mds->add_ctx;
>  	struct device *dev = mds->cxlds.dev;
>  	int rc;
>  
> -	rc = add_to_pending_list(&mds->add_ctx.pending_extents, &event->extent);
> +	guard(mutex)(&ctx->lock);
> +
> +	if (ctx->nr_pending >= CXL_DC_MAX_PENDING_EXTENTS) {
> +		dev_warn(dev, "DC add chain exceeds %u extents; dropping (firmware bug)\n",
> +			 CXL_DC_MAX_PENDING_EXTENTS);
> +		clear_pending_extents(mds);
> +		return -ENOSPC;
> +	}
> +
> +	rc = add_to_pending_list(&ctx->pending_extents, &event->extent);
>  	if (rc) {
>  		clear_pending_extents(mds);
>  		return rc;
> @@ -1250,9 +1324,19 @@ static int handle_add_event(struct cxl_memdev_state *mds,
>  
>  	if (event->flags & CXL_DCD_EVENT_MORE) {
>  		dev_dbg(dev, "more bit set; delay the surfacing of extent\n");
> +		mod_delayed_work(system_wq, &ctx->timeout_work,
> +						 CXL_DC_ADD_TIMEOUT);
> +		ctx->armed = true;
>  		return 0;
>  	}
>  
> +	/*
> +	 * Chain is closing.  Disarm before flushing so a pending watchdog
> +	 * (queued but blocked on @ctx->lock) sees !armed and bails out.
> +	 */
> +	ctx->armed = false;
> +	cancel_delayed_work(&ctx->timeout_work);
> +
>  	rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
>  				  &mds->add_ctx.pending_extents, 0);
>  	clear_pending_extents(mds);
> @@ -2036,11 +2120,23 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
>  
>  	mutex_init(&mds->event.log_lock);
>  	INIT_LIST_HEAD(&mds->add_ctx.pending_extents);
> +	mutex_init(&mds->add_ctx.lock);
> +	INIT_DELAYED_WORK(&mds->add_ctx.timeout_work,
> +			  cxl_dc_add_timeout);
>  
>  	rc = devm_add_action_or_reset(dev, clear_pending_extents, mds);
>  	if (rc)
>  		return ERR_PTR(rc);
>  
> +	/*
> +	 * Registered after clear_pending_extents so devm's reverse-order
> +	 * unwind cancels (and waits for) the watchdog first, then the list
> +	 * cleanup runs with the watchdog guaranteed not to refire.
> +	 */
> +	rc = devm_add_action_or_reset(dev, cxl_cancel_dcd_add_chain_work, mds);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
>  	rc = devm_cxl_register_mce_notifier(dev, &mds->mce_notifier);
>  	if (rc == -EOPNOTSUPP)
>  		dev_warn(dev, "CXL MCE unsupported\n");
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 4ffa7bd1e5f1..81498d47f309 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -8,6 +8,8 @@
>  #include <linux/uuid.h>
>  #include <linux/node.h>
>  #include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/workqueue.h>
>  #include <cxl/event.h>
>  #include <cxl/mailbox.h>
>  #include "cxl.h"
> @@ -407,19 +409,33 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>  
>  /**
>   * struct pending_add_ctx - Staging state for an in-progress
> - *			    DCD_ADD_CAPACITY event chain
> + *							DCD_ADD_CAPACITY event chain
>   * @pending_extents: extents received so far in the chain; flushed when
> - *		     the chain closes (More=0)
> + *					 the chain closes (More=0)
>   * @group: tag group being assembled from the chain
> + * @timeout_work: watchdog that fires if a chain is opened with
> + *				  CXL_DCD_EVENT_MORE but the closing record never arrives
> + * @lock: serialises updates to the chain state against the watchdog
> + * @armed: set when a More=1 chain opens; cleared when the chain closes,
> + *		   either by a More=0 event record or by the watchdog firing.
>   *
>   * A DCD_ADD_CAPACITY notification can span multiple event records
>   * stitched together by the CXL_DCD_EVENT_MORE flag.  Records are staged
> - * here until the device clears More, at which point the staged batch is
> - * processed and responded to as a single Add_DC_Response.
> + * here until an event record with 'More'=0 is received, at which point the
> + * staged batch is processed and responded to as a single Add_DC_Response.
> + *
> + * If a chain is opened (More=1) but the device never sends the closing
> + * record, the staged list would otherwise sit indefinitely.  @timeout_work
> + * is a defensive watchdog that refuses such a chain with an empty response
> + * and drops the staged list.
>   */
>  struct pending_add_ctx {
>  	struct list_head pending_extents;
>  	struct cxl_dc_tag_group *group;
> +	struct delayed_work timeout_work;
> +	struct mutex lock;
> +	unsigned int nr_pending;

Missing kdoc in comment section

> +	bool armed;
>  };
>  
>  /**

