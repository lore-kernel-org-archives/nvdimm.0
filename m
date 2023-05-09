Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164DC17FE0
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 17:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683653578; x=1715189578;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9c9rODCEChw8HkLEJmiJj2jDB4UiE+/DfspcG/XxYQs=;
  b=josG3C2L3PTJgcptS50S2pqGzSUhehhos1Xi6lLNmGdKbT+CfLnXodnG
   FXNEMNwQG1XBrEN2oMCLkRGv7pRLkHXBXkJdXrNmxW/6t/0Qn6O29O450
   rFMX3S37Aa2JXHL2x/iihbO+W5ews8Xe1ojQXi2StwRbi7r3YCfSMXyUg
   DwF7GP//tIZVa6qZeUfwy8E4zUKaEiBMs4bwp/We2Ri7CKSZSwVyDyQ5O
   tXyg1ldlYfByLRrHzTzTKY2LuRTXmrcRSDlShhYGXpH8MPsQBFUIpOO1Z
   JIcXT8feYJ4aDTBj5GPxnExdwUzgDz1I5UXD3GJAQdua1nIwMz2C2tlIZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="353065943"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="353065943"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:31:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="731824461"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="731824461"
Received: from dcovax-mobl.amr.corp.intel.com (HELO [10.212.97.226]) ([10.212.97.226])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:31:55 -0700
Message-ID: <d6626276-2822-61f5-6b5e-296a49ffbea1@intel.com>
Date: Tue, 9 May 2023 10:31:55 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [ndctl PATCH 1/3] cxl/list: Fix typo in cxl-list documentation
Content-Language: en-US
To: Minwoo Im <minwoo.im.dev@gmail.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
References: <20230509152427.6920-1-minwoo.im.dev@gmail.com>
 <20230509152427.6920-2-minwoo.im.dev@gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230509152427.6920-2-minwoo.im.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/9/23 8:24 AM, Minwoo Im wrote:
> s/the returned the returned object/the returned object
> s/ellided/elided
> s/hierararchy/hierarchy
> s/specifed/specified
> s/identidier/identifier
> s/scenerios/scenarios
> 
> Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   Documentation/cxl/cxl-list.txt | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index c64d65d3ffbe..838de4086678 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -18,9 +18,9 @@ instances along with some of their major attributes.
>   Options can be specified to limit the output to specific objects. When a
>   single object type is specified the return json object is an array of
>   just those objects, when multiple objects types are specified the
> -returned the returned object may be an array of arrays with the inner
> -array named for the given object type. The top-level arrays are ellided
> -when the objects can nest under a higher object-type in the hierararchy.
> +returned object may be an array of arrays with the inner
> +array named for the given object type. The top-level arrays are elided
> +when the objects can nest under a higher object-type in the hierarchy.
>   The potential top-level array names and their nesting properties are:
>   
>   "anon memdevs":: (disabled memory devices) do not nest
> @@ -34,7 +34,7 @@ The potential top-level array names and their nesting properties are:
>   "endpoint decoders":: nest under endpoints, or ports (if endpoints are
>      not emitted) or buses (if endpoints and ports are not emitted)
>   
> -Filters can by specifed as either a single identidier, a space separated
> +Filters can be specified as either a single identifier, a space separated
>   quoted string, or a comma separated list. When multiple filter
>   identifiers are specified within a filter string, like "-m
>   mem0,mem1,mem2", they are combined as an 'OR' filter.  When multiple
> @@ -263,7 +263,7 @@ OPTIONS
>   --buses::
>   	Include 'bus' / CXL root object(s) in the listing. Typically, on ACPI
>   	systems the bus object is a singleton associated with the ACPI0017
> -	device, but there are test scenerios where there may be multiple CXL
> +	device, but there are test scenarios where there may be multiple CXL
>   	memory hierarchies.
>   ----
>   # cxl list -B
