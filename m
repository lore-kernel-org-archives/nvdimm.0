Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314037E
	for <nvdimm@lists.linux.dev>; Wed,  6 Apr 2022 05:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xkKN41eLVrIheZpH/2SH1i+aJL00RRx4irbbX94rx9Q=; b=Q/3lDXWd19Mt0b3/k3Rb7zcP5h
	p5Eze/s2YucUMuPYsP3/q20TplDhpywYDITWcq7DW8bCL9f9peotPecyp39tdZIQ1ExUkalAybXyS
	Sxt54IpLbAnxVjk06D6a2NNMvqpMHsxgMeosQjblK8oh9AW6ILrD0OEcrPhOIK4bCqie2ImxZgB4X
	gS/zqX5LtXLSyVWRgAmLMMXXDrccEDWzqicolNHUqaDXH8PiWuHSYpqXNQ8jCr6Cn3U5UgMr7P2gH
	bzB3VhlCqf6aRtj6S9vDNsm1YM8SxrSXMJeCnnlVBFrEDH/mbtk/QwMI4mI6duvxeYNJiTCqNnT1B
	dCRczSmQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nby6y-003oOR-F6; Wed, 06 Apr 2022 05:21:44 +0000
Date: Tue, 5 Apr 2022 22:21:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v7 6/6] pmem: implement pmem_recovery_write()
Message-ID: <Yk0jaC9rHwwoEV11@infradead.org>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-7-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405194747.2386619-7-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 05, 2022 at 01:47:47PM -0600, Jane Chu wrote:
> +	off = (unsigned long)addr & ~PAGE_MASK;

offset_inpage()

> +	if (off || !(PAGE_ALIGNED(bytes))) {

No need for the inner braces.

> +	mutex_lock(&pmem->recovery_lock);
> +	pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
> +	cleared = __pmem_clear_poison(pmem, pmem_off, len);
> +	if (cleared > 0 && cleared < len) {
> +		dev_warn(dev, "poison cleared only %ld out of %lu\n",
> +			cleared, len);
> +		mutex_unlock(&pmem->recovery_lock);
> +		return 0;
> +	} else if (cleared < 0) {

No need for an else after a return.
