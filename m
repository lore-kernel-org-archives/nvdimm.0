Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0AB302194EB78
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jul 2019 19:48:53 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id r21so47837813otq.6
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jul 2019 19:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190724215741.18556-1-vishal.l.verma@intel.com>
 <20190724215741.18556-9-vishal.l.verma@intel.com>
In-Reply-To: <20190724215741.18556-9-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jul 2019 19:46:15 -0700
Message-ID: <CAPcyv4h=i_EJD425mRUzpCdppiwA6CN3FmC0u3thvkMy4aajWg@mail.gmail.com>
Subject: Re: [ndctl PATCH v7 08/13] Documentation/daxctl: add a man page for
 daxctl-reconfigure-device
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 24, 2019 at 2:57 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a man page describing the new daxctl-reconfigure-device command.
>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/daxctl/Makefile.am              |   3 +-
>  .../daxctl/daxctl-reconfigure-device.txt      | 139 ++++++++++++++++++
>  2 files changed, 141 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/daxctl/daxctl-reconfigure-device.txt
>
> diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
> index 6aba035..715fbad 100644
> --- a/Documentation/daxctl/Makefile.am
> +++ b/Documentation/daxctl/Makefile.am
> @@ -28,7 +28,8 @@ endif
>  man1_MANS = \
>         daxctl.1 \
>         daxctl-list.1 \
> -       daxctl-migrate-device-model.1
> +       daxctl-migrate-device-model.1 \
> +       daxctl-reconfigure-device.1
>
>  CLEANFILES = $(man1_MANS)
>
> diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documentation/daxctl/daxctl-reconfigure-device.txt
> new file mode 100644
> index 0000000..fb2b36b
> --- /dev/null
> +++ b/Documentation/daxctl/daxctl-reconfigure-device.txt
> @@ -0,0 +1,139 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +daxctl-reconfigure-device(1)
> +============================
> +
> +NAME
> +----
> +daxctl-reconfigure-device - Reconfigure a dax device into a different mode
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'daxctl reconfigure-device' <dax0.0> [<dax1.0>...<daxY.Z>] [<options>]
> +
> +EXAMPLES
> +--------
> +
> +* Reconfigure dax0.0 to system-ram mode, don't online the memory
> +----
> +# daxctl reconfigure-device --mode=system-ram --no-online dax0.0
> +[
> +  {
> +    "chardev":"dax0.0",
> +    "size":16777216000,
> +    "target_node":2,
> +    "mode":"system-ram"
> +  }
> +]
> +----
> +
> +* Reconfigure dax0.0 to devdax mode, attempt to offline the memory
> +----
> +# daxctl reconfigure-device --human --mode=devdax --attempt-offline dax0.0
> +{
> +  "chardev":"dax0.0",
> +  "size":"15.63 GiB (16.78 GB)",
> +  "target_node":2,
> +  "mode":"devdax"
> +}
> +----
> +
> +* Reconfigure all dax devices on region0 to system-ram mode
> +----
> +# daxctl reconfigure-device --mode=system-ram --region=0 all
> +[
> +  {
> +    "chardev":"dax0.0",
> +    "size":16777216000,
> +    "target_node":2,
> +    "mode":"system-ram"
> +  },
> +  {
> +    "chardev":"dax0.1",
> +    "size":16777216000,
> +    "target_node":3,
> +    "mode":"system-ram"
> +  }
> +]
> +----
> +
> +* Run a process called 'some-service' using numactl to restrict its cpu
> +nodes to '0' and '1', and  memory allocations to node 2 (determined using
> +daxctl_dev_get_target_node() or 'daxctl list')
> +----
> +# daxctl reconfigure-device --mode=system-ram --no-online dax0.0

Any reason to use --no-online in this example? Presumably some-service
may not start if node2 has no online memory.


> +[
> +  {
> +    "chardev":"dax0.0",
> +    "size":16777216000,
> +    "target_node":2,
> +    "mode":"system-ram"
> +  }
> +]
> +
> +# numactl --cpunodebind=0-1 --membind=2 -- some-service --opt1 --opt2
> +----
> +
> +DESCRIPTION
> +-----------
> +
> +Reconfigure the operational mode of a dax device. This can be used to convert
> +a regular 'devdax' mode device to the 'system-ram' mode which allows for the dax

s/allows/arranges/

> +range to be hot-plugged into the system as regular memory.
> +
> +NOTE: This is a destructive operation. Any data on the dax device *will* be
> +lost.
> +
> +NOTE: Device reconfiguration depends on the dax-bus device model. If dax-class is
> +in use (via the dax_pmem_compat driver), the reconfiguration will fail. See
> +linkdaxctl:daxctl-migrate-device-model[1] for more information.

Let's make sure that do_reconfig() bails with a common error message
for the compat case and quote that message here. You can check that by
comparing the device path 'subsystem' to /sys/class/dax. I.e.

# ls -l /dev/dax0.0
crw------- 1 root root 253, 4 Jul 25 12:22 /dev/dax0.0

# readlink -f /sys/dev/char/253\:4/subsystem
/sys/class/dax

...it will be /sys/bus/dax otherwise.

> +
> +OPTIONS
> +-------
> +-r::
> +--region=::
> +       Restrict the operation to devices belonging to the specified region(s).
> +       A device-dax region is a contiguous range of memory that hosts one or
> +       more /dev/daxX.Y devices, where X is the region id and Y is the device
> +       instance id.
> +
> +-m::
> +--mode=::
> +       Specify the mode to which the dax device(s) should be reconfigured.
> +       - "system-ram": hotplug the device into system memory.
> +
> +       - "devdax": switch to the normal "device dax" mode. This requires the
> +         kernel to support hot-unplugging 'kmem' based memory. If this is not
> +         available, a reboot is the only way to switch back to 'devdax' mode.
> +
> +-N::
> +--no-online::
> +       By default, memory sections provided by system-ram devices will be
> +       brought online automatically and immediately with the 'online_movable'
> +       policy. Use this option to disable the automatic onlining behavior.

Probably need to mention that the system might online the memory even
if this is specified, or for extra credit, coordinate with that
auto-online facility to arrange for it to be skipped.

> +
> +-O::
> +--attempt-offline::
> +       When converting from "system-ram" mode to "devdax", it is expected
> +       that all the memory sections are first made offline. By default,
> +       daxctl won't touch online memory. However with this option, attempt
> +       to offline the memory on the NUMA node associated with the dax device
> +       before converting it back to "devdax" mode.

As mentioned in patch 7, this sounds like --force to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
