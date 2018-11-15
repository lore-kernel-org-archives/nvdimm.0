Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C2492118DC48
 for <linux-nvdimm@lists.01.org>; Wed, 14 Nov 2018 21:39:14 -0800 (PST)
Date: Wed, 14 Nov 2018 21:39:01 -0800
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [Ksummit-discuss] [RFC PATCH 1/3] MAINTAINERS: Reclaim the P:
 tag for Subsystem Profile
Message-ID: <20181114213901.75768212@silica.lan>
In-Reply-To: <154225759959.2499188.5163439674278041458.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225759959.2499188.5163439674278041458.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, ksummit-discuss@lists.linuxfoundation.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Em Wed, 14 Nov 2018 20:53:19 -0800
Dan Williams <dan.j.williams@intel.com> escreveu:

> Fixup some P: entries to be M: and rename the remaining ones to 'E:' for
> "entity". The P: tag will be used to indicate the location of a
> Subsystem Profile for a given MAINTAINERS entry.
> 
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  MAINTAINERS |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0abecc528dac..83b7b3943a12 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -76,7 +76,7 @@ trivial patch so apply some common sense.
>  
>  Descriptions of section entries:
>  
> -	P: Person (obsolete)
> +	E: Entity (obsolete)

I don't like very much the idea of renaming it, but that's just my 2 cents.

IMO, the best would be to replace them to a non-obsolete field on a patch
that would remove it, then another patch would re-add with a different
meaning.

On a quick look, I suspect we could get rid of all remaining entries.
See below.

>  	M: Mail patches to: FullName <address@domain>
>  	R: Designated reviewer: FullName <address@domain>
>  	   These reviewers should be CCed on patches.
> @@ -771,7 +771,7 @@ S:	Orphan
>  F:	drivers/usb/gadget/udc/amd5536udc.*
>  
>  AMD GEODE PROCESSOR/CHIPSET SUPPORT
> -P:	Andres Salomon <dilinger@queued.net>
> +M:	Andres Salomon <dilinger@queued.net>
>  L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
>  W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
>  S:	Supported
> @@ -9271,7 +9271,7 @@ F:	drivers/staging/media/tegra-vde/
>  
>  MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
>  M:	Mauro Carvalho Chehab <mchehab@kernel.org>

> -P:	LinuxTV.org Project
> +E:	LinuxTV.org Project

LinuxTV is not really an entity. Just a name for a community-maintained site
where we store data about it.

That's already a "W:" tag pointing for it, so I would just remove it.

If you decide to remove, feel free to add my ack:

	Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

>  L:	linux-media@vger.kernel.org
>  W:	https://linuxtv.org
>  Q:	http://patchwork.kernel.org/project/linux-media/list/
> @@ -12465,7 +12465,7 @@ S:	Maintained
>  F:	arch/mips/ralink
>  
>  RALINK RT2X00 WIRELESS LAN DRIVER
> -P:	rt2x00 project
> +E:	rt2x00 project

I suspect that the above info is not really useful, and it is probably just
a left-over from the past history. 

I suspect that, if removed, nobody will really miss it, as it is quite
obvious :-)

>  M:	Stanislaw Gruszka <sgruszka@redhat.com>
>  M:	Helmut Schaa <helmut.schaa@googlemail.com>
>  L:	linux-wireless@vger.kernel.org
> @@ -12764,7 +12764,7 @@ S:	Supported
>  F:	drivers/net/ethernet/rocker/
>  
>  ROCKETPORT DRIVER
> -P:	Comtrol Corp.
> +E:	Comtrol Corp.

There's already a W: field pointing to the company that maintains it.
So, IMHO this is simply duplicated stuff that can be removed.

>  W:	http://www.comtrol.com
>  S:	Maintained
>  F:	Documentation/serial/rocket.txt
> @@ -13577,15 +13577,15 @@ F:	drivers/video/fbdev/simplefb.c
>  F:	include/linux/platform_data/simplefb.h

>  SIMTEC EB110ATX (Chalice CATS)
> -P:	Ben Dooks
> -P:	Vincent Sanders <vince@simtec.co.uk>
> +E:	Ben Dooks
> +M:	Vincent Sanders <vince@simtec.co.uk>
>  M:	Simtec Linux Team <linux@simtec.co.uk>
>  W:	http://www.simtec.co.uk/products/EB110ATX/
>  S:	Supported
>  
>  SIMTEC EB2410ITX (BAST)
> -P:	Ben Dooks
> -P:	Vincent Sanders <vince@simtec.co.uk>
> +E:	Ben Dooks
> +M:	Vincent Sanders <vince@simtec.co.uk>
>  M:	Simtec Linux Team <linux@simtec.co.uk>
>  W:	http://www.simtec.co.uk/products/EB2410ITX/
>  S:	Supported

On the above two drivers, I've no idea why to keep it there. Ben Dooks
seems to be a past maintainer. He is already listed at CREDITS
for several things including Simtec.

So, I guess this information is duplicated/obsoleted and could just 
be removed.

Cheers,
Mauro
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
