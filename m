Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523C9256D;
	Mon, 24 Nov 2025 06:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965366; cv=none; b=JghcO8rNclcvUWRionGltQSG3HtdABmfQWC33zwZr4RXKzwUH7oI5YjeZvNAFaKU3jyrE6bJWg2u4sPBb+8lSgNTYuKfn1OIyzFq+XzHiXvDdrZ3mRmP3HQlAvXMXEeHDiFd0gN9XoDq130SHqYN0yHNxPvjIzgdYBqLo2OPh4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965366; c=relaxed/simple;
	bh=nx3VukjuuMOBSyaDA6zUnfhDxdBh573OnuZhnglTync=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJiX7bPuFhNENBY7+czpzWSp46MMmaOpMJP/pqBLeaMv5vcOq0Nk2moo/xJR+lAA1Oc6G96efujyUZ1qIP4jYCSu98fT4rT6ELKn5mkOmfF+Osu2ZF03biQ10SzjEUGw2MKZKsvrk0d7F6t3XAWFllWOSw+D0unkt1oP+127VZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qH8qp2/x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qH8qp2/x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dp3mlPd1tGPSHjwalGRl3+OXBzlUltt5c2g4rrDWar4=; b=qH8qp2/x9cZUMrdILRqeU862Zl
	rY+YcfF4XPEPXN/zjHR+j1pwqvCwhGipGukmvP7MEANpCrlePLgfvo+05kOyRgrrA3iEWaXcdkfwy
	n5MFvlXTOYs8cCMXaPqm2NJrQn6ejYfHPXF6Fk+6S1lNaAbGp001jBuqd3Yx8ixJeykV21c62OgO9
	IxdMSY6IQXNeDIUGXAoKu3y67wRgr7iijuqp1G/8PN73v/lq0LzcuS/sL2NNnuTiZz+ePoC33OgqI
	5JyrqgQXsohfKx04w9wzb+dCx2vOLMZs814+VxsjteBNXfNEM5E8FFaII+89JtbsMIzbCxoUqIaPn
	6AjZf4SA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNPyE-0000000B90n-31B1;
	Mon, 24 Nov 2025 06:22:42 +0000
Date: Sun, 23 Nov 2025 22:22:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO
 Chain Handling
Message-ID: <aSP5svsQfFe8x8Fb@infradead.org>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSBA4xc9WgxkVIUh@infradead.org>
 <CANubcdVjXbKc88G6gzHAoJCwwxxHUYTzexqH+GaWAhEVrwr6Dg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANubcdVjXbKc88G6gzHAoJCwwxxHUYTzexqH+GaWAhEVrwr6Dg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Nov 22, 2025 at 02:38:59PM +0800, Stephen Zhang wrote:
> ======code analysis======
> In kernel version 4.19, XFS handles extent I/O using the ioend structure,

Linux 4.19 is more than four years old, and both the block I/O code
and the XFS/iomap code changed a lot since then.

> changes the logic. Since there are still many code paths that use
> bio_chain, I am including these cleanups with the fix. This provides a reason
> to CC all related communities. That way, developers who are monitoring
> this can help identify similar problems if someone asks for help in the future,
> if that is the right analysis and fix.

As many pointed out something in the analysis doesn't end up.  How do
you even managed to call bio_chain_endio as almost no one should be
calling it.  Are you using bcache?  Are the others callers in the
obsolete kernel you are using?  Are they calling it without calling
bio_endio first (which the bcache case does, and which is buggy).

