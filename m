Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C16813
	for <nvdimm@lists.linux.dev>; Fri, 12 May 2023 14:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683903195; x=1715439195;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=0V12Jigh7nTOtc6aPiAsO82TRkaWiw/N6Ze4LZ/XTeI=;
  b=T0LdDF7BWZo0YcTlLSiewKBqsBQNynQJsRhtHNBRnyUueR6C0H5Udi18
   a69DcEC+YCHfRkZq2wh2RXZQT0Ygp6fsrr6DdXLjKDRK+GhNqF8rfVIym
   WShVaDJcKVKB0yB6vD/68XS4WQww5guatiFq15OkB6ygm0Bc+yTPT10Ce
   IEYNiisk4nAdxvtpHqlAN9R8Vq+ixzpAOj2R1Si2TcADIfoGjVRs44mvr
   FU541kSsXDhuxtIE/E4A0fuUyEcRb5TK6cfNUDdl8dVvHATO+zyQNBj8Q
   0bBxFQNMz1ehK7watlDU+Em9xTnbsRHZjAEBDO4kbd9WcPMTjQe/Jcl42
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="414176340"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="414176340"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 07:53:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="1030109160"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="1030109160"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.160.55]) ([10.213.160.55])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 07:53:13 -0700
Message-ID: <47dfb4b8-ab75-8c10-64d1-978244d20cdb@intel.com>
Date: Fri, 12 May 2023 07:53:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [NDCTL PATCH] ndctl: Add key cleanup after overwrite operation
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Cc: Yi Zhang <yi.zhang@redhat.com>
References: <168357518158.2750073.1393407560977941832.stgit@djiang5-mobl3>
In-Reply-To: <168357518158.2750073.1393407560977941832.stgit@djiang5-mobl3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/8/23 12:46 PM, Dave Jiang wrote:
> Yi reported [1] the key blob is not removed after an overwrite operation is
> performed. Issue is discovered when running ndtest. Add the key blob
> removal call to address the issue.
> 
> [1]: https://github.com/pmem/ndctl/issues/239
> 
> Fixes: 8e4193885357 ("ndctl: add an overwrite option to 'sanitize-dimm'")
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Please ignore patch.

> ---
>   ndctl/keys.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/ndctl/keys.c b/ndctl/keys.c
> index 2c1f474896c6..3fa076402cfc 100644
> --- a/ndctl/keys.c
> +++ b/ndctl/keys.c
> @@ -658,7 +658,7 @@ int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
>   	int rc;
>   
>   	key = check_dimm_key(dimm, false, ND_USER_KEY);
> -	if (key < 0)
> +	if (key < 0 && key != -ENOKEY)
>   		return key;
>   
>   	rc = run_key_op(dimm, key, ndctl_dimm_overwrite,
> @@ -666,5 +666,8 @@ int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
>   	if (rc < 0)
>   		return rc;
>   
> +	if (key >= 0)
> +		discard_key(dimm, ND_USER_KEY);
> +
>   	return 0;
>   }
> 
> 
