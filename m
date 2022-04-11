Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B003D10EC
	for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 06:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zuE9Oa+Qeir18sQSYzqnRYIpuPNJeRgzj07o7ivdwmk=; b=jhLaW6gCJNXjHQjbpXI001NoLm
	AdFauJ9hVbDbbdwuShc0kE3TWVJ7U6cHbS1IVv5Dkz7vDn/LxPDJbM1rz1CQYtaBq9enHaO+9NlL/
	jw3q0mng0Gv7hWxJJvqwU/5geav0RGI5PD2R26zZwNTmbVZ0e2qgaOoci6Tk8P03ECRbTlHhAWhWI
	Nu2CciiC2elMY1Hh1rOZEbKyZ+CMYK7ToiTB8yDWTIR+NTU9faXcILk2jK5BIglpKBW1v2DZQYhXT
	c4S6MZxbtPM/AI23zj/vdJiRazAwFyTd0o2QCLP287g1iNfUVd0oCI7ghVyoF7Tju6mc5yarGTDAJ
	+XuGp9AA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ndnfr-006wdX-RD; Mon, 11 Apr 2022 06:37:19 +0000
Date: Sun, 10 Apr 2022 23:37:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v12 2/7] mm: factor helpers for memory_failure_dev_pagemap
Message-ID: <YlPMn2DjbqzAVhrb@infradead.org>
References: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com>
 <20220410160904.3758789-3-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410160904.3758789-3-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
> +unlock:
> +	dax_unlock_page(page, cookie);
> +	return 0;

As the buildbot points out this should probably be a "return rc".
