Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2561D70
	for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 14:32:57 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8053603E7;
	Tue, 27 Jul 2021 14:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1627396376;
	bh=P+J3nIURP3B0hGzMIl54oyj1L6/yl7CDmXAm5X+Upx8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mrlGqwmpjfPpgIzgTRGvv8csrCB9SF7IAeAXSl4PoYy4iHOL8O7IQYDa4eZu4E+7C
	 1OaUNt7sGa++izEvGezUm4A51hFgnFq/otisMzdmjNXAX54GLwKWj5K/orOK2B6S1v
	 XglpIa8SNerVvNFX5K5SD/TrRB+AvsU3281uQ1BiTC6o4EXW3QZJCVVCJ33pM+NlJm
	 L3VPYLxHOsKcEElZIdokwaqGoub+L6oWy+apXEDlQpMVQj7k7qbq0hXCQmhVKpiKtO
	 v+lwBnYgi/S5VV0CcbVlTi3CTNmvbAJrktYncwHyG+GYNgGiXBwuqtUsZX8lH/OQdw
	 uHMmFHkU98lMA==
Date: Tue, 27 Jul 2021 07:32:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 16/27] iomap: switch iomap_bmap to use iomap_iter
Message-ID: <20210727143256.GC559142@magnolia>
References: <20210719103520.495450-1-hch@lst.de>
 <20210719103520.495450-17-hch@lst.de>
 <20210719170545.GF22402@magnolia>
 <20210726081942.GD14853@lst.de>
 <20210726163922.GA559142@magnolia>
 <20210727063138.GA10143@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727063138.GA10143@lst.de>

On Tue, Jul 27, 2021 at 08:31:38AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 26, 2021 at 09:39:22AM -0700, Darrick J. Wong wrote:
> > The documentation needs to be much more explicit about the fact that you
> > cannot "break;" your way out of an iomap_iter loop.  I think the comment
> > should be rewritten along these lines:
> > 
> > "Iterate over filesystem-provided space mappings for the provided file
> > range.  This function handles cleanup of resources acquired for
> > iteration when the filesystem indicates there are no more space
> > mappings, which means that this function must be called in a loop that
> > continues as long it returns a positive value.  If 0 or a negative value
> > is returned, the caller must not return to the loop body.  Within a loop
> > body, there are two ways to break out of the loop body: leave
> > @iter.processed unchanged, or set it to the usual negative errno."
> > 
> > Hm.
> 
> Yes, I'll update the documentation.

Ok, thanks!

> > Clunky, for sure, but at least we still get to use break as the language
> > designers intended.
> 
> I can't see any advantage there over just proper documentation.  If you
> are totally attached to a working break we might have to come up with
> a nasty for_each macro that ensures we have a final iomap_apply, but I
> doubt it is worth the effort.

I was pushing the explicit _break() function as a means to avoid an even
fuglier loop macro.

--D
