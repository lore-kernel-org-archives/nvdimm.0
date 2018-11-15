Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 15 Nov 2018 11:09:34 -0800
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
Message-ID: <20181115110919.46978343@silica.lan>
In-Reply-To: <20181115162008.GO3759@mtr-leonro.mtl.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
        <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
        <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
        <20181115061036.1575223d@silica.lan>
        <20181115162008.GO3759@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Dave Jiang <dave.jiang@intel.com>, ksummit-discuss@lists.linuxfoundation.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, vishal.l.verma@intel.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Em Thu, 15 Nov 2018 18:20:08 +0200
Leon Romanovsky <leon@kernel.org> escreveu:

> On Thu, Nov 15, 2018 at 06:10:36AM -0800, Mauro Carvalho Chehab wrote:
> > Em Thu, 15 Nov 2018 09:03:11 +0100
> > Geert Uytterhoeven <geert@linux-m68k.org> escreveu:
> >  
> > > Hi Dan,
> > >
> > > On Thu, Nov 15, 2018 at 6:06 AM Dan Williams <dan.j.williams@intel.com> wrote:  
> > > > Document the basic policies of the libnvdimm subsystem and provide a
> > > > first example of a Subsystem Profile for others to duplicate and edit.
> > > >
> > > > Cc: Ross Zwisler <zwisler@kernel.org>
> > > > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > > > Cc: Dave Jiang <dave.jiang@intel.com>
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>  
> > >
> > > Thanks for your patch!
> > >  
> > > > --- /dev/null
> > > > +++ b/Documentation/nvdimm/subsystem-profile.rst  
> > >  
> > > > +Trusted Reviewers
> > > > +-----------------
> > > > +Johannes Thumshirn
> > > > +Toshi Kani
> > > > +Jeff Moyer
> > > > +Robert Elliott  
> > >
> > > Don't you want to add email addresses?
> > > Only the first one is listed in MAINTAINERS.  
> >
> > IMO, it makes sense to have their e-mails here, in a way that it could
> > easily be parsed by get_maintainers.pl.  
> 
> I personally think that list of "trusted reviewers" makes more harm than
> good. It creates unneeded negative feelings to those who wanted to be in
> this list, but for any reason they don't. Those reviewers will feel
> "untrusted".

Yeah, perhaps something like "most active reviewers" would sound
better.

Cheers,
Mauro
