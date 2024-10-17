Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540641DA61E
	for <nvdimm@lists.linux.dev>; Thu, 17 Oct 2024 14:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729176968; cv=none; b=m/j304pcaHhkNbZyv5reZCFuMQph2UXvBq3IB+415drB1ncade+QNVySJIffrTJ+rtTZTMKa3zkkxo+on/fkH5Boz6k0CRl1ui7d2vHyQy6XAR4Gvs9dnXaPZWWTYGML4NCMOu9mslX68abgUmD/5zRbsqclkBFwaaAPs3rb/84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729176968; c=relaxed/simple;
	bh=sXnb38zc/mtA8QeZhnfLZMYsnErtLg/u2GutMOZk/5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UT1epuyU/Nx+SmWjGaP3fYAYyQiLC6AstTfWHKU75ySIkw5QdfZZ0hgYOLHVZNLbRTLXHbyPEpaf+WUZ1m8DbUqipJwM0iwgcTU+jGPgDh5No3eT/c3X4XHA6wdFbhQSn0zdLlXuaVC2iVGSE6vaLe9XzcWzKzmBKGAMyXVu4sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BXt7RN4y; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BXt7RN4y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729176966; x=1760712966;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sXnb38zc/mtA8QeZhnfLZMYsnErtLg/u2GutMOZk/5Y=;
  b=BXt7RN4y7XEf+Kt95wWSH1YSohv6v+mcMXrbUE9/+MYsfJrdsPvcr/X+
   yOhGcGlURi9DJYPzaEXV9GbewyEui8qMBIzFXRVoN6R2xxqdFwuc26dB6
   qezaUal5MWcEjtL+OE1p89JI+gQYmevBtE5tdPlsHNGBZyZFQdNDpB92m
   5NZVqXklqD8wU2JesLqe1v/IeII/uNWPU5MiclBEAINd7rPr0cc7hZk+2
   USfmFi9J7abfoPCSlBI38CdoeW6smtxRJKEhPXCswf4E8L5BM4G65ZdlM
   EgYjRirO+tFhpcultr5EwJI9C0vC6s0ZU9xUYLGCWpfnVJmidezKX81B7
   g==;
X-CSE-ConnectionGUID: +VSCTPYRRH6a0joZF+WAJQ==
X-CSE-MsgGUID: A4eZ0MOAQK+MvuYbELAM1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11228"; a="28548669"
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="28548669"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 07:56:06 -0700
X-CSE-ConnectionGUID: xjH6tqqPTDa6qQqdvyW8Dw==
X-CSE-MsgGUID: nCwDGZymTo+LghLxgdhiJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="78597431"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.109.53])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 07:56:06 -0700
Date: Thu, 17 Oct 2024 07:56:03 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Coly Li <colyli@suse.de>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: Removing a misleading warning message?
Message-ID: <ZxElg0RC_S1TY2cd@aschofie-mobl2.lan>
References: <15237B14-B55B-4737-9A98-D76AEDB4AEAD@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15237B14-B55B-4737-9A98-D76AEDB4AEAD@suse.de>


+ linux-cxl mailing list

On Fri, Oct 11, 2024 at 05:58:52PM +0800, Coly Li wrote:
> Hi list,
> 
> Recently I have a report for a warning message from CXL subsystem,
> [ 48.142342] cxl_port port2: Couldn't locate the CXL.cache and CXL.mem capability array header.
> [ 48.144690] cxl_port port3: Couldn't locate the CXL.cache and CXL.mem capability array header.
> [ 48.144704] cxl_port port3: HDM decoder capability not found
> [ 48.144850] cxl_port port4: Couldn't locate the CXL.cache and CXL.mem capability array header.
> [ 48.144859] cxl_port port4: HDM decoder capability not found
> [ 48.170374] cxl_port port6: Couldn't locate the CXL.cache and CXL.mem capability array header.
> [ 48.172893] cxl_port port7: Couldn't locate the CXL.cache and CXL.mem capability array header.
> [ 48.174689] cxl_port port7: HDM decoder capability not found
> [ 48.175091] cxl_port port8: Couldn't locate the CXL.cache and CXL.mem capability array header.
> [ 48.175105] cxl_port port8: HDM decoder capability not found
> 
> After checking the source code I realize this is not a real bug, just a warning message that expected device was not detected.
> But from the above warning information itself, users/customers are worried there is something wrong (IMHO indeed not).
> 
> Is there any chance that we can improve the code logic that only printing out the warning message when it is really a problem to be noticed? 
> 
> Thanks in advance.
> 
> Coly Li 
