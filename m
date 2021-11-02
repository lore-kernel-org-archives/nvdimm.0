Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3007068
	for <nvdimm@lists.linux.dev>; Tue,  2 Nov 2021 17:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3bBcvFcyfbMgkxTabHoDugt0QDDF2AsVik61xYhcvY8=; b=cU09DI26n/HuOfXSGqvnoYXccm
	btgFjQftFTj8uFw/bdPpySJs8e+7RKCufouvPj8a9PRomwNJZ3mL7eaNJtneuS1VWToYH1yLqjBv3
	m89b5NUiMX3cVF/rKxoTsV8LwGO8QEm/5XlTbBHx1DxbIwX0xAm8IdwOBHVoMxAqZi3cy2/MNriKS
	iDCYoYwhK8cO4awe/SWrQE/T8ddEIozAommDi/x5RAG4+JdgOojsx3aHaZEyweML/LrElyOIzTu2F
	95JZDncYEgYlEMqo7AMW2+I/jpyu82tBawT5t7eMueYiE+khoi9NEjHbk0Y0jwGwUSoFnlgMokg/R
	ig+ZPcrg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mhxCQ-002RP3-6N; Tue, 02 Nov 2021 17:03:50 +0000
Date: Tue, 2 Nov 2021 10:03:50 -0700
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
Subject: Re: [PATCH 03/13] nvdimm/btt: do not call del_gendisk() if not needed
Message-ID: <YYFvdiOYoqRPx8JE@bombadil.infradead.org>
References: <20211015235219.2191207-1-mcgrof@kernel.org>
 <20211015235219.2191207-4-mcgrof@kernel.org>
 <CAPcyv4gU0q=UhDhGoDjK1mwS8WNcWYUXgEb7Rd8Amqr1XFs6ow@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gU0q=UhDhGoDjK1mwS8WNcWYUXgEb7Rd8Amqr1XFs6ow@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Sun, Oct 31, 2021 at 10:47:22AM -0700, Dan Williams wrote:
> On Fri, Oct 15, 2021 at 4:53 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > We know we don't need del_gendisk() if we haven't added
> > the disk, so just skip it. This should fix a bug on older
> > kernels, as del_gendisk() became able to deal with
> > disks not added only recently, after the patch titled
> > "block: add flag for add_disk() completion notation".
> 
> Perhaps put this in:
> 
>     commit $abbrev_commit ("block: add flag for add_disk() completion notation")
> 
> ...format, but I can't seem to find that commit?

Indeed, that patch got dropped and it would seem Christoph preferred
a simpler approach with the new disk_live()

commit 40b3a52ffc5bc3b5427d5d35b035cfb19d03fdd6
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Aug 18 16:45:32 2021 +0200

    block: add a sanity check for a live disk in del_gendisk

> If you're touching the changelog how about one that clarifies the
> impact and drops "we"?
> "del_gendisk() is not required if the disk has not been added. On
> kernels prior to commit $abbrev_commit ("block: add flag for
> add_disk() completion notation")
> it is mandatory to not call del_gendisk() if the underlying device has
> not been through device_add()."
> 
> Fixes: 41cd8b70c37a ("libnvdimm, btt: add support for blk integrity")
> 
> With that you can add:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

You got it.

  Luis
