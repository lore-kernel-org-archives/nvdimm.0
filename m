Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F42389118;
	Fri, 16 Oct 2026 15:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792164060; cv=none; b=IQBlU4CMKyjZ3d4h4rWcSPJtg89/h4xZA8oSvh69Gig1GTSNQ5vfcaO8aJ1jr7KWvjer0rE/NR6QgBiGNG92xulF0w/+hpmEaxuQRe2rpHqin04x31GIXrC6kKT9Xju4LtMgN/Ncf5UzRtmLYPkPO27C17FqJ9rYSZ908EF5NMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792164060; c=relaxed/simple;
	bh=8iZmLzyjHSRq5MJ6PnaAz072+sn5G/rcSK+lSCUYsbo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EuLpzrYWw337zXpoFe1Wkx3mZk6KKjiAMrmHZ9p9O08qws962hgApZldpQTODHTKiozXEGGsn992ae9MT8hOFwQGiCcSI+Uzq2OSnQIznjWCIVbLhQgE0BxTI+ANDZi9QUT0C050N52CIC2n5wYT9Kt8/ygLNUPGKbWfkRhJT0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EWohUamC; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EWohUamC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792164059; x=1823700059;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8iZmLzyjHSRq5MJ6PnaAz072+sn5G/rcSK+lSCUYsbo=;
  b=EWohUamCNt7+OKsBmnahV0x68oMSg/vsAETo06+yE/+mRAJwZiBREQ3f
   vk03m3Ppv1L95xQl9Mpqy9BxC4HT0+zLORwWj0lqhpmeI5e81kJ5slzqr
   ljsvfGZ53hivD0K0zNnkAkxmXxD4S5/irpzW8gbgQWGN9o7i1pxcTYM7Z
   2C3jv2gCMVvUkamE+RaRYPK2a8vbdloqPxOJj393SIpnwS7D6XQz7Pk0E
   yDoRvrki2aHE+jS02j/QX8nzf2iX6pKAEgH1aa89m2A2gGAEvmsk6Tq8V
   Xiq2i7PEY6pXBH5WkI3jqr72g3pt7IcOQeuNdESP7Pi9uhBPQ4fafFUeb
   Q==;
X-CSE-ConnectionGUID: 1swEhThXRhGPSqisePAUxw==
X-CSE-MsgGUID: vpsRlWYJSKenTB9cjiLMTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11937"; a="839781"
X-IronPort-AV: E=Sophos;i="6.27,162,1787036400"; 
   d="scan'208";a="839781"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 08:20:58 -0700
X-CSE-ConnectionGUID: weUmDpvRT2OVeUeI8zZRjw==
X-CSE-MsgGUID: nmn5J1npQv2s/eTgI5xyoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,162,1787036400"; 
   d="scan'208";a="1885393"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.167]) ([10.125.110.167])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 08:20:56 -0700
Message-ID: <a9b64ee5-4f90-4f42-b680-0d9a77cf64af@intel.com>
Date: Fri, 16 Oct 2026 08:20:56 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/10] dax: use READ_ONCE() in dax_holder()
To: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev
Cc: John Groves <john@groves.net>, Amir Goldstein <amir73il@gmail.com>,
 "Darrick J . Wong" <djwong@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
References: <20261016151638.2962413-1-mszeredi@redhat.com>
 <20261016151638.2962413-3-mszeredi@redhat.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261016151638.2962413-3-mszeredi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/16/26 8:16 AM, Miklos Szeredi wrote:
> A future fuse patch will utilize dax_holder() in RCU context to make sure
> that the holder can't be freed by a racing fs_put_dax.
> 
> This patch just makes sure that dax_holder() works properly in such a
> context by adding READ_ONCE() (equivalent to rcu_dereference minus sanity
> checks).
> 
> Fixing XFS is out of scope for this patchset.
> 
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 25836f389bde..76e8d3654629 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -642,7 +642,7 @@ EXPORT_SYMBOL_GPL(put_dax);
>   */
>  void *dax_holder(struct dax_device *dax_dev)
>  {
> -	return dax_dev->holder_data;
> +	return READ_ONCE(dax_dev->holder_data);
>  }
>  EXPORT_SYMBOL_GPL(dax_holder);
>  

