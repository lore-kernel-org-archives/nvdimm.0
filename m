Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 684932118B649
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 08:31:01 -0700 (PDT)
Date: Wed, 6 Jun 2018 09:30:59 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 3/3] libnvdimm: don't flush power-fail protected CPU
 caches
Message-ID: <20180606153059.GA30568@linux.intel.com>
References: <20180605235802.14531-1-ross.zwisler@linux.intel.com>
 <20180605235802.14531-3-ross.zwisler@linux.intel.com>
 <CAPcyv4gs-EMxQhX6dNYnygav1RfaLOuuA0XwYVHv-eSirjw6jA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gs-EMxQhX6dNYnygav1RfaLOuuA0XwYVHv-eSirjw6jA@mail.gmail.com>
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
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 05, 2018 at 07:00:14PM -0700, Dan Williams wrote:
> On Tue, Jun 5, 2018 at 4:58 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > This commit:
> >
> > 5fdf8e5ba566 ("libnvdimm: re-enable deep flush for pmem devices via fsync()")
> >
> > intended to make sure that deep flush was always available even on
> > platforms which support a power-fail protected CPU cache.  An unintended
> > side effect of this change was that we also lost the ability to skip
> > flushing CPU caches on those power-fail protected CPU cache.
> >
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Fixes: 5fdf8e5ba566 ("libnvdimm: re-enable deep flush for pmem devices via fsync()")
> > ---
> >  drivers/dax/super.c   | 14 +++++++++++++-
> >  drivers/nvdimm/pmem.c |  2 ++
> >  include/linux/dax.h   |  4 ++++
> >  3 files changed, 19 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index c2c46f96b18c..80253c531a9b 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -152,6 +152,8 @@ enum dax_device_flags {
> >         DAXDEV_ALIVE,
> >         /* gate whether dax_flush() calls the low level flush routine */
> >         DAXDEV_WRITE_CACHE,
> > +       /* only flush the CPU caches if they are not power fail protected */
> > +       DAXDEV_FLUSH_ON_SYNC,
> 
> I'm not grokking why we need DAXDEV_FLUSH_ON_SYNC. The power fail
> protected status of the cache only determines the default for
> DAXDEV_WRITE_CACHE.

Ah, yea, that's much cleaner.  I'll send out a v3.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
