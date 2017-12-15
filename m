Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 387FB22137D80
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 10:07:59 -0800 (PST)
Received: by mail-ot0-x242.google.com with SMTP id p31so1883273ota.4
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 10:12:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151260047300.3630.15691857990092270462.stgit@djiang5-desk3.ch.intel.com>
References: <151260039600.3630.12960859289293301854.stgit@djiang5-desk3.ch.intel.com>
 <151260047300.3630.15691857990092270462.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Dec 2017 10:12:40 -0800
Message-ID: <CAPcyv4jQy=bkvOMFaUa7uUVWm8YeqTXjJHBNHTEn-PrhoTs=BQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ndctl: add firmware update command option for ndctl
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 6, 2017 at 2:47 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding option "update-firmware" to ndctl for update firmware support from
> Intel DSM v1.6. ndctl update-firmware takes an option of -f for a firmware
> binary and a -d for the DIMM name:
> ndctl update-firmware -d nmem0 -f new_firmware.bin
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[..]
> diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
> index 3ac4d3b..6d26a6c 100644
> --- a/ndctl/lib/intel.c
> +++ b/ndctl/lib/intel.c

These changes should be folded into the previous patch.

> @@ -323,7 +323,7 @@ static int intel_fw_get_info_valid(struct ndctl_cmd *cmd)
>  {
>         struct nd_pkg_intel *pkg = cmd->intel;
>
> -       if (cmd->type != ND_CMD_CALL || cmd->status != 1
> +       if (cmd->type != ND_CMD_CALL || cmd->status != 0
>                         || pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
>                         || pkg->gen.nd_command != ND_INTEL_FW_GET_INFO)
>                 return -EINVAL;
> @@ -382,7 +382,7 @@ static int intel_fw_start_valid(struct ndctl_cmd *cmd)
>  {
>         struct nd_pkg_intel *pkg = cmd->intel;
>
> -       if (cmd->type != ND_CMD_CALL || cmd->status != 1
> +       if (cmd->type != ND_CMD_CALL || cmd->status != 0
>                         || pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
>                         || pkg->gen.nd_command != ND_INTEL_FW_START_UPDATE)
>                 return -EINVAL;
> @@ -414,7 +414,7 @@ static struct ndctl_cmd *intel_dimm_cmd_new_fw_send(struct ndctl_dimm *dimm,
>         return cmd;
>  }
>
> -static int intel_fw_send_valid(struct ndctl_cmd *cmd)
> +static int intel_fw_send_set_valid(struct ndctl_cmd *cmd)

Why the name change? The way you initially had it is what I would expect.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
