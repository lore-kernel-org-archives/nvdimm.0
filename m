Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E0F2C80
	for <nvdimm@lists.linux.dev>; Wed,  3 Nov 2021 12:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LQd9ON0o0bxgVa7t/t6C9KFNoIbTbvNYlRZH6tdxt4Y=; b=OvNVPtV32tvtoM0UNp1KdJFx0h
	rk4o14YLiAcRhZjsPUS+gf7opoD5BAyYW1K+PW46am4LoJJyw3vgZppcPtgYkmA6j6j9Tk6LmUBFr
	KQfk5LSuWEDjwkHe3nb8jWJsxxd2GZJ2Ob44TfZbhMnE2ym8w54y+OmpUHVddxfP+BtuZivjblqSA
	kEirsx4rHviqVwtD1dcEdze+gddxPooPNBcIvTYgDWQpn7+VivXkkYoGz6I8cj3q8EZO5AF4meTw4
	u9oQcAK/YBDxVs4vFsARMZPt1MS162S+iAhHPggWWBACjp+8vW9SD8IBYm+H+wUJmoQ3+FRwVQ8Am
	lo7Mt61w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1miF3s-0053o0-A0; Wed, 03 Nov 2021 12:08:12 +0000
Date: Wed, 3 Nov 2021 05:08:12 -0700
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
Message-ID: <YYJ7rIzHH754Pe1D@bombadil.infradead.org>
References: <20211015235219.2191207-1-mcgrof@kernel.org>
 <20211015235219.2191207-7-mcgrof@kernel.org>
 <CAPcyv4j+xLT=5RUodHWgnPjNq6t5OcmX1oM2zK2ML0U+OS_16Q@mail.gmail.com>
 <YYHTejXKvsGoDlOa@bombadil.infradead.org>
 <CAPcyv4h1dqBm71OQ_A5Qv4agT3PhV7uoojmSB1pEpS-CXaWb5w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h1dqBm71OQ_A5Qv4agT3PhV7uoojmSB1pEpS-CXaWb5w@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, Nov 02, 2021 at 05:49:12PM -0700, Dan Williams wrote:
> On Tue, Nov 2, 2021 at 5:10 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Fri, Oct 15, 2021 at 05:13:48PM -0700, Dan Williams wrote:
> > > On Fri, Oct 15, 2021 at 4:53 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > > >
> > > > If nd_integrity_init() fails we'd get del_gendisk() called,
> > > > but that's not correct as we should only call that if we're
> > > > done with device_add_disk(). Fix this by providing unwinding
> > > > prior to the devm call being registered and moving the devm
> > > > registration to the very end.
> > > >
> > > > This should fix calling del_gendisk() if nd_integrity_init()
> > > > fails. I only spotted this issue through code inspection. It
> > > > does not fix any real world bug.
> > > >
> > >
> > > Just fyi, I'm preparing patches to delete this driver completely as it
> > > is unused by any shipping platform. I hope to get that removal into
> > > v5.16.
> >
> > Curious if are you going to nuking it on v5.16? Otherwise it would stand
> > in the way of the last few patches to add __must_check for the final
> > add_disk() error handling changes.
> 
> True, I don't think I can get it nuked in time, so you can add my
> Reviewed-by for this one.

This patch required the previous patch in this series to also be
applied. Can I apply your Reviewed-by there too?

  Luis
