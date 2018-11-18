Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from casper.infradead.org (casper.infradead.org
 [IPv6:2001:8b0:10b:1236::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ABFBA2118B7B2
 for <linux-nvdimm@lists.01.org>; Sun, 18 Nov 2018 05:11:41 -0800 (PST)
Date: Sun, 18 Nov 2018 11:11:29 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
Message-ID: <20181118111119.0ae5f374@coco.lan>
In-Reply-To: <87va4wczc5.fsf@notabene.neil.brown.name>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
 <20181115061036.1575223d@silica.lan>
 <20181115162008.GO3759@mtr-leonro.mtl.com>
 <CABVU7+twSz3OZx7PTO+bS-wfLfTTjZVhRAnhgtcs6KWwntattw@mail.gmail.com>
 <CAPcyv4hWK+to6vOSfSdeVMDzUutYwg9=XqshSDzaCf0c-u8jLA@mail.gmail.com>
 <87va4wczc5.fsf@notabene.neil.brown.name>
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
To: NeilBrown <neilb@suse.com>
Cc: Leon Romanovsky <leon@kernel.org>, ksummit <ksummit-discuss@lists.linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org, rodrigo.vivi@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

Em Sat, 17 Nov 2018 11:38:50 +1100
NeilBrown <neilb@suse.com> escreveu:

> On Fri, Nov 16 2018, Dan Williams wrote:
> 
> > On Fri, Nov 16, 2018 at 12:37 PM Rodrigo Vivi <rodrigo.vivi@gmail.com> wrote:  
> >>
> >> On Thu, Nov 15, 2018 at 8:38 AM Leon Romanovsky <leon@kernel.org> wrote:  
> >> >
> >> > On Thu, Nov 15, 2018 at 06:10:36AM -0800, Mauro Carvalho Chehab wrote:  
> >> > > Em Thu, 15 Nov 2018 09:03:11 +0100
> >> > > Geert Uytterhoeven <geert@linux-m68k.org> escreveu:
> >> > >  
> >> > > > Hi Dan,
> >> > > >
> >> > > > On Thu, Nov 15, 2018 at 6:06 AM Dan Williams <dan.j.williams@intel.com> wrote:  
> >> > > > > Document the basic policies of the libnvdimm subsystem and provide a
> >> > > > > first example of a Subsystem Profile for others to duplicate and edit.
> >> > > > >
> >> > > > > Cc: Ross Zwisler <zwisler@kernel.org>
> >> > > > > Cc: Vishal Verma <vishal.l.verma@intel.com>
> >> > > > > Cc: Dave Jiang <dave.jiang@intel.com>
> >> > > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>  
> >> > > >
> >> > > > Thanks for your patch!
> >> > > >  
> >> > > > > --- /dev/null
> >> > > > > +++ b/Documentation/nvdimm/subsystem-profile.rst  
> >> > > >  
> >> > > > > +Trusted Reviewers
> >> > > > > +-----------------
> >> > > > > +Johannes Thumshirn
> >> > > > > +Toshi Kani
> >> > > > > +Jeff Moyer
> >> > > > > +Robert Elliott  
> >> > > >
> >> > > > Don't you want to add email addresses?
> >> > > > Only the first one is listed in MAINTAINERS.  
> >> > >
> >> > > IMO, it makes sense to have their e-mails here, in a way that it could
> >> > > easily be parsed by get_maintainers.pl.  
> >> >
> >> > I personally think that list of "trusted reviewers" makes more harm than
> >> > good. It creates unneeded negative feelings to those who wanted to be in
> >> > this list, but for any reason they don't. Those reviewers will feel
> >> > "untrusted".  
> >>
> >> I'd like to +1 on this concern here. Besides leaving all the other
> >> people demotivated.  
> >
> > Yes, that's a valid concern, I overlooked that unfortunate interpretation.
> >  
> >>
> >> A small group of trusted reviewers doesn't scale. People will get overloaded.
> >> Or you won't be able to enforce that all patches need to get Reviews.
> >>
> >> Reviews should be coming from everywhere and commiters and maintainers
> >> deciding on what to trust or re-review.
> >>
> >> Also the list is hard to maintain and keep the lists updated.  
> >
> > I understand the concern, and as I saw feedback come in I realized
> > there were more people that I would add to that reviewer list for
> > libnvdimm.
> >
> > Stepping back the end goal is to have an initial list of recommended
> > people to follow up with directly to seek a second opinion, or help in
> > cases where a contributor otherwise needs some direction / engagement
> > that they are not readily receiving from the maintainer. Typically
> > someone just lurks on the mailing list for a few weeks to get a feel
> > for who the usual suspects are in the subsystem, but for a new
> > contributor identifying those individuals may be difficult.
> >
> > One of the contributing factors of lack of response to a patchset is
> > that they are sent with the implicit expectation that the maintainer
> > will get to eventually, and typically other people feel content to sit
> > back and watch. If instead a contributor sent a direct mail to a
> > "trusted reviewer" saying, "Hey, Alice, Bob seems busy can you help me
> > out?" that seems more likely to rope in additional review help.  
> 
> In here is, I think, a real issue that listing "trusted reviewers" might
> help address.
> As you say, people don't feel the need to comment - particularly if they
> don't see anything wrong (often best to insert a bug to encourage
> responses!).
> Maybe if we list people, it will make them feel that their opinion is
> valuable (trusted!) and that will encourage them to Ack or Review a
> patch.
> I have found that being given a title of responsibility can change my
> thinking from "someone should" to "I should".

I heard a similar feedback from some subsystems: giving someone a 
formal credit may actually help to get more reviews.

However, as Leon pointed later in this tread:

Em Sun, 18 Nov 2018 09:12:54 +0200
Leon Romanovsky <leon@kernel.org> escreveu:

> On Fri, Nov 16, 2018 at 03:39:47AM -0800, Mauro Carvalho Chehab wrote:
> > Em Thu, 15 Nov 2018 11:43:51 -0800
> > Joe Perches <joe@perches.com> escreveu:
> >  
> > > On Thu, 2018-11-15 at 19:40 +0000, Luck, Tony wrote:  
> > > > > I would recommend to remove this section at all.
> > > > > New maintainers won't come out of blue, but will be come
> > > > > from existing community and such individuals for sure will see
> > > > > and judge by themselves to whom they trust and to whom not.  
> > > >
> > > > Perhaps this is more of a hint to contributors than to maintainers
> > > > (see earlier discussion on who is the target audience for these documents).
> > > >
> > > > It would help contributors know some names of useful reviewers (and
> > > > thus this list should be picked up by scripts/get_maintainer.pl to help
> > > > the user compose Cc: lists for e-mail patches).  
> > >
> > > Trusted reviewers should be specifically listed
> > > in the MAINTAINERS file with an "R:" entry.
> > >
> > > get_maintainers should not look anywhere else.  
> >
> > I know that making get_maintainers to look elsewhere can make it more
> > complex and slower, but IMHO, by having a per-subsystem profile, this is
> > unavoidable.
> >
> > The thing is that touching at a single MAINTAINERS file every time a new
> > reviewer comes is painful. Also, MAINTAINERS file format doesn't allow
> > adding free text explaining the criteria for someone to become a
> > reviewer.  
> 
> You are pointing to the actual problem -> someone needs to maintain such
> lists, Removal of persons from that list won't be easy task too.

While adding new reviewers is easy (someone just need to send a patch,
with the Acked-by from the reviewer to be included), getting someone 
removed from it can be very painful (and will likely require some written
policy about how to do that).

Thanks,
Mauro
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
