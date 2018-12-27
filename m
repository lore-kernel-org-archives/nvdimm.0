Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22D3C2119EF4D
 for <linux-nvdimm@lists.01.org>; Thu, 27 Dec 2018 10:07:52 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id x202so15631238oif.13
 for <linux-nvdimm@lists.01.org>; Thu, 27 Dec 2018 10:07:52 -0800 (PST)
MIME-Version: 1.0
References: <154559137045.4076221.14167624874916967075.stgit@dwillia2-desk3.amr.corp.intel.com>
 <54d64ba8d45781e9e072929d52c270cfdd43f9be.camel@intel.com>
In-Reply-To: <54d64ba8d45781e9e072929d52c270cfdd43f9be.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Dec 2018 10:07:40 -0800
Message-ID: <CAPcyv4gi59rNT6Bq=CrJyM_qor5rYs2vrcS9zBvDiPi37KCTPA@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl/monitor: Drop 'struct ndctl_ctx *' casts
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 26, 2018 at 4:03 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Sun, 2018-12-23 at 10:56 -0800, Dan Williams wrote:
> > Functions that take a 'struct ndctl_ctx *' are fine to take the 'void *'
> > argument representing a library context that is passed to all commands.
> > However, the shared logging macros need a defined type to dereference
> > and retrieve the log_ctx. Introduce _gen_ctx to generically represent
> > 'struct ndctl_ctx *' and 'struct daxctl_ctx *' to the log helpers, and
> > drop the remaining casts in ndctl/monitor.c. Add a couple BUILD_BUG_ON()
> > statements to backup the log_ctx expectations.
> >
> > Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  daxctl/lib/libdaxctl.c |    4 ++++
> >  ndctl/lib/libndctl.c   |    4 ++++
> >  ndctl/monitor.c        |   22 +++++++++++-----------
> >  util/log.h             |   16 ++++++++++++----
> >  4 files changed, 31 insertions(+), 15 deletions(-)
> >
>
> <..>
>
> > diff --git a/util/log.h b/util/log.h
> > index 495e0d33c7f5..881971522690 100644
> > --- a/util/log.h
> > +++ b/util/log.h
> > @@ -56,10 +56,18 @@ do { \
> >  #  define log_notice(ctx, arg...) log_null(ctx, ## arg)
> >  #endif
> >
> > -#define dbg(x, arg...) log_dbg(&(x)->ctx, ## arg)
> > -#define info(x, arg...) log_info(&(x)->ctx, ## arg)
> > -#define err(x, arg...) log_err(&(x)->ctx, ## arg)
> > -#define notice(x, arg...) log_notice(&(x)->ctx, ## arg)
> > +struct _gen_ctx {
> > +     /*
> > +      * Requires ndctl_ctx and daxctl_ctx keep their log_ctx as their
> > +      * first element
> > +      */
> > +     struct log_ctx ctx;
> > +};
> > +
> > +#define dbg(x, arg...) log_dbg(&((struct _gen_ctx *)(x))->ctx, ## arg)
> > +#define info(x, arg...) log_info(&((struct _gen_ctx *)(x))->ctx, ## arg)
> > +#define err(x, arg...) log_err(&((struct _gen_ctx *)(x))->ctx, ## arg)
> > +#define notice(x, arg...) log_notice(&((struct _gen_ctx *)(x))->ctx, ## arg)
>
> Looks like this breaks ndctl/check.c's (ab)use of log_ctx directly,
> causing a segfault when this is called.

Whoops.

> I'm guessing this should be
> fixed by passing the actual ndctl_ctx to the check function, and letting
> the logging helpers dereference it correctly.
>
> It is also fixed if I move log_ctx to be the first member of btt_chk.
>
> Any thoughts on whether we should allow the embedding of log_ctx like
> this?

Yeah, I think we should, it's useful.

I'll just cook up a patch to convert the command harness to be
typesafe and drop this "offset-0" trickery.

> Other than that the patch looks good to me.

Good catch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
