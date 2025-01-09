Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0179A290F
	for <nvdimm@lists.linux.dev>; Thu,  9 Jan 2025 01:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736386476; cv=none; b=Dp/t+AaY4cd6vIBQdDVTFCosmsGqidsuRoQY6w6yW07wWiotATMqgFdm/zBLEFA3Hpw5WWWKxEVEN/LpPY2drvXPJ7Y0vWz6CR08/kb2Kbitw7WolKK400YV6fxE3TmwMaqIr3I+kDKXEfxycgzf/TRIRcEyhFiSllZX8aYplgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736386476; c=relaxed/simple;
	bh=RER8xEkbtZJunXd1DrZR4xiCOceE1iPmaLstar6K/Ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCn7q6jDwHoEnP8BJNtR/f2J6iajaubKzJrp4SVbN5CIqbI2h6HPE4u7r4a5gPFddn82bj84I7EeWLkmBV5irodSHGmOeCL+jU/J7TTgm/Y/nPDo1pZLqQEdUlrRFj4wTvAJefjyRwva6GvgHYx05MSSLociKtSTsACAYfMoAtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HJ7z2xfp; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJ7z2xfp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736386475; x=1767922475;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RER8xEkbtZJunXd1DrZR4xiCOceE1iPmaLstar6K/Ws=;
  b=HJ7z2xfpq3HIkCajFTpaJdrlZyGaNCgBl4XDsM9Mj+HQ8Q3zpR/qjBhy
   7k6GXEs6Vs66yVj5Osrnn8TOeNQhua9MOurpe4UskxgJlYoZ9rBbhgiJ1
   WR9gNhZNeCb2x35MZx7IPUzA32Y7lUhycRUe7iMoavgwfHQ7UJp0hSaMx
   LCDCxyWcW0zeTRSlkf3ypB5S+TCNNHYyXraOGf+RJDOU3kv+84IJHRLVB
   YFnpRtH9dWOLpvDwgnckl24J5cBq/k224yMB/gOPHR+SOm98TYJdqNX7w
   MTT13Z4+TceTM9u8DNYs96ehOLy3nAjDj16EDqJLcwyhRwyh3kOdXooVu
   w==;
X-CSE-ConnectionGUID: Fj4JYjOxTrmrShlmlh6CYw==
X-CSE-MsgGUID: tp3nrJIDREukoup/jjA6HQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="40313999"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="40313999"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 17:34:35 -0800
X-CSE-ConnectionGUID: Hc5lWmCDRcOCp4HuSUdhaQ==
X-CSE-MsgGUID: 8EZhG4KIQciXTPEzWMApnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="107305857"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.65])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 17:34:32 -0800
Date: Wed, 8 Jan 2025 17:34:30 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, linux-mm@kvack.org,
	lina@asahilina.net, zhang.lyra@gmail.com,
	gerald.schaefer@linux.ibm.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com,
	jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
	will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
	dave.hansen@linux.intel.com, ira.weiny@intel.com,
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
	linmiaohe@huawei.com, david@redhat.com, peterx@redhat.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
	david@fromorbit.com
Subject: Re: [PATCH v5 00/25] fs/dax: Fix ZONE_DEVICE page reference counts
Message-ID: <Z38npigJajz_gm-5@aschofie-mobl2.lan>
References: <cover.425da7c4e76c2749d0ad1734f972b06114e02d52.1736221254.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.425da7c4e76c2749d0ad1734f972b06114e02d52.1736221254.git-series.apopple@nvidia.com>

On Tue, Jan 07, 2025 at 02:42:16PM +1100, Alistair Popple wrote:
> Main updates since v4:
> 
>  - Removed most of the devdax/fsdax checks in fs/proc/task_mmu.c. This
>    means smaps/pagemap may contain DAX pages.
> 
>  - Fixed rmap accounting of PUD mapped pages.
> 
>  - Minor code clean-ups.
> 
> Main updates since v3:
> 
>  - Rebased onto next-20241216.

Hi Alistair-

This set passes the ndctl/dax unit tests when applied to next-20241216

Tested-by: Alison Schofield <alison.schofield@intel.com>

-- snip


