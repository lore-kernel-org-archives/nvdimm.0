Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850A63F8890
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 16:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779987450; cv=none; b=QUyQiUXzSSqk1SR0fGa3JNwzMFWbavfCDV3kTsI//aoQr5P5jjrNYhB6U4/qfXWC4HhP/6ALXOtUMqsIE/+c6fPSkUDEqIJkCgLoOWaVt6TxsCdrIzBnF0O8n6CAxLX6EY4yTDDpT6O7I8O9cEK+I1avKq7VGT7FIr3A1QC2RJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779987450; c=relaxed/simple;
	bh=hnwibjkXy24jmZQdub9bsWIASaywnNJKokxWuM/hlGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ef9mdyqtyU/82g+DGZkKxyRKjc2s/CAOcOTPbBNfMKgoJoylCHhcIb0dgalRep5Fvgmb3BP7a2GyKa3fjdAdaUx7ZUNWQ0HDm6wL17B99gOoW8qylWREbuaYypcPjp4KYvQSx1UHzrC+IWwHcRd0TIyeyRLfvwu95q6Hgt+Qyj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ECBLscK1; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ECBLscK1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779987449; x=1811523449;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hnwibjkXy24jmZQdub9bsWIASaywnNJKokxWuM/hlGU=;
  b=ECBLscK11CgZ3NTUF/RsJuV9PUij6i5zkVFCTcJ92NSY+svxyg7CBk/X
   Wva5oKhueDc36JGRmkOKRRcBodAcVuFrvErzuv+3AUNvLTwGtCwu3BkFG
   wEnBq8wELnwAwCGhEGpR/PJ3KNDZ+cgUyzA+PsrIpFikCNPhXkqElSwlS
   4UV4kAly2PEFFpDiS8DetjUtdzU+72fA9K2K/OEG6uzbP3jm2Z9pcWL5G
   hcM5728dpm52DyxO2R3L89WCqcxzgL7PCT+v5/Th/cW+CX2RumC/iEtcS
   4GLXgtqOy/Kfzgg07H/ekNqdnyNg7WyF7jShoIphV3NrvfwK6mFEaukMI
   A==;
X-CSE-ConnectionGUID: 0MKjqMDwQbemTfmn82hOaQ==
X-CSE-MsgGUID: GfYd7vNSRdqaDKfko88xEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80860127"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="80860127"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:57:28 -0700
X-CSE-ConnectionGUID: Mjen+XKOScO3HMXFjzX5kw==
X-CSE-MsgGUID: RNVbwYzNQXWXMsZAxmS85Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="246620281"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.111.91]) ([10.125.111.91])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:57:26 -0700
Message-ID: <6fb98a05-2c44-4f97-b078-a0a65a2d07e6@intel.com>
Date: Thu, 28 May 2026 09:57:25 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 13/31] cxl/mem: Add 20 second timeout for stalled
 DC_ADD_CAPACITY chains
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <68caa60e758cb8ad5c9d0870cace911829ac965d.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <68caa60e758cb8ad5c9d0870cace911829ac965d.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/23/26 2:43 AM, Anisa Su wrote:
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
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> ---
>  drivers/cxl/core/mbox.c | 73 ++++++++++++++++++++++++++++++++++++++++-
>  drivers/cxl/cxlmem.h    | 23 ++++++++++---
>  2 files changed, 91 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 1b38f34538f3..c376492fa166 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1219,6 +1219,48 @@ static void clear_pending_extents(void *_mds)
>  	mds->add_ctx.group = NULL;
>  }
>  
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
> +	if (!ctx->armed)
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
> @@ -1246,18 +1288,34 @@ static int add_to_pending_list(struct list_head *pending_list,
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
> +	rc = add_to_pending_list(&ctx->pending_extents, &event->extent);
>  	if (rc)
>  		return rc;
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
> +	 * cancel_delayed_work() — not _sync — because handle_add_event()
> +	 * itself runs on system_wq and a sync cancel of same-wq work can
> +	 * deadlock.
> +	 */

Don't think this comment is correct. handle_add_event() is launched from threaded irq and does not run in system_wq. Just drop that second part of the comments.

> +	ctx->armed = false;
> +	cancel_delayed_work(&ctx->timeout_work);
> +
>  	rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
>  				  &mds->add_ctx.pending_extents, 0);
>  	clear_pending_extents(mds);
> @@ -2009,11 +2067,24 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
>  
>  	mutex_init(&mds->event.log_lock);
>  	INIT_LIST_HEAD(&mds->add_ctx.pending_extents);
> +	mutex_init(&mds->add_ctx.lock);
> +	INIT_DELAYED_WORK(&mds->add_ctx.timeout_work,
> +			  cxl_dc_add_timeout);
> +	mds->add_ctx.armed = false;

Not needed. Allocated memory zeroed.

DJ

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
> index 592c8e3b611c..d992cc9b7811 100644
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
> @@ -402,19 +404,32 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
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
> +	bool armed;
>  };
>  
>  /**

