Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 7 Nov 2015 17:02:36 +0300
Message-ID: <CAJN_NGaPbziX=OcyYpcn5TP76HwGQSTsUz-yOVGB2Sh8VxDQjA@mail.gmail.com>
Subject: Re: [PATCH 3/4] nvdimm: Add IOCTL pass thru
From: Dmitry Krivenok <krivenok.dmitry@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

> +       if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
> +               dev_dbg(dev, "%s:%s cmd: %d input length: %d\n", __func__,
> +                               dimm_name, cmd, in_buf.buffer.length);
> +               print_hex_dump_debug("cmd: ", DUMP_PREFIX_OFFSET, 4,
> +                               4, in_buf.buffer.pointer, min_t(u32, 128,
> +                                       in_buf.buffer.length), true);
> +       }

Maybe move this code to a helper function? There are 4 almost
identical blocks now in acpi_nfit_ctl_passthru and
acpi_nfit_ctl_intel.

> +       for (i = 0; i < ARRAY_SIZE(pkg.h.res); i++)
> +               if (pkg.h.res[i])
> +                       return -EINVAL;

I'd rename "res" to "reserved" for clarity.

> +       /* This may be bigger that the fixed portion of the pakcage */

s/that/than/
s/pakcage/package/

> +               switch (type) {
> +               case NVDIMM_TYPE_INTEL:
> +                       rc = __nd_ioctl(nvdimm_bus, nvdimm, ro, cmd, arg);
> +                       break;
> +               case NVDIMM_TYPE_PASSTHRU:
> +                       rc = __nd_ioctl_passthru(nvdimm_bus, nvdimm, ro, cmd, arg);
> +                       break;
> +               default:
> +                       rc = -ENOTTY;
> +               }

The same comment. Identical code in nd_ioctl and nvdimm_ioctl.
Perhaps move to a helper function?

Thanks,
Dmitry
