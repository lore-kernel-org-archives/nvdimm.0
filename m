Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1473F65FC
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 15:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779119130; cv=none; b=NU0iU66GZaAWxhvFTz9gr10zviqMhu5dKt1oAi9ykyTQDKWlklH2oxO1I//a/NdxWSgwFix1RwwVeIqSqHOKYXmeNQlTltF5cveDRFlgEpEZCOIa4xlUzGBhT6+R5WkFoh0xUrg/3mvkzrn6ekp8e6muU8ae6CvFpaCPzPyAj0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779119130; c=relaxed/simple;
	bh=HKxtO0yR/IM3FGjYVNRZAhALOn/0uxLmniCPMpQoCvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=usK85YH8aSvyiBqoHJIpWXNgArDZfe5I+iQFAy14VX1V3d20YQO8a/tAyApdXk9JZMo1Amn9K9nRc+nydoJt9aRgjIXZmYtYZc3ayqQlmItetY9ttl+VCZThOHzfin8YaM+v6k+76/ohEqJMs/NkrtGEaLOcf2sD8JuuCzwWhgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bocx2U4Q; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bocx2U4Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779119127; x=1810655127;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HKxtO0yR/IM3FGjYVNRZAhALOn/0uxLmniCPMpQoCvg=;
  b=bocx2U4QWWb4hS9t3O+NHwEpQ/83TugFhEwcXUFBAx9mv9lL6u1iNefH
   lNlFk3bAc7YRYZa578TMyQnRZtF4NlkNW3lcoooqKmKH9bD+tQc6Cizno
   gq/HcdC8cA1xBj4jRABj5zSeQmD/VlJs53spQtG7Goj/NyN/n/K1xLGx7
   mefxg+uGZKo3/yhi+D8KtxIB4Y0ol6HaAI7Wmkufi7O3gtVnxaKlH4YPK
   vBha3Vn8ZMsQtzwkz2PfIeCN/BtLSWwmelDbq85hXwqJANT5sebcynFJJ
   aDzBP5wglTvvDbMCRAqkxgIKEPDPyAgvm4PRi93BEHEOa6ZbmNp6QytQn
   w==;
X-CSE-ConnectionGUID: ponWgJ1TSwaZP8m3Etp1ug==
X-CSE-MsgGUID: 6U0A4zcuR0qX8zhJ42sjAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11790"; a="78996684"
X-IronPort-AV: E=Sophos;i="6.23,242,1770624000"; 
   d="scan'208";a="78996684"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2026 08:45:25 -0700
X-CSE-ConnectionGUID: QkkwGVLYSi2EBo+uF1yQ0w==
X-CSE-MsgGUID: kDklf8YeRjOT1Sip90tfmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,242,1770624000"; 
   d="scan'208";a="241282772"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.65]) ([10.125.109.65])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2026 08:45:24 -0700
Message-ID: <8c2135c7-eb97-457e-860c-83f784b5328b@intel.com>
Date: Mon, 18 May 2026 08:45:23 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] nvdimm: Convert nvdimm_bus guard to class
To: Dmitry Ilvokhin <d@ilvokhin.com>, Peter Zijlstra <peterz@infradead.org>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Miguel Ojeda <ojeda@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
References: <cover.1779116497.git.d@ilvokhin.com>
 <9857a934214db3460bf55a56e152dedfa1d8bd01.1779116497.git.d@ilvokhin.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <9857a934214db3460bf55a56e152dedfa1d8bd01.1779116497.git.d@ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/18/26 8:21 AM, Dmitry Ilvokhin wrote:
> The nvdimm_bus guard accepts NULL and skips locking when NULL is passed.
> Convert from DEFINE_GUARD() to DEFINE_CLASS() + DEFINE_CLASS_IS_GUARD().
> 
> This is a preparatory change for making DEFINE_GUARD() constructors
> __nonnull(). nvdimm_bus legitimately passes NULL, so it must be adjusted
> to avoid a compile error.
> 
> No functional change.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/nd.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index b199eea3260e..18b64559664b 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -632,8 +632,11 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
>  u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
>  void nvdimm_bus_lock(struct device *dev);
>  void nvdimm_bus_unlock(struct device *dev);
> -DEFINE_GUARD(nvdimm_bus, struct device *,
> -	     if (_T) nvdimm_bus_lock(_T), if (_T) nvdimm_bus_unlock(_T));
> +DEFINE_CLASS(nvdimm_bus, struct device *,
> +	     if (_T) nvdimm_bus_unlock(_T),
> +	     ({ if (_T) nvdimm_bus_lock(_T); _T; }),
> +	     struct device *_T);
> +DEFINE_CLASS_IS_GUARD(nvdimm_bus);
>  
>  bool is_nvdimm_bus_locked(struct device *dev);
>  void nvdimm_check_and_set_ro(struct gendisk *disk);

