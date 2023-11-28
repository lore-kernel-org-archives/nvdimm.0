Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A153D0B1
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CuvP0IIj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701196303; x=1732732303;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+2BbyUX6CyXp6gO8nAK40/k4URbVDQ+WJdGF/imZ0Y8=;
  b=CuvP0IIjLFld7LzTochURWwEVepyPLLaRfNz6UyPflRYC9zwagkj5vyu
   XLJsfxq0wJbzYDt6qpMfNcefp1qs0t8HwSe9hypMoUBRM0sRZ7QqqS+TE
   YCNL4S/PQjb+v76wxfO1z1Ok0LvrT+n8s06lKPqHRpjpRmTl2lvc82fJ4
   BauN+BfJ2SS83B6VbjUGKjGFl95kl0Y8IfQYatPhcJgi5RjZalscTcvLZ
   bM6SnaT8BoBZfT3/UMR9bvaFhhR1G4Ce9/t/OjKDvW4PE6736HTFhQGvr
   CABa8jluD5upGJDTGKWSunqIB2VTOcOUoxjjiH46j58L/rJ08QXDW3vEs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="383378921"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="383378921"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 10:31:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="839148861"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="839148861"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.26.170])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 10:31:41 -0800
Date: Tue, 28 Nov 2023 10:31:40 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: vishal.l.verma@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [NDCTL PATCH 2/2] cxl: Add check for regions before disabling
 memdev
Message-ID: <ZWYyDDOYyqxTf7k+@aschofie-mobl2>
References: <169645730392.624805.16511039948183288287.stgit@djiang5-mobl3>
 <169645731012.624805.15404457479294344934.stgit@djiang5-mobl3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169645731012.624805.15404457479294344934.stgit@djiang5-mobl3>

On Wed, Oct 04, 2023 at 03:08:30PM -0700, Dave Jiang wrote:
> Add a check for memdev disable to see if there are active regions present
> before disabling the device. This is necessary now regions are present to
> fulfill the TODO that was left there. The best way to determine if a
> region is active is to see if there are decoders enabled for the mem
> device. This is also best effort as the state is only a snapshot the
> kernel provides and is not atomic WRT the memdev disable operation. The
> expectation is the admin issuing the command has full control of the mem
> device and there are no other agents also attempt to control the device.
> 

snip

> +
> +	if (cxl_port_decoders_committed(port) && !param.force) {
>  		log_err(&ml, "%s is part of an active region\n",
>  			cxl_memdev_get_devname(memdev));
>  		return -EBUSY;

Can you emit the message either way, that is, even if it is forced,
let the user know what they just trampled on.

How easy is it to add the region names in the message?

> 
> 
> 
