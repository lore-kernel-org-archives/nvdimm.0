Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE60F1EB5C2;
	Wed,  8 Apr 2026 05:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775627187; cv=none; b=FB2Z34kF7MaKymezLjjrOaXhe5XoEOMzzLcIDoYf0iu463QpvKU0yGhkxRGwZlhGe00nPqYCV7eUjCR+X84e/+dDIt5MS+GdLHgZ38RlnLD/gys3pqOuH7Wl6JHyPM/bCjdaIeWxi63BndJJr7n0waLLi1FotbnvOquOg4/m8U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775627187; c=relaxed/simple;
	bh=c3uM1Hh9/Z5cghwcYPpZ0G1u1yDL6hE+sM8tckvWT1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NGC665zyUrgNzmxhtFcqG7MgDt/Azh+YRVm8ijYLqh22+CUzigVURSeTxL5dsD5HJy2M6Q0eqgIpaC3aa1J/w/Wyf0HWliMEXTSZuUKaeazFizAnrXuT8eZGoWtXMwT1T7hoW5ZaJzHIijteCLfsYzHz34O7U/xS/odhpQw77nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ov/SnaXx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ov/SnaXx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nm4J6cVc9fv225rRNI935mcVaIP0KdgRI26cZBTikF8=; b=Ov/SnaXx0Q/Z3SkamNyHpx+8C2
	4DAfg6g37LD/hoZIyT0kwZLa+zeFZINYdTT4lP5m9A3lydgLDzTDG96mJxUpBwi9oCLPUCXXtffua
	Fk91CKv8eSaPUa8ZUIUhvfhSYA+VJvfIA2X2W7AQ2Ob5UoKCCgoqYn+WZoTA8PK6CYeeiZ4sh9Xus
	iZ6mZ4Sg2QAOkhVCQ+8Obt5oq9klPhSD2OVtmNJ2jXwargl3U7vJ99bpdqjOfXZDioRPKeHvpw7Jo
	6U0tucfgyIgJVIMa/jx+X0lzn4ctkaDG5x6/mXgvfxZC7p8iyZ8pWBy44hiN6xQrXT1aeZaixXNjD
	vDoAJZHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wALkA-00000008IWy-0vEj;
	Wed, 08 Apr 2026 05:46:26 +0000
Date: Tue, 7 Apr 2026 22:46:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
	linux-kernel@vger.kernel.org,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org,
	Joel Colledge <joel.colledge@linbit.com>,
	an Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev
Subject: Re: [PATCH 08/20] drbd: add DAX/PMEM support for metadata access
Message-ID: <adXrslkhromDtu37@infradead.org>
References: <20260327223820.2244227-1-christoph.boehmwalder@linbit.com>
 <20260327223820.2244227-9-christoph.boehmwalder@linbit.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327223820.2244227-9-christoph.boehmwalder@linbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Adding the dax maintainers and they really need to review this.

> +	long want = (drbd_md_last_sector(bdev) + 1 - first_sector) >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	pgoff_t pgoff = first_sector >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	long md_offset_byte = (bdev->md.md_offset - first_sector) << SECTOR_SHIFT;
> +	long al_offset_byte = (al_sector - first_sector) << SECTOR_SHIFT;

You really want helpers to make all these unit conversions maintainable.

