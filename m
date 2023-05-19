Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A9B125D9
	for <nvdimm@lists.linux.dev>; Fri, 19 May 2023 17:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684519075; x=1716055075;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=F3UvG25uCNkIoOOIdBdj7ui1n04FTcRrD21+/TBNisg=;
  b=BlZUuZV7ihhGmDjfYg0UQAq3lI3bjvk2YzaLssR14QBAdO0n24m17YSf
   7js5BBLySHurzvQ12jIpERqCPF2n63oMqte4uje7wldKp6EoOpEyfRJ1N
   e2CgDXe09RnAuxsy0L4jdtQ+DR8Jerg7m3SVDf0rUKLRodbTzjNs61fnw
   rGr9B73E9D/ZdJoMVxxs5z6kAvWM/4OvvR3syn012U8LbISvb0uofn8sf
   hZnZSIiyM+XpPjUVcR290UZyDZj1u7iD231QltluUy16w9XsqZ5vLmG06
   /U6Zpj8jnJVjSy0tXjiTeXltW+m3ZJJtYCCO8wAucVndiA4r9UjaIzwGK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="415903042"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="415903042"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:57:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="680127262"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="680127262"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.29.189]) ([10.212.29.189])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:57:54 -0700
Message-ID: <f3ee8396-5413-5299-a30a-b53f38ff5a53@intel.com>
Date: Fri, 19 May 2023 10:57:53 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH ndctl 1/5] cxl/memdev.c: allow filtering memdevs by bus
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>
References: <20230405-vv-fw_update-v1-0-722a7a5baea3@intel.com>
 <20230405-vv-fw_update-v1-1-722a7a5baea3@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230405-vv-fw_update-v1-1-722a7a5baea3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/21/23 8:09 PM, Vishal Verma wrote:
> The family of memdev based commands implemented in memdev.c lacked an
> option to filter the operation by bus. Add a helper to filter memdevs by
> the bus they're under, and use it in memdev_action() which loops through
> the requested memdevs. Update the man pages for all the affected
> commands as well to include the bus filter option.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   Documentation/cxl/cxl-disable-memdev.txt |  2 ++
>   Documentation/cxl/cxl-enable-memdev.txt  |  2 ++
>   Documentation/cxl/cxl-free-dpa.txt       |  2 ++
>   Documentation/cxl/cxl-read-labels.txt    |  2 ++
>   Documentation/cxl/cxl-reserve-dpa.txt    |  2 ++
>   Documentation/cxl/cxl-set-partition.txt  |  2 ++
>   Documentation/cxl/cxl-write-labels.txt   |  3 +++
>   cxl/filter.h                             |  2 ++
>   cxl/filter.c                             | 19 +++++++++++++++++++
>   cxl/memdev.c                             |  4 ++++
>   10 files changed, 40 insertions(+)
> 
> diff --git a/Documentation/cxl/cxl-disable-memdev.txt b/Documentation/cxl/cxl-disable-memdev.txt
> index edd5385..d397802 100644
> --- a/Documentation/cxl/cxl-disable-memdev.txt
> +++ b/Documentation/cxl/cxl-disable-memdev.txt
> @@ -18,6 +18,8 @@ OPTIONS
>   <memory device(s)>::
>   include::memdev-option.txt[]
>   
> +include::bus-option.txt[]
> +
>   -f::
>   --force::
>   	DANGEROUS: Override the safety measure that blocks attempts to disable
> diff --git a/Documentation/cxl/cxl-enable-memdev.txt b/Documentation/cxl/cxl-enable-memdev.txt
> index 088d5e0..5b5ed66 100644
> --- a/Documentation/cxl/cxl-enable-memdev.txt
> +++ b/Documentation/cxl/cxl-enable-memdev.txt
> @@ -23,6 +23,8 @@ OPTIONS
>   <memory device(s)>::
>   include::memdev-option.txt[]
>   
> +include::bus-option.txt[]
> +
>   -v::
>   	Turn on verbose debug messages in the library (if libcxl was built with
>   	logging and debug enabled).
> diff --git a/Documentation/cxl/cxl-free-dpa.txt b/Documentation/cxl/cxl-free-dpa.txt
> index 73fb048..506fafd 100644
> --- a/Documentation/cxl/cxl-free-dpa.txt
> +++ b/Documentation/cxl/cxl-free-dpa.txt
> @@ -24,6 +24,8 @@ OPTIONS
>   <memory device(s)>::
>   include::memdev-option.txt[]
>   
> +include::bus-option.txt[]
> +
>   -d::
>   --decoder::
>   	Specify the decoder to free. The CXL specification
> diff --git a/Documentation/cxl/cxl-read-labels.txt b/Documentation/cxl/cxl-read-labels.txt
> index 143f296..a96e7a4 100644
> --- a/Documentation/cxl/cxl-read-labels.txt
> +++ b/Documentation/cxl/cxl-read-labels.txt
> @@ -20,6 +20,8 @@ OPTIONS
>   -------
>   include::labels-options.txt[]
>   
> +include::bus-option.txt[]
> +
>   -o::
>   --output::
>   	output file
> diff --git a/Documentation/cxl/cxl-reserve-dpa.txt b/Documentation/cxl/cxl-reserve-dpa.txt
> index 5e79ef2..58cc93e 100644
> --- a/Documentation/cxl/cxl-reserve-dpa.txt
> +++ b/Documentation/cxl/cxl-reserve-dpa.txt
> @@ -24,6 +24,8 @@ OPTIONS
>   <memory device(s)>::
>   include::memdev-option.txt[]
>   
> +include::bus-option.txt[]
> +
>   -d::
>   --decoder::
>   	Specify the decoder to attempt the allocation. The CXL specification
> diff --git a/Documentation/cxl/cxl-set-partition.txt b/Documentation/cxl/cxl-set-partition.txt
> index f0126da..bed7f76 100644
> --- a/Documentation/cxl/cxl-set-partition.txt
> +++ b/Documentation/cxl/cxl-set-partition.txt
> @@ -35,6 +35,8 @@ OPTIONS
>   <memory device(s)>::
>   include::memdev-option.txt[]
>   
> +include::bus-option.txt[]
> +
>   -t::
>   --type=::
>   	Type of partition, 'pmem' or 'ram' (volatile), to modify.
> diff --git a/Documentation/cxl/cxl-write-labels.txt b/Documentation/cxl/cxl-write-labels.txt
> index 75f42a5..8f2d139 100644
> --- a/Documentation/cxl/cxl-write-labels.txt
> +++ b/Documentation/cxl/cxl-write-labels.txt
> @@ -21,6 +21,9 @@ not allow write access to the device's label data area.
>   OPTIONS
>   -------
>   include::labels-options.txt[]
> +
> +include::bus-option.txt[]
> +
>   -i::
>   --input::
>   	input file
> diff --git a/cxl/filter.h b/cxl/filter.h
> index c486514..595cde7 100644
> --- a/cxl/filter.h
> +++ b/cxl/filter.h
> @@ -36,6 +36,8 @@ struct cxl_filter_params {
>   struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
>   					  const char *__ident,
>   					  const char *serials);
> +struct cxl_memdev *util_cxl_memdev_filter_by_bus(struct cxl_memdev *memdev,
> +						 const char *__ident);
>   struct cxl_port *util_cxl_port_filter_by_memdev(struct cxl_port *port,
>   						const char *ident,
>   						const char *serial);
> diff --git a/cxl/filter.c b/cxl/filter.c
> index 90b13be..d2ab899 100644
> --- a/cxl/filter.c
> +++ b/cxl/filter.c
> @@ -243,6 +243,25 @@ static struct cxl_port *util_cxl_port_filter_by_bus(struct cxl_port *port,
>   	return NULL;
>   }
>   
> +struct cxl_memdev *util_cxl_memdev_filter_by_bus(struct cxl_memdev *memdev,
> +						 const char *__ident)
> +{
> +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +	struct cxl_bus *bus;
> +
> +	if (!__ident)
> +		return memdev;
> +
> +	cxl_bus_foreach(ctx, bus) {
> +		if (!util_cxl_bus_filter(bus, __ident))
> +			continue;
> +		if (bus == cxl_memdev_get_bus(memdev))
> +			return memdev;
> +	}
> +
> +	return NULL;
> +}
> +
>   static struct cxl_decoder *
>   util_cxl_decoder_filter_by_bus(struct cxl_decoder *decoder, const char *__ident)
>   {
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 0b3ad02..807e859 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -44,6 +44,8 @@ enum cxl_setpart_type {
>   };
>   
>   #define BASE_OPTIONS() \
> +OPT_STRING('b', "bus", &param.bus, "bus name", \
> +	   "Limit operation to the specified bus"), \
>   OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug"), \
>   OPT_BOOLEAN('S', "serial", &param.serial, "use serial numbers to id memdevs")
>   
> @@ -753,6 +755,8 @@ static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
>   			if (!util_cxl_memdev_filter(memdev, memdev_filter,
>   						    serial_filter))
>   				continue;
> +			if (!util_cxl_memdev_filter_by_bus(memdev, param.bus))
> +				continue;
>   			found = true;
>   
>   			if (action == action_write) {
> 
