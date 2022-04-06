Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7547E
	for <nvdimm@lists.linux.dev>; Wed,  6 Apr 2022 05:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vqxJ46s1qeqVh8b5I6ydRXIhwjWlT/dFZD1qSfok+48=; b=B4F244K1t7i0S9VvsgftPFGVLL
	twk4UfeFzkxPTopcSzaeMxjEn5gzp3bjROlPuf41jSz2peCYKRvM2K5KrtS8rqY/IuEREqW7w8iWe
	dlNzOnFFnRN/UcR3HjvrkcBrhb+a2aKDxY15FvMwwib9aGOt/Ss/OK/c1eY8TcNJuKQ6Np2Jx538y
	RdMn1JCn6WhxVm3iL767HujuEQ28+HIKZDKYjOFfqYuBZQg8hTqkhhC0DTq0O3arV1NDtWSOvwkYQ
	OU41zD1ECjzE2uoK1byrm67/l1tCnM/dlbQPak1l6Wz7NY1Go0ZYFefdxLIR0geWUhRHcm2ysQ3/c
	EFnU1YPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nbxqX-003nIX-Gh; Wed, 06 Apr 2022 05:04:45 +0000
Date: Tue, 5 Apr 2022 22:04:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v7 5/6] pmem: refactor pmem_clear_poison()
Message-ID: <Yk0fbUs584vRprMg@infradead.org>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-6-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405194747.2386619-6-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 05, 2022 at 01:47:46PM -0600, Jane Chu wrote:
> +	pmem_clear_bb(pmem, to_sect(pmem, offset), cleared >> SECTOR_SHIFT);
> +	return (cleared < len) ? BLK_STS_IOERR : BLK_STS_OK;

No need for the braces.  That being said perosnally I find a simple:

	if (cleared < len)
		return BLK_STS_IOERR;
	return BLK_STS_OK;

much easier to read anyway.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
