Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 02FFB2034D83C
 for <linux-nvdimm@lists.01.org>; Wed,  8 Nov 2017 11:06:01 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] libndctl, nfit: Fix in/out sizes for error
 injection commands
Date: Wed, 8 Nov 2017 19:09:59 +0000
Message-ID: <1510168169.2914.0.camel@intel.com>
References: <20171107225058.12805-1-vishal.l.verma@intel.com>
 <CAPcyv4j1Jo4L=f4C_SFTXHAgfqLnmbeGrE6g+gE4oL4gx_xCow@mail.gmail.com>
 <CAPcyv4iMU1KUb5_S+B52b6bZXcisNmdB2PY6t8x7ANxQveMNjA@mail.gmail.com>
In-Reply-To: <CAPcyv4iMU1KUb5_S+B52b6bZXcisNmdB2PY6t8x7ANxQveMNjA@mail.gmail.com>
Content-Language: en-US
Content-ID: <6410ABDD77AA9341890AB591CF7F3EC1@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Dokupil, Dariusz" <dariusz.dokupil@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2017-11-08 at 10:48 -0800, Dan Williams wrote:
> On Wed, Nov 8, 2017 at 10:07 AM, Dan Williams <dan.j.williams@intel.c
> om> wrote:
> > On Tue, Nov 7, 2017 at 2:50 PM, Vishal Verma <vishal.l.verma@intel.
> > com> wrote:
> > > The input/output size bounds being set in the various
> > > nd_bus_cmd_new_*
> > > helpers for error injection commands were larger than they needed
> > > to be,
> > > and platforms could reject these. Fix the bounds to be exactly as
> > > the
> > > spec describes.
> > > 
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > >  ndctl/lib/nfit.c | 16 ++++++++--------
> > >  1 file changed, 8 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/ndctl/lib/nfit.c b/ndctl/lib/nfit.c
> > > index fb6af32..6346fd9 100644
> > > --- a/ndctl/lib/nfit.c
> > > +++ b/ndctl/lib/nfit.c
> > > @@ -164,9 +164,9 @@ struct ndctl_cmd
> > > *ndctl_bus_cmd_new_err_inj(struct ndctl_bus *bus)
> > >         cmd->status = 1;
> > >         pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
> > >         pkg->nd_command = NFIT_CMD_ARS_INJECT_SET;
> > > -       pkg->nd_size_in = (2 * sizeof(u64)) + sizeof(u32);
> > > -       pkg->nd_size_out = cmd_length;
> > > -       pkg->nd_fw_size = cmd_length;
> > > +       pkg->nd_size_in = (2 * sizeof(u64)) + sizeof(u8);
> > 
> > How about:
> > 
> >     pkg->nd_size_in = offset_of(struct nd_cmd_ars_err_inj, status);
> 
> Actually, something like this to make the pkg-> settings and
> inter-relations clearer:
> 
> diff --git a/ndctl/lib/nfit.c b/ndctl/lib/nfit.c
> index 6346fd90f0e2..21c567ad5d4a 100644
> --- a/ndctl/lib/nfit.c
> +++ b/ndctl/lib/nfit.c
> @@ -164,9 +164,9 @@ struct ndctl_cmd
> *ndctl_bus_cmd_new_err_inj(struct
> ndctl_bus *bus)
>         cmd->status = 1;
>         pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
>         pkg->nd_command = NFIT_CMD_ARS_INJECT_SET;
> -       pkg->nd_size_in = (2 * sizeof(u64)) + sizeof(u8);
> -       pkg->nd_size_out = sizeof(u32);
> -       pkg->nd_fw_size = sizeof(u32);
> +       pkg->nd_size_in = offsetof(struct nd_cmd_ars_err_inj,
> status);
> +       pkg->nd_size_out = sizeof(struct nd_cmd_ars_err_inj) - pkg-
> >nd_size_in;
> +       pkg->nd_fw_size = pkg->nd_size_out;
>         err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
>         cmd->firmware_status = &err_inj->status;

Yep, I like that. I will resend.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
