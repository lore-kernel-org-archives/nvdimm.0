Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtprelay.hostedemail.com (smtprelay0090.hostedemail.com
 [216.40.44.90])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D3C0921184ACA
 for <linux-nvdimm@lists.01.org>; Thu, 15 Nov 2018 12:12:28 -0800 (PST)
Message-ID: <4a97926d76be9382051f438c4254cb534105c48b.camel@perches.com>
Subject: Re: [Ksummit-discuss] [RFC PATCH 1/3] MAINTAINERS: Reclaim the P:
 tag for Subsystem Profile
From: Joe Perches <joe@perches.com>
Date: Thu, 15 Nov 2018 12:12:24 -0800
In-Reply-To: <20181114213901.75768212@silica.lan>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225759959.2499188.5163439674278041458.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20181114213901.75768212@silica.lan>
Mime-Version: 1.0
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
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, ksummit-discuss@lists.linuxfoundation.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2018-11-14 at 21:39 -0800, Mauro Carvalho Chehab wrote:
> Em Wed, 14 Nov 2018 20:53:19 -0800
> Dan Williams <dan.j.williams@intel.com> escreveu:
> 
> > Fixup some P: entries to be M: and rename the remaining ones to 'E:' for
> > "entity". The P: tag will be used to indicate the location of a
> > Subsystem Profile for a given MAINTAINERS entry.
> > 
> > Cc: Joe Perches <joe@perches.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  MAINTAINERS |   18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 0abecc528dac..83b7b3943a12 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -76,7 +76,7 @@ trivial patch so apply some common sense.
> >  
> >  Descriptions of section entries:
> >  
> > -	P: Person (obsolete)
> > +	E: Entity (obsolete)
> 
> I don't like very much the idea of renaming it, but that's just my 2 cents.

I'd prefer just removing all the "P:" entries.

[]
> > @@ -13577,15 +13577,15 @@ F:	drivers/video/fbdev/simplefb.c
> >  F:	include/linux/platform_data/simplefb.h
> >  SIMTEC EB110ATX (Chalice CATS)
> > -P:	Ben Dooks
> > -P:	Vincent Sanders <vince@simtec.co.uk>
> > +E:	Ben Dooks
> > +M:	Vincent Sanders <vince@simtec.co.uk>
> >  M:	Simtec Linux Team <linux@simtec.co.uk>
> >  W:	http://www.simtec.co.uk/products/EB110ATX/
> >  S:	Supported

This is an ancient StrongARM based board that is shown as
discontinued on Simtec's website.
This is very obsolete and it's probably better to remove it.

> >  SIMTEC EB2410ITX (BAST)
> > -P:	Ben Dooks
> > -P:	Vincent Sanders <vince@simtec.co.uk>
> > +E:	Ben Dooks
> > +M:	Vincent Sanders <vince@simtec.co.uk>
> >  M:	Simtec Linux Team <linux@simtec.co.uk>
> >  W:	http://www.simtec.co.uk/products/EB2410ITX/
> >  S:	Supported
[]
> So, I guess this information is duplicated/obsoleted and could just 
> be removed.

This one is still listed as a production board on Simtec's website.
http://www.simtec.co.uk/products/EB2410ITX/

But I expect these 2410 boards aren't sold in any volume.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
