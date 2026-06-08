Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A633A1695
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 21:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780954746; cv=none; b=ecSYyTMnIbcwWNVG1kqIEnCsrp7xlmiu+57bXIBjq1Tk+jBM9wmGkcUZsktDzR/rotMiJcysmekGintbUZrnPSSZCh9vMGwngrxIfHKgl8g3WkF21V4WBgFf3oFp8RZR2chgOu9TVamxyxwjpUUgIbcIBSJmhMZN9bbb0uZb4PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780954746; c=relaxed/simple;
	bh=fY5IWLEy1I6c8Z7Uz1QiZcbXgAx7FjqH5ElMe0zIaX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cGMci5o3q/3ugw9W0Qgr3PyJb6wfsO9DBcPfRAds9SXPKGHkJWfMPVfhsgYzTKDuSVq/CkvhnS5s5mFIrtzpDFDhLX4duwKn/2R8hAKqQkOnfly9soWrcQwzmRTQsZpSqBuNGaTbsgY9HT4bj21WVuJQuJmqggRNQ9ANjeRoFi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQUPy+Un; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQUPy+Un"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780954745; x=1812490745;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fY5IWLEy1I6c8Z7Uz1QiZcbXgAx7FjqH5ElMe0zIaX4=;
  b=cQUPy+UnP6UcqiXTUwMWF+JKxfQGDN3qmFx845z45tUS17b8mfEK9FL5
   LigU0ca2+C2SeOlEyIhbddt2D9oUR37D+vSySNvlfK9kAeXp04OUbjPtb
   HfPCP9kyfOAJUxhJykH+fMPZWACaQmea/jItTro9AdhmvKGDYZuYGjMc7
   D868L0JdfM6YY+Q0A1KsUhG/I6eHcuoEjN4XWMotw4wdJuGym6IxC9nBG
   jCiczDPjkhWlo01F5lLNR76Sn0tIdiqrabLgTfmwEnmIYbE4Llw9GJPSV
   CR9Peiy+CCztftSGJaim9Z5RzfmTL1UarC40/2OLy4UfNYumpffflpENN
   g==;
X-CSE-ConnectionGUID: agfVm6qgQgyms0TOPp1+KA==
X-CSE-MsgGUID: Y220sZ5vRsajxFZ4Oa46zQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="107142943"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="107142943"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 14:39:04 -0700
X-CSE-ConnectionGUID: DzbcaY8/T2Su6l8SURZbCg==
X-CSE-MsgGUID: Pjj7yoHhRCCOGc1lYxt7Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="242721937"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.162]) ([10.125.109.162])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 14:39:02 -0700
Message-ID: <bf0d88bd-a514-499d-a81f-24f4e0c7c186@intel.com>
Date: Mon, 8 Jun 2026 14:39:01 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 6/9] dax/fsdev: fail probe on invalid pgmap offset
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Dan Williams <djbw@kernel.org>
Cc: John Groves <jgroves@micron.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
 <20260607193354.94372-1-john@jagalactic.com>
 <0100019ea393f2e0-98d65e1f-5656-4e44-afa4-f9836ab6dd40-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019ea393f2e0-98d65e1f-5656-4e44-afa4-f9836ab6dd40-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/7/26 12:34 PM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Convert the WARN_ON to a fatal error when pgmap_phys > phys. This
> condition means the remapped region starts after the device's data
> region, which is an impossible state. Previously the probe continued
> with data_offset=0, leaving virt_addr silently misaligned. Now probe
> returns -EINVAL with a diagnostic message.
> 
> Fixes: 759455848df0b ("dax: Save the kva from memremap")
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/fsdev.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index af9ef80c05c6d..dcb512625ce65 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -320,8 +320,12 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  		u64 phys = dev_dax->ranges[0].range.start;
>  		u64 pgmap_phys = pgmap[0].range.start;
>  
> -		if (!WARN_ON(pgmap_phys > phys))
> -			data_offset = phys - pgmap_phys;
> +		if (pgmap_phys > phys) {
> +			dev_err(dev, "pgmap start %#llx exceeds data start %#llx\n",
> +				pgmap_phys, phys);
> +			return -EINVAL;
> +		}
> +		data_offset = phys - pgmap_phys;
>  
>  		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
>  		       __func__, phys, pgmap_phys, data_offset);

