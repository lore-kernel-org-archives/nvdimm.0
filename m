Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C61D621DF967E
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 11:01:51 -0700 (PDT)
Date: Thu, 27 Jul 2017 12:03:55 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: FIle copy to FAT FS on NVDIMM hits BUG_ON at fs/buffer.c:3305!
Message-ID: <20170727180355.GB26633@linux.intel.com>
References: <1501018096.2042.70.camel@hpe.com>
 <20170725222247.GA26391@linux.intel.com>
 <20170726082159.GE4039@linux-x5ow.site> <87d18neemb.fsf@devron>
 <20170726171101.GA15980@bombadil.infradead.org>
 <1501171371.2042.83.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1501171371.2042.83.camel@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@infradead.org" <willy@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 27, 2017 at 04:12:18PM +0000, Kani, Toshimitsu wrote:
> On Wed, 2017-07-26 at 10:11 -0700, Matthew Wilcox wrote:
> > On Wed, Jul 26, 2017 at 06:23:08PM +0900, OGAWA Hirofumi wrote:
> > > The locking of this path seems to be broken. The guy familiar to
> > > bdev_write_page() path will made real fix though, The following
> > > patch should be explaining enough what is wrong.
> > > =

> > > In short, clean_buffers() must be called before unlocking
> > > lock_page().
> > =

> > Thanks for that.=A0=A0This should fix the problem while not leaking the
> > unlock_page call outside bdev_write_page.
> > =

> > --- 8< ---
> > =

> > Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> =

> Thanks Willy and Hirofumi for the quick fix!  I've tested the change,
> and it works fine.
> =

> Tested-by: Toshi Kani <toshi.kani@hpe.com>
> =

> Out of curiosity, I am still wondering about the following:=A0
>  - Why is this issue exposed with FAT FS, but not with other FSs?
>  - Why did I not see this issue with BTT?

I also didn't see it with FAT + BRD, so I think the answer to both of the
above is just that the timings were different.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
