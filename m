Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D538E362
	for <nvdimm@lists.linux.dev>; Fri, 10 Jun 2022 05:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fQQYd8rH7yJgcH0WS5t7Iydx1WYbX6aTpNe9zlkn5xY=; b=knb9VjPHC+6O7WDiHU1GAHcTAG
	vRgrANbZCRTzUEEFNEjFJ1RdGOfNA/zo2JrBBPC+yL6tSluDm289+6nyXfosJtKmlyZlBieC7vkkz
	QE+AGKTlV/bfs9e2X6gg8YTXmB+lbg9RldomOdR9TXR7wcDPHzZYjcFA9ivk5gypnNfJ+PG8MIqWv
	jb3fC56WsabH27bAKa+26acnxmxXetekXbR4k99gDJ1eLm8bsipbbeON7lqnj3i1K4QksMVFK2MiX
	UWkr5+1IN9mWvoqKgH+esAlnwDVxmlsDwGC2wYggJwT9uExQr93/yAyGe32WwmBfYGoeEox9EeC0X
	fd4876rA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nzXTB-0061yU-Ai; Fri, 10 Jun 2022 05:46:05 +0000
Date: Thu, 9 Jun 2022 22:46:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
Message-ID: <YqLanVuXPaIJOtAW@infradead.org>
References: <20220609143435.393724-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609143435.393724-1-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 09, 2022 at 10:34:35PM +0800, Shiyang Ruan wrote:
> Failure notification is not supported on partitions.  So, when we mount
> a reflink enabled xfs on a partition with dax option, let it fail with
> -EINVAL code.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
