Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34101BA45
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 00:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780358634; cv=none; b=GOcH5/na4QgU5Ln+fiJJo9WLVCmi72NeM+7fcC2qxGhAbmHXSbAnl0WRcfANSscWvSomBljTeRxSJT6NuC4s/ok6WP1dpRguF7fUAxiiLMTKMPKA3FX00iUQjB8XwScF/P2LE5aAAVy/pVn3cCSL8iD8fP3Q/DQKFvivCxIyrAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780358634; c=relaxed/simple;
	bh=to8P1CZX2GbAoTqZA4Mfp4tKhLJ+ZWagu5SoFzW38Qk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QJfs46BB9KTph8JPVnQsCbDxxnBPdv+TDME2Y1yWLeOLx4oHCKDq4nbQ/ajtfNpic3T5WTl/wnLsZzlLogGdeggDTMPgu7AY7o3VBJvmUjKSV4H2kpYNBZD5UXulya9vcRhLI0LVaFB7ZkwyHg4m2nnfhOfYcSv8KuwReEp6jT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dOjXnHIf; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dOjXnHIf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780358632; x=1811894632;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=to8P1CZX2GbAoTqZA4Mfp4tKhLJ+ZWagu5SoFzW38Qk=;
  b=dOjXnHIfcEFPJn4vv0DSbQBYbaZvtvo53HJj60oU13qc8ix9NHsVzpiF
   DCpKCA0ktCeV88LzYEhkPbtQF9z11wF/kT7G0pmhhJnXqUS0jDXNZiXeo
   3iO6zUNso4w9/NPTmQ1q14T2BDSItVxys1FU+B4v82a1s1gXO5/wiYN90
   MClmaCTJogOUq+J7B0mDscI8Ttv3gCsBOQcGzcTWz9pNt6CT5+qHg75tP
   ewezDYHl2UvK/K02O4vxk0paVU445GrXVylqpUzzYJFVNoJUYHCNWss/b
   3qNxRFiiqLopFtdLctRHZltJ4hkb+C8liMJRMMavuYsqWU0lBn24swyLq
   Q==;
X-CSE-ConnectionGUID: bGYXIoXXTfKYtb3lrRmaGA==
X-CSE-MsgGUID: DPnev3kIRqS3Kq/409GSEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="92605284"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="92605284"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 17:03:51 -0700
X-CSE-ConnectionGUID: lS4CsBijSQqbwAaC0t9cZg==
X-CSE-MsgGUID: /MJK9tynTeq52WBeLO8rSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="242907572"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.108.24]) ([10.125.108.24])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 17:03:49 -0700
Message-ID: <2908dc0f-5790-4801-89b8-7f53dff9e320@intel.com>
Date: Mon, 1 Jun 2026 17:03:48 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 7/9] dax: fix holder_ops race in fs_put_dax()
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
 <20260530165115.6704-1-john@jagalactic.com>
 <0100019e79cc1d9e-d39ff70d-4f1d-4a02-8b8e-e01c70272c0c-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e79cc1d9e-d39ff70d-4f1d-4a02-8b8e-e01c70272c0c-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/30/26 9:51 AM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Clear holder_ops before holder_data so that a concurrent fs_dax_get()
> cannot have its newly installed holder_ops overwritten. cmpxchg()
> provides release ordering on weakly-ordered architectures, ensuring the
> WRITE_ONCE(holder_ops, NULL) store is visible to any CPU that observes
> the holder_data release.
> 
> Add WARN_ON() on the cmpxchg result to catch two API contract
> violations: fs_put_dax() called by a non-holder, or called twice by
> the same holder (double-put). Either way holder_ops has already been
> cleared, so WARN_ON() does not prevent the damage but makes the bug
> visible. (Note: "damage" is only if a non-holder causes holder_ops
> to be cleared)
> 
> Also add a kerneldoc comment documenting that fs_put_dax() must only
> be called by the current holder.
> 
> Fixes: eec38f5d86d27 ("dax: Add fs_dax_get() func to prepare dax for fs-dax usage")
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/super.c | 35 ++++++++++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 25cf99dd9360b..4c56ac2faacdb 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -116,11 +116,40 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
>  
>  #if IS_ENABLED(CONFIG_FS_DAX)
>  
> +/**
> + * fs_put_dax() - release holder ownership of a dax_device
> + * @dax_dev: dax device to release (may be NULL)
> + * @holder: the holder pointer previously passed to fs_dax_get() or
> + *          fs_dax_get_by_bdev(); must match exactly, as it is used
> + *          in a cmpxchg to atomically release ownership
> + *
> + * Must only be called by the current holder. Clears holder_ops before
> + * holder_data to avoid a race where a concurrent fs_dax_get() could have
> + * its newly installed holder_ops overwritten.
> + */
>  void fs_put_dax(struct dax_device *dax_dev, void *holder)
>  {
> -	if (dax_dev && holder &&
> -	    cmpxchg(&dax_dev->holder_data, holder, NULL) == holder)
> -		dax_dev->holder_ops = NULL;
> +	if (dax_dev && holder) {
> +		/*
> +		 * Clear holder_ops before releasing holder_data. A concurrent
> +		 * dax_holder_notify_failure() that sees NULL ops returns
> +		 * -EOPNOTSUPP cleanly. A concurrent fs_dax_get() that acquires
> +		 * holder_data after the cmpxchg below is guaranteed to observe
> +		 * holder_ops=NULL first (cmpxchg provides release ordering), so
> +		 * its subsequent store of new ops will not be overwritten.
> +		 *
> +		 * Two cases will trigger the WARN_ON():
> +		 * - Caller is not the current holder; this is an API contract
> +		 *   violation, and the holder will no longer get callbacks
> +		 * - Holder calls this function twice; also a contract violation
> +		 *
> +		 * A lock would be necessary to guard against the contract
> +		 * violations, but we WARN_ON() instead since violating the
> +		 * contract is a bug
> +		 */
> +		WRITE_ONCE(dax_dev->holder_ops, NULL);
> +		WARN_ON(cmpxchg(&dax_dev->holder_data, holder, NULL) != holder);
> +	}
>  	put_dax(dax_dev);
>  }
>  EXPORT_SYMBOL_GPL(fs_put_dax);


This is what Claude Opus 4.8 said:

  The added WARN_ON(cmpxchg(...) != holder) fires on the supported
  device-removal-while-mounted path. kill_dax() (super.c:457) clears holder_data
  = NULL while a holder is still attached — it explicitly tests holder_data !=
  NULL to deliver MF_MEM_PRE_REMOVE first. For xfs on pmem:

  1. pmem_remove() → kill_dax() → MF_MEM_PRE_REMOVE →
  xfs_force_shutdown(SHUTDOWN_FORCE_UMOUNT); the handler does not call
  fs_put_dax. kill_dax then clears holder_data.
  2. Forced unmount → xfs_free_buftarg() → fs_put_dax(bt_daxdev, mp).
  3. cmpxchg(&holder_data, mp, NULL) returns NULL (already cleared) != mp → WARN
  fires, despite xfs being the legitimate holder doing a single put.

  The old == holder form skipped silently in this case. On panic_on_warn systems
  this turns a supported device removal into a panic.

  The commit message's claim that the WARN catches only "non-holder" or
  "double-put" contract violations is incomplete — it also catches the holder
  racing with kill_dax(), which is not a contract violation.

This is the suggested fix:
  void fs_put_dax(struct dax_device *dax_dev, void *holder)
  {
        if (dax_dev && holder) {
                void *prev;

                /*
                 * Clear holder_ops before releasing holder_data so a
                 * concurrent fs_dax_get() that wins holder_data observes
                 * holder_ops == NULL and its store is not overwritten.
                 */
                WRITE_ONCE(dax_dev->holder_ops, NULL);
                prev = cmpxchg(&dax_dev->holder_data, holder, NULL);

                /*
                 * prev == holder: normal release.
                 * prev == NULL:   already released by kill_dax() when the
                 *                 device was removed under a live holder;
                 *                 not a bug.
                 * prev != holder (non-NULL): fs_put_dax() called by something
                 *                 that is not the current holder.
                 */
                WARN_ON(prev && prev != holder);
        }
        put_dax(dax_dev);
  }


