Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2733D1A1E5E
 for <linux-nvdimm@lists.01.org>; Wed, 14 Sep 2016 19:22:25 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id w11so50574830oia.2
 for <linux-nvdimm@lists.01.org>; Wed, 14 Sep 2016 19:22:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160913174140.10810-2-brian.boylston@hpe.com>
References: <20160913174140.10810-1-brian.boylston@hpe.com>
 <20160913174140.10810-2-brian.boylston@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Sep 2016 19:22:23 -0700
Message-ID: <CAPcyv4hDEgz9Y4KX3sQVNVw9K7ckuOeJVd4pUeFCagiTbpaZpw@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 1/4] libndctl: introduce ndctl_smart_ops
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
To: Brian Boylston <brian.boylston@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 13, 2016 at 10:41 AM, Brian Boylston <brian.boylston@hpe.com> wrote:
> Add a layer of indirection for the ndctl_cmd_smart*() family of
> interfaces.  This will allow the underlying implementation to be
> switched based on the DSM family supported by the DIMM.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
> ---
>  ndctl/lib/libndctl-private.h |  21 ++++++++
>  ndctl/lib/libndctl-smart.c   | 111 ++++++++++++++++++++++++++++++++++---------
>  ndctl/lib/libndctl.c         |   8 ++++
>  ndctl/libndctl.h.in          |   1 +
>  4 files changed, 118 insertions(+), 23 deletions(-)

Looks good to me and passes my regression tests.

Just one minor comment below:

>
> diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
> index 65ef86d..8d2ebfc 100644
> --- a/ndctl/lib/libndctl-private.h
> +++ b/ndctl/lib/libndctl-private.h
> @@ -201,6 +201,27 @@ struct ndctl_cmd {
>         };
>  };
>
> +struct ndctl_smart_ops {
> +       struct ndctl_cmd *(*new_smart)(struct ndctl_dimm *);
> +       unsigned int (*smart_get_flags)(struct ndctl_cmd *);
> +       unsigned int (*smart_get_health)(struct ndctl_cmd *);
> +       unsigned int (*smart_get_temperature)(struct ndctl_cmd *);
> +       unsigned int (*smart_get_spares)(struct ndctl_cmd *);
> +       unsigned int (*smart_get_alarm_flags)(struct ndctl_cmd *);
> +       unsigned int (*smart_get_life_used)(struct ndctl_cmd *);
> +       unsigned int (*smart_get_shutdown_state)(struct ndctl_cmd *);
> +       unsigned int (*smart_get_vendor_size)(struct ndctl_cmd *);
> +       unsigned char *(*smart_get_vendor_data)(struct ndctl_cmd *);
> +       struct ndctl_cmd *(*new_smart_threshold)(struct ndctl_dimm *);
> +       unsigned int (*smart_threshold_get_alarm_control)(struct ndctl_cmd *);
> +       unsigned int (*smart_threshold_get_temperature)(struct ndctl_cmd *);
> +       unsigned int (*smart_threshold_get_spares)(struct ndctl_cmd *);
> +};
> +
> +#if HAS_SMART == 1
> +struct ndctl_smart_ops intel_smart_ops;
> +#endif
> +
>  /* internal library helpers for conditionally defined command numbers */
>  #ifdef HAVE_NDCTL_ARS
>  static const int nd_cmd_ars_status = ND_CMD_ARS_STATUS;
> diff --git a/ndctl/lib/libndctl-smart.c b/ndctl/lib/libndctl-smart.c
> index cba1e9d..a172541 100644
> --- a/ndctl/lib/libndctl-smart.c
> +++ b/ndctl/lib/libndctl-smart.c
> @@ -16,7 +16,55 @@
>  #include <ndctl/libndctl.h>
>  #include "libndctl-private.h"
>
> -NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
> +/*
> + * The smart_dimm_op() and smart_cmd_op() macros are used here to
> + * define the wrappers around the ndctl_smart_ops:
> + */
> +
> +#define smart_dimm_op(name, op) \
> +NDCTL_EXPORT struct ndctl_cmd *name( \
> +               struct ndctl_dimm *dimm) \
> +{ \
> +       struct ndctl_smart_ops *ops = ndctl_dimm_get_smart_ops(dimm); \
> +       if (ops && ops->op) \
> +               return ops->op(dimm); \
> +       else \
> +               return NULL; \
> +}
> +
> +smart_dimm_op(ndctl_dimm_cmd_new_smart, new_smart)
> +smart_dimm_op(ndctl_dimm_cmd_new_smart_threshold, new_smart_threshold)

There's only two of these routines and I don't suppose there will need
to have many more variants in the future.  Let's just open code them
and not use a macro.  The rest looks good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
