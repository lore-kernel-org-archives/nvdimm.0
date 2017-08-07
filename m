Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EED9921DF37BA
 for <linux-nvdimm@lists.01.org>; Sun,  6 Aug 2017 17:01:15 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id CEE2EAC00C0
 for <linux-nvdimm@lists.01.org>; Mon,  7 Aug 2017 09:03:25 +0900 (JST)
Date: Mon, 07 Aug 2017 09:03:13 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC/Patch 1/5] Remove old enum definition of "Translate Spa"
In-Reply-To: <CAPcyv4g7cWsUESUg__RmTGQoV4L+ePM=fzbZdcpiaTEH_bhM0w@mail.gmail.com>
References: <20170804180655.27BF.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4g7cWsUESUg__RmTGQoV4L+ePM=fzbZdcpiaTEH_bhM0w@mail.gmail.com>
Message-Id: <20170807090309.F95F.E1E9C6FF@jp.fujitsu.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Fri, Aug 4, 2017 at 2:06 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> >
> > Remove old enum definition of "Translate Spa".
> >
> > Translate SPA becomes standard specification on ACPI 6.2,
> > but current definition is likely temporary.
> > So it is removed.
> >
> > Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> >
> >
> > ---
> >  drivers/acpi/nfit/core.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > index 19182d0..5334755 100644
> > --- a/drivers/acpi/nfit/core.c
> > +++ b/drivers/acpi/nfit/core.c
> > @@ -1626,7 +1626,6 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
> >   * these commands.
> >   */
> >  enum nfit_aux_cmds {
> > -        NFIT_CMD_TRANSLATE_SPA = 5,
> >          NFIT_CMD_ARS_INJECT_SET = 7,
> >          NFIT_CMD_ARS_INJECT_CLEAR = 8,
> >          NFIT_CMD_ARS_INJECT_GET = 9,
> > @@ -1655,7 +1654,6 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
> >                 (1 << ND_CMD_ARS_START) |
> >                 (1 << ND_CMD_ARS_STATUS) |
> >                 (1 << ND_CMD_CLEAR_ERROR) |
> > -               (1 << NFIT_CMD_TRANSLATE_SPA) |
> >                 (1 << NFIT_CMD_ARS_INJECT_SET) |
> >                 (1 << NFIT_CMD_ARS_INJECT_CLEAR) |
> >                 (1 << NFIT_CMD_ARS_INJECT_GET);
> 
> Hmm, those definitions are brand new as of the 4.13 kernel, see commit
> 7db5bb33add5 "libnvdimm, acpi, nfit: Add bus level dsm mask for pass
> thru". What's going on here is that we stopped defining new ND_CMD
> numbers for each new DSM that is added to the specification. Instead,
> we use the ND_CMD_CALL mechanism to wrap these new command payloads
> and pass them through to the BIOS. So, these definitions are needed to
> allow that passthrough mechanism to work.

Ah, Ok.
I'll check it.


Thanks,



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
