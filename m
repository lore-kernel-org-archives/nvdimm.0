Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E7A8A21E977F4
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 11:10:49 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id r20so485176oie.0
 for <linux-nvdimm@lists.01.org>; Tue, 05 Sep 2017 11:13:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170901221602.C282.E1E9C6FF@jp.fujitsu.com>
References: <20170901221335.C27F.E1E9C6FF@jp.fujitsu.com>
 <20170901221602.C282.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Sep 2017 11:13:37 -0700
Message-ID: <CAPcyv4joECiCkd3+GJ8dWq-MfN=6dg3_+QQ5h6Qg-chgTjfsgQ@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/5] ndctl: Introduce libndctl-nfit.h
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

On Fri, Sep 1, 2017 at 6:16 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> This patch introduces libndctl-nfit.h.
>
> Since these command can be executed via ND_CMD_CALL,
> libndctl.h which is shared between ndctl command and kernel does not
> have to include these defintions.
>
> So, libndctl-nfit.h, which is defined for only ndctl, is created instead,
> and move definitions from ndctl.h to it.
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> ---
>  ndctl/libndctl-nfit.h | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/ndctl.h         | 37 -------------------------
>  2 files changed, 76 insertions(+), 37 deletions(-)
>
> diff --git a/ndctl/libndctl-nfit.h b/ndctl/libndctl-nfit.h
> new file mode 100644
> index 0000000..1258d2e
> --- /dev/null
> +++ b/ndctl/libndctl-nfit.h
> @@ -0,0 +1,76 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU Lesser General Public License,
> + * version 2.1, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT ANY
> + * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> + * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
> + * more details.
> + */
> +
> +#ifndef __LIBNDCTL_NFIT_H__
> +#define __LIBNDCTL_NFIT_H__
> +
> +/*
> + * libndctl-nfit.h : definitions for NFIT related commands/functions.
> + */
> +
> +/* nfit command numbers which are called via ND_CMD_CALL */
> +enum {
> +       NFIT_CMD_TRANSLATE_SPA = 5,
> +       NFIT_CMD_ARS_INJECT_SET = 7,
> +       NFIT_CMD_ARS_INJECT_CLEAR = 8,
> +       NFIT_CMD_ARS_INJECT_GET = 9,
> +};
> +
> +/* error number of Translate SPA by firmware  */
> +#define ND_TRANSLATE_SPA_STATUS_INVALID_SPA  2
> +
> +/*
> + * The following structures are command packages which are
> + * defined by ACPI 6.2 (or later).
> + */
> +
> +/* For Translate SPA */
> +struct nd_cmd_translate_spa {
> +       __u64 spa;
> +       __u32 status;
> +       __u8  flags;
> +       __u8  _reserved[3];
> +       __u64 translate_length;
> +       __u32 num_nvdimms;
> +       struct nd_nvdimm_device {
> +               __u32 nfit_device_handle;
> +               __u32 _reserved;
> +               __u64 dpa;
> +       } devices[0];
> +
> +}; /* naturally packed */
> +

Sorry, I wasn't clear. Only "nd_cmd_ars_err_inj_stat" is naturally
packed the others are not. I can fix this up when I apply it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
