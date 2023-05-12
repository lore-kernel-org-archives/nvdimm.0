Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051C4BE4E
	for <nvdimm@lists.linux.dev>; Fri, 12 May 2023 13:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3ANktL2xVKVN8HxQMkWuLRyfDdr3/NdcNv7SU8ma8Vs=; b=QBzQUcOFZKTX2j9/C+4x9R61vv
	lmsSqCO6FXWe8EV6L4voAOxBMn+UMpvuV+vnSrUDWmqz68fo9USsxSjp6RlzwFfDWHBr8uqHmrBfT
	7tmJKJaX8crJ9LlZ+cOu1XKjvecu19UkH/Ypqqe73SGdZYQdw0mjrZv7pmLWjG1cORfwQ8i/U/9+t
	PEhk8XfSv90ccfasskviQLLE3UlS/8H6bUuW3N15e6aKg8X1SQ/xm2mSLPPuLlBaewiNzHsp7hXKL
	fZwiJLM0pH1ssX1zyyk6/C4rlTB8uqkBeBGsMbSS/3ax4IFEJFxp8ImW64FlsZSe1rlOp3Nun11qj
	LRJfj+dA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pxSpt-00C1ti-24;
	Fri, 12 May 2023 13:29:29 +0000
Date: Fri, 12 May 2023 06:29:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev
Subject: Re: [PATCH 0/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Message-ID: <ZF4/OWd9aqBaDacL@infradead.org>
References: <20230512104302.8527-1-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512104302.8527-1-kch@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 12, 2023 at 03:43:01AM -0700, Chaitanya Kulkarni wrote:
> Allow user to set the QUEUE_FLAG_NOWAIT optionally using module
> parameter to retain the default behaviour.

Why?
