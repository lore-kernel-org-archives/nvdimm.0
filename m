Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C4822257E;
	Mon, 13 Apr 2026 15:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776093509; cv=none; b=JW1cCk9Qx8VOorxCJVpskbB5hgZFIG3iUeFaoa8x9b4yR+VMYsd3q11x2AwAq8RXr7VxyqSitZUKaPfUKLlSD6oyd7d7IhTpFnuLdGt9zgvB5ckQ3aavxA2YwixEBpB9NuOhmnfRCdYxEuM+wEnXnqgihCN2UaRgkKntSYE5gAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776093509; c=relaxed/simple;
	bh=qPosjHYLo9Hq2FhDXbwq7orePQ+n+tSloJdBUSsczt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D/vI2DK3Hvp7xNbFPyEeYY7NpqJGxuhvCPoDtnEY0LLIZrp2NA/Eq6+eY5jPXe3WwwCNjiXT8O4EtSqyJ80SJUCvTZhnNrAB3K3a5Rag0qreMOCwZZ4rfsM6eTppRyvkktqYpoChDFs0KquzAYTQg25GR02alR3B/A+aecElqlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K1qPaqfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1qPaqfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5EBC2BCAF;
	Mon, 13 Apr 2026 15:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776093509;
	bh=qPosjHYLo9Hq2FhDXbwq7orePQ+n+tSloJdBUSsczt4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K1qPaqfk+ihx13XKNsQtlioArqeIhdxNB/ZKZGPCr6BuEy0pAb37wqz+bxBWwCwZQ
	 puErCwlnV4880p5ybrQn8UsJ2WNY3igCfrpxP0vBcjBWLJqI4bJmiLLnxFpcet+9ns
	 6uPvatoSXrx0fV6+RfVyexaB+pUmlewcZxOQUP5G3nGgXsxyZeWyR+ARea7hcF03RZ
	 9ohD2GC7sAb2KiA92vTjxhp3pKBlFPXZpbTtzRkzRuuXnR1TmkZUOPIrLrRi70tW5u
	 An52ysAqhKZGFyG9fFc+O1wXT2BfkoUIDdpcr2j0Rk8qOfQU0teS/bYto9YFii3R75
	 /TMvL44Xg9m6g==
Message-ID: <f4436f23-3af5-4b07-a582-69ff704dc17c@kernel.org>
Date: Mon, 13 Apr 2026 17:18:21 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] mm/memory_hotplug: export mhp_get_default_online_type
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 osalvador@suse.de
Cc: dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321150404.3288786-5-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260321150404.3288786-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/26 16:04, Gregory Price wrote:
> Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
> and the mhp_get_default_online_type function for hotplug use cases.
> 
> Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
> the same driver code, and chose the dax_kmem path as the default driver
> path - making it difficult to require hotplug as a predicate to building
> the overall driver (it may break other non-hotplug use-cases).
> 
> Export mhp_get_default_online_type function to allow these drivers to
> build when hotplug is disabled and still use the DAX use case.
> 
> In the built-out case we simply return MMOP_OFFLINE as it's
> non-destructive.  The internal function can never return -1 either,
> so we choose this to allow for defining the function with 'enum mmop'.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  include/linux/memory_hotplug.h | 29 +++++++++++++++++++++++++++++
>  mm/memory_hotplug.c            |  1 +
>  2 files changed, 30 insertions(+)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index e77ef3d7ff73..a8bcb36f93b8 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -6,6 +6,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/notifier.h>
>  #include <linux/bug.h>
> +#include <linux/errno.h>
>  
>  struct page;
>  struct zone;
> @@ -28,6 +29,27 @@ enum mmop {
>  	MMOP_ONLINE_MOVABLE,
>  };
>  
> +/**
> + * mmop_to_str - convert memory online type to string
> + * @online_type: the MMOP_* value to convert
> + *
> + * Returns a string representation of the memory online type,
> + * suitable for sysfs output (includes trailing newline).
> + */
> +static inline const char *mmop_to_str(enum mmop online_type)
> +{
> +	switch (online_type) {
> +	case MMOP_ONLINE:
> +		return "online\n";
> +	case MMOP_ONLINE_KERNEL:
> +		return "online_kernel\n";
> +	case MMOP_ONLINE_MOVABLE:
> +		return "online_movable\n";
> +	default:
> +		return "offline\n";
> +	}
> +}

In drivers/base/memory.c we have online_type_to_str[]. Likely you should
build upon that, and locate the code in there as well (or move all of
that to the same header). And call the function something matching like
mhp_online_type_to_str().

But, the patch description only spells out exporting
mhp_get_default_online_type(), so something is missing here why these
changes are even included in this patch.


-- 
Cheers,

David
