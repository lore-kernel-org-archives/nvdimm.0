Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 864B021B06E91
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 13:49:20 -0700 (PDT)
Date: Tue, 25 Jul 2017 16:51:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] dm,dax: Make sure dm_dax_flush() is called if device
 supports it
Message-ID: <20170725205117.GB20979@redhat.com>
References: <20170725194337.GA20979@redhat.com>
 <CAPcyv4gqyOjBTFDbXbSYqxPQzY2cAjA6=zi6+51cN=Hae7eDJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gqyOjBTFDbXbSYqxPQzY2cAjA6=zi6+51cN=Hae7eDJQ@mail.gmail.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 25, 2017 at 01:43:27PM -0700, Dan Williams wrote:
> On Tue, Jul 25, 2017 at 12:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Right now, dm_dax_flush() is not being called and I think it is not being
> > called becuase DAXDEV_WRITE_CACHE is not set on dm dax device.
> >
> > If underlying dax device supports write cache, set DAXDEV_WRITE_CACHE on
> > dm dax device. This will get dm_dax_flush() being called.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  drivers/dax/super.c   |  5 +++++
> >  drivers/md/dm-table.c | 33 +++++++++++++++++++++++++++++++++
> >  include/linux/dax.h   |  1 +
> >  3 files changed, 39 insertions(+)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index ce9e563e6e1d..5c5e7b9f6831 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -278,6 +278,11 @@ void dax_write_cache(struct dax_device *dax_dev, bool wc)
> >  }
> >  EXPORT_SYMBOL_GPL(dax_write_cache);
> >
> > +bool dax_write_cache_enabled(struct dax_device *dax_dev)
> > +{
> > +       return test_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> > +}
> 
> We need :
> 
>     EXPORT_SYMBOL_GPL(dax_write_cache_enabled)
> 
> ...but other than that, looks good to me.

Aha, missed that. Will fix in next version.

Vivek
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
