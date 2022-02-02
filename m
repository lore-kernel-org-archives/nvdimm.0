Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4E32F21
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 13:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dq3J4PURLRkL+u3uGPxxtzHSbIW9BWym1tctSNdLoyw=; b=HbPestmYYX+VHHHvUgDZLk/k50
	FccnMiv0tIhH9g0nmAcowBY/STZTiaTCjJfLpSedU0TwjxzEVc49lL4mdS+yQOhPP5Ctib1voaXUv
	kTyz5YV6z94HxOIH16cTotbstVsFOAQ6AmeQeY441YwMG9iYaGLdabMzN5eplbEcN0OoGj5D/FgoM
	JHM2ZWb1KR6fJ7Xc6KyoaWWmYvQvQOTjzjYeW0aQIO6qlk+dQRBuFdLQUMhQl18x4uZVcimwHKMGp
	Y1n23sROFF9D5qDT+gmuTpQhHbvaTeFcnHKHVKh8kgDY+EMtAltlB6loz41wEbAcHFAynD/6d4mYv
	mBhHOryQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nFFmk-00FN5h-1w; Wed, 02 Feb 2022 13:34:58 +0000
Date: Wed, 2 Feb 2022 05:34:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 4/7] dax: add dax_recovery_write to dax_op and dm
 target type
Message-ID: <YfqIgliJi0GkviXD@infradead.org>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
 <20220128213150.1333552-5-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128213150.1333552-5-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 28, 2022 at 02:31:47PM -0700, Jane Chu wrote:
> dax_recovery_write() dax op is only required for DAX device that
> export DAXDEV_RECOVERY indicating its capability to recover from
> poisons.
> 
> DM may be nested, if part of the base dax devices forming a DM
> device support dax recovery, the DM device is marked with such
> capability.

I'd fold this into the previous 2 patches as the flag and method
are clearly very tightly coupled.

> +static size_t linear_dax_recovery_write(struct dm_target *ti, pgoff_t pgoff,
> +	void *addr, size_t bytes, struct iov_iter *i)

Function line continuations use two tab indentations or alignment after
the opening brace.

> +{
> +	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
> +
> +	if (!dax_recovery_capable(dax_dev))
> +		return (size_t) -EOPNOTSUPP;

Returning a negativ errno through an unsigned argument looks dangerous.

> +	/* recovery_write: optional operation. */

And explanation of what the method is use for might be more useful than
mentioning that is is optional.

> +	size_t (*recovery_write)(struct dax_device *, pgoff_t, void *, size_t,
> +				struct iov_iter *);

Spelling out the arguments tends to help readability, but then again
none of the existing methods does it.
