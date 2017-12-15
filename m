Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22d.google.com (mail-ot0-x22d.google.com
 [IPv6:2607:f8b0:4003:c0f::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1BF5422137D80
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 10:00:19 -0800 (PST)
Received: by mail-ot0-x22d.google.com with SMTP id d5so8497655oti.3
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 10:05:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151260047300.3630.15691857990092270462.stgit@djiang5-desk3.ch.intel.com>
References: <151260039600.3630.12960859289293301854.stgit@djiang5-desk3.ch.intel.com>
 <151260047300.3630.15691857990092270462.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Dec 2017 10:05:00 -0800
Message-ID: <CAPcyv4g8nHCcOhkWeVkXkyOrarwrEQrGq_pb93kfJx3gTpAPWQ@mail.gmail.com>
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
> ---
[..]
> diff --git a/ndctl/update.c b/ndctl/update.c
> new file mode 100644
> index 0000000..2ac6d21
> --- /dev/null
> +++ b/ndctl/update.c
[..]
> +#define ND_CMD_STATUS_SUCCESS  0
> +#define ND_CMD_STATUS_NOTSUPP  1
> +#define        ND_CMD_STATUS_NOTEXIST  2
> +#define ND_CMD_STATUS_INVALPARM        3
> +#define ND_CMD_STATUS_HWERR    4
> +#define ND_CMD_STATUS_RETRY    5
> +#define ND_CMD_STATUS_UNKNOWN  6
> +#define ND_CMD_STATUS_EXTEND   7
> +#define ND_CMD_STATUS_NORES    8
> +#define ND_CMD_STATUS_NOTREADY 9
> +
> +#define ND_CMD_STATUS_START_BUSY       0x10000
> +#define ND_CMD_STATUS_SEND_CTXINVAL    0x10000
> +#define ND_CMD_STATUS_FIN_CTXINVAL     0x10000
> +#define ND_CMD_STATUS_FIN_DONE         0x20000
> +#define ND_CMD_STATUS_FIN_BAD          0x30000
> +#define ND_CMD_STATUS_FIN_ABORTED      0x40000
> +#define ND_CMD_STATUS_FQ_CTXINVAL      0x10000
> +#define ND_CMD_STATUS_FQ_BUSY          0x20000
> +#define ND_CMD_STATUS_FQ_BAD           0x30000
> +#define ND_CMD_STATUS_FQ_ORDER         0x40000

I think we need to have the DIMM implementation translate these statuses...

> +static int query_fw_finish_status(struct update_context *uctx)
> +{
> +       struct ndctl_cmd *cmd;
> +       int rc;
> +       uint32_t status;
> +       struct fw_info *fw = &uctx->dimm_fw;
> +       bool done = false;
> +       struct timeval before, after;
> +       struct timespec now;
> +       uint64_t ver;
> +
> +       cmd = ndctl_dimm_cmd_new_fw_finish_query(uctx->dimm);
> +       if (!cmd)
> +               return -ENXIO;
> +
> +       rc = ndctl_cmd_fw_fquery_set_context(cmd, fw->context);
> +       if (rc < 0)
> +               goto out;
> +
> +       rc = gettimeofday(&before, NULL);
> +       if (rc < 0)
> +               goto out;
> +
> +       now.tv_nsec = fw->query_interval / 1000;
> +       now.tv_sec = 0;
> +
> +       do {
> +               rc = ndctl_cmd_submit(cmd);
> +               if (rc < 0)
> +                       break;
> +
> +               status = ndctl_cmd_get_firmware_status(cmd);

I think we need a ndctl_cmd_xlat_firmware_status() to translate the
DIMM specific error code into a common error number otherwise this is
immediately not portable to another DIMM's firmware update commands.
For example: https://msdn.microsoft.com/en-us/library/windows/hardware/mt604709(v=vs.85).aspx
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
