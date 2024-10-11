Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BACD207A36;
	Fri, 11 Oct 2024 09:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728638294; cv=none; b=YWxkfmRwekJaJVudJ0lDyYtoZc15Z6505ud+mf8McbKQJRAp5Bt03Lrnd1RxTAJu0CZjkwsyCcegKvvdMGzKNNNZYT231LwZIqljbTXZZMCDSk5xUQED/s2ffv6KOimQJBlA5jGZQgQQ+C6/Kfaher4SKcf+t1EZkgtvjbmwzLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728638294; c=relaxed/simple;
	bh=m2Llmirs7gZ+YvRTkAP1OLo1mBvaOWjgJWGJGgqeTJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F4i9BqM9qB/KYYMyBY2QUq81ufoOKlg9g1b9dnavRSb7h9Sz0gLzPpUTv7JLGlHM6+9OcOjGoUjLRad7DesVQD2My8XHXWa+5fJI4QOPOxZskABsv7PCoCzjCimH3S1+4npiBEWpk7HW9V3winIRDojBkbMWfvTsJUSyFKCC+zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Quf8GJzg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Quf8GJzg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lU4r4tbL0K3+5Mx7gnspEYb/vcINY3gT5cXeOgb5F4w=; b=Quf8GJzgeSqTUbUf2AO61bq2LU
	Vf+sqE1ISUAtcou7pFQzSVWv9InCaQKBoNd0afkNiv10L1mfVdLAfuZqdRMl/eVzwvg1LIjnPSgRK
	bKGLaoP6oKtAZ0+iIW2SuFuA9IX5rlhBRy2PApzCAuKxL5P39veXhGyuBZikJB5HCpCMvAy/RPwhk
	x+iQBynF6YG1b170b2ADWCDkmbV+l3SIixwMM+ABeReVdPFfffqfyxC8IpG4uEF7f5C0GB0e8yg9O
	ROhve62AuLOSgCtv0FBgCduv+2YocVTwKa+gGZ5aSE9GPjg+5J5xpstuLLxyrAoBK+jWMzLm2wGew
	PN1kCL1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1szBmb-0000000FnpU-3CEE;
	Fri, 11 Oct 2024 09:18:01 +0000
Date: Fri, 11 Oct 2024 02:18:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Huang, Ying" <ying.huang@intel.com>, Chris Li <chrisl@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dan Schatzberg <schatzberg.dan@gmail.com>,
	Barry Song <baohua@kernel.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Casper Li <casper.li@mediatek.com>,
	Chinwen Chang <chinwen.chang@mediatek.com>,
	Andrew Yang <andrew.yang@mediatek.com>,
	John Hsu <john.hsu@mediatek.com>, wsd_upstream@mediatek.com
Subject: Re: [PATCH] mm: Split BLK_FEAT_SYNCHRONOUS and SWP_SYNCHRONOUS_IO
 into separate read and write flags
Message-ID: <ZwjtSe8zL3WO32h5@infradead.org>
References: <20241011091133.28173-1-qun-wei.lin@mediatek.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011091133.28173-1-qun-wei.lin@mediatek.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 11, 2024 at 05:11:33PM +0800, Qun-Wei Lin wrote:
> This patch splits the BLK_FEAT_SYNCHRONOUS feature flag into two
> separate flags: BLK_FEAT_READ_SYNCHRONOUS and
> BLK_FEAT_WRITE_SYNCHRONOUS. Similarly, the SWP_SYNCHRONOUS_IO flag is
> split into SWP_READ_SYNCHRONOUS_IO and SWP_WRITE_SYNCHRONOUS_IO.
> 
> These changes are motivated by the need to better accommodate certain
> swap devices that support synchronous read operations but asynchronous write
> operations.
> 
> The existing BLK_FEAT_SYNCHRONOUS and SWP_SYNCHRONOUS_IO flags are not
> sufficient for these devices, as they enforce synchronous behavior for
> both read and write operations.

You're still failing to provide a user.  Without that it is dead in
the water from the very beginning.

