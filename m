Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56BC221A07A92
 for <linux-nvdimm@lists.01.org>; Fri, 16 Nov 2018 15:44:57 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id z33so22872384otz.11
 for <linux-nvdimm@lists.01.org>; Fri, 16 Nov 2018 15:44:57 -0800 (PST)
MIME-Version: 1.0
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
 <20181115061036.1575223d@silica.lan>
 <20181115162008.GO3759@mtr-leonro.mtl.com>
 <CABVU7+twSz3OZx7PTO+bS-wfLfTTjZVhRAnhgtcs6KWwntattw@mail.gmail.com>
In-Reply-To: <CABVU7+twSz3OZx7PTO+bS-wfLfTTjZVhRAnhgtcs6KWwntattw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Nov 2018 15:44:45 -0800
Message-ID: <CAPcyv4hWK+to6vOSfSdeVMDzUutYwg9=XqshSDzaCf0c-u8jLA@mail.gmail.com>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
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
To: rodrigo.vivi@gmail.com
Cc: Leon Romanovsky <leon@kernel.org>, ksummit <ksummit-discuss@lists.linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org, mchehab+samsung@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 16, 2018 at 12:37 PM Rodrigo Vivi <rodrigo.vivi@gmail.com> wrote:
>
> On Thu, Nov 15, 2018 at 8:38 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Thu, Nov 15, 2018 at 06:10:36AM -0800, Mauro Carvalho Chehab wrote:
> > > Em Thu, 15 Nov 2018 09:03:11 +0100
> > > Geert Uytterhoeven <geert@linux-m68k.org> escreveu:
> > >
> > > > Hi Dan,
> > > >
> > > > On Thu, Nov 15, 2018 at 6:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > > > > Document the basic policies of the libnvdimm subsystem and provide a
> > > > > first example of a Subsystem Profile for others to duplicate and edit.
> > > > >
> > > > > Cc: Ross Zwisler <zwisler@kernel.org>
> > > > > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > > > > Cc: Dave Jiang <dave.jiang@intel.com>
> > > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > >
> > > > Thanks for your patch!
> > > >
> > > > > --- /dev/null
> > > > > +++ b/Documentation/nvdimm/subsystem-profile.rst
> > > >
> > > > > +Trusted Reviewers
> > > > > +-----------------
> > > > > +Johannes Thumshirn
> > > > > +Toshi Kani
> > > > > +Jeff Moyer
> > > > > +Robert Elliott
> > > >
> > > > Don't you want to add email addresses?
> > > > Only the first one is listed in MAINTAINERS.
> > >
> > > IMO, it makes sense to have their e-mails here, in a way that it could
> > > easily be parsed by get_maintainers.pl.
> >
> > I personally think that list of "trusted reviewers" makes more harm than
> > good. It creates unneeded negative feelings to those who wanted to be in
> > this list, but for any reason they don't. Those reviewers will feel
> > "untrusted".
>
> I'd like to +1 on this concern here. Besides leaving all the other
> people demotivated.

Yes, that's a valid concern, I overlooked that unfortunate interpretation.

>
> A small group of trusted reviewers doesn't scale. People will get overloaded.
> Or you won't be able to enforce that all patches need to get Reviews.
>
> Reviews should be coming from everywhere and commiters and maintainers
> deciding on what to trust or re-review.
>
> Also the list is hard to maintain and keep the lists updated.

I understand the concern, and as I saw feedback come in I realized
there were more people that I would add to that reviewer list for
libnvdimm.

Stepping back the end goal is to have an initial list of recommended
people to follow up with directly to seek a second opinion, or help in
cases where a contributor otherwise needs some direction / engagement
that they are not readily receiving from the maintainer. Typically
someone just lurks on the mailing list for a few weeks to get a feel
for who the usual suspects are in the subsystem, but for a new
contributor identifying those individuals may be difficult.

One of the contributing factors of lack of response to a patchset is
that they are sent with the implicit expectation that the maintainer
will get to eventually, and typically other people feel content to sit
back and watch. If instead a contributor sent a direct mail to a
"trusted reviewer" saying, "Hey, Alice, Bob seems busy can you help me
out?" that seems more likely to rope in additional review help.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
