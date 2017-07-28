Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C8A421E11D8E
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 10:46:29 -0700 (PDT)
Date: Fri, 28 Jul 2017 13:48:30 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [resend PATCH v2 11/33] dm: add dax_device and dax_operations
 support
Message-ID: <20170728174830.GA13772@redhat.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149245618859.10206.13182319600260215993.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1501258623.2413.3.camel@wdc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1501258623.2413.3.camel@wdc.com>
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
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 28 2017 at 12:17pm -0400,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Mon, 2017-04-17 at 12:09 -0700, Dan Williams wrote:
> > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> > index b7767da50c26..1de8372d9459 100644
> > --- a/drivers/md/Kconfig
> > +++ b/drivers/md/Kconfig
> > @@ -200,6 +200,7 @@ config BLK_DEV_DM_BUILTIN
> >  config BLK_DEV_DM
> >  	tristate "Device mapper support"
> >  	select BLK_DEV_DM_BUILTIN
> > +	select DAX
> >  	---help---
> >  	  Device-mapper is a low level volume manager.  It works by allowing
> >  	  people to specify mappings for ranges of logical sectors.  Various
> 
> (replying to an e-mail of three months ago)
> 
> Hello Dan,
> 
> While building a v4.12 kernel I noticed that enabling device mapper support
> now unconditionally enables DAX. I think there are plenty of systems that use
> dm but do not need DAX. Have you considered to rework this such that instead
> of dm selecting DAX that DAX support is only enabled in dm if CONFIG_DAX is
> enabled?

I haven't but patches to do so would be welcomed.

Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
