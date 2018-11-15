Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD0BD2119172C
 for <linux-nvdimm@lists.01.org>; Thu, 15 Nov 2018 06:10:53 -0800 (PST)
Date: Thu, 15 Nov 2018 06:10:36 -0800
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
Message-ID: <20181115061036.1575223d@silica.lan>
In-Reply-To: <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
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
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: ksummit-discuss@lists.linuxfoundation.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Em Thu, 15 Nov 2018 09:03:11 +0100
Geert Uytterhoeven <geert@linux-m68k.org> escreveu:

> Hi Dan,
> 
> On Thu, Nov 15, 2018 at 6:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > Document the basic policies of the libnvdimm subsystem and provide a
> > first example of a Subsystem Profile for others to duplicate and edit.
> >
> > Cc: Ross Zwisler <zwisler@kernel.org>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>  
> 
> Thanks for your patch!
> 
> > --- /dev/null
> > +++ b/Documentation/nvdimm/subsystem-profile.rst  
> 
> > +Trusted Reviewers
> > +-----------------
> > +Johannes Thumshirn
> > +Toshi Kani
> > +Jeff Moyer
> > +Robert Elliott  
> 
> Don't you want to add email addresses?
> Only the first one is listed in MAINTAINERS.

IMO, it makes sense to have their e-mails here, in a way that it could
easily be parsed by get_maintainers.pl.

That's said, IMO a given subsystem should either use the R: tag at
MAINTAINERS or have a list of reviewers or sub-maintainers here, as
maintaining duplicated information will be painful.

If we go to this path, we should probably document it at MAINTAINERS
file.

> 
> > +Time Zone / Office Hours
> > +------------------------
> > +8:00am to 5:00pm Pacific Time Zone  
> 
> UTC-???
> 
> People are not familiar with all time zones.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 




Cheers,
Mauro
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
