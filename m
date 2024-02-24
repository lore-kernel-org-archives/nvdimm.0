Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EABC391
	for <nvdimm@lists.linux.dev>; Sat, 24 Feb 2024 00:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708733165; cv=none; b=aA3F8z7gFBB7uifafVwpilxdwFM+sOghz12J06zBQ46x2Uekfd9LLY4BxxBWzkve1I0Av0e/DUbv4Jy4r9JS7OnwIG94nSPrzdaAnCPcygJ5ofBDS+yp88EytwUqHxvPn8R96w0Eb4jmQfgXHai93+ASqN9vW6jpm2gpxdaa7Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708733165; c=relaxed/simple;
	bh=mGMFhkEAVEATSeecAUb5ND2N8AhgPWE+Gj/9u1cOHVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZtB+KQk3oJM2X5b2AAA5LL1ARqh4jk5D9ceb6nuuhl+U/1KPV4YyZ2JT4+EJX9WIGMMEoG1yX0cV5wmdp/Vnay3VJwedK+dSK19ZVpohkJg5kPi1Ft71oOxDKnVRKhKKq8qq9Sgw5R4XdD/lHkg3E66nGvnGsnA1xTb4htu8gM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mjyGr9Tl; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mjyGr9Tl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708733164; x=1740269164;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mGMFhkEAVEATSeecAUb5ND2N8AhgPWE+Gj/9u1cOHVU=;
  b=mjyGr9TlcusK3vP20diEu6H0As6WX3M7p7o4U8mU+lDcllsaxt6Y+fhA
   ESaumxL6gYj4K1ktVpeplOdei2lKW8wWXAymF1XGM/k4JI7eg7/Qn5OXZ
   IqAg9gcS0bh36D01dV940SucHULdsD5nAY8MLuoj8IHrtm2f3k4DgRjjP
   eIXxJ7wfzKaIwf1GA92JBWX5on9dlGjBOA2CmRfrlXgwu5PImg17ft4/G
   +5sBCWdM1hDS9zwezTyp5ZENXLLl1pdnWsCutabcZqdUXkv+jNzMlgUJZ
   Tn97gbbkdXoOXqRS+DXCkGH6m8/5EYEJFPxwyGMRKLbkCkLKgoijfNJod
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10993"; a="3590765"
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="3590765"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 16:06:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="6066855"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.115.84]) ([10.246.115.84])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 16:06:02 -0800
Message-ID: <4cafe9e0-1a08-4574-aa0d-5070b67f8cf3@intel.com>
Date: Fri, 23 Feb 2024 17:06:01 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dax: constify the struct device_type usage
Content-Language: en-US
To: "Ricardo B. Marliere" <ricardo@marliere.net>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20240219-device_cleanup-dax-v1-1-6b319ee89dc2@marliere.net>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240219-device_cleanup-dax-v1-1-6b319ee89dc2@marliere.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/19/24 5:47 AM, Ricardo B. Marliere wrote:
> Since commit aed65af1cc2f ("drivers: make device_type const"), the driver
> core can properly handle constant struct device_type. Move the
> dax_mapping_type variable to be a constant structure as well, placing it
> into read-only memory which can not be modified at runtime.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/dax/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 1ff1ab5fa105..e265ba019785 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -763,7 +763,7 @@ static const struct attribute_group *dax_mapping_attribute_groups[] = {
>  	NULL,
>  };
>  
> -static struct device_type dax_mapping_type = {
> +static const struct device_type dax_mapping_type = {
>  	.release = dax_mapping_release,
>  	.groups = dax_mapping_attribute_groups,
>  };
> 
> ---
> base-commit: b401b621758e46812da61fa58a67c3fd8d91de0d
> change-id: 20240219-device_cleanup-dax-d82fd0c67ffd
> 
> Best regards,
