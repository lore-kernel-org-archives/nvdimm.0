Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2624A21A02937
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 12:55:57 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id y23so14018700oia.4
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 12:55:57 -0800 (PST)
MIME-Version: 1.0
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20181125105754.GB25471@amd>
In-Reply-To: <20181125105754.GB25471@amd>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 25 Nov 2018 12:55:45 -0800
Message-ID: <CAPcyv4jmTUJFUWL99OCxAofhD6=jfZk+SA02sceAaJ0Q9X_=jA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Maintainer Handbook: Subsystem Profile
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
To: Pavel Machek <pavel@ucw.cz>
Cc: ksummit <ksummit-discuss@lists.linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Daniel Vetter <daniel.vetter@ffwll.ch>, zwisler@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Olof Johansson <olof@lixom.net>, linux-nvdimm <linux-nvdimm@lists.01.org>, Greg KH <gregkh@linuxfoundation.org>, stfrench@microsoft.com, Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>, Mauro Carvalho Chehab <mchehab@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Nov 25, 2018 at 2:58 AM Pavel Machek <pavel@ucw.cz> wrote:
>
> On Wed 2018-11-14 20:53:13, Dan Williams wrote:
> > At a recently concluded session at the Linux Plumbers Conference I
> > proposed a "Subsystem Profile" as a document that a maintainer can
> > provide to set contributor expectations and provide fodder for a
> > discussion between maintainers about the merits of different maintainer
> > policies.
> >
> > For those that did not attend, the goal of the Subsystem Profile, and the
> > Maintainer Handbook more generally, is to provide a desk reference for
> > maintainers both new and experienced. The session introduction was:
> >
> >     The first rule of kernel maintenance is that there are no hard and
> >     fast rules. That state of affairs is both a blessing and a curse. It
> >     has served the community well to be adaptable to the different
> >     people and different problem spaces that inhabit the kernel
> >     community. However, that variability also leads to inconsistent
> >     experiences for contributors, little to no guidance for new
> >     contributors, and unnecessary stress on current maintainers. There
> >     are quite a few of people who have been around long enough to make
> >     enough mistakes that they have gained some hard earned proficiency.
> >     However if the kernel community expects to keep growing it needs to
> >     be able both scale the maintainers it has and ramp new ones without
> >     necessarily let them make a decades worth of mistakes to learn the
> >     ropes.
> >
> > To be clear, the proposed document does not impose or suggest new
> > rules. Instead it provides an outlet to document the unwritten rules
> > and policies in effect for each subsystem, and that each subsystem
> > might decide differently for whatever reason.
>
> Sounds like a new rules to me :-(, making submitting simple patches
> harder.

I'm missing how documenting how a subsystem generally handles patches
makes submitting simple patches harder?

> It would be good if the rules were similar / same accross the
> subsystems, documenting "it is okay to be different" is not really helpful.

It is not documenting "it is okay to be different", it is
acknowledging that processes are already different. The goals are to
allow comparing notes across subsystems with the hope of some
convergence down the road, provide a template for new maintainers to
copy rather than reinvent, and give submitters a resource to discover
subsystem local policy.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
