Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24A8360ED8
	for <nvdimm@lists.linux.dev>; Mon,  1 Jun 2026 22:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780351575; cv=none; b=E9LbLSCxj896tyWFmBsxegGAoxRL7Tskx8xDOKPT0MQG6vHV9SrUf8zgV6b+XD4UbppgV8EQxGZ8oF2EkMaz5+HsSctiB951OKVY/+o/j1yEHHmdDdk9zke6B6xZKVBJaYDz9vGI8XeU1kiz875V1lErNkk6skXDV7ueesnGhRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780351575; c=relaxed/simple;
	bh=3Q8RBoZyRUD7cQyjc+4etF7zrY2CU8q5vivRmAXGz4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AaQXfdsiu2lDL6APoJ1IgGMBawLAJYSCjn1yszTrjxzoaB6ByDAGqi01N1ECwl3fdXiUIJQVBT8QbIBDLfByqcGyTZ7gQd11NBmHQXUNdVBSTF31gWPvmVw7pGyZQ/8+P1c7Pfr2yY0b/KfeCOJ3rwvMqK1m5YOerxzde9Ue+EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q3IrT9Ri; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q3IrT9Ri"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780351573; x=1811887573;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3Q8RBoZyRUD7cQyjc+4etF7zrY2CU8q5vivRmAXGz4k=;
  b=Q3IrT9RiF2meLFQRq9wMXpRijo4kgDZAoKV3igKm4nf6zFqPDvZ3uoxX
   Ky7n4Z+8zbZl9ykSGX/OlHLjFZzK9vtOW9rt3ScVA8FZ6c0zrAPuFxUNN
   7Bo3tMI8RDEi6Mp4ix3+ct/N7GuudyKFwdJRneB2wTB8azlXYV6+4ogTi
   H3huDensPk/Q6huaNtmwgoWPwfF67KTvXo87IXYW5VEBlXRj5J1Zphz8Q
   Nho5UbqrzT0GNiWHkRGPMWyOAb4KXgOTFG8qnX6/L1gK1uMepC80zz2JL
   ohm60PaYAmUaSFkV9lBFPc96iCooy/EcyE39wJQ1lgVzTY3Ukou340cUM
   w==;
X-CSE-ConnectionGUID: aipgg92WTO2pZy+co1yyYg==
X-CSE-MsgGUID: p86wJ2/bTkOeBqoOhBjeyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="84746096"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="84746096"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 15:06:12 -0700
X-CSE-ConnectionGUID: 3n444LH2S2W+8Y61L+iKvg==
X-CSE-MsgGUID: DiXOi7tiSqasq17ke5cq7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="248625650"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.108.24]) ([10.125.108.24])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 15:06:10 -0700
Message-ID: <9bf1a823-8e77-42c3-a02b-58d4d8c3387f@intel.com>
Date: Mon, 1 Jun 2026 15:06:09 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 3/9] dax/fsdev: clear vmemmap_shift when binding static
 pgmap
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
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165045.6636-1-john@jagalactic.com>
 <0100019e79cba76d-76fe26ff-33d2-4842-8eee-bd108eae6990-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e79cba76d-76fe26ff-33d2-4842-8eee-bd108eae6990-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/30/26 9:50 AM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Clear pgmap->vmemmap_shift for static DAX devices. When rebinding a static
> device from device_dax (which may set vmemmap_shift based on alignment) to
> fsdev_dax, the stale vmemmap_shift persists on the shared pgmap. Explicitly
> zero it before devm_memremap_pages() so the vmemmap is built for order-0
> folios as fsdev requires.
> 
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/fsdev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index f315533b299e9..dbd722ed7ab05 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -237,6 +237,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  		}
>  
>  		pgmap = dev_dax->pgmap;
> +		pgmap->vmemmap_shift = 0;
>  	} else {
>  		size_t pgmap_size;
>  

