Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 10DBD1A1ED4
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 12:15:15 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id w85so220322728oiw.0
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 12:15:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e228edeeaa2f6527af89f10089e4bb6939de2532.1458583367.git.jerry.hoemann@hpe.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
 <e228edeeaa2f6527af89f10089e4bb6939de2532.1458583367.git.jerry.hoemann@hpe.com>
Date: Mon, 11 Apr 2016 12:15:14 -0700
Message-ID: <CAPcyv4jZf0udsY3aPCGxqLFi6Dvrn14oV0C8UBMX6VhOzEuk2w@mail.gmail.com>
Subject: Re: [PATCH v8 05/10] nvdimm: Add IOCTL pass thru functions
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
> Add ioctl command ND_CMD_CALL_DSM to acpi_nfit_ctl and __nd_ioctl which
> allow kernel to call a nvdimm's _DSM as a passthru without using the
> marshaling code of the nd_cmd_desc.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  drivers/acpi/nfit.c  | 141 ++++++++++++++++++++++++++++++++++++++++++++-------
>  drivers/nvdimm/bus.c |  43 +++++++++++++++-
>  2 files changed, 166 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index d0f35e6..9511ab4 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -56,6 +56,21 @@ struct nfit_table_prev {
>         struct list_head flushes;
>  };
>
> +struct cmd_family_tbl {
> +       enum nfit_uuids key_uuid;       /* Internal handle              */
> +       int             key_type;       /* Exported handle              */
> +       int             rev;            /* _DSM rev                     */
> +       u64             mask;           /* 0 bit excludes underlying func.*/
> +};
> +
> +struct cmd_family_tbl nfit_cmd_family_tbl[] = {
> +       { NFIT_DEV_BUS,         ND_TYPE_BUS,            1, ~0UL},

Per the comment on patch2 lets kill this for now.

> +       { NFIT_DEV_DIMM,        ND_TYPE_DIMM_INTEL1,    1, ~0UL},
> +       { NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,    1, ~0UL},
> +       { NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,    1, ~0UL},

Why does the mask default to all supported?  I assume this should be
the known-valid mask for each type, i.e. 0x3fe for
ND_TYPE_DIMM_INTEL1.

> +       { -1, -1, -1, 0},
> +};
> +
>  static u8 nfit_uuid[NFIT_UUID_MAX][16];
>
>  const u8 *to_nfit_uuid(enum nfit_uuids id)
> @@ -64,6 +79,19 @@ const u8 *to_nfit_uuid(enum nfit_uuids id)
>  }
>  EXPORT_SYMBOL(to_nfit_uuid);
>
> +static const u8 *
> +family_to_uuid(int type)
> +{
> +       struct cmd_family_tbl *tbl = nfit_cmd_family_tbl;
> +       int i;
> +
> +       for (i = 0;  tbl[i].key_type >= 0 ; i++) {
> +               if (tbl[i].key_type == type)
> +                       return to_nfit_uuid(tbl[i].key_uuid);
> +       }
> +       return 0;
> +}
> +
>  static struct acpi_nfit_desc *to_acpi_nfit_desc(
>                 struct nvdimm_bus_descriptor *nd_desc)
>  {
> @@ -171,8 +199,9 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>                 unsigned int buf_len, int *cmd_rc)
>  {
>         struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
> -       const struct nd_cmd_desc *desc = NULL;
>         union acpi_object in_obj, in_buf, *out_obj;
> +       struct nd_cmd_pkg *call_dsm = NULL;
> +       const struct nd_cmd_desc *desc = NULL;
>         struct device *dev = acpi_desc->dev;
>         const char *cmd_name, *dimm_name;
>         unsigned long dsm_mask;
> @@ -180,6 +209,12 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>         const u8 *uuid;
>         u32 offset;
>         int rc, i;
> +       __u64 rev = 1, func = cmd;
> +
> +       if (cmd == ND_CMD_CALL) {
> +               call_dsm = buf;
> +               func = call_dsm->nd_command;
> +       }
>
>         if (nvdimm) {
>                 struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> @@ -207,7 +242,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>         if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
>                 return -ENOTTY;
>
> -       if (!test_bit(cmd, &dsm_mask))
> +       if (!test_bit(func, &dsm_mask))
>                 return -ENOTTY;
>
>         in_obj.type = ACPI_TYPE_PACKAGE;
> @@ -218,25 +253,49 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>         in_buf.buffer.length = 0;
>
>         /* libnvdimm has already validated the input envelope */
> -       for (i = 0; i < desc->in_num; i++)
> +       for (i = 0; i < desc->in_num; i++) {
>                 in_buf.buffer.length += nd_cmd_in_size(nvdimm, cmd, desc,
>                                 i, buf);
> +       }
> +
> +       if (call_dsm) {
> +               /* must skip over package wrapper */
> +               in_buf.buffer.pointer = (void *) &call_dsm->nd_payload;
> +               in_buf.buffer.length = call_dsm->nd_size_in;
> +               uuid = family_to_uuid(call_dsm->nd_family);
> +               if (!uuid) {
> +                       dev_dbg(dev, "%s:%s unsupported uuid\n", dimm_name,
> +                                       cmd_name);
> +                       return -EINVAL;
> +               }
> +       }
>
>         if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
> -               dev_dbg(dev, "%s:%s cmd: %s input length: %d\n", __func__,
> -                               dimm_name, cmd_name, in_buf.buffer.length);
> -               print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
> -                               4, in_buf.buffer.pointer, min_t(u32, 128,
> -                                       in_buf.buffer.length), true);
> +               dev_dbg(dev, "%s:%s cmd: %d: %llu input length: %d\n", __func__,
> +                               dimm_name, cmd, func, in_buf.buffer.length);
> +               print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
> +                       in_buf.buffer.pointer,
> +                       min_t(u32, 256, in_buf.buffer.length), true);
> +
>         }
>
> -       out_obj = acpi_evaluate_dsm(handle, uuid, 1, cmd, &in_obj);
> +       out_obj = acpi_evaluate_dsm(handle, uuid, rev, func, &in_obj);
>         if (!out_obj) {
> -               dev_dbg(dev, "%s:%s _DSM failed cmd: %s\n", __func__, dimm_name,
> -                               cmd_name);
> +               dev_dbg(dev, "%s:%s unexpected output object type cmd: %s %llu, type: %d\n",
> +                       __func__, dimm_name, cmd_name, func, out_obj->type);
>                 return -EINVAL;
>         }
>
> +       if (call_dsm) {
> +               call_dsm->nd_fw_size = out_obj->buffer.length;
> +               memcpy(call_dsm->nd_payload + call_dsm->nd_size_in,
> +                       out_obj->buffer.pointer,
> +                       min(call_dsm->nd_fw_size, call_dsm->nd_size_out));
> +
> +               ACPI_FREE(out_obj);
> +               return 0;
> +       }
> +
>         if (out_obj->package.type != ACPI_TYPE_BUFFER) {
>                 dev_dbg(dev, "%s:%s unexpected output object type cmd: %s type: %d\n",
>                                 __func__, dimm_name, cmd_name, out_obj->type);
> @@ -918,13 +977,60 @@ static struct nvdimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
>         return NULL;
>  }
>
> +
> +/*
> + * determine if the _DSM specified by UUID is supported and return
> + * mask of supported functions in nd_cmd_mask.
> + */
> +
> +static int acpi_nfit_sup_func(acpi_handle handle, const u8 *uuid,
> +               int rev, unsigned long *nd_cmd_mask)
> +{
> +       int i;
> +       u64 mask = 0;
> +       union acpi_object *obj;
> +
> +       obj = acpi_evaluate_dsm(handle, uuid, rev, 0, NULL);
> +       if (!obj)
> +               return 0;
> +       /* For compatibility, old BIOSes may return an integer */
> +       if (obj->type == ACPI_TYPE_INTEGER)
> +               mask = obj->integer.value;
> +       else if (obj->type == ACPI_TYPE_BUFFER)
> +               for (i = 0; i < obj->buffer.length && i < 8; i++)
> +                       mask |= (((u8)obj->buffer.pointer[i]) << (i * 8));
> +       ACPI_FREE(obj);
> +
> +       *nd_cmd_mask = mask;
> +
> +       return !!mask;
> +}
> +
> +
> +static inline void
> +to_nfit_uuid_msk(acpi_handle handle, struct cmd_family_tbl *tbl,
> +               u8 const **cmd_uuid, unsigned long *cmd_mask)
> +{
> +       unsigned long mask = 0;
> +       int i;
> +
> +       for (i = 0;  tbl[i].key_uuid >= 0 ; i++) {
> +               const u8 *uuid = to_nfit_uuid(tbl[i].key_uuid);
> +               int rev = tbl[i].rev;
> +
> +               if (acpi_nfit_sup_func(handle, uuid, rev, &mask)) {
> +                       *cmd_mask = mask & tbl[i].mask;
> +                       *cmd_uuid = uuid;
> +                       break;
> +               }
> +       }
> +}
> +
>  static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>                 struct nfit_mem *nfit_mem, u32 device_handle)
>  {
>         struct acpi_device *adev, *adev_dimm;
>         struct device *dev = acpi_desc->dev;
> -       const u8 *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
> -       int i;
>
>         nfit_mem->dsm_mask = acpi_desc->dimm_dsm_force_en;
>         adev = to_acpi_dev(acpi_desc);
> @@ -939,9 +1045,8 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>                 return force_enable_dimms ? 0 : -ENODEV;
>         }
>
> -       for (i = ND_CMD_SMART; i <= ND_CMD_VENDOR; i++)
> -               if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
> -                       set_bit(i, &nfit_mem->dsm_mask);
> +       to_nfit_uuid_msk(adev_dimm->handle, nfit_cmd_family_tbl,
> +                       &nfit_mem->dsm_uuid, &nfit_mem->dsm_mask);

Why is this replacing acpi_check_dsm() with an open-coded implementation?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
