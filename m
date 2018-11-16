Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C99D421A07A92
 for <linux-nvdimm@lists.01.org>; Fri, 16 Nov 2018 11:21:01 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id u3so17218361ota.5
 for <linux-nvdimm@lists.01.org>; Fri, 16 Nov 2018 11:21:01 -0800 (PST)
MIME-Version: 1.0
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20181115063040.11eaef93@silica.lan>
In-Reply-To: <20181115063040.11eaef93@silica.lan>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Nov 2018 11:20:49 -0800
Message-ID: <CAPcyv4gySBHp=-xnwA7f10K2wDuqPAB2C8C=9uU0q_mXcnzxbw@mail.gmail.com>
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
To: mchehab+samsung@kernel.org
Cc: ksummit <ksummit-discuss@lists.linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 15, 2018 at 6:31 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Em Wed, 14 Nov 2018 20:53:30 -0800
> Dan Williams <dan.j.williams@intel.com> escreveu:
>
> > Document the basic policies of the libnvdimm subsystem and provide a
> > first example of a Subsystem Profile for others to duplicate and edit.
> >
> > Cc: Ross Zwisler <zwisler@kernel.org>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  Documentation/nvdimm/subsystem-profile.rst |   86 ++++++++++++++++++++++++++++
> >  MAINTAINERS                                |    4 +
> >  2 files changed, 90 insertions(+)
> >  create mode 100644 Documentation/nvdimm/subsystem-profile.rst
> >
> > diff --git a/Documentation/nvdimm/subsystem-profile.rst b/Documentation/nvdimm/subsystem-profile.rst
> > new file mode 100644
> > index 000000000000..d3428be7528e
> > --- /dev/null
> > +++ b/Documentation/nvdimm/subsystem-profile.rst
>
> Hmm... would it make sense to add a pointer at maintainer/index.rst (or to some
> other .rst file) for those profiles too?
>
> > @@ -0,0 +1,86 @@
> > +LIBNVDIMM Subsystem Profile
> > +===========================
> > +
> > +Overview
> > +--------
>
> A minor nitpick here: I would add a blank line after each topic/subtopic.
>
> On some cases, Sphinx will do wrong without that blank line, and having
> some places with that extra line and others without it sounds unbalanced
> on my eyes ;-)
>
> > +So, you have recently become a maintainer of the LIBNVDIMM subsystem,
> > +condolences, it is a thankless job, here is the lay of the land. The git
>
> My understanding that the main focus of this document is to help people to
> submit patches to the subsystem.
>
> With that in mind, I would never start the doc talking only to maintainers,
> as developers will likely just stop reading it at the above paragraph.

Yes, I see this is confusing now. I'll fix up the Subsystem Profile
description text to be written with maintainers as the audience and
clarify that the per-subsystem instance is written with contributors
as the audience.

>
> > +tree, git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/, is
> > +writable by all the individuals listed in LIBNVDIMM section of
> > +MAINTAINERS. Access is granted per the typical kernel.org account
> > +management policies. Two branches in that tree are regularly pulled into
> > +-next, libnvdimm-for-next, and libnvdimm-fixes. The submit rate of
> > +patches is low, usually enough for one person to handle. There is a
> > +patchwork instance at
> > +https://patchwork.kernel.org/project/linux-nvdimm/list/, and it
> > +historically is only used for ingesting patches and collecting
> > +ack/review tags, i.e. no expectation to update the patch state after it
> > +has been dispositioned, or merged.
> > +
> > +The most sensitive code area is the ACPI DSM (Device Specific Method)
> > +path. In addition to the general fragility of an ioctl() ABI the ACPI
> > +DSM scheme allows any vendor to implement any command without any prior
> > +review by the ACPI committee. For this reason the LIBNVDIMM system seeks
> > +to constrain the proliferation of vendor commands and at a minimum
> > +requires any command support to be publicly documented. Over time the
> > +submission rate of new vendor-specific commands is falling as more
> > +commands are defined with named methods in the official ACPI
> > +specification.
>
> As Jani pointed, all the above stuff is for maintainers, but several other
> stuff on this document are for developers. The best would likely to have
> two separate files.
>
> However, maintaining it on two separate files could be painful. Maybe
> we could have an specific section, at the end of the document, with
> maintainers-specific instructions.

Yes, good idea, will incorporate.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
