Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B745C143746
	for <nvdimm@lists.linux.dev>; Tue,  2 Jul 2024 11:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719920771; cv=none; b=J1aaIjAtjOWfVc1dMC1kR5MeojDAsbIAuiBiMowFVZ/vTvnxHslJdeEcs36Ngt6TR9R92GUE6Qdq6cOMI+NX2yhhv5+eTA6nR92nWoIX8dvSCPs9ObUkpE1A4G9ro6BbYHgqe4zCQ30cXCedH8CoQGNkSMnadlwwew3Am8u5VDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719920771; c=relaxed/simple;
	bh=faBHkEfvnz503A9yalKx4skYcKR2V/7jqzANpvrR4aE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cX9uooDQn/CgFkOx92WlZCoK2jCFcBoSpZbiS9N24pusEx1KxajRac+M5iqh7DU85O3XzwGP6zl0EbJWbZqznwURPMAULpJZ8Yg5AVYTjkwDzMxTFaQv7gEJfDpKvrc9h8h549kW7GyPTkEUl4DVOuWThcRUDoE5DTd779FgNcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 385AC68AA6; Tue,  2 Jul 2024 13:46:02 +0200 (CEST)
Date: Tue, 2 Jul 2024 13:46:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, logang@deltatee.com,
	bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca,
	catalin.marinas@arm.com, will@kernel.org, mpe@ellerman.id.au,
	npiggin@gmail.com, dave.hansen@linux.intel.com, ira.weiny@intel.com,
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
	linmiaohe@huawei.com, peterx@redhat.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
	david@fromorbit.com
Subject: Re: [PATCH 06/13] mm/memory: Add dax_insert_pfn
Message-ID: <20240702114601.GA15426@lst.de>
References: <cover.66009f59a7fe77320d413011386c3ae5c2ee82eb.1719386613.git-series.apopple@nvidia.com> <50013c1ee52b5bb1213571bff66780568455f54c.1719386613.git-series.apopple@nvidia.com> <eb3120fd-44db-4cb3-af3c-a13f9e71380b@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb3120fd-44db-4cb3-af3c-a13f9e71380b@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 02, 2024 at 09:18:31AM +0200, David Hildenbrand wrote:
> We have this comparably nasty vmf_insert_mixed() that FS dax abused to 
> insert into !VM_MIXED VMAs. Is that abuse now stopping and are there maybe 
> ways to get rid of vmf_insert_mixed()?

Unfortunately it is also used by a few drm drivers and not just DAX.
