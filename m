Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FBC29CA
	for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 16:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d+JJm4oOxq5DwxbgVcq/OaoV+BL6oX8jKgPcci4Cxx8=; b=EdB/cP4eAG6COf0OroQ/fEGY/b
	J9xBV+A2WVoXv/JiuFNH4oPk/p7/O8vaIpon9fnvstGLsrkMowQAYbrtLX2BYuqhMfZpBc/dqtWsR
	E6yrsqwN6KEmhcgdvOViHTkp99X1oIkJtVcBjt7MS/zXUEGYPsFeCtG+10DMYjeSUW3Du7yZU2owG
	/P1GwmyKmfSMHBffRrHs2U2bGy9RnwW8IaJycSpOHQt8YLJZhr3K1vrizKHkgVVXxEXEOFkje+enA
	4vDkbaraarOFgcmqFe/0gV//vX9rYdz/YDc2fz7HIdQhMgXfzgOR/Mp//MJMYJ8GSqCiC8dRO+FyY
	xzlpOZNQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mcVIn-00GToq-Uz; Mon, 18 Oct 2021 16:15:53 +0000
Date: Mon, 18 Oct 2021 09:15:53 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Geoff Levand <geoff@infradead.org>
Cc: axboe@kernel.dk, mpe@ellerman.id.au, benh@kernel.crashing.org,
	paulus@samba.org, jim@jtan.com, minchan@kernel.org,
	ngupta@vflare.org, senozhatsky@chromium.org, richard@nod.at,
	miquel.raynal@bootlin.com, vigneshr@ti.com,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] block: add_disk() error handling stragglers
Message-ID: <YW2duaTqf3qUbTIm@bombadil.infradead.org>
References: <20211015235219.2191207-1-mcgrof@kernel.org>
 <a31970d6-8631-9d9d-a36f-8f4fcebfb1e6@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a31970d6-8631-9d9d-a36f-8f4fcebfb1e6@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Sun, Oct 17, 2021 at 08:26:33AM -0700, Geoff Levand wrote:
> Hi Luis,
> 
> On 10/15/21 4:52 PM, Luis Chamberlain wrote:
> > This patch set consists of al the straggler drivers for which we have
> > have no patch reviews done for yet. I'd like to ask for folks to please
> > consider chiming in, specially if you're the maintainer for the driver.
> > Additionally if you can specify if you'll take the patch in yourself or
> > if you want Jens to take it, that'd be great too.
> 
> Do you have a git repo with the patch set applied that I can use to test with?

Sure, although the second to last patch is in a state of flux given
the ataflop driver currently is broken and so we're seeing how to fix
that first:

https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20211011-for-axboe-add-disk-error-handling

  Luis
