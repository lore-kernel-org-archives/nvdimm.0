Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B25EF201B0431
 for <linux-nvdimm@lists.01.org>; Tue, 19 Feb 2019 18:58:35 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id i5so37758275oto.9
 for <linux-nvdimm@lists.01.org>; Tue, 19 Feb 2019 18:58:35 -0800 (PST)
MIME-Version: 1.0
References: <154958385172.3932544.193235520333886200.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49lg2bql2v.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49lg2bql2v.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Feb 2019 18:58:23 -0800
Message-ID: <CAPcyv4iiZS_zfroRtmS-zD-cCDj1yQonBsWM23utR9m9kiBizA@mail.gmail.com>
Subject: Re: [PATCH] acpi/nfit: Fix bus command validation
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Vishal Verma <vishal.verma@intel.com>, stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 19, 2019 at 5:57 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > Commit 11189c1089da "acpi/nfit: Fix command-supported detection" broke
> > ND_CMD_CALL for bus-level commands. The "func = cmd" assumption is only
> > valid for:
> >
> >     ND_CMD_ARS_CAP
> >     ND_CMD_ARS_START
> >     ND_CMD_ARS_STATUS
> >     ND_CMD_CLEAR_ERROR
> >
> > The function number otherwise needs to be pulled from the command
> > payload for:
> >
> >     NFIT_CMD_TRANSLATE_SPA
> >     NFIT_CMD_ARS_INJECT_SET
> >     NFIT_CMD_ARS_INJECT_CLEAR
> >     NFIT_CMD_ARS_INJECT_GET
> >
> > Update cmd_to_func() for the bus case and call it in the common path.
> >
> > Fixes: 11189c1089da ("acpi/nfit: Fix command-supported detection")
> > Cc: <stable@vger.kernel.org>
> > Cc: Vishal Verma <vishal.verma@intel.com>
> > Reported-by: Grzegorz Burzynski <grzegorz.burzynski@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Tricky code path, eh?

ioctl path, number one source of bugs / thrash in this subsystem. 2nd
place, ARS.

> Tested-by: Jeff Moyer <jmoyer@redhat.com>

Thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
