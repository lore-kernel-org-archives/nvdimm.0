Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B7511CAF
	for <nvdimm@lists.linux.dev>; Wed,  8 Jan 2025 05:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736315493; cv=none; b=Eqy/oS2IEK/s5dJ5VaJNz3lS/lcMPk916vxp8YDkBAJwTHXjt1hPc7Kdvl8iLClqL7ro9zvyBufktgi9vwUEwP5v0BStNp91q9Knd/0WVnp0ihajlLeTvrh9w3t6hVWFMxyBYWvVoGw8P7C8ptyYqs2aGfUDunlEPvLRQJ8CtK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736315493; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fx6wBMYyfhFAtHkbPEnLs3C/+lVCSm50bnHYdSHlMS1GBCOXqUgyEha44czA9pmLkYAMbIeMM3cUOqCxwgFiJXPXADGzSo+0eG+tByo99OVPPtQvAp6wSVf7RUgDo0JkhW5/1JtzFq45densCitPNFh7XjdWVvLgMYHGzdCHCEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9A0DC68BEB; Wed,  8 Jan 2025 06:51:27 +0100 (CET)
Date: Wed, 8 Jan 2025 06:51:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Alistair Popple <apopple@nvidia.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	gerald.schaefer@linux.ibm.com, dan.j.williams@intel.com,
	jgg@ziepe.ca, willy@infradead.org, david@redhat.com,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de
Subject: Re: [RFC 1/4] mm: Remove PFN_MAP, PFN_SG_CHAIN and PFN_SG_LAST
Message-ID: <20250108055127.GB20341@lst.de>
References: <cover.a7cdeffaaa366a10c65e2e7544285059cc5d55a4.1736299058.git-series.apopple@nvidia.com> <106d22a58b4971a2e41ca65d9ceb30ed81fcf727.1736299058.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <106d22a58b4971a2e41ca65d9ceb30ed81fcf727.1736299058.git-series.apopple@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

