Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F39344038;
	Fri, 21 Nov 2025 10:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763721448; cv=none; b=jx4A6a0qZtIBYhlKj21OTX+JkFcVQP9s0QXJ7W3nsV3fU2rzZliHwv3VMlm4q/C+SBX/9ZSwtQJ86foMnUTY4Zkj1YTncYLOljPQxDsg4PmmtFimcjgIo5C21slKsjmR2xyMch6TMO6VqmpOk5f9cQzc4/eEiRNJkMrrEvQdLTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763721448; c=relaxed/simple;
	bh=Q88weaBzGr4ILIu7fSII/CisX2y++SfSOFdR83V6VyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjoQq4j/DVQfZPzN1nNX4jHO+X6JxHmlcPUA6rDkD5yOQHinG/G815Kh1bQNuUtV6uzw5rytnwO7pak9Lw5nqX5V2Uk/ETOyDpsN0DPVA4lXHOS+MPOee/y+RToO4y1jN4xoUXzhPtaobir+Fftes7/CKYF/+gZ6gStBMdwgnG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rri3jibu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rri3jibu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zp3TKlTxdZlSsgsBn6EkPyeGu/Ie/JJn00zi5VBT4ZA=; b=rri3jibudiMPNZW1jMH/K7wpHe
	lN7iw0UVscFHtHslhvjQH+q3NhuICnmeqz1uYKXbTm/aKu8BDPcmQwxWQdKd9OP76eQWnmgKw+clq
	AiS7Y6G+s6xTzCDuxYSQ3LnBMkKgFyNTR9PgaUFVOII7NTkNOa1AMj5fHqEdz0ONLhuMXhVzXPYi7
	/BIsAwS2tcntMHs5R6rr7x25tKvPVYf+BARt4VgsUlg0lGXNau/2Y21zYmXw+tMbLUXcqW52tAjBo
	/ZHZipqbVR5d8+xvC3DSwSik+9kf1uvPQk5KfEst3j6cx9frbuu0WwvcpQl2CPxiJscmtbLuG4gVR
	NyQekE4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMOW3-00000008FLE-3gSW;
	Fri, 21 Nov 2025 10:37:23 +0000
Date: Fri, 21 Nov 2025 02:37:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: zhangshida <starzhangzsd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO
 Chain Handling
Message-ID: <aSBA4xc9WgxkVIUh@infradead.org>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121081748.1443507-1-zhangshida@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 21, 2025 at 04:17:39PM +0800, zhangshida wrote:
> We have captured four instances of this corruption in our production
> environment.
> In each case, we observed a distinct pattern:
>     The corruption starts at an offset that aligns with the beginning of
>     an XFS extent.
>     The corruption ends at an offset that is aligned to the system's
>     `PAGE_SIZE` (64KB in our case).
> 
> Corruption Instances:
> 1.  Start:`0x73be000`, **End:** `0x73c0000` (Length: 8KB)
> 2.  Start:`0x10791a000`, **End:** `0x107920000` (Length: 24KB)
> 3.  Start:`0x14535a000`, **End:** `0x145b70000` (Length: 8280KB)
> 4.  Start:`0x370d000`, **End:** `0x3710000` (Length: 12KB)

Do you have a somwhat isolate reproducer for this?

> After analysis, we believe the root cause is in the handling of chained
> bios, specifically related to out-of-order io completion.
> 
> Consider a bio chain where `bi_remaining` is decremented as each bio in 
> the chain completes.
> For example,
> if a chain consists of three bios (bio1 -> bio2 -> bio3) with
> bi_remaining count:
> 1->2->2
> if the bio completes in the reverse order, there will be a problem. 
> if bio 3 completes first, it will become:
> 1->2->1
> then bio 2 completes:
> 1->1->0
> 
> Because `bi_remaining` has reached zero, the final `end_io` callback
> for the entire chain is triggered, even though not all bios in the
> chain have actually finished processing. This premature completion can
> lead to stale data being exposed, as seen in our case.

It sounds like there is a problem because bi_remaining is only
incremented after already submittin a bio.  Which code path do you
see this with?  iomap doesn't chain bios, so is this the buffer cache
or log code?  Or is there a remapping driver involved?

