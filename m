Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F4836E
	for <nvdimm@lists.linux.dev>; Wed, 30 Mar 2022 05:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ShlAuSZLyEq25xAfycHWI7hECNIi/GQOtl1mtKw5Shk=; b=hpQUdyyucc04FsSCWb013XTcO0
	y2GjL8gVriHew3MYCDqfR8ivlsTCoQ7g8whXxPt36DScOa0Zo6Zj9DDqJWWziGgLmYOJpAfGCm0qq
	BH77DEtEPOutPjLuav55+27+6J+YBCiF+PSdGg7AfoHRcx/iByOBAWfP1jvPNIXff6RArvYBV8qF0
	xnpWDCU3i+zCa/FxT/6PAxeN2Nx5zkJXV7JD+75XSBZIxKikg3jWrTOOe6gDK1DULV3xnjxXMX0e0
	h/JxGdqxaSEruRTcEV2rZgvsEtKc/eSNEqJKpEO88YBfEdbgpkV3cAsUYswOBVFv+kuRmz1KOt5Dn
	0yyRSCjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nZR9m-00EMtx-Iy; Wed, 30 Mar 2022 05:46:10 +0000
Date: Tue, 29 Mar 2022 22:46:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v11 5/8] mm: move pgoff_address() to vma_pgoff_address()
Message-ID: <YkPuooGD139Wpg1v@infradead.org>
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
 <20220227120747.711169-6-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220227120747.711169-6-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Feb 27, 2022 at 08:07:44PM +0800, Shiyang Ruan wrote:
> Since it is not a DAX-specific function, move it into mm and rename it
> to be a generic helper.

FYI, there is a patch in -mm and linux-next:

  "mm: rmap: introduce pfn_mkclean_range() to cleans PTEs"

that adds a vma_pgoff_address which seems like a bit of a superset of
the one added in this patch, but only is in mm/internal.h.
