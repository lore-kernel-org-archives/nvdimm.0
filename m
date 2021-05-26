Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAB52F80
	for <nvdimm@lists.linux.dev>; Wed, 26 May 2021 04:49:49 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3ADA76736F; Wed, 26 May 2021 06:49:44 +0200 (CEST)
Date: Wed, 26 May 2021 06:49:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com,
	linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
	drbd-dev@lists.linbit.com,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-mmc <linux-mmc@vger.kernel.org>, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: simplify gendisk and request_queue allocation for bio based
 drivers
Message-ID: <20210526044943.GA28551@lst.de>
References: <20210521055116.1053587-1-hch@lst.de> <CAPDyKFpqdSYeA+Zg=9Ewi46CmSWNpXQbju6HQo7aviCcRzyAAg@mail.gmail.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFpqdSYeA+Zg=9Ewi46CmSWNpXQbju6HQo7aviCcRzyAAg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 26, 2021 at 12:41:37AM +0200, Ulf Hansson wrote:
> On Fri, 21 May 2021 at 07:51, Christoph Hellwig <hch@lst.de> wrote:
> >
> > Hi all,
> >
> > this series is the first part of cleaning up lifetimes and allocation of
> > the gendisk and request_queue structure.  It adds a new interface to
> > allocate the disk and queue together for bio based drivers, and a helper
> > for cleanup/free them when a driver is unloaded or a device is removed.
> 
> May I ask what else you have in the pipe for the next steps?
> 
> The reason why I ask is that I am looking into some issues related to
> lifecycle problems of gendisk/mmc, typically triggered at SD/MMC card
> removal.

In the short run not much more than superficial cleanups.  Eventually
I want bio based drivers to not require a separate request_queue, leaving
that purely as a data structure for blk-mq based drivers.  But it will
take a while until we get there, so it should not block any fixes.

For hot unplug handling it might be worth to take a look at nvme, as it
is tested a lot for that case.
