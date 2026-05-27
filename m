Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2592027F017
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 00:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779840988; cv=none; b=ep/wqCRLugZC1unu/7Sa9eFN+hdzFUak7bBg1Rq/6TAsHi4bs26K9qqC6CgbsHxxYHf1GaAz7laj4VuJGuXIeBvPPTb/gmClz329WSzkTSJdeYwFPDzLhjM5tVE2DTCLp1nlFbibC9F4faPNWp2MbN2WS1Q6g1UCPTTFgC8oSRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779840988; c=relaxed/simple;
	bh=qOqJqCGw20iqiS+sk9mqMlpQVA7enZ94rTTT/wcwRmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PQsldbHVHnXOhK+PNrwVkBVCl8jorRAqLp0DHVd8ZPiyWPdyB9LPlSslEUO0P6r3FIv5hO/AR1/2gVb5I8gC5yf8tQVmNPPCCeYvU1M2mq5Le32oricXKgAHuh2Qv72nv1ruDZu2f+hfg56CYbn7w1EhLWbIChAX3u/HrOtxUio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kX/Axxge; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kX/Axxge"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779840985; x=1811376985;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qOqJqCGw20iqiS+sk9mqMlpQVA7enZ94rTTT/wcwRmA=;
  b=kX/AxxgelQdkJlBgp0KN3ofeWBi8bqME+am4opoVHad+lUc6U5lqIxSJ
   JPa1NbNGmY0yN2ZtpXAnUsee++65b50Ak+vBLcFMhnY+Z4kfv0gkcDpo7
   xrwdsZSyMe4ZFn3QeF+xHnq2yPUPqd+IL8AMk5eokSh1JrLmUreuV6VOP
   Ytj0moAYAMFzzF051QbdoMBtNWZDKOQqcWgCH2EpRfXXodUT1o2HT/yFW
   jpoQBOqvjl/Fgx+E9DE/0h1q0XRB8+XjlJ7sumNpHHL/zg2pWh5+iUCvj
   wu5sMdLgQhX6g8dwQHca5ou38QamwRwaN1a/sT0riefle8duFWNvNcq93
   A==;
X-CSE-ConnectionGUID: EBdkUxq8QMSaELz5iFa2xw==
X-CSE-MsgGUID: WrDfCUexSqiFlVbhDPZkYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="98092136"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="98092136"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 17:16:21 -0700
X-CSE-ConnectionGUID: p2VfEESbTmygnWmicb4QyQ==
X-CSE-MsgGUID: 5AjUHhovQNqsTiJDNYCYQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="246101045"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.110.201]) ([10.125.110.201])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 17:16:20 -0700
Message-ID: <e7655b88-c56d-4d9a-8ae1-68eb9448bb87@intel.com>
Date: Tue, 26 May 2026 17:16:19 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 5/7] dax: fix holder_ops race in fs_put_dax()
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
References: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191917.79204-1-john@jagalactic.com>
 <0100019e5120c6c2-6fee7a58-7fb8-4c80-a229-4b5573e0e2c0-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e5120c6c2-6fee7a58-7fb8-4c80-a229-4b5573e0e2c0-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/22/26 12:19 PM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Clear holder_ops before holder_data so that a concurrent fs_dax_get()
> cannot have its newly installed holder_ops overwritten. Also add a
> kerneldoc comment documenting that fs_put_dax() must only be called
> by the current holder.
> 
> Fixes: eec38f5d86d27 ("dax: add fs_dax_get() for devdax")
> Signed-off-by: John Groves <john@groves.net>

Couple things from Claude that may be worth taking a look at:

  1. Memory ordering is now load-bearing and missing

  The whole correctness argument depends on the reader observing holder_ops =
  NULL before observing holder_data = NULL. The patch uses a plain store
  followed by cmpxchg. On x86 plain stores are ordered, but on arm64/ppc they
  are not — the reader can observe cmpxchg's release of holder_data while still
  seeing the old holder_ops. That puts us back in the dangerous (holder_data ==
  NULL, holder_ops == old) state on weakly-ordered arches.

  Required:

  smp_store_release(&dax_dev->holder_ops, NULL);   /* publish ops=NULL first */
  cmpxchg(&dax_dev->holder_data, holder, NULL);    /* then release holder_data
  */

  And the reader in dax_holder_notify_failure should use
  smp_load_acquire/READ_ONCE because today it reads dax_dev->holder_ops twice
  (line 334 and line 339), allowing tearing or stale-cache reads. Pre-existing
  weakness, but this patch is what makes the ordering matter.

  kill_dax (line 461-462) has the same naked-store pattern — it should be made
  consistent.

  2. Unconditional holder_ops = NULL is a behavior regression

  Pre-patch was defensive: if a caller passed the wrong holder, the cmpxchg
  failed and nothing got cleared.

  Post-patch clears holder_ops unconditionally whenever dax_dev && holder is
  truthy. A wrong-holder fs_put_dax() now actively damages the legitimate
  holder's state — sets holder_ops to NULL while holder_data retains the
  legitimate holder's pointer. From that point, all dax_holder_notify_failure()
  calls return -EOPNOTSUPP, silently breaking the legitimate holder's
  poison-recovery path.

DJ


> ---
>  drivers/dax/super.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 25cf99dd9360b..fa1d2a6eb2408 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -116,11 +116,31 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
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
> +	if (dax_dev && holder) {
> +		/*
> +		 * Clear holder_ops before holder_data so that a concurrent
> +		 * fs_dax_get() cannot have its newly installed holder_ops
> +		 * overwritten. holder_ops is only consulted when holder_data
> +		 * is non-NULL, so clearing ops first is safe — any in-flight
> +		 * holder_notify_failure() will see the old holder_data with
> +		 * NULL ops (a no-op) rather than new ops with wrong context.
> +		 */
>  		dax_dev->holder_ops = NULL;
> +		cmpxchg(&dax_dev->holder_data, holder, NULL);
> +	}
>  	put_dax(dax_dev);
>  }
>  EXPORT_SYMBOL_GPL(fs_put_dax);

