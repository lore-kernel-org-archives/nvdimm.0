Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com
 [IPv6:2607:f8b0:4864:20::444])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE5EF20212CBF
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 13:27:32 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b24so525256pfp.1
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 13:25:33 -0700 (PDT)
Date: Wed, 28 Aug 2019 13:25:31 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] libnvdimm, region: Use struct_size() in kzalloc()
Message-ID: <201908281325.1E7C2A9@keescook>
References: <20190610210613.GA21989@embeddedor>
 <3abfb317-76cc-f9a0-243f-9b493a524a98@embeddedor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3abfb317-76cc-f9a0-243f-9b493a524a98@embeddedor.com>
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
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 28, 2019 at 01:30:24PM -0500, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping:
> 
> Who can take this, please?
> 
> Thanks
> --
> Gustavo
> 
> On 6/10/19 4:06 PM, Gustavo A. R. Silva wrote:
> > One of the more common cases of allocation size calculations is finding
> > the size of a structure that has a zero-sized array at the end, along
> > with memory for some number of elements for that array. For example:
> > 
> > struct nd_region {
> > 	...
> >         struct nd_mapping mapping[0];
> > };
> > 
> > instance = kzalloc(sizeof(struct nd_region) + sizeof(struct nd_mapping) *
> >                           count, GFP_KERNEL);
> > 
> > Instead of leaving these open-coded and prone to type mistakes, we can
> > now use the new struct_size() helper:
> > 
> > instance = kzalloc(struct_size(instance, mapping, count), GFP_KERNEL);
> > 
> > This code was detected with the help of Coccinelle.
> > 
> > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

FWIW,

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> > ---
> >  drivers/nvdimm/region_devs.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> > index b4ef7d9ff22e..88becc87e234 100644
> > --- a/drivers/nvdimm/region_devs.c
> > +++ b/drivers/nvdimm/region_devs.c
> > @@ -1027,10 +1027,9 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
> >  		}
> >  		region_buf = ndbr;
> >  	} else {
> > -		nd_region = kzalloc(sizeof(struct nd_region)
> > -				+ sizeof(struct nd_mapping)
> > -				* ndr_desc->num_mappings,
> > -				GFP_KERNEL);
> > +		nd_region = kzalloc(struct_size(nd_region, mapping,
> > +						ndr_desc->num_mappings),
> > +				    GFP_KERNEL);
> >  		region_buf = nd_region;
> >  	}
> >  
> > 

-- 
Kees Cook


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
