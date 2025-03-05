Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A1F24EF7A
	for <nvdimm@lists.linux.dev>; Wed,  5 Mar 2025 16:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741192991; cv=none; b=Q8GO+nQ2llxqpTnHRpFJFfd5PK1atRViVJ7+ZmQ88qN7UsrHGVVDIpTFL6aFavTUhyJk172Tq6SDYlOWC4gn/mmk1R1SzbrGowpnIBAIvJzHIQOvGSOtv8DW7YlT+YG3cZ4VZWp/Y13UbpqJqIxsH3stM8hg7EJsw1Qy+9aM8zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741192991; c=relaxed/simple;
	bh=7dqa6cs1pUa/RGAXtOefcKR4C+b2HkCX+uTcFmrSTTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PsT0UE1esZA8KxX1Q2z/noSZieBBgZ9bp1jPV+H/ffkEtg4RxFZ0yvsZpdQeQy0vkhndaTbDxgaGwvCIaBgURJi9PVoMmXJHn2SlplTVHi3ThYAtlPr3tB8h2EUbhReRWS+AdjxF3nDvjYEG+7XSIHMzipsSeb8c807SxaW14LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j3470rAe; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j3470rAe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741192991; x=1772728991;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=7dqa6cs1pUa/RGAXtOefcKR4C+b2HkCX+uTcFmrSTTY=;
  b=j3470rAegtRtO0l/ujihiZkim0FTYlUH45lRK6VKx+w4F2b2WJHxaEJ1
   93JMNr/VbBO+pw/nbIw4ADSbdox7gaovzW+Gn0zXZP9FUcDREoBkRQU8h
   4LGfxV88F8TWxCIDyVkbKZu8wX2AfeKPzSdjgOhZrn6AQRdpyQHZT9kV0
   4Cr2hJe8YtwpMiYlVrS/z7+VFES3pLYOHaHnEGp9894dmhPw2hfPOSMc5
   nXfEMZI5LO/oDfm2u/EWPsNX2RpusQMtZMZ3t/08Ky3Ix3pUfC3Bw5zmI
   utco0S1FcqI3+6+p2LD6eOKbSDiB3qiKxzjjWlS+EUo427KL/AQfhxmgw
   A==;
X-CSE-ConnectionGUID: kLuxQERZQmyxD1vRDPkX1g==
X-CSE-MsgGUID: ZaL/UYILQtGLvXnBqxX6Ew==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42190222"
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="42190222"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 08:43:10 -0800
X-CSE-ConnectionGUID: 1AqV692bRfefxDaoSBj3YQ==
X-CSE-MsgGUID: cD0m+Hp9RxyRmW+uXyLFeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118666976"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.222]) ([10.125.109.222])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 08:43:10 -0800
Message-ID: <b3550837-7ddd-4aee-92f8-0ec988d0dfe9@intel.com>
Date: Wed, 5 Mar 2025 09:43:08 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 4/5] ndctl/namespace: protect against overflow
 handling param.offset
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
References: <cover.1741047738.git.alison.schofield@intel.com>
 <065eb60a8255e44d73b5be963ba3a4a532ae1689.1741047738.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <065eb60a8255e44d73b5be963ba3a4a532ae1689.1741047738.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/3/25 5:37 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> A param.offset is parsed using parse_size64() but the result is
> not checked for the error return ULLONG_MAX. If ULLONG_MAX is
> returned, follow-on calculations will lead to overflow.
> 
> Add check for ULLONG_MAX upon return from parse_size64.
> Add check for overflow in subsequent PFN_MODE offset calculation.
> 
> This issue was reported in a coverity scan.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/namespace.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 5eb9e1e98e11..40bcf4ca65ac 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -1872,6 +1872,10 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
>  	int rc;
>  
>  	start = parse_size64(param.offset);
> +	if (start == ULLONG_MAX) {
> +		err("failed to parse offset option '%s'\n", param.offset);
> +		return -EINVAL;
> +	}
>  	npfns = PHYS_PFN(size - SZ_8K);
>  	pfn_align = parse_size64(param.align);
>  	align = max(pfn_align, SUBSECTION_SIZE);
> @@ -1913,6 +1917,10 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
>  		 * struct page size. But we also want to make sure we notice
>  		 * when we end up adding new elements to struct page.
>  		 */
> +		if (start > ULLONG_MAX - (SZ_8K + MAX_STRUCT_PAGE_SIZE * npfns)) {
> +			error("integer overflow in offset calculation\n");
> +			return -EINVAL;
> +		}
>  		offset = ALIGN(start + SZ_8K + MAX_STRUCT_PAGE_SIZE * npfns, align)
>  			- start;
>  	} else

