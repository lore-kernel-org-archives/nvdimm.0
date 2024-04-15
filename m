Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A904F6BB52
	for <nvdimm@lists.linux.dev>; Mon, 15 Apr 2024 16:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713197947; cv=none; b=UqifU77iDkF4tpB9To6524Geao4G/eJrnbo0lwnCBe38GIuo+iRRd92hX00CFczK4GpL8fyMonw+KDKU5C61q4l+qzUBJdVKiS/tYhzD6QySUFXfL/OR8sC5trHSPlYzgfN3HI0nr8AmqmDVeMu7pzDCRTA2mUduniPV8JP5ZbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713197947; c=relaxed/simple;
	bh=7nn0qfUVoSicmQ4+5XlugO2gkx/uZTpdBSSnB/eRq3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=guDV7SYWmsAQTWUe9kF4T87KNgmDXTTsv83AiwiA2aJM68oA8ybge/0vi8ZqT442OAsAuO4CtosFpZg4CsCgAS2WUFnj6ODZTGMjqKeX+TJ9HBMdN9HBozeFD8MeZT9uaa4OS87YKRxRK5r6I/LzCE7D7JTFyHxPaDdzUa/1LFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G9twk7wR; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G9twk7wR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713197946; x=1744733946;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7nn0qfUVoSicmQ4+5XlugO2gkx/uZTpdBSSnB/eRq3w=;
  b=G9twk7wRBR8oeKkgi6Lok9jeEXQkshjJcFFybbIM5yjGp+oIj2ZuLHcZ
   TMK3tCFbtITF+dctnWoLugfm8bUP8DBNZcZHC8gIA3zP5y5AFRzA8vJrt
   Uu7p2AVCuXO8Fq3V/LxmSs22wIyO8tBFLohQyvQMjET0U+uEKC63l1Qyf
   EiywKjCQX4BojBNLwsFZbTqVonAFLBemz5Fu/kic/IViIlYonBXETsBu3
   QntLp0qXgxRuH37nQHKdQXIQt8YgoRt2R1lbQxOx75AgUv30++nkfqy0+
   NOGlcqjwMX36zdmXxVnPtM8mCzxunFboHM9DnTeH3RD7gMLhamnfrzTR8
   w==;
X-CSE-ConnectionGUID: xheRiIsDQ0eFuro6HF8XFw==
X-CSE-MsgGUID: 1yVa0u42S+OEEjnBCrwQ8A==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="12447220"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="12447220"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 09:19:05 -0700
X-CSE-ConnectionGUID: zDHSpjnXSj+Bn8X8Dil2Zw==
X-CSE-MsgGUID: MPp/DMsWRJ2ftAIUnPF1tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="59403753"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.61.52]) ([10.212.61.52])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 09:19:04 -0700
Message-ID: <c1db1a62-93b8-402e-bc9b-720a5621d8bb@intel.com>
Date: Mon, 15 Apr 2024 09:19:04 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ndctl 2/2] daxctl/device.c: Fix error propagation in
 do_xaction_device()
To: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Ira Weiny <ira.weiny@intel.com>
References: <20240412-vv-daxctl-fixes-v1-0-6e808174e24f@intel.com>
 <20240412-vv-daxctl-fixes-v1-2-6e808174e24f@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240412-vv-daxctl-fixes-v1-2-6e808174e24f@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/12/24 2:05 PM, Vishal Verma wrote:
> The loop through the provided list of devices in do_xaction_device()
> returns the status based on whatever the last device did. Since the
> order of processing devices, especially in cases like the 'all' keyword,
> can be effectively random, this can lead to the same command, and same
> effects, exiting with a different error code based on device ordering.
> 
> This was noticed with flakiness in the daxctl-create.sh unit test. Its
> 'destroy-device all' command would either pass or fail based on the
> order it tried to destroy devices in. (Recall that until now, destroying
> a daxX.0 device would result in a failure).
> 
> Make this slightly more consistent by saving a failed status in
> do_xaction_device if any iteration of the loop produces a failure.
> Return this saved status instead of returning the status of the last
> device processed.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  daxctl/device.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/daxctl/device.c b/daxctl/device.c
> index 83c61389..14d62148 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -1012,7 +1012,7 @@ static int do_xaction_device(const char *device, enum device_action action,
>  	struct json_object *jdevs = NULL;
>  	struct daxctl_region *region;
>  	struct daxctl_dev *dev;
> -	int rc = -ENXIO;
> +	int rc = -ENXIO, saved_rc = 0;
>  
>  	*processed = 0;
>  
> @@ -1059,6 +1059,8 @@ static int do_xaction_device(const char *device, enum device_action action,
>  				rc = -EINVAL;
>  				break;
>  			}
> +			if (rc)
> +				saved_rc = rc;
>  		}
>  	}
>  
> @@ -1070,7 +1072,7 @@ static int do_xaction_device(const char *device, enum device_action action,
>  	if (jdevs)
>  		util_display_json_array(stdout, jdevs, flags);
>  
> -	return rc;
> +	return saved_rc;
>  }
>  
>  int cmd_create_device(int argc, const char **argv, struct daxctl_ctx *ctx)
> 
