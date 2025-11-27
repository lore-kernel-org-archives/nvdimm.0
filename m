Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0401D2765EA;
	Thu, 27 Nov 2025 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254822; cv=none; b=htY5sJ780LHxz20NqJ6UDKwPSWvX7AyG6Peg3NxkNRGDyScu5Y1b8RGF4Lq5xxhGnQt/EgSuMyy/FHElKBPmeLCZEIb9GiXf6LoHybJeBrG3pdqeHMd0z29GSVHe3YgLX7fEXAnl9RnVsT6ub/oAsV6X5cWGDWKAPjB/bowkGyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254822; c=relaxed/simple;
	bh=ivuoXExaB3gsliilPqzQI7ROdKlgJlBqam2Q0DpFMbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQ1RYDKDxtl7rQe9SGVVXu+wuueUuoMrRh4KyrxsV4WO/KwUOuHbtw3/9qg6Uzh7NOeH9f46OimlCHpf1T02dUl0H1CwDv6yLiSeE7hzwB8dMaM4Rlzm3OpOwCF87Og/4QaxTKtiaB4m5uxgK2O9r2L1T/K/KZItQRebqewiUfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KLtq1zLl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KLtq1zLl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JB6Vn8jaGZJZFbHXqiLHtPjpjF68p2nfQjOHbcKK9KQ=; b=KLtq1zLlifxDD6EFn/Q+RiTUa1
	PG8KgYjyvrgOSvwGtUKvHikYUCvoxtUpFM9PoPWH/yVVCuyMLtlzQOvEdltPVZy0AFPaeGJPwVYOD
	QJzdV/aD5BGaEQg8qYXEXpl+nPufbM5cju7eJ590cYPfJqBMxgi0+dC0IGPUB7AXp3sFUkwscs1ZF
	WxxiipMGyQ5NZbmSGUwmWbYW2Uk1OcR7cyUDmdUoAhiAlzKnj/NoVYLGgjZU/6y8IZjWnWOy3bm0E
	3hgWbv2yVSQxs3Z5m7d2sqE3KrlGrAHnO8gRzZxvjBVmHpbmzSKURd6tLnwkfxa/SqrpkajnAF3Sd
	5v7sZoyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOdGl-0000000Gnt0-2Jdy;
	Thu, 27 Nov 2025 14:46:51 +0000
Date: Thu, 27 Nov 2025 06:46:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Stephen Zhang <starzhangzsd@gmail.com>,
	Ming Lei <ming.lei@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO
 Chain Handling
Message-ID: <aShkWxt9Yfa7YiSe@infradead.org>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSBA4xc9WgxkVIUh@infradead.org>
 <CANubcdVjXbKc88G6gzHAoJCwwxxHUYTzexqH+GaWAhEVrwr6Dg@mail.gmail.com>
 <aSP5svsQfFe8x8Fb@infradead.org>
 <CANubcdVgeov2fhcgDLwOmqW1BNDmD392havRRQ7Jz5P26+8HrQ@mail.gmail.com>
 <aSf6T6z6f2YqQRPH@infradead.org>
 <3a29b0d8-f13d-4566-8643-18580a859af7@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a29b0d8-f13d-4566-8643-18580a859af7@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 27, 2025 at 03:40:20PM +0800, Gao Xiang wrote:
> For erofs, let me fix this directly to use bio_endio() instead
> and go through the erofs (although it doesn't matter in practice
> since no chain i/os for erofs and bio interfaces are unique and
> friendly to operate bvecs for both block or non-block I/Os
> compared to awkward bvec interfaces) and I will Cc you, Ming
> and Stephen then.

Thanks.  I'll ping Coly for bcache.

