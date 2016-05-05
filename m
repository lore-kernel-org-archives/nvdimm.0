Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 355F41A1F5C
 for <linux-nvdimm@lists.01.org>; Thu,  5 May 2016 16:44:07 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id x201so121348215oif.3
 for <linux-nvdimm@lists.01.org>; Thu, 05 May 2016 16:44:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160505180135.GD6808@tevye.fc.hp.com>
References: <146189774241.29835.12947278159500915461.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146189775335.29835.217177508880335589.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160505180135.GD6808@tevye.fc.hp.com>
Date: Thu, 5 May 2016 16:44:06 -0700
Message-ID: <CAPcyv4iU0NzxoTv9KLEofq3048z2335+f3dnNa=8hjSwo0xXSA@mail.gmail.com>
Subject: Re: [PATCH v11 2/5] nfit, libnvdimm: limited/whitelisted dimm command
 marshaling mechanism
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 5, 2016 at 11:01 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Thu, Apr 28, 2016 at 07:42:33PM -0700, Dan Williams wrote:
>
> ...
>
>
>> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>> index 1b98e9dc6138..710d3a07d178 100644
>> --- a/drivers/acpi/nfit.c
>> +++ b/drivers/acpi/nfit.c
>> @@ -171,33 +171,46 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>>               unsigned int buf_len, int *cmd_rc)
>>  {
>>       struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
>> -     const struct nd_cmd_desc *desc = NULL;
>>       union acpi_object in_obj, in_buf, *out_obj;
>> +     const struct nd_cmd_desc *desc = NULL;
>>       struct device *dev = acpi_desc->dev;
>> +     struct nd_cmd_pkg *call_pkg = NULL;
>>       const char *cmd_name, *dimm_name;
>> -     unsigned long cmd_mask;
>> +     unsigned long cmd_mask, dsm_mask;
>>       acpi_handle handle;
>> +     unsigned int func;
>>       const u8 *uuid;
>>       u32 offset;
>>       int rc, i;
>>
>> +     func = cmd;
>> +     if (cmd == ND_CMD_CALL) {
>> +             call_pkg = buf;
>> +             func = call_pkg->nd_command;
>> +     }
>> +
>>       if (nvdimm) {
>>               struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
>>               struct acpi_device *adev = nfit_mem->adev;
>>
>>               if (!adev)
>>                       return -ENOTTY;
>> +             if (call_pkg && nfit_mem->family != call_pkg->nd_family)
>> +                     return -ENOTTY;
>> +
>>               dimm_name = nvdimm_name(nvdimm);
>>               cmd_name = nvdimm_cmd_name(cmd);
>>               cmd_mask = nvdimm_cmd_mask(nvdimm);
>> +             dsm_mask = nfit_mem->dsm_mask;
>>               desc = nd_cmd_dimm_desc(cmd);
>> -             uuid = to_nfit_uuid(NFIT_DEV_DIMM);
>> +             uuid = to_nfit_uuid(nfit_mem->family);
>>               handle = adev->handle;
>>       } else {
>>               struct acpi_device *adev = to_acpi_dev(acpi_desc);
>>
>>               cmd_name = nvdimm_bus_cmd_name(cmd);
>>               cmd_mask = nd_desc->cmd_mask;
>> +             dsm_mask = cmd_mask;
>>               desc = nd_cmd_bus_desc(cmd);
>>               uuid = to_nfit_uuid(NFIT_DEV_BUS);
>>               handle = adev->handle;
>> @@ -207,7 +220,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>>       if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
>>               return -ENOTTY;
>>
>> -     if (!test_bit(cmd, &cmd_mask))
>> +     if (!test_bit(cmd, &cmd_mask) || !test_bit(func, &dsm_mask))
>>               return -ENOTTY;
>>
>>       in_obj.type = ACPI_TYPE_PACKAGE;
>> @@ -222,21 +235,44 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>>               in_buf.buffer.length += nd_cmd_in_size(nvdimm, cmd, desc,
>>                               i, buf);
>>
>> +     if (call_pkg) {
>> +             /* skip over package wrapper */
>> +             in_buf.buffer.pointer = (void *) &call_pkg->nd_payload;
>> +             in_buf.buffer.length = call_pkg->nd_size_in;
>> +     }
>> +
>>       if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
>> -             dev_dbg(dev, "%s:%s cmd: %s input length: %d\n", __func__,
>> -                             dimm_name, cmd_name, in_buf.buffer.length);
>> -             print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
>> -                             4, in_buf.buffer.pointer, min_t(u32, 128,
>> -                                     in_buf.buffer.length), true);
>> +             dev_dbg(dev, "%s:%s cmd: %d: func: %d input length: %d\n",
>> +                             __func__, dimm_name, cmd, func,
>> +                             in_buf.buffer.length);
>> +             print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
>> +                     in_buf.buffer.pointer,
>> +                     min_t(u32, 256, in_buf.buffer.length), true);
>>       }
>>
>> -     out_obj = acpi_evaluate_dsm(handle, uuid, 1, cmd, &in_obj);
>> +     out_obj = acpi_evaluate_dsm(handle, uuid, 1, func, &in_obj);
>>       if (!out_obj) {
>>               dev_dbg(dev, "%s:%s _DSM failed cmd: %s\n", __func__, dimm_name,
>>                               cmd_name);
>>               return -EINVAL;
>>       }
>>
>> +     if (call_pkg) {
>> +             call_pkg->nd_fw_size = out_obj->buffer.length;
>> +             memcpy(call_pkg->nd_payload + call_pkg->nd_size_in,
>> +                     out_obj->buffer.pointer,
>> +                     min(call_pkg->nd_fw_size, call_pkg->nd_size_out));
>> +
>> +             ACPI_FREE(out_obj);
>> +             /*
>> +              * Need to support FW function w/o known size in advance.
>> +              * Caller can determine required size based upon nd_fw_size.
>> +              * If call erroed (like elsewhere) then caller wouldn't
>                            ^^^^^^^
>                         typo:  returned error?

Yes, should be "returned an error"

>
>
>
>> +              * be able to rely upon data returned to make calculation.
>> +              */
>> +             return 0;
>> +     }
>> +
>>       if (out_obj->package.type != ACPI_TYPE_BUFFER) {
>>               dev_dbg(dev, "%s:%s unexpected output object type cmd: %s type: %d\n",
>>                               __func__, dimm_name, cmd_name, out_obj->type);
>> @@ -923,11 +959,13 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>>  {
>>       struct acpi_device *adev, *adev_dimm;
>>       struct device *dev = acpi_desc->dev;
>> -     const u8 *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
>> +     unsigned long dsm_mask;
>> +     const u8 *uuid;
>>       int i;
>>
>>       /* nfit test assumes 1:1 relationship between commands and dsms */
>>       nfit_mem->dsm_mask = acpi_desc->dimm_cmd_force_en;
>> +     nfit_mem->family = NVDIMM_FAMILY_INTEL;
>>       adev = to_acpi_dev(acpi_desc);
>>       if (!adev)
>>               return 0;
>> @@ -940,7 +978,31 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>>               return force_enable_dimms ? 0 : -ENODEV;
>>       }
>>
>> -     for (i = ND_CMD_SMART; i <= ND_CMD_VENDOR; i++)
>> +     /*
>> +      * Until standardization materializes we need to consider up to 3
>> +      * different command sets.  Note, that checking for function0 (bit0)
>> +      * tells us if any commands are reachable through this uuid.
>> +      */
>> +     for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_HPE2; i++)
>> +             if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
>> +                     break;
>> +
>> +     /* limit the supported commands to those that are publicly documented */
>> +     nfit_mem->family = i;
>> +     if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
>> +             dsm_mask = 0x3fe;
>> +     else if (nfit_mem->family == NVDIMM_FAMILY_HPE1)
>> +             dsm_mask = 0x1c3c76;
>
>
>
>                         ^ Missing defined function 0.

This is deliberate as function0 does not return the effective dsm mask
understood by the kernel.  This information is available in the
"nfit/dsm_mask" attribute of the nmem device.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
