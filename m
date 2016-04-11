Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 301D91A2186
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 11:21:46 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id y204so218164424oie.3
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 11:21:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fc6407acd4f88fad4a74d1be19bc46de01f0d809.1458583367.git.jerry.hoemann@hpe.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
 <fc6407acd4f88fad4a74d1be19bc46de01f0d809.1458583367.git.jerry.hoemann@hpe.com>
Date: Mon, 11 Apr 2016 11:21:45 -0700
Message-ID: <CAPcyv4g-zgOoCBcm7M0Sgb8uM6pOC2Aott-yk-jHtU+zQs6smw@mail.gmail.com>
Subject: Re: [PATCH v8 02/10] nvdimm: Add wrapper for IOCTL pass thru
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 21, 2016 at 12:37 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> Add struct nd_cmd_pkg which serves as a warapper for
> the data being passed via a pass thru to a NVDIMM DSM.
> This wrapper specifies the extra information in a uniform
> manner allowing the kenrel to call a DSM without knowing
> specifics of the DSM.
>
> Add dsm_call command to nvdimm_bus_cmd_name and nvdimm_cmd_name.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  include/uapi/linux/ndctl.h | 53 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>
> diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
> index 7cc28ab..c043cd1 100644
> --- a/include/uapi/linux/ndctl.h
> +++ b/include/uapi/linux/ndctl.h
> @@ -114,6 +114,7 @@ enum {
>         ND_CMD_ARS_START = 2,
>         ND_CMD_ARS_STATUS = 3,
>         ND_CMD_CLEAR_ERROR = 4,
> +       /* 10 reserved for ND_CMD_CALL below */
>
>         /* per-dimm commands */
>         ND_CMD_SMART = 1,
> @@ -125,6 +126,7 @@ enum {
>         ND_CMD_VENDOR_EFFECT_LOG_SIZE = 7,
>         ND_CMD_VENDOR_EFFECT_LOG = 8,
>         ND_CMD_VENDOR = 9,
> +       ND_CMD_CALL = 10,
>  };
>
>  enum {
> @@ -139,6 +141,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
>                 [ND_CMD_ARS_START] = "ars_start",
>                 [ND_CMD_ARS_STATUS] = "ars_status",
>                 [ND_CMD_CLEAR_ERROR] = "clear_error",
> +               [ND_CMD_CALL] = "cmd_call",
>         };
>
>         if (cmd < ARRAY_SIZE(names) && names[cmd])
> @@ -158,6 +161,7 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
>                 [ND_CMD_VENDOR_EFFECT_LOG_SIZE] = "effect_size",
>                 [ND_CMD_VENDOR_EFFECT_LOG] = "effect_log",
>                 [ND_CMD_VENDOR] = "vendor",
> +               [ND_CMD_CALL] = "cmd_call",
>         };
>
>         if (cmd < ARRAY_SIZE(names) && names[cmd])
> @@ -224,4 +228,53 @@ enum ars_masks {
>         ARS_STATUS_MASK = 0x0000FFFF,
>         ARS_EXT_STATUS_SHIFT = 16,
>  };
> +
> +
> +/*
> + * struct nd_cmd_pkg
> + *
> + * is a wrapper to a quasi pass thru interface for invoking firmware
> + * associated with nvdimms.
> + *
> + * INPUT PARAMETERS
> + *
> + * nd_family corresponds to the firmware (e.g. DSM) interface.
> + *
> + * nd_command are the function index advertised by the firmware.
> + *
> + * nd_size_in is the size of the input parameters being passed to firmware
> + *
> + * OUTPUT PARAMETERS
> + *
> + * nd_fw_size is the size of the data firmware wants to return for
> + * the call.  If nd_fw_size is greater than size of nd_size_out, only
> + * the first nd_size_out bytes are returned.
> + */
> +
> +struct nd_cmd_pkg {
> +       __u64   nd_family;              /* family of commands, eg ND_TYPE_BUS */
> +       __u64   nd_command;
> +       __u32   nd_size_in;             /* INPUT: size of input args */
> +       __u32   nd_size_out;            /* INPUT: size of payload */
> +       __u32   nd_reserved2[9];        /* reserved must be zero */
> +       __u32   nd_fw_size;             /* OUTPUT: size fw wants to return */
> +       unsigned char nd_payload[];     /* Contents of call      */
> +};
> +
> +/*
> + * the list nd_family of commands.  The mapping to firmware handles
> + * is definied in the nfit_cmd_family_tbl
> + *
> + */
> +#define ND_TYPE_BUS                    1
> +#define ND_TYPE_DIMM_INTEL1            2
> +#define ND_TYPE_DIMM_N_HPE1            3
> +#define ND_TYPE_DIMM_N_HPE2            4
> +
> +
> +#define ND_IOCTL_CALL                  _IOWR(ND_IOCTL, ND_CMD_CALL,\
> +                                       struct nd_cmd_pkg)
> +
> +
> +
>  #endif /* __NDCTL_H__ */

Looks, good, but for now lets assume there will never be such a thing
as ND_TYPE_BUS commands or an ND_CMD_CALL for the bus.  I.e. all the
commands that currently exist for the bus are commands that the kernel
wants to handle.  In this way, struct nd_cmd_pkg is a solution to the
problem of commands that the kernel knows exist, but has no use case
to generate or parse itself.  Commands that fit that description
currently only exist in leaf node implementations.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
