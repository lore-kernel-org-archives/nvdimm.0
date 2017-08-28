Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3708F21E11D2E
 for <linux-nvdimm@lists.01.org>; Sun, 27 Aug 2017 19:38:36 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id g127so21084803oic.1
 for <linux-nvdimm@lists.01.org>; Sun, 27 Aug 2017 19:41:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170828104352.9A58.E1E9C6FF@jp.fujitsu.com>
References: <20170818133524.8EB4.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4jTYpVHocSb+XucA3MSMZ6QWJdFOm29iEj4bjyx2HSdPQ@mail.gmail.com>
 <20170828104352.9A58.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 27 Aug 2017 19:41:13 -0700
Message-ID: <CAPcyv4gV5DxA+mRPo7Eb8sXG3EOY0sk6VcNM18LYBakSYkGGig@mail.gmail.com>
Subject: Re: [ndctl PATCH 3/4] Make interfaces to use Translate SPA.
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Aug 27, 2017 at 6:43 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> On Thu, Aug 17, 2017 at 9:35 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> >
>> > This patch makes 3 new interfaces :
>> >   - to ask bus has translate SPA feature.
>> >   - to call translate SPA.
>> >   - to find DIMM by SPA address.
>> >
>> >
>> > Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>> > ---
>> >  configure.ac                 |  19 ++++++++
>> >  ndctl/lib/libndctl-private.h |   7 +++
>> >  ndctl/lib/libndctl.c         | 111 +++++++++++++++++++++++++++++++++++++++++++
>> >  ndctl/lib/libndctl.sym       |   3 ++
>> >  ndctl/libndctl.h.in          |  23 +++++++++
>> >  ndctl/ndctl.h                |   5 ++
>> >  6 files changed, 168 insertions(+)
>> >
>> > diff --git a/configure.ac b/configure.ac
>> > index 316f5b7..31d6956 100644
>> > --- a/configure.ac
>> > +++ b/configure.ac
>> > @@ -162,6 +162,25 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
>> >  )
>> >  AM_CONDITIONAL([ENABLE_CLEAR_ERROR], [test "x$enable_clear_err" = "xyes"])
>> >
>> > +AC_MSG_CHECKING([for TRANSLATE SPA support])
>> > +AC_LANG(C)
>> > +AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
>> > +                       #ifdef HAVE_NDCTL_H
>> > +                       #include <linux/ndctl.h>
>> > +                       #else
>> > +                       #include "ndctl/ndctl.h"
>> > +                       #endif
>> > +                       ]], [[
>> > +                       int x = NFIT_CMD_TRANSLATE_SPA;
>> > +                       ]]
>> > +               )], [AC_MSG_RESULT([yes])
>> > +                    enable_trans_spa=yes
>> > +                    AC_DEFINE([HAVE_NDCTL_TRANS_SPA], [1],
>> > +                               [Define to 1 if ndctl.h has TRANSLATE SPA support.])
>> > +               ], [AC_MSG_RESULT([no])]
>> > +)
>> > +AM_CONDITIONAL([ENABLE_TRANS_SPA], [test "x$enable_trans_spa" = "xyes"])
>>
>> Since the kernel is not defining a custom ioctl for this I don't think
>> I want to use ndctl.h to carry the definition of
>> NFIT_CMD_TRANSLATE_SPA. Instead I think we should create a
>> libndctl-nfit.h header that gets installed alongside libndctl.h. Then
>> consumers can use ndctl_bus_has_nfit() to check that they are talking
>> to an NFIT-defined NVDIMM bus and use the NFIT-specific commands
>> defined in that header file.
>
>
> Ok.
>
>>
>> > +
>> >  AC_MSG_CHECKING([for device DAX support])
>> >  AC_LANG(C)
>> >  AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
>> > diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
>> > index 8f10fbc..0512782 100644
>> > --- a/ndctl/lib/libndctl-private.h
>> > +++ b/ndctl/lib/libndctl-private.h
>> > @@ -196,6 +196,7 @@ struct ndctl_cmd {
>> >  #ifdef HAVE_NDCTL_CLEAR_ERROR
>> >                 struct nd_cmd_clear_error clear_err[0];
>> >  #endif
>> > +               struct nd_cmd_trans_spa trans_spa[0];
>> >                 struct ndn_pkg_hpe1 hpe1[0];
>> >                 struct ndn_pkg_msft msft[0];
>> >                 struct nd_cmd_smart smart[0];
>> > @@ -250,6 +251,12 @@ static const int nd_cmd_clear_error = ND_CMD_CLEAR_ERROR;
>> >  static const int nd_cmd_clear_error;
>> >  #endif
>> >
>> > +#ifdef HAVE_NDCTL_TRANS_SPA
>> > +static const int nd_cmd_trans_spa = NFIT_CMD_TRANSLATE_SPA;
>> > +#else
>> > +static const int nd_cmd_trans_spa;
>> > +#endif
>> > +
>> >  static inline struct ndctl_bus *cmd_to_bus(struct ndctl_cmd *cmd)
>> >  {
>> >         if (cmd->dimm)
>> > diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
>> > index b3535f0..4556067 100644
>> > --- a/ndctl/lib/libndctl.c
>> > +++ b/ndctl/lib/libndctl.c
>> > @@ -1959,6 +1959,117 @@ NDCTL_EXPORT struct badblock *ndctl_region_get_first_badblock(struct ndctl_regio
>> >         return ndctl_region_get_next_badblock(region);
>> >  }
>>
>> I believe these functions below will always be NFIT specific so lets
>> move them to a new ndctl/lib/libndctl-nfit.c file.
>>
>> >
>> > +#ifdef HAVE_NDCTL_TRANS_SPA
>> > +NDCTL_EXPORT int ndctl_bus_has_trans_spa(struct ndctl_bus *bus)
>>
>> Hmm, now that I read this patch perhaps we should just have this local
>> capability check and drop the generic
>> ndctl_bus_is_passthru_cmd_supported() helper since the only reason to
>> check for sub / passthru command is if you know you are talking to an
>> NFIT bus.
>>
>> > +{
>> > +       if (!bus)
>> > +               return 0;
>>
>> All these functions should also have
>>
>>     if (!ndctl_bus_has_nfit(bus))
>>         return false / NULL / etc...
>>
>>
>> Another general comment is to rename trans_spa to translate_spa, the
>> function name is already long, so no need to abbreviate.
>
> Hmm.
>
> I found "struct nd_cmd_trans_spa" is already defined in
> ndctl/ndctl.h of ndctl tree, and include/uapi/linux/ndctl.h of kernel tree.
>
> Do you think it should be changed too?
> If yes, I'll do.

Yes, if we have libndctl-nfit.h we don't need those defines in the
kernel. We should remove them before 4.13 final.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
