Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0BF313E2F;
	Thu, 27 Nov 2025 07:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764227670; cv=none; b=mzSTKUcBZTzxBIdd2bEzKZxISxhaxvgigbrMZUSERG5USGrS6xW8rUdRm8VnHk/4RzkR3WXUYflZuSTOryPOQUJDekuy9zde3acprgs3XkB8Kc4USB7/nmiwqe13uPTdfnVGemhBz+G4nr+3D3sq6jktvLOUCgCQD0x2skxt/x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764227670; c=relaxed/simple;
	bh=Dg0LO8VGcXvLC+hqSiLBkFrgUGx89nIpGsekD4cXYxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wj9U2pOSYFJCLNPYYSKd9jgnr/0wnjTRzMQlPSA5SqmvzP6ztAZBeie3WUJeN9/kq8Re3BhUfxDmujb4KZR0KyaiSO5sraeWFzzUjiNydwZ3NDJyoiuDJ9Q/UBk88GRUUWyDGFhS/Oikg9oKF2uxxoBCn6/hlwy2UMvyrwm7mpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zg1oGhwM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zg1oGhwM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Mg+PdZwdO0sia44+fBnEmBbsN7z3KLsWp8ZG90Kr2co=; b=zg1oGhwMXKXGpM+xN5wCmVjIwM
	W8o/ZRV8Sk/82xVCZfXa0NPWzZO/OCbW9F3gQ/C5UCbbIFFD4HxDx734V3/wQXOtgEtMkowhrn57p
	ry68pe8OtSiFnM64iVFWSLyVxBYc4kWQ5uAo3zcSMQlTJbnFCm0YRTmhefnY/0pui7Fvsumi+Sm4T
	D034uORhocYZRN0N0Cp6kCWN/8ojGWdoUkIX6v2104g4Vzjgaf5iNvL0+kHczzoenAomSvHRPI6bi
	Kz/W2mREv6tu4NCYbCRF5RpV9bHXp0TLv1nVxpcfwbol1vNTYCdaLRCp3hWi29HC7yLCGA3fJRU1I
	GNig/OVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOWCt-0000000G6bt-2k36;
	Thu, 27 Nov 2025 07:14:23 +0000
Date: Wed, 26 Nov 2025 23:14:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO
 Chain Handling
Message-ID: <aSf6T6z6f2YqQRPH@infradead.org>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSBA4xc9WgxkVIUh@infradead.org>
 <CANubcdVjXbKc88G6gzHAoJCwwxxHUYTzexqH+GaWAhEVrwr6Dg@mail.gmail.com>
 <aSP5svsQfFe8x8Fb@infradead.org>
 <CANubcdVgeov2fhcgDLwOmqW1BNDmD392havRRQ7Jz5P26+8HrQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANubcdVgeov2fhcgDLwOmqW1BNDmD392havRRQ7Jz5P26+8HrQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 27, 2025 at 03:05:29PM +0800, Stephen Zhang wrote:
> No, they are not using bcache.

Then please figure out how bio_chain_endio even gets called in this
setup.  I think for mainline the approach should be to fix bcache
and eorfs to not call into ->bi_end_io and add a BUG_ON() to
bio_chain_endio to ensure no new callers appear.  I

> If there are no further objections or other insights regarding this issue,
> I will proceed with creating a v2 of this series.

Not sure how that is helpful.  You have a problem on a kernel from stone
age, can't explain what actually happens and propose something that is
mostly a no-op in mainline, with the callers that could even reach the
area being clear API misuse.

