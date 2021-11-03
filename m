Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969D32C85
	for <nvdimm@lists.linux.dev>; Wed,  3 Nov 2021 00:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yiusFCW+f2K0ALHpFvDau6vHV1OaeV9ZhqUB3iArawg=; b=H3i3P/paQQyo18OlORiZcA7r0B
	+YeBijwe8hPcFbRYtNWNI45FDMMZfW/e+XSx3ky8cIP05TeFW7ANNvmd2mXLMMS1Hpd8Whbj/eFkR
	YJ6ioeR4dr2sSK/1ZBz9e9oL4+vZ58EfniVNDcH6MOJpxCIDCJCdCT6gMEkUhPNykHGaUpKYFoabq
	uRbBazNnswQdE+yh5dAF23euhaKmAjo8bP3mbyVGVyzuCH8O4220oZ8CgOWZ2loc663vkvM1HXMXJ
	oShxcfv3/5JtGpMI5NgD+OVwGQzz98d/FK/iYltgZ8Sg2iZLeqC5rPjCc0JFrrlCa7XAjTTR8n4+B
	oTCJo9mw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mi3rO-003aHh-An; Wed, 03 Nov 2021 00:10:34 +0000
Date: Tue, 2 Nov 2021 17:10:34 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Geoff Levand <geoff@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>, Jim Paris <jim@jtan.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	senozhatsky@chromium.org, Richard Weinberger <richard@nod.at>,
	miquel.raynal@bootlin.com, vigneshr@ti.com,
	Vishal L Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	linux-mtd@lists.infradead.org,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-nvme@lists.infradead.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/13] nvdimm/blk: avoid calling del_gendisk() on early
 failures
Message-ID: <YYHTejXKvsGoDlOa@bombadil.infradead.org>
References: <20211015235219.2191207-1-mcgrof@kernel.org>
 <20211015235219.2191207-7-mcgrof@kernel.org>
 <CAPcyv4j+xLT=5RUodHWgnPjNq6t5OcmX1oM2zK2ML0U+OS_16Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4j+xLT=5RUodHWgnPjNq6t5OcmX1oM2zK2ML0U+OS_16Q@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Oct 15, 2021 at 05:13:48PM -0700, Dan Williams wrote:
> On Fri, Oct 15, 2021 at 4:53 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > If nd_integrity_init() fails we'd get del_gendisk() called,
> > but that's not correct as we should only call that if we're
> > done with device_add_disk(). Fix this by providing unwinding
> > prior to the devm call being registered and moving the devm
> > registration to the very end.
> >
> > This should fix calling del_gendisk() if nd_integrity_init()
> > fails. I only spotted this issue through code inspection. It
> > does not fix any real world bug.
> >
> 
> Just fyi, I'm preparing patches to delete this driver completely as it
> is unused by any shipping platform. I hope to get that removal into
> v5.16.

Curious if are you going to nuking it on v5.16? Otherwise it would stand
in the way of the last few patches to add __must_check for the final
add_disk() error handling changes.

  Luis
