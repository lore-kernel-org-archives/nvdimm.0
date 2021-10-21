Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7832C8F
	for <nvdimm@lists.linux.dev>; Thu, 21 Oct 2021 11:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jHNkeu1MGIkme3Ou2Fc+7gjNFGDmVI77OK4rHIfkekk=; b=RKBcfzKOloAfOxSWW6IBPF/yTy
	9xwY27QTnR5eroggOBW+EDNgmwreHjqT/35SHF1zkvDj55xydrRDW/N0wSeBHA+4i+5MMkKTTuP5q
	gml2cOIUbFnnMiSZJkYYAP1EVNdP4VbvLVFiUGO3fD8bkuItik+q6L+PQbqY8A0rPHagJijvV9Ko+
	hrhSnV4C/7BzabxgOV1kEc6hNQ07BomA/cyaBUxcocLjXPjyveHl/BTUAN7gWJOn514IYJq0FTZnC
	GGn1NaFxVDiS4uHEXP8wHZyl3BRXrq4T/z6Uv/aivbSJkEF4V9VnlTzw4Y7GCWi/7mhNtgnU2WZma
	fgpfBGxg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mdWAK-007Kld-Ns; Thu, 21 Oct 2021 11:23:20 +0000
Date: Thu, 21 Oct 2021 04:23:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] pmem: pmem_dax_direct_access() to honor the
 DAXDEV_F_RECOVERY flag
Message-ID: <YXFNqI/+nbdVEoif@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
 <20211021001059.438843-4-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021001059.438843-4-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 20, 2021 at 06:10:56PM -0600, Jane Chu wrote:
> -	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> -					PFN_PHYS(nr_pages))))
> +	if (unlikely(!(flags & DAXDEV_F_RECOVERY) &&
> +		is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> +				PFN_PHYS(nr_pages))))

The indentation here is pretty messed up. Something like this would
be move normal:

	if (unlikely(!(flags & DAXDEV_F_RECOVERY) &&
			is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
				    PFN_PHYS(nr_pages)))) {

but if we don't really need the unlikely we could do an actually
readable variant:

	if (!(flags & DAXDEV_F_RECOVERY) &&
	    is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, PFN_PHYS(nr_pages)))
