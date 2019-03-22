Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D6A9211E82F1
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 15:56:42 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] nvdimm: btt_devs: fix a NULL pointer dereference and a
 memory leak
Date: Fri, 22 Mar 2019 22:56:40 +0000
Message-ID: <4377c210798b000d60ebdc5150e015737d05565b.camel@intel.com>
References: <20190312081529.4889-1-kjlu@umn.edu>
 <eea1b50fe8c76d45fef0aaca1878c30fa8f2cbde.camel@intel.com>
In-Reply-To: <eea1b50fe8c76d45fef0aaca1878c30fa8f2cbde.camel@intel.com>
Content-Language: en-US
Content-ID: <9DA9F31267ADB746A1202655693A23A7@intel.com>
MIME-Version: 1.0
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
To: "kjlu@umn.edu" <kjlu@umn.edu>
Cc: "zwisler@kernel.org" <zwisler@kernel.org>, "pakki001@umn.edu" <pakki001@umn.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2019-03-22 at 22:49 +0000, Verma, Vishal L wrote:
> On Tue, 2019-03-12 at 03:15 -0500, Kangjie Lu wrote:
> > In case kmemdup fails, the fix releases resources and returns to
> > avoid the NULL pointer dereference.
> > Also, the error paths in the following code should release
> > resources to avoid memory leaks.
> > 
> > Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> > ---
> >  drivers/nvdimm/btt_devs.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> 
> Looks good,
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

Looking again, there is another kmemdup() call in __nd_btt_probe which
is lacking error checking.
And referring to your other related patch to namespace_devs, that has
/several/ instances of the same thing.

Instead of fixing just a couple of these, it might be worthwhile to send
a wider cleanup patch to catch all of these, at least within
drivers/nvdimm/ for starters, instead of a select few.

> 
> > diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> > index 795ad4ff35ca..565ea0b6f765 100644
> > --- a/drivers/nvdimm/btt_devs.c
> > +++ b/drivers/nvdimm/btt_devs.c
> > @@ -196,8 +196,13 @@ static struct device *__nd_btt_create(struct
> > nd_region *nd_region,
> >  	}
> >  
> >  	nd_btt->lbasize = lbasize;
> > -	if (uuid)
> > +	if (uuid) {
> >  		uuid = kmemdup(uuid, 16, GFP_KERNEL);
> > +		if (!uuid) {
> > +			kfree(nd_btt);
> > +			return NULL;
> > +		}
> > +	}
> >  	nd_btt->uuid = uuid;
> >  	dev = &nd_btt->dev;
> >  	dev_set_name(dev, "btt%d.%d", nd_region->id, nd_btt->id);
> > @@ -209,6 +214,7 @@ static struct device *__nd_btt_create(struct
> > nd_region *nd_region,
> >  		dev_dbg(&ndns->dev, "failed, already claimed by %s\n",
> >  				dev_name(ndns->claim));
> >  		put_device(dev);
> > +		kfree(uuid);
> >  		return NULL;
> >  	}
> >  	return dev;
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
