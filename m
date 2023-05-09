Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B76E17FE0
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683654359; x=1715190359;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5geztCiICG6q0ZiKQJfhQvhgE04r7s2rrDZ1IgWQR2E=;
  b=YHZn5omdNZIqKmIEQpo60OVlR0gNLleIqftk1c4Wpbu1hm1id2ucT6js
   SyXSiCKHTEThBYIONqtTCfTuWggAno/vOkrYnx0bl/yOQYo80NNvBkNgt
   5PWjSE8IYk8n1Yqu0qFJDF6WtxZZ3aDWhCwHQOU4b/y5xQHzTTqs9K8hN
   1GrlBBi3ezJXt7o0SaOB87Fuc9+eCP/IWSSW4QzzOy8QFUZmwou4xicn/
   0NHoD1uJvuJmwXFTUVUj502hAxSfwnuY+O6b1A4wNhaFKu96ujve5Tj5A
   BSa06QwBqmndWYiOSetwFrNQeH9zpTYjC6GvIXQdcfebt5Eh5vORgUyV9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="352182926"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="352182926"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:45:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="693075085"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="693075085"
Received: from dcovax-mobl.amr.corp.intel.com (HELO [10.212.97.226]) ([10.212.97.226])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:45:58 -0700
Message-ID: <8fac1e26-2291-af82-323b-9e17ef7dd511@intel.com>
Date: Tue, 9 May 2023 10:45:57 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH ndctl] typo fix: ovewrite -> overwrite
Content-Language: en-US
To: Yi Zhang <yi.zhang@redhat.com>, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com, dan.j.williams@intel.com
References: <20230509230005.2122950-1-yi.zhang@redhat.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230509230005.2122950-1-yi.zhang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/9/23 4:00 PM, Yi Zhang wrote:
> Fix typos in Documentation/ndctl/ndctl-sanitize-dimm.txt and ndctl/lib/dimm.c
> 
> Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   Documentation/ndctl/ndctl-sanitize-dimm.txt | 2 +-
>   ndctl/lib/dimm.c                            | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
> index e044678..72ec96e 100644
> --- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
> +++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
> @@ -47,7 +47,7 @@ include::xable-bus-options.txt[]
>   	label data. Namespaces get reverted to raw mode.
>   
>   -o::
> ---ovewrite::
> +--overwrite::
>   	Wipe the entire DIMM, including label data. This can take significant
>   	time, and the command is non-blocking. With this option, the overwrite
>   	request is merely submitted to the NVDIMM, and the completion is
> diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
> index 2b6e8a5..f9dde2f 100644
> --- a/ndctl/lib/dimm.c
> +++ b/ndctl/lib/dimm.c
> @@ -853,7 +853,7 @@ NDCTL_EXPORT int ndctl_dimm_wait_overwrite(struct ndctl_dimm *dimm)
>   		dbg(ctx, "%s: overwrite complete\n",
>   				ndctl_dimm_get_devname(dimm));
>   	else if (rc == 0)
> -		dbg(ctx, "%s: ovewrite skipped\n",
> +		dbg(ctx, "%s: overwrite skipped\n",
>   				ndctl_dimm_get_devname(dimm));
>   	else
>   		dbg(ctx, "%s: overwrite error waiting for complete\n",
