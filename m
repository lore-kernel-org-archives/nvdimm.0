Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF9B2C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 20:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641501624; x=1673037624;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KZyQPDpbiZhWCmOnCsxj9VhyJoF0sP1HJlXxHYTbXEc=;
  b=krPycV8Dda0mvsCh/M1UkCPia8+wPX4zr1eYB7oFghUJnMbzRMCcb2FV
   EO4HSyCOmMvRf36We4QDmTKeZN9Vy+mm/QAv87vPD9+F+VPRSTNombWGa
   uROOPxFDZuaySaJF/cqQZOiCVffC4+M8CdpGE2qvg+YjHy97/a4EWwNTR
   M4GEB2OkG/EpV5XHtrcsIlZlqK4mK2WJ0UPTrHlPrlJGhB+JjY3Aega8q
   wCo8Orksg3M0LxbbUGBx8wKlMOalZTs+FfJRvvPv9ubFxfV7l/TNcTBCM
   5oVgcUUnuQwDopXNcLX7FwQSqMdeWPU8i9IIvITWzt0mjHrZedE+aUCeo
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="267025679"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="267025679"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:40:19 -0800
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="668556215"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:40:19 -0800
Date: Thu, 6 Jan 2022 12:40:19 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: alison.schofield@intel.com
Cc: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 3/7] libcxl: apply CXL_CAPACITY_MULTIPLIER to
 partition alignment field
Message-ID: <20220106204019.GD178135@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: alison.schofield@intel.com,
	Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
References: <cover.1641233076.git.alison.schofield@intel.com>
 <a5ff95fd75d42c29a15d285caee81cb9ea4c05d8.1641233076.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5ff95fd75d42c29a15d285caee81cb9ea4c05d8.1641233076.git.alison.schofield@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Jan 03, 2022 at 12:16:14PM -0800, Schofield, Alison wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> The IDENTIFY mailbox command returns the partition alignment field
> expressed in multiples of 256 MB.

Interesting...

I don't think anyone is using this function just yet but this does technically
change the behavior of this function.

Will that break anyone or cxl-cli?

> Use CXL_CAPACITY_MULTIPLIER when
> returning this field.
> 
> This is in sync with all the other partitioning related fields using
> the multiplier.

To me the fact that this was not in bytes implies that the original API of
libcxl was intended to not convert these values.

Vishal may have an opinion.  Should these be in bytes or 'CXL Capacity' units
(ie 256MB's)?

I think I prefer bytes as well.

Ira

> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/lib/libcxl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 715d8e4..85a6c0e 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1086,7 +1086,7 @@ CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
>  	if (cmd->status < 0)
>  		return cmd->status;
>  
> -	return le64_to_cpu(id->partition_align);
> +	return le64_to_cpu(id->partition_align) * CXL_CAPACITY_MULTIPLIER;
>  }
>  
>  CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
> -- 
> 2.31.1
> 
