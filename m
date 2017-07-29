Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBD7221E1DB3B
 for <linux-nvdimm@lists.01.org>; Sat, 29 Jul 2017 14:22:03 -0700 (PDT)
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [resend PATCH v2 11/33] dm: add dax_device and dax_operations
 support
Date: Sat, 29 Jul 2017 21:24:07 +0000
Message-ID: <1501363445.3005.1.camel@wdc.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149245618859.10206.13182319600260215993.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1501258623.2413.3.camel@wdc.com>
 <CAPcyv4hc9zBHYtXrzS1XP514dMPcjBxjaSwRnPD8zUig1kCKnA@mail.gmail.com>
In-Reply-To: <CAPcyv4hc9zBHYtXrzS1XP514dMPcjBxjaSwRnPD8zUig1kCKnA@mail.gmail.com>
Content-Language: en-US
Content-ID: <075CB57016976D449B7B56C037AF491A@namprd04.prod.outlook.com>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, 2017-07-29 at 12:57 -0700, Dan Williams wrote:
> On Fri, Jul 28, 2017 at 9:17 AM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > On Mon, 2017-04-17 at 12:09 -0700, Dan Williams wrote:
> > > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> > > index b7767da50c26..1de8372d9459 100644
> > > --- a/drivers/md/Kconfig
> > > +++ b/drivers/md/Kconfig
> > > @@ -200,6 +200,7 @@ config BLK_DEV_DM_BUILTIN
> > >  config BLK_DEV_DM
> > >       tristate "Device mapper support"
> > >       select BLK_DEV_DM_BUILTIN
> > > +     select DAX
> > >       ---help---
> > >         Device-mapper is a low level volume manager.  It works by allowing
> > >         people to specify mappings for ranges of logical sectors.  Various
> > 
> > (replying to an e-mail of three months ago)
> > 
> > Hello Dan,
> > 
> > While building a v4.12 kernel I noticed that enabling device mapper support
> > now unconditionally enables DAX. I think there are plenty of systems that use
> > dm but do not need DAX. Have you considered to rework this such that instead
> > of dm selecting DAX that DAX support is only enabled in dm if CONFIG_DAX is
> > enabled?
> 
> I'd rather flip this around and add a CONFIG_DM_DAX that gates whether
> DM enables / links to the DAX core. I'll take a look at a patch.

Thanks! Please also consider to move all DAX-related dm code into a separate
source file such that the number of #ifdef CONFIG_DM_DAX statements can be
kept to an absolute minimum.

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
