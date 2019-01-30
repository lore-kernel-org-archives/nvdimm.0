Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DDFE2211BED6C
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 11:05:11 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libndctl, dimm: Don't require an xlat function
Date: Wed, 30 Jan 2019 19:05:09 +0000
Message-ID: <9e91a2899b78fee4aa7f99b9b4a011b147e65ccc.camel@intel.com>
References: <20190130102645.31032-1-oohall@gmail.com>
 <CAPcyv4i-d=dt1JSnfbBBoyN1XdsfomK1TVo-kvdHNKR=+nmotA@mail.gmail.com>
In-Reply-To: <CAPcyv4i-d=dt1JSnfbBBoyN1XdsfomK1TVo-kvdHNKR=+nmotA@mail.gmail.com>
Content-Language: en-US
Content-ID: <7112D4899139E44685DF26C90B662593@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "oohall@gmail.com" <oohall@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-01-30 at 08:38 -0800, Dan Williams wrote:
> On Wed, Jan 30, 2019 at 2:27 AM Oliver O'Halloran <oohall@gmail.com> wrote:
> > commit 62bbfce3cb62 ("libndctl, intel: Add infrastructure for
> > firmware_status translation") has the unfortunate side effect of making
> > all NDCTL commands fail with -ENOMSG unless an xlat_firmware_status
> > function is defined for the DIMM family. This means that none of the
> > DIMM label manipulation commands work anymore, unless you happen to be
> > using an Intel DIMM.
> > 
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Fixes: 62bbfce3cb62 ("libndctl, intel: Add infrastructure for firmware_status translation")
> > Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> > ---
> >  ndctl/lib/libndctl.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> > index 06f835d76117..80d107394a74 100644
> > --- a/ndctl/lib/libndctl.c
> > +++ b/ndctl/lib/libndctl.c
> > @@ -2846,6 +2846,9 @@ NDCTL_EXPORT int ndctl_cmd_submit_xlat(struct ndctl_cmd *cmd)
> >          * useful), then the xlat function is available separately as well.
> >          */
> >         xlat_rc = ndctl_cmd_xlat_firmware_status(cmd);
> > +       if (xlat_rc == -ENOMSG)
> > +               return rc;
> > +
> 
> Ah, good point, however I think we should do this instead:
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 830b791339d2..2fa89162e05e 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -2710,7 +2710,7 @@ NDCTL_EXPORT int
> ndctl_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
>         struct ndctl_dimm_ops *ops = dimm ? dimm->ops : NULL;
> 
>         if (!dimm || !ops || !ops->xlat_firmware_status)
> -               return -ENOMSG;
> +               return 0;
>         return ops->xlat_firmware_status(cmd);
>  }
> 
> 
> A failure to translate just means proceed with the information that we
> *do* have, not a failure.

Ah good catch and I agree. Dan, will you send a proper patch for this
or shall I?


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
