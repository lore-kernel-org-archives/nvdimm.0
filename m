Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835FE316197
	for <nvdimm@lists.linux.dev>; Mon, 22 Jun 2026 18:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782152069; cv=none; b=rHhSzxXWEb7bF/FipJQ6ohUgNy+74TucQKSg+RDwbuCW2FQYCI3RRYfI8lRUep903y9061fw8xdFSxVecagJMpuit0LQW7myU4E/SAV+VnsBPr98Yn/tBO7jz7ZeaLReU8ABe2UDlse9Q7BRZYRPvdUdw478xzeGwfjBe7K3F/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782152069; c=relaxed/simple;
	bh=kH2OSgrR0daI3J6D/xDWHfzT7F1M8Tw89DTA5LGgOrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DeXQOwxAB9c/5xzgSM4y2TVt0g3k+niBH7ayidgaVDXG1eaMpYc1HjWf386E+mPl6tUwKbwBFSSFKXBRRVuH99YY/psmkfdpYKKRDDimyBPKHDtUvOAyPaih2PxtycPGgVQYdr9PVt8O1o8nXQ11ZwHelg/pOiIsnpUwc96YNaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DmDHbQoA; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DmDHbQoA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782152067; x=1813688067;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=kH2OSgrR0daI3J6D/xDWHfzT7F1M8Tw89DTA5LGgOrM=;
  b=DmDHbQoAxL5aTzhHUky5SPKS1P4HFRSK2GoPWiXkPWKdAFaese4dhQig
   8tOWikOQ9VchgctyOuAaROo2YVXV7yXGwnzS+6nFa0q9ZDQ7bPTQFdFGk
   cvm4haCaGRmMgj97G8IT4N0ERLCnVZa0gpsNy8LmuH+v9uBPYRn2sNT+L
   mXbIoGH1g7hOiRY7kyBhM3FJI+zhSHpjERSbzmg2Gt6IB0LBd9KBGBv6n
   ywsajN2KZrUOOR+wQ0JCG2uT+hyaR6hf2xO1fAefihaDnmArv3/KtZ42Q
   3hDJH9dkLJ3qKxovB6mbtM7tkgG4nQMH5Wfyb+IQwAicmKHmwflNF2a2W
   Q==;
X-CSE-ConnectionGUID: E0zFewuuRa6coH+P4bT+eQ==
X-CSE-MsgGUID: sFR3kZcLRvKLSPc+MKIJ6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="94007422"
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="94007422"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 11:14:27 -0700
X-CSE-ConnectionGUID: KKY0fuNcQ7GlSNU/iuxDpA==
X-CSE-MsgGUID: fZg/J3niS6SzBNnp2HCiig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="246380386"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.108.100]) ([10.125.108.100])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 11:14:25 -0700
Message-ID: <da2f4702-e389-4534-8046-94a7d8c32788@intel.com>
Date: Mon, 22 Jun 2026 11:14:23 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm/btt: add endian conversion in dev_err in
 btt_log_read
To: Ben Dooks <ben.dooks@codethink.co.uk>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260622142011.491522-1-ben.dooks@codethink.co.uk>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260622142011.491522-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/22/26 7:20 AM, Ben Dooks wrote:
> The dev_err() call in btt_log_read() is passing a seq value
> into dev_err() which is a __le32 without any conversion.
> 
> Fix the following (prototype) sparse warnings:
> drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 5 (different base types)
> drivers/nvdimm/btt.c:342:17:    expected int
> drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq
> drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 6 (different base types)
> drivers/nvdimm/btt.c:342:17:    expected int
> drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/btt.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 7e1112960d7f..e9d548442884 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -341,8 +341,9 @@ static int btt_log_read(struct arena_info *arena, u32 lane,
>  	if (old_ent < 0 || old_ent > 1) {
>  		dev_err(to_dev(arena),
>  				"log corruption (%d): lane %d seq [%d, %d]\n",
> -				old_ent, lane, log.ent[arena->log_index[0]].seq,
> -				log.ent[arena->log_index[1]].seq);
> +				old_ent, lane,
> +				le32_to_cpu(log.ent[arena->log_index[0]].seq),
> +				le32_to_cpu(log.ent[arena->log_index[1]].seq));
>  		/* TODO set error state? */
>  		return -EIO;
>  	}

