Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A108921D091A2
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 10:01:40 -0700 (PDT)
Date: Wed, 26 Jul 2017 10:03:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: FIle copy to FAT FS on NVDIMM hits BUG_ON at fs/buffer.c:3305!
Message-ID: <20170726170340.GA8576@infradead.org>
References: <1501018096.2042.70.camel@hpe.com>
 <20170725222247.GA26391@linux.intel.com>
 <20170726082159.GE4039@linux-x5ow.site> <87d18neemb.fsf@devron>
 <20170726142348.GA4130@linux.intel.com>
 <CAPcyv4j4ifRiS-J42p1DfOU0TjMYAyc1_==72+RPXvutyXxpMA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j4ifRiS-J42p1DfOU0TjMYAyc1_==72+RPXvutyXxpMA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 26, 2017 at 09:08:00AM -0700, Dan Williams wrote:
> Another question, does ->rw_page() really buy us that much with the
> pmem driver? If applications want to enjoy the lowest latency access
> they can just use DAX. There's now only 4 drivers that use rw_page
> since nvme dropped its usage and I'd be inclined to just rip it out.

nvme never supported rw_page (there was a page for it, but it
fortunately never got merged).

rw_page are massive pain the ass and the method should go away.
For make_request drivers that actually operate synchronous (e.g.
the ramdisk) it's not much of a benefit, and even for normally
asynchronous drivers like nvme the block layer polling interface
is much more suitable.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
