Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F38D53C
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669933939; x=1701469939;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jy3o2n/2K7yTocpk47mjN+fl4UK0NOw4ms4Bl09tFO4=;
  b=XVB937ayc5LGs7zWzGD80ZyiuAzqZXjRWL+TKjo7qED3Hfq+6nq4TEUI
   nHpNyW07QEWEV7YbwIlXolNW894FzBaHB3rELrZfVt3ieG/ccX48xAACq
   NU343gHZkrZZPt0EX0mo0sKw6J1GoPv4HJpZm/Ey5X0ptTly+xaMRhc2B
   sFVjcteiNvCf4gJ1qOb2v51vZFCZhAh9Oijywa/+Qr03tuMz1IOl4X6aB
   ucIgu92kctGXBNW9OrLwIF9GAiX1nfm8jaFbnpo/J7+jnO+ZsH4sA82p9
   w0h3Ev72NPIEZ6jXvtrOR5jsOVRBScQXB2Hkilt+l/nXW1N9zu6IwmQyU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="380101752"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="380101752"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:32:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="622471108"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="622471108"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.66.184]) ([10.212.66.184])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:32:16 -0800
Message-ID: <6bf9b135-2bde-26b6-792f-d699eebfde3f@intel.com>
Date: Thu, 1 Dec 2022 15:32:15 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH 3/5] cxl/pmem: Enforce keyctl ABI for PMEM security
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc: Jonathan.Cameron@huawei.com, nvdimm@lists.linux.dev, dave@stgolabs.net
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993221008.1995348.11651567302609703175.stgit@dwillia2-xfh.jf.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <166993221008.1995348.11651567302609703175.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/1/2022 3:03 PM, Dan Williams wrote:
> Preclude the possibility of user tooling sending device secrets in the
> clear into the kernel by marking the security commands as exclusive.
> This mandates the usage of the keyctl ABI for managing the device
> passphrase.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

No need for get security state command?

> ---
>   drivers/cxl/core/mbox.c |   10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 8747db329087..35dd889f1d3a 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -704,6 +704,16 @@ int cxl_enumerate_cmds(struct cxl_dev_state *cxlds)
>   		rc = 0;
>   	}
>   
> +	/*
> +	 * Setup permanently kernel exclusive commands, i.e. the
> +	 * mechanism is driven through sysfs, keyctl, etc...
> +	 */
> +	set_bit(CXL_MEM_COMMAND_ID_SET_PASSPHRASE, cxlds->exclusive_cmds);
> +	set_bit(CXL_MEM_COMMAND_ID_DISABLE_PASSPHRASE, cxlds->exclusive_cmds);
> +	set_bit(CXL_MEM_COMMAND_ID_UNLOCK, cxlds->exclusive_cmds);
> +	set_bit(CXL_MEM_COMMAND_ID_PASSPHRASE_SECURE_ERASE,
> +		cxlds->exclusive_cmds);
> +
>   out:
>   	kvfree(gsl);
>   	return rc;
> 
