Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <f8e838fb666b7d05e5e1f7527d643181c6f6ba4d.1449089647.git.jerry.hoemann@hpe.com>
References: <cover.1449089647.git.jerry.hoemann@hpe.com>
	<f8e838fb666b7d05e5e1f7527d643181c6f6ba4d.1449089647.git.jerry.hoemann@hpe.com>
Date: Tue, 8 Dec 2015 18:10:20 -0800
Message-ID: <CAPcyv4gFNnsbyTy8u-_jBF9JPYH_0a9dNX_R1oj2EH2sdrb=-g@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] nvdimm: Add IOCTL pass thru functions
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, jmoyer <jmoyer@redhat.com>, Dmitry Krivenok <krivenok.dmitry@gmail.com>, Linda Knippers <linda.knippers@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 2, 2015 at 1:05 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> Add ioctl command ND_CMD_CALL_DSM to acpi_nfit_ctl and __nd_ioctl which
> allow kernel to call a nvdimm's _DSM as a passthru without using the
> marshaling code of the nd_cmd_desc.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  drivers/acpi/nfit.c  | 109 ++++++++++++++++++++++++++++++++-------------------
>  drivers/nvdimm/bus.c |  61 +++++++++++++++++++++-------
>  2 files changed, 115 insertions(+), 55 deletions(-)
>

In general I'd like to see this patch remove the need to sprinkle "if
(dsm_call)" throughout the implementation ... specific examples below:

> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index c1b8d03..e509145 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -75,7 +75,11 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>         acpi_handle handle;
>         const u8 *uuid;
>         u32 offset;
> -       int rc, i;
> +       int rc = 0, i;
> +       __u64 rev = 1, func = cmd;

Why __u64 and not int for these?  acpi_evaluate_dsm() takes an int for
both so a bigger type here will be truncated down.

> +
> +       struct nd_cmd_dsmcall_pkg *pkg = buf;
> +       int dsm_call = (cmd == ND_CMD_CALL_DSM);
>
>         if (nvdimm) {
>                 struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> @@ -85,48 +89,62 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>                         return -ENOTTY;
>                 dimm_name = nvdimm_name(nvdimm);
>                 cmd_name = nvdimm_cmd_name(cmd);
> -               dsm_mask = nfit_mem->dsm_mask;
> +               if (!dsm_call)
> +                       dsm_mask = nfit_mem->dsm_mask;

Unpack the function id from the dsm_call so we can do the standard
check against dsm_mask.  Something like introduce 'dsm_func_id' that
is equal to 'cmd' in the legacy case.  That change to be explicit
about when we are referring to the "ioctl command number" vs the "dsm
function number" can be done in a lead in patch

>                 desc = nd_cmd_dimm_desc(cmd);
> -               uuid = to_nfit_uuid(NFIT_DEV_DIMM);
> +               if (!dsm_call)
> +                       uuid = to_nfit_uuid(NFIT_DEV_DIMM);
>                 handle = adev->handle;
>         } else {
>                 struct acpi_device *adev = to_acpi_dev(acpi_desc);
>
>                 cmd_name = nvdimm_bus_cmd_name(cmd);
> -               dsm_mask = nd_desc->dsm_mask;
> +               if (!dsm_call)
> +                       dsm_mask = nd_desc->dsm_mask;
>                 desc = nd_cmd_bus_desc(cmd);
> -               uuid = to_nfit_uuid(NFIT_DEV_BUS);
> +               if (!dsm_call)
> +                       uuid = to_nfit_uuid(NFIT_DEV_BUS);
>                 handle = adev->handle;
>                 dimm_name = "bus";
>         }
>
> -       if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
> -               return -ENOTTY;
> +       if (!dsm_call) {
> +               if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
> +                       return -ENOTTY;

Any reason to not create an nd_cmd_{dimm|bus}_desc() entry for this
command and reuse this check?

>
> -       if (!test_bit(cmd, &dsm_mask))
> -               return -ENOTTY;
> +               if (!test_bit(cmd, &dsm_mask))
> +                       return -ENOTTY;
> +       }
>
>         in_obj.type = ACPI_TYPE_PACKAGE;
>         in_obj.package.count = 1;
>         in_obj.package.elements = &in_buf;
>         in_buf.type = ACPI_TYPE_BUFFER;
> -       in_buf.buffer.pointer = buf;
>         in_buf.buffer.length = 0;
>
> -       /* libnvdimm has already validated the input envelope */
> -       for (i = 0; i < desc->in_num; i++)
> -               in_buf.buffer.length += nd_cmd_in_size(nvdimm, cmd, desc,
> +       if (dsm_call) {
> +               in_buf.buffer.pointer = (void *) &pkg->dsm_buf;
> +               in_buf.buffer.length = pkg->h.dsm_in;
> +               uuid = pkg->h.dsm_uuid;

'uuid' is determined above.

> +               rev  = pkg->h.dsm_rev;
> +               func = pkg->h.dsm_fun_idx;

This can be unified with the legacy case when func == cmd.

> +       } else {
> +               /* libnvdimm has already validated the input envelope */
> +               in_buf.buffer.pointer = buf;
> +               for (i = 0; i < desc->in_num; i++)
> +                       in_buf.buffer.length += nd_cmd_in_size(nvdimm, cmd, desc,
>                                 i, buf);
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

Would be nice to have both the cmd name and the dsm function name in
the debug output.  Something like:

dev_dbg("%s %s\n", cmd_name, cmd == func ? "" : func_name)

>         }
>
> -       out_obj = acpi_evaluate_dsm(handle, uuid, 1, cmd, &in_obj);
> +       out_obj = acpi_evaluate_dsm(handle, uuid, rev, func, &in_obj);
>         if (!out_obj) {
>                 dev_dbg(dev, "%s:%s _DSM failed cmd: %s\n", __func__, dimm_name,
>                                 cmd_name);
> @@ -134,21 +152,28 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>         }
>
>         if (out_obj->package.type != ACPI_TYPE_BUFFER) {
> -               dev_dbg(dev, "%s:%s unexpected output object type cmd: %s type: %d\n",
> -                               __func__, dimm_name, cmd_name, out_obj->type);
> +               dev_dbg(dev, "%s:%s unexpected output object type cmd: %s %llu, type: %d\n",
> +                               __func__, dimm_name, cmd_name, func, out_obj->type);
>                 rc = -EINVAL;
>                 goto out;
>         }
>
>         if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
> -               dev_dbg(dev, "%s:%s cmd: %s output length: %d\n", __func__,
> -                               dimm_name, cmd_name, out_obj->buffer.length);
> -               print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
> -                               4, out_obj->buffer.pointer, min_t(u32, 128,
> -                                       out_obj->buffer.length), true);
> +               dev_dbg(dev, "%s:%s cmd %d: %llu output length %d\n", __func__,
> +                               dimm_name, cmd, func, out_obj->buffer.length);
> +               print_hex_dump_debug("nvdimm out ", DUMP_PREFIX_OFFSET, 4, 4,
> +                       out_obj->buffer.pointer,
> +                       min_t(u32, 256, out_obj->buffer.length), true);
>         }
>
> -       for (i = 0, offset = 0; i < desc->out_num; i++) {
> +       if (dsm_call) {
> +               pkg->h.dsm_size = out_obj->buffer.length;
> +               memcpy(pkg->dsm_buf + pkg->h.dsm_in,
> +                       out_obj->buffer.pointer,
> +                       min(pkg->h.dsm_size, pkg->h.dsm_out));

Reuse nd_cmd_out_size()?  It already supports variable-size fields.

> +
> +       } else {
> +               for (i = 0, offset = 0; i < desc->out_num; i++) {
>                 u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i, buf,
>                                 (u32 *) out_obj->buffer.pointer);
>
> @@ -167,22 +192,23 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>                 memcpy(buf + in_buf.buffer.length + offset,
>                                 out_obj->buffer.pointer + offset, out_size);
>                 offset += out_size;
> -       }
> -       if (offset + in_buf.buffer.length < buf_len) {
> -               if (i >= 1) {
> -                       /*
> -                        * status valid, return the number of bytes left
> -                        * unfilled in the output buffer
> -                        */
> -                       rc = buf_len - offset - in_buf.buffer.length;
> -               } else {
> -                       dev_err(dev, "%s:%s underrun cmd: %s buf_len: %d out_len: %d\n",
> +               }
> +               if (offset + in_buf.buffer.length < buf_len) {
> +                       if (i >= 1) {
> +                               /*
> +                                * status valid, return the number of bytes left
> +                                * unfilled in the output buffer
> +                                */
> +                               rc = buf_len - offset - in_buf.buffer.length;
> +                       } else {
> +                               dev_err(dev, "%s:%s underrun cmd: %s buf_len: %d out_len: %d\n",
>                                         __func__, dimm_name, cmd_name, buf_len,
>                                         offset);
> -                       rc = -ENXIO;
> -               }
> -       } else
> -               rc = 0;
> +                               rc = -ENXIO;
> +                       }
> +               } else
> +                       rc = 0;
> +       }
>
>   out:
>         ACPI_FREE(out_obj);
> @@ -190,6 +216,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>         return rc;
>  }
>
> +
>  static const char *spa_type_name(u16 type)
>  {
>         static const char *to_name[] = {
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 1c81203..83900d50 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -492,31 +492,38 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>         struct device *dev = &nvdimm_bus->dev;
>         const char *cmd_name, *dimm_name;
>         unsigned long dsm_mask;
> -       void *buf;
> +       void *buf = NULL;
>         int rc, i;
>
> +       struct nd_cmd_dsmcall_pkg pkg;
> +       int dsm_call = (cmd == ND_CMD_CALL_DSM);
> +
>         if (nvdimm) {
>                 desc = nd_cmd_dimm_desc(cmd);
>                 cmd_name = nvdimm_cmd_name(cmd);
> -               dsm_mask = nvdimm->dsm_mask ? *(nvdimm->dsm_mask) : 0;
> +               if (!dsm_call)
> +                       dsm_mask = nvdimm->dsm_mask ? *(nvdimm->dsm_mask) : 0;
>                 dimm_name = dev_name(&nvdimm->dev);
>         } else {
>                 desc = nd_cmd_bus_desc(cmd);
>                 cmd_name = nvdimm_bus_cmd_name(cmd);
> -               dsm_mask = nd_desc->dsm_mask;
> +               if (!dsm_call)
> +                       dsm_mask = nd_desc->dsm_mask;
>                 dimm_name = "bus";
>         }
>
> -       if (!desc || (desc->out_num + desc->in_num == 0) ||
> -                       !test_bit(cmd, &dsm_mask))
> -               return -ENOTTY;
> +       if (!dsm_call)
> +               if (!desc || (desc->out_num + desc->in_num == 0) ||
> +                               !test_bit(cmd, &dsm_mask))
> +                       return -ENOTTY;

Same comments as the acpi_nfit_ctl path.

>
>         /* fail write commands (when read-only) */
>         if (read_only)
> -               switch (ioctl_cmd) {
> -               case ND_IOCTL_VENDOR:
> -               case ND_IOCTL_SET_CONFIG_DATA:
> -               case ND_IOCTL_ARS_START:
> +               switch (cmd) {
> +               case ND_CMD_VENDOR:
> +               case ND_CMD_SET_CONFIG_DATA:
> +               case ND_CMD_ARS_START:
> +               case ND_CMD_CALL_DSM:

I agree with your comment in the cover letter that this change should
be a separate patch.

It bothers me that we'll block all ND_CMD_CALL_DSM in the read_only
case.  Let's leave ND_CMD_CALL_DSM out of this selection for now.

I think we'll need to delete the protection going forward because we
won't be teaching the kernel about new DSM function numbers.  For
security purposes I'm looking at adding a mechanism for userspace to
disable commands by function number until next reboot.
