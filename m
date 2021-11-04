Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0647E2C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wTE0pUvAy2SS7XIPVFk47lEu8RHkWpmW/KaM1nPJ460=; b=nGx1gBZldH+s/qsgyKfbHwWNXg
	50DXz1YBwxTRvfUi5UmXEXSn8BUfgTNmeRoWmDK8iDaM+WpTWFNoFaSw+DaNvaFxT/Z+ZLVknHAgB
	xLTdxY/HFyieIJMqUAnK87tF4q5wToZ3bcY0V1WFDP4OBh7Y7h0gWg7KV+9aFdRordrJEy2/eFkxw
	IEw2RuJoAfDQkR9Oo1ErkY+3W5qCWhus//8Iwz38nvOKHHA7Btxe2tdmGMnAhuuWcAGXjlOgyU+MW
	vKJZV4viv4Nu8SXXFYvqLi3pqSjlbu7oP+uk9hDhAfDtOpx3Z2O9TAVvExTXpryu8BP2jojaSzONA
	OEthPTHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1migvz-009j2r-Mv; Thu, 04 Nov 2021 17:53:55 +0000
Date: Thu, 4 Nov 2021 10:53:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, viro@zeniv.linux.org.uk,
	willy@infradead.org, jack@suse.cz, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] dax: introduce dax_clear_poison to dax pwrite
 operation
Message-ID: <YYQeM+1f7JgDY/QP@infradead.org>
References: <20210914233132.3680546-1-jane.chu@oracle.com>
 <20210914233132.3680546-3-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914233132.3680546-3-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 14, 2021 at 05:31:30PM -0600, Jane Chu wrote:
> +		if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {

No need for the inner braces.

> +			if (dax_clear_poison(dax_dev, pgoff, PHYS_PFN(size)) == 0)

Overly long line.

Otherwise looks good, but it might need a rebase to the iomap_iter
changes.

