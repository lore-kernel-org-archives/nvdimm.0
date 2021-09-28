Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1094F72
	for <nvdimm@lists.linux.dev>; Tue, 28 Sep 2021 04:34:29 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 15E1067373; Tue, 28 Sep 2021 06:34:26 +0200 (CEST)
Date: Tue, 28 Sep 2021 06:34:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Murphy Zhou <jencce.kernel@gmail.com>,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [regression] fs dax xfstests panic
Message-ID: <20210928043426.GA28185@lst.de>
References: <20210927061747.rijhtovxafsot32z@xzhoux.usersys.redhat.com> <20210927115116.GB23909@lst.de> <20210927230259.GA2706839@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927230259.GA2706839@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 27, 2021 at 04:02:59PM -0700, Darrick J. Wong wrote:
> > > Looping xfstests generic/108 or xfs/279 on mountpoints with fsdax
> > > enabled can lead to panic like this:
> > 
> > Does this still happen with this series:
> > 
> > https://lore.kernel.org/linux-block/20210922172222.2453343-1-hch@lst.de/T/#m8dc646a4dfc40f443227da6bb1c77d9daec524db
> > 
> > ?
> 
> My test machinse all hit this when writeback throttling is enabled, so
> 
> Tested-by: Darrick J. Wong <djwong@kernel.org>

Do you mean the series fixed it for you?
