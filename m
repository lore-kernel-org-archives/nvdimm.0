Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508CE1C2AD
	for <nvdimm@lists.linux.dev>; Thu, 27 Jun 2024 05:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719466505; cv=none; b=M6xggb+Zu75mljFGBWbmKqjiH3sBjzLeI6oeV34Yop1OEqWwKVAeBCWs1sB6PJMVPtvx0G4H2ZjWBEOLev10fDbpunaj61P/xRdMJv6pDVmWmmEJX872GDX9CU5/ztUhSAn2NbaYfManzWXTxqOGAT8nSLsO1tgD1hnU16L+RRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719466505; c=relaxed/simple;
	bh=ANTmq0PDyj7pcosuTPkRJbwuIFc1EiOFoKBs5TAWMEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SjGo0qlc8GtWrioANnCb5oI57r9QLNqWU+CL2Q7F7E5TJGB+MgO0C3FMY+gMdrAXCj99/1l1PY6o5JnH+DhNoDSyNO2zVDpdnepiTR7m/FsQ2l4BbHK5wYEGskYqxFl/DUgVAL+RzjYeM3ddGvgxWgXYej22gjoCNru/p+verZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1D92568C4E; Thu, 27 Jun 2024 07:35:01 +0200 (CEST)
Date: Thu, 27 Jun 2024 07:35:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Alistair Popple <apopple@nvidia.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com,
	jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
	will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
	dave.hansen@linux.intel.com, ira.weiny@intel.com,
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
	linmiaohe@huawei.com, david@redhat.com, peterx@redhat.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	jhubbard@nvidia.com, hch@lst.de, david@fromorbit.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 05/13] mm: Allow compound zone device pages
Message-ID: <20240627053500.GE14837@lst.de>
References: <cover.66009f59a7fe77320d413011386c3ae5c2ee82eb.1719386613.git-series.apopple@nvidia.com> <e5caa5ac3592dfd360ca44604a5b7c8b499976e8.1719386613.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5caa5ac3592dfd360ca44604a5b7c8b499976e8.1719386613.git-series.apopple@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 27, 2024 at 10:54:20AM +1000, Alistair Popple wrote:
>  static struct nouveau_dmem_chunk *nouveau_page_to_chunk(struct page *page)
>  {
> -	return container_of(page->pgmap, struct nouveau_dmem_chunk, pagemap);
> +	return container_of(page_dev_pagemap(page), struct nouveau_dmem_chunk, pagemap);

Overly long line hee (and quite a few more).

