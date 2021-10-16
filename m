Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8995B2C81
	for <nvdimm@lists.linux.dev>; Sat, 16 Oct 2021 00:01:22 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18BA3611C3;
	Sat, 16 Oct 2021 00:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1634342482;
	bh=zERYufNJ1MZk5CclnMi+gL/h2WeGYYoy9Om0aXiHGLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lAd5BhR7dX0bhUFdgALWUXGCQ+v5W0tvJIwfUWbRKvGKqR2h6V0I6ukKcRF5Dj+Nw
	 0dFWCYUmBg7S2Rodk9yCf0H1+kehM9Vr5MyDW3E957s4BJA3cyS4uAhz4e17bCP29s
	 II0rzTuzcoBkDSvXr4ZGRWsUKw8yktjg7TyZT5pwSjCguTcC1658+kFky8M1STBicA
	 7fLq43tAQkTcs+sDRgIw1Gv5v7j5U3hjGyPw8mDDVxsn00Q51dQWLT/IESbUsSNm65
	 nxOHSWjB0mZ+Ve03BmVAuGYwTgnYAMB4qLl+33yxh5AlIshuEdLL26zAeBOF+sdd/j
	 wOOh/LnbCmJTQ==
Date: Fri, 15 Oct 2021 18:01:18 -0600
From: Keith Busch <kbusch@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: axboe@kernel.dk, geoff@infradead.org, mpe@ellerman.id.au,
	benh@kernel.crashing.org, paulus@samba.org, jim@jtan.com,
	minchan@kernel.org, ngupta@vflare.org, senozhatsky@chromium.org,
	richard@nod.at, miquel.raynal@bootlin.com, vigneshr@ti.com,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, hch@lst.de,
	sagi@grimberg.me, linux-block@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/13] nvme-multipath: add error handling support for
 add_disk()
Message-ID: <20211016000118.GA50317@C02WT3WMHTD6>
References: <20211015235219.2191207-1-mcgrof@kernel.org>
 <20211015235219.2191207-3-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015235219.2191207-3-mcgrof@kernel.org>

On Fri, Oct 15, 2021 at 04:52:08PM -0700, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> Since we now can tell for sure when a disk was added, move
> setting the bit NVME_NSHEAD_DISK_LIVE only when we did
> add the disk successfully.
> 
> Nothing to do here as the cleanup is done elsewhere. We take
> care and use test_and_set_bit() because it is protects against
> two nvme paths simultaneously calling device_add_disk() on the
> same namespace head.

Looks good, thank you.

Reviewed-by: Keith Busch <kbusch@kernel.org>
