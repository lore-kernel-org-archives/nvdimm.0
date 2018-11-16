Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 054D22118F356
 for <linux-nvdimm@lists.01.org>; Fri, 16 Nov 2018 04:00:55 -0800 (PST)
Date: Fri, 16 Nov 2018 13:00:53 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
Message-ID: <20181116120053.GD24157@quack2.suse.cz>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
 <20181115061036.1575223d@silica.lan>
 <20181115162008.GO3759@mtr-leonro.mtl.com>
 <20181115110919.46978343@silica.lan>
 <20181115193520.GA24359@mtr-leonro.mtl.com>
 <20181116033258.23992cde@silica.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181116033258.23992cde@silica.lan>
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
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>, ksummit-discuss@lists.linuxfoundation.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri 16-11-18 03:33:17, Mauro Carvalho Chehab wrote:
> Em Thu, 15 Nov 2018 21:35:20 +0200
> Leon Romanovsky <leon@kernel.org> escreveu:
> 
> > On Thu, Nov 15, 2018 at 11:09:34AM -0800, Mauro Carvalho Chehab wrote:
> > > Em Thu, 15 Nov 2018 18:20:08 +0200
> > > Leon Romanovsky <leon@kernel.org> escreveu:
> > >  
> > > > On Thu, Nov 15, 2018 at 06:10:36AM -0800, Mauro Carvalho Chehab wrote:  
> > > > > Em Thu, 15 Nov 2018 09:03:11 +0100
> > > > > Geert Uytterhoeven <geert@linux-m68k.org> escreveu:
> > > > >  
> > > > > > Hi Dan,
> > > > > >
> > > > > > On Thu, Nov 15, 2018 at 6:06 AM Dan Williams <dan.j.williams@intel.com> wrote:  
> > > > > > > Document the basic policies of the libnvdimm subsystem and provide a
> > > > > > > first example of a Subsystem Profile for others to duplicate and edit.
> > > > > > >
> > > > > > > Cc: Ross Zwisler <zwisler@kernel.org>
> > > > > > > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > > > > > > Cc: Dave Jiang <dave.jiang@intel.com>
> > > > > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>  
> > > > > >
> > > > > > Thanks for your patch!
> > > > > >  
> > > > > > > --- /dev/null
> > > > > > > +++ b/Documentation/nvdimm/subsystem-profile.rst  
> > > > > >  
> > > > > > > +Trusted Reviewers
> > > > > > > +-----------------
> > > > > > > +Johannes Thumshirn
> > > > > > > +Toshi Kani
> > > > > > > +Jeff Moyer
> > > > > > > +Robert Elliott  
> > > > > >
> > > > > > Don't you want to add email addresses?
> > > > > > Only the first one is listed in MAINTAINERS.  
> > > > >
> > > > > IMO, it makes sense to have their e-mails here, in a way that it could
> > > > > easily be parsed by get_maintainers.pl.  
> > > >
> > > > I personally think that list of "trusted reviewers" makes more harm than
> > > > good. It creates unneeded negative feelings to those who wanted to be in
> > > > this list, but for any reason they don't. Those reviewers will feel
> > > > "untrusted".  
> > >
> > > Yeah, perhaps something like "most active reviewers" would sound
> > > better.  
> > 
> > I would recommend to remove this section at all.
> > New maintainers won't come out of blue, but will be come
> > from existing community and such individuals for sure will see
> > and judge by themselves to whom they trust and to whom not.
> 
> I see your point, but, on the other hand, having a list with the ones
> that are actively doing reviews helps newcomers.

How exactly? Do you expect people to CC patches to these directly? And if
yes, why is not picking patches from the mailing list good enough?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
