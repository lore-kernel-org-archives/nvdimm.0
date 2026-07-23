Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4184361962
	for <nvdimm@lists.linux.dev>; Thu, 23 Jul 2026 21:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840985; cv=none; b=mkNcgwKk7fvdugpn39GmAV9kdyYhqwld2s/Gox5JBYJwPPCRCZGSso3zicE1+sxw6vkx4iqcrW8P7iQjLNzIPDjlYF/Rj9plwKOnWFK8pF6wy36A1hKd3fSewWUbcYY/ekf5/iqj05WA/IzkjyfHtk15CwE3AOY9zuYX4nS00EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840985; c=relaxed/simple;
	bh=gpKHmEPl19mjSrJdu9c1j21HlJrdu1M8dhYbXI+i2Hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NI+gQDzjBvAn4kU1MU73OgJhjCs0Eycf065XPVCXriu5WtE/7yZzDM2gtVT2I4GaQL3aAHcPYXrudw3V+jYaz+UE7R69AmRByxIoAfyXQLVkPoWr5QwAtTaVr8fsOq8/Sf175JAmGkrxdFengYmuxOBEzg7QyWvPqElWJcu6ivw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m6XijFj8; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m6XijFj8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784840981; x=1816376981;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gpKHmEPl19mjSrJdu9c1j21HlJrdu1M8dhYbXI+i2Hc=;
  b=m6XijFj8xGXxvQ6Lmh6MtZ8OM67f1QfOS0QTFfL4ZzBmKFSaxUaU5yLa
   39udQcYLpmFaynojt1ZvRFWRatY7CQ7j+0hwQdmOWnVoKUhBSW502e+U/
   tbCxdRUCg0qhJn/HGpXXRtbaWE/kzgh8T9MJqHmAM5iZjsJlYWwp5Yf0y
   xpdvzhk7Rl2dBrmmVxTg/uwNyG3na0T1zbqdwf7rffCmtKqrHIo7YQC+M
   gl1+dSZTcxxe06zsYySBY97u9ioOLo4MCKQp6lDaX1ViKF09yuR3kfEzp
   IqE0AYI+I9h73ID6bsy0zokTRjzwWwz+BqHbknefWnMK3NIB7oTNtwyjb
   A==;
X-CSE-ConnectionGUID: EKb+EDMNSOiu42p7aiCNtg==
X-CSE-MsgGUID: K02Uq4yiQeOc0UbJql/Sow==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="108296299"
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="108296299"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 14:09:38 -0700
X-CSE-ConnectionGUID: aZyY/9LKS5+yl4Kwm6ks/A==
X-CSE-MsgGUID: Jvc6hYt/THunAPCUCEtcRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="263500409"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.110.160]) ([10.125.110.160])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 14:09:36 -0700
Message-ID: <85ab2829-f2d2-47f4-952b-e64c10e82d8a@intel.com>
Date: Thu, 23 Jul 2026 14:09:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] libnvdimm: nd.h: clean up kernel-doc warnings
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, nvdimm@lists.linux.dev
References: <20260721172132.3718892-1-rdunlap@infradead.org>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260721172132.3718892-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/21/26 10:21 AM, Randy Dunlap wrote:
> Add missing struct member, function parameters, and function return
> values to eliminate all kernel-doc warnings:
> 
> Warning: include/linux/nd.h:124 struct member 'common' not described in 'nd_namespace_io'
> Warning: include/linux/nd.h:124 Excess struct member 'dev' description in 'nd_namespace_io'
> Warning: include/linux/nd.h:166 function parameter 'flags' not described in 'nvdimm_read_bytes'
> Warning: include/linux/nd.h:166 No description found for return value of 'nvdimm_read_bytes'
> Warning: include/linux/nd.h:185 function parameter 'flags' not described in 'nvdimm_write_bytes'
> Warning: include/linux/nd.h:185 No description found for return value of 'nvdimm_write_bytes'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> Cc: Dan Williams <djbw@kernel.org>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Ira Weiny <iweiny@kernel.org>
> Cc: nvdimm@lists.linux.dev
> 
>  include/linux/nd.h |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> --- linux-next-20260720.orig/include/linux/nd.h
> +++ linux-next-20260720/include/linux/nd.h
> @@ -110,7 +110,7 @@ static inline struct nd_namespace_common
>  
>  /**
>   * struct nd_namespace_io - device representation of a persistent memory range
> - * @dev: namespace device created by the nd region driver
> + * @common: namespace device core infrastructure created by the nd region driver
>   * @res: struct resource conversion of a NFIT SPA table
>   * @size: cached resource_size(@res) for fast path size checks
>   * @addr: virtual address to access the namespace range
> @@ -158,8 +158,11 @@ static inline struct nd_namespace_pmem *
>   * @offset: namespace-relative starting offset
>   * @buf: buffer to fill
>   * @size: transfer length
> + * @flags: process (0) or atomic (1) context
>   *
>   * @buf is up-to-date upon return from this routine.
> + *
> + * Returns: %0 on success or a negative error code on failure
>   */
>  static inline int nvdimm_read_bytes(struct nd_namespace_common *ndns,
>  		resource_size_t offset, void *buf, size_t size,
> @@ -174,11 +177,14 @@ static inline int nvdimm_read_bytes(stru
>   * @offset: namespace-relative starting offset
>   * @buf: buffer to drain
>   * @size: transfer length
> + * @flags: process (0) or atomic (1) context
>   *
>   * NVDIMM Namepaces disks do not implement sectors internally.  Depending on
>   * the @ndns, the contents of @buf may be in cpu cache, platform buffers,
>   * or on backing memory media upon return from this routine.  Flushing
>   * to media is handled internal to the @ndns driver, if at all.
> + *
> + * Returns: %0 on success or a negative error code on failure
>   */
>  static inline int nvdimm_write_bytes(struct nd_namespace_common *ndns,
>  		resource_size_t offset, void *buf, size_t size,

