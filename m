Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342381CD0C
	for <nvdimm@lists.linux.dev>; Thu, 27 Jun 2024 05:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719466430; cv=none; b=ceS+DplyCZW5X6L3fasvS8zRi1PgQX4uRuab/Zutyb2E14BIOdDimAcVqmMlmltq3VKS9iIHf8M9kZUBTNCXbidd5x3xocxNwAhz1uK+nux43q/9L0PrJbtDbRbZck7W9Q+ZsA9FS/vjkC+ZK+0Fkmez9RlV5TkoUnxdgxzjb+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719466430; c=relaxed/simple;
	bh=u1VLRD751P6xMITpXH3h1dqGSUMP4GL72rO7Zwx6hkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QqIuh6mf0xCRhGX7PY4ChBtT8JnSU8bT95CxaYRHXFcuCOqdfd64OXoHRc7Yf4rGtZXh08aPGW6YgcwuTNk9WVHRtL8to+Cy/0P60GYwNc+ojgwgRmMGqywYR6X/VkwAoGjnGOgXvupi9F5HPkm9YWGEYW0FbfkjxffpTJNVqSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1840168C4E; Thu, 27 Jun 2024 07:33:44 +0200 (CEST)
Date: Thu, 27 Jun 2024 07:33:43 +0200
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
	jhubbard@nvidia.com, hch@lst.de, david@fromorbit.com
Subject: Re: [PATCH 04/13] fs/dax: Add dax_page_free callback
Message-ID: <20240627053343.GD14837@lst.de>
References: <cover.66009f59a7fe77320d413011386c3ae5c2ee82eb.1719386613.git-series.apopple@nvidia.com> <e626eda568267e1f86d5c30c24bc62474b45f6c3.1719386613.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e626eda568267e1f86d5c30c24bc62474b45f6c3.1719386613.git-series.apopple@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 27, 2024 at 10:54:19AM +1000, Alistair Popple wrote:
> When a fs dax page is freed it has to notify filesystems that the page
> has been unpinned/unmapped and is free. Currently this involves
> special code in the page free paths to detect a transition of refcount
> from 2 to 1 and to call some fs dax specific code.
> 
> A future change will require this to happen when the page refcount
> drops to zero. In this case we can use the existing
> pgmap->ops->page_free() callback so wire that up for all devices that
> support FS DAX (nvdimm and virtio).

Given that ->page_ffree is only called from free_zone_device_folio
and right next to a switch on the the type, can't we just do the
wake_up_var there without the somewhat confusing indirect call that
just back in common code without any driver logic?

