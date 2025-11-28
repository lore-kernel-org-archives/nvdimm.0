Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797C61FC8;
	Fri, 28 Nov 2025 05:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764309316; cv=none; b=ZbM8yHFvWid1MS9BNYiC+r1mJe9q6QWsyoKFoaRtVNECynmNy61u7JqT8XR+KalDLzTMhPkkidQ4+c3+ya+542PAYDf4vMDGUO4oSmnDMbjFBHDGsa9p9MZztGrQjvgrLtmKJKANMlUeUKaeiTh255e7GFsYw5WW8JayJ1lbD68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764309316; c=relaxed/simple;
	bh=G47L7g/eGhulVRV0NVuVwtTeuuCmMSVBJ3unKsEtbkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XzYpLor1ynuMZSB97bLjFK7r4nPCTC8Ywu2BLCOrmf4Vc/JaStOb4GBmytR9LE5ijSC90043eopTzSN/OHfk/uGH/rWapYvD5+4fJ4MPH7q10t0Tjaa2tKR2y3hwQlnoQ3M0EcvHnriRY4ucEBSqjF1pT82qAMZOTcWlyGxmBHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rhvckYgC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rhvckYgC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=l1eIbKtcI47ARmgDaF6pAjkz2qY2W5DPgqZvQZUd/7A=; b=rhvckYgCiFKGMUmwtmCukKxDOH
	jI8+XR956nf/YgmEDN+xVrz9PskmyOoZTMcDsIqUOJKoW4YEcEM5ZelLDIbpqXMUW90mu8VLPMKwV
	pmBOzbwaqJra+4hBW4OVzsQiM7bdZMeN1bA+zReFvyTvnoE04fNi8JCDjn9N9kRz7Uqke54t4eeyC
	Pf93KNS0R/JcDGTLIudbQq6ybOuzdP7/MLgiE+V+kcXN3WAhLaWwRh1AOCDMn3MK9mwAXx5Gpscy9
	wLGxTP/zAe4HzEZLHNokFZEveJkzdKZtXdcs83ehnlE49xWf0ihv0xVok5r8oHHe7ricKT/Q+vm9O
	5TH4KorQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOrRo-0000000015K-0I0V;
	Fri, 28 Nov 2025 05:55:12 +0000
Date: Thu, 27 Nov 2025 21:55:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH 1/9] block: fix data loss and stale date exposure
 problems during append write
Message-ID: <aSk5QFHzCwz97Xqw@infradead.org>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-2-zhangshida@kylinos.cn>
 <aSA_dTktkC85K39o@infradead.org>
 <CAHc6FU7NpnmbOGZB8Z7VwOBoZLm8jZkcAk_2yPANy9=DYS67-A@mail.gmail.com>
 <CANubcdXzxPuh9wweeW0yjprsQRZuBWmJwnEBcihqtvk6n7b=bQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANubcdXzxPuh9wweeW0yjprsQRZuBWmJwnEBcihqtvk6n7b=bQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 28, 2025 at 11:22:49AM +0800, Stephen Zhang wrote:
> Therefore, we could potentially change it to::
> 
>         if (bio->bi_status && !READ_ONCE(parent->bi_status))
>                 parent->bi_status = bio->bi_status;
> 
> But as you mentioned, the check might not be critical here. So ultimately,
> we can simplify it to:
> 
>         if (bio->bi_status)
>                 parent->bi_status = bio->bi_status;

It might make sense to just use cmpxchg.  See btrfs_bio_end_io as an
example (although it is operating on the btrfs_bio structure)

