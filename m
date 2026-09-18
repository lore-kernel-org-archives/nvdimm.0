Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B161251589C
	for <nvdimm@lists.linux.dev>; Fri, 18 Sep 2026 17:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789751072; cv=none; b=NaQYf58CrX6j210iHaFCv0cbRtnmMINS/vcysOpLDG5O2sqEiwPGc6alVdowVm1RpBeKgrnVhmWpc1UEhF3X9Y7h4+ppbmTvnkbva5mCPxIcBFebE7Sox8kbQ2e76CrUZEE/u0exXkQj1ElPeG0TDu36NXtDxqXlmNvd+6gYpP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789751072; c=relaxed/simple;
	bh=MnkwHZrJApUNsOtjdYn+F37zNNPyNe7IzdBGMwGWjqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nRTgvDlJkFT1fDWwB/1viqkksRyYo2fCcL/vbAe1xGs1FxSnLfuWLZh3FduQu1mK2ht+6k2hti6Nt/gq9hbrAaEic3a25OPchtqQwwSDBRH0TCYzMP5XBU1nvHAoVe0mkGvSOREQ61a4Sc2ZBrhphsg3kBm/4aNBdQjpQaVuRqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eM1p54Pl; arc=none smtp.client-ip=192.198.163.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eM1p54Pl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789751070; x=1821287070;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MnkwHZrJApUNsOtjdYn+F37zNNPyNe7IzdBGMwGWjqE=;
  b=eM1p54PlBnM3b96Q7iTRgfeLNoLfJLJHJwHdQGwEbgMyOemY8QRuiHpm
   6W1ysOTbjP/meWxCp6hjb0wAmogAa96B9ABJOLuCzeMX7EIDC2Bs0Eond
   7Mu/NgR78rCAo1KXMsJ6Bko71kt0Bpg3z15ut1ivqMdsDalArpeZUM9lZ
   P293r1oQf5iMEYeoAiKuspu97sI/QwXgKCME9oqLgbvUhsTzmIgfM9Czh
   ewImT1HbESvNX3D7yKek58vPjrml4mS5IUzJmNMzQffAYABm+Y7ivUEGJ
   atDOkP0oJWiAUHJxEFYTpdt9kB/BT7JpmP43sDxzsbtuFw9V+HlWYLdj+
   A==;
X-CSE-ConnectionGUID: iLCz6jXyTTOkilcjMDxTTQ==
X-CSE-MsgGUID: lFNXCBb0QZWHqMYlCDrZoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11909"; a="783674"
X-IronPort-AV: E=Sophos;i="6.27,109,1787036400"; 
   d="scan'208";a="783674"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa116.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 10:04:29 -0700
X-CSE-ConnectionGUID: GHrioJeRRhCg6kBJAOnDTg==
X-CSE-MsgGUID: eATVg+wWRqKIm5EG7F62Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,109,1787036400"; 
   d="scan'208";a="2701689"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.109.117]) ([10.125.109.117])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 10:04:29 -0700
Message-ID: <1b8631c6-5359-4021-a307-f3b58cfa3f9d@intel.com>
Date: Fri, 18 Sep 2026 10:04:27 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] nvdimm/pmem: Release gendisk on probe failure
To: Hemanth Selam <hemanth.selam@gmail.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260911082543.473670-1-hemanth.selam@gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260911082543.473670-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/11/26 1:25 AM, Hemanth Selam wrote:
> pmem_attach_disk() allocates the gendisk with blk_alloc_disk() and hands
> it to devres only once device_add_disk() has succeeded.  Until that
> point the probe path owns the disk itself, which is why every failure
> after the allocation jumps to the out: label and puts it there.
> 
> The devm_init_badblocks() failure returns directly instead, so the disk
> allocated a few lines earlier is never released.  Nothing releases it
> afterwards either: the devres action that would have done so has not
> been registered yet, so unbinding the namespace or destroying it does
> not reach the disk, and it stays allocated along with its queue and its
> bdev inode until the machine is rebooted.
> 
> devm_init_badblocks() only fails when a single page allocation fails, so
> reaching this at all needs memory exhaustion during namespace probe, and
> because device_add_disk() has not run there is nothing user visible left
> behind: no device node, no sysfs entry, only the leaked memory.
> 
> Release the gendisk through the existing cleanup path on this failure.
> 
> Fixes: 3dd60fb9d95d ("nvdimm/pmem: stop using q_usage_count as external pgmap refcount")
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> v2, all of it from Alison's review of v1:
>  - retitled, and the changelog rewritten as background, problem, impact
>    and resolution rather than a walk through the call sequence
>  - says whether the disk is permanently leaked: it is, because the
>    devres action has not been registered at that point, so no later
>    unbind or destroy reaches it
>  - says when the failure can be reached at all, and that nothing user
>    visible is left behind
>  - the Fixes: tag re-derived.  v1 blamed b95f5f4391fa, but the early
>    return after the disk was allocated already existed before it; that
>    commit only changed which call failed.  The leak starts at
>    3dd60fb9d95d, which removed the pmem_release_queue devres action and
>    the fsdax_pagemap_ops .cleanup that had been freeing the disk on
>    these paths.  accf58afb689 then converted the addr and dax_dev
>    returns to goto out, and this one was missed.
>  - the object counts kept, but measured across four batch sizes so that
>    the scaling is visible, and the shortfall you noticed explained
> 
> Found by an AI-assisted review of the error paths in pmem_attach_disk().
> 
> Tested on 7.3.0-rc2 in QEMU, with a legacy pmem region (memmap=1G!2G) and
> a local debug patch forcing the devm_init_badblocks() branch, as it is
> otherwise only reachable under memory exhaustion.  namespace0.0 was bound
> and unbound repeatedly with the branch forced, counting bdev_cache in
> /proc/slabinfo after a drop_caches and a settle:
> 
>     failed probes      32     64    128    256
>     growth, unfixed   +24    +60   +120   +252
>     growth, fixed     +12    +12    +12    +12
> 
> Without the patch the count tracks the number of failed probes, and the
> unbind between attempts does not bring it back down, which is what makes
> the leak permanent.  With the patch it is flat.  Both rows sit a little
> under the probe count because SLUB's active_objs is an estimate, which is
> the discrepancy you asked about in v1.  Clearing the debug flag and
> binding again still gives a working /dev/pmem0.
> 
> v1: https://lore.kernel.org/all/20260824060113.2330468-1-hemanth.selam@gmail.com/
> 
>  drivers/nvdimm/pmem.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 30a51c365ce8..648fc7d66063 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -563,8 +563,10 @@ static int pmem_attach_disk(struct device *dev,
>  	nvdimm_namespace_disk_name(ndns, disk->disk_name);
>  	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
>  			/ 512);
> -	if (devm_init_badblocks(dev, &pmem->bb))
> -		return -ENOMEM;
> +	if (devm_init_badblocks(dev, &pmem->bb)) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
>  	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
>  	disk->bb = &pmem->bb;
>  

