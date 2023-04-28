Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ED36101
	for <nvdimm@lists.linux.dev>; Fri, 28 Apr 2023 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682698018; x=1714234018;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J08f/hTWevMWIxBOMCnPQYnNGa60d/STH9HrXUvb4VA=;
  b=dAV6CZcWjUITb8XaATOcbKBMGwsk+dpqqq+5i4lMClerFuHmfIhCvFhB
   B+I2TRhp81+o1VjYUjM5SN3BJvs3nmLd7/Qj4GvmqTikvYmnn9jV/Dz3Q
   rtTWs9/ZPWMSqWGgqAXOZ7xKfAnWDub3ENvdjLY5q4jdfi/K1I0HCBSgI
   Mwa+JxGFlrv0XTX0yPvkKZt2KUY+cosRu7qS06N58F+2FSrY1K1DUgA18
   Y/Ut2p3KkDTmz0RgPV03Vd97CK6MtfNwXRg+m1V33UpOnqJTrBnA1qT9t
   Ey82c2pt5R88fIQ7UyXb5jWUJJdTphuO8EtvkS/Uc48S2QDh/moPozrSh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="375780631"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="375780631"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 09:06:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="697588275"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="697588275"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.108.170]) ([10.212.108.170])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 09:06:57 -0700
Message-ID: <20661e33-3fa5-ef03-0860-fa20f540a3f6@intel.com>
Date: Fri, 28 Apr 2023 09:06:56 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] test: Fix dangling pointer warning
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <168236637159.1027628.7560967008080605819.stgit@dwillia2-xfh.jf.intel.com>
 <168236639399.1027628.5866455518934998684.stgit@dwillia2-xfh.jf.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <168236639399.1027628.5866455518934998684.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/24/23 12:59 PM, Dan Williams wrote:
> gcc (13.0.1 20230421 (Red Hat 13.0.1-0)) complains:
> 
> ../test/libndctl.c: In function ‘check_commands’:
> ../test/libndctl.c:2313:20: warning: storing the address of local variable
> ‘__check_dimm_cmds’ in ‘check_cmds’ [-Wdangling-poiter=]
> 
> ...fix it by showing the compiler that the local setting does not escape
> the function.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   test/libndctl.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/test/libndctl.c b/test/libndctl.c
> index 51245cf4ea98..858110c4dbc1 100644
> --- a/test/libndctl.c
> +++ b/test/libndctl.c
> @@ -2322,7 +2322,8 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
>   					ndctl_bus_get_provider(bus),
>   					ndctl_dimm_get_id(dimm),
>   					ndctl_dimm_get_cmd_name(dimm, i));
> -			return -ENXIO;
> +			rc = -ENXIO;
> +			break;
>   		}
>   
>   		if (!check->check_fn)
> @@ -2331,6 +2332,7 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
>   		if (rc)
>   			break;
>   	}
> +	check_cmds = NULL;
>   
>   	for (i = 0; i < ARRAY_SIZE(__check_dimm_cmds); i++) {
>   		if (__check_dimm_cmds[i].cmd)
> 
> 
