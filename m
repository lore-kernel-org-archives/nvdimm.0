Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39CDE2034D8D3
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 15:40:08 -0800 (PST)
Received: by mail-oi0-x242.google.com with SMTP id f186so2453746oig.4
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 15:46:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180219180754.GA31007@mordor.localdomain>
References: <20180219180754.GA31007@mordor.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Feb 2018 15:46:06 -0800
Message-ID: <CAPcyv4iQzEeZO-LYPvKQJHzrb3mrgENWZdnH2LzDV49tyfNM2Q@mail.gmail.com>
Subject: Re: [PATCH] acpi: nfit: document sysfs interface
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
To: Aishwarya Pant <aishpant@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Jonathan Corbet <corbet@lwn.net>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Wow, thank you for taking a look at this! Always nice to get an
unexpected documentation gift. Some comments below:

On Mon, Feb 19, 2018 at 10:07 AM, Aishwarya Pant <aishpant@gmail.com> wrote:
> This is an attempt to document the nfit sysfs interface. The
> descriptions have been collected from git commit logs and the ACPI
> specification 6.2. There are still two undocumented attributes-
> range_index and ecc_unit_size, for which I couldn't collect complete
> information.

'range_index' is taken directly from the ACPI specification. It's a
unique number provided by the BIOS to identify an address range.
Here's a quote from ACPI 6.2a [1] section '5.2.25.2 System Physical
Address (SPA) Range Structure' "SPA Range Structure Index: Used by
NVDIMM Region Mapping Structure to uniquely refer to this structure.
Value of 0 is Reserved and shall not be used as an index."

'ecc_unit_size' is the size of a write request to a DIMM that will not
incur a read-modify-write cycle at the memory controller. More details
from the commit log here [2]

[1]: http://www.uefi.org/sites/default/files/resources/ACPI%206_2_A_Sept29.pdf
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a15797f4bef

>
> Signed-off-by: Aishwarya Pant <aishpant@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-nfit | 202 +++++++++++++++++++++++++++++++
>  1 file changed, 202 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-nfit
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-nfit b/Documentation/ABI/testing/sysfs-bus-nfit
> new file mode 100644
> index 000000000000..758d8d0d4c37
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-nfit
> @@ -0,0 +1,202 @@
> +What:          /sys/bus/nd/devices/nmemX/nfit/serial
> +Date:          Apr, 2015
> +KernelVersion: v4.1
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) Serial number of the NVDIMM (non-volatile dual in-line
> +               memory module), assigned by the module vendor.

For all of these nfit/* attributes it would be helpful to include a
reference to the ACPI specification. I.e. for all of these nfit/*
attributes add a sentence "See the 'NVDIMM Firmware Interface Table
(NFIT)' section in the ACPI specification
(http://www.uefi.org/specifications) for more details.".

> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/handle
> +Date:          Apr, 2015
> +KernelVersion: v4.1
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) The address (given by the _ADR object) of the device on its
> +               parent bus of the NVDIMM device containing the NVDIMM region.
> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/device
> +Date:          Apr, 2015
> +KernelVersion: v4.1
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) Identifier for the NVDIMM, assigned by the module vendor.

s/Identifier/Device Id/

> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/rev_id
> +Date:          Apr, 2015
> +KernelVersion: v4.1
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) Revision of the NVDIMM, assigned by the module vendor.
> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/phys_id
> +Date:          Apr, 2015
> +KernelVersion: v4.1
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) Handle (i.e., instance number) for the SMBIOS (system
> +               management BIOS) Memory Device structure describing the NVDIMM
> +               containing the NVDIMM region.
> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/flags
> +Date:          Jun, 2015
> +KernelVersion: v4.1
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) The flags in the NFIT memory device sub-structure indicate
> +               the state of the data on the nvdimm relative to its energy
> +               source or last "flush to persistence".
> +
> +               The attribute is a translation of the 'NVDIMM State Flags' field
> +               in section 5.2.25.3 'NVDIMM Region Mapping' Structure of the
> +               ACPI specification 6.2.
> +
> +               The health states are "save_fail", "restore_fail", "flush_fail",
> +               "not_armed", "smart_event", "map_fail" and "smart_notify".
> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/format
> +What:          /sys/bus/nd/devices/nmemX/nfit/format1
> +What:          /sys/bus/nd/devices/nmemX/nfit/formats
> +Date:          Apr, 2016
> +KernelVersion: v4.6
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) Identifiers for the programming interface. Starting with

"Identifiers for one or more programming interfaces, format interface
codes, supported by the NVDIMM."

> +               ACPI 6.1 an NFIT table reports multiple 'NVDIMM Control Region
> +               Structure' instances per-dimm, one for each supported format
> +               interface. That code is represented in the sysfs as follows:
> +               nmemX/nfit/formats, nmemX/nfit/format, nmemX/nfit/format1,
> +               nmemX/nfit/format2 ... nmemX/nfit/formatN, where format2 -
> +               formatN are theoretical as there are no known DIMMs with support
> +               for more than two interface formats.

I'd delete the above since those are kernel / specification
implementation details that don't help explain what the attribute is.

>                  The 'formats' attribute
> +               displays the number of supported interfaces.

"The interface codes indicate support for persistent memory mapped
directly into system physical address space and / or a block aperture
access mechanism to the NVDIMM media."

> +
> +               This layout is compatible with existing libndctl binaries that
> +               only expect one code per-dimm as they will ignore
> +               nmemX/nfit/formats and nmemX/nfit/formatN.
> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/vendor
> +Date:          Apr, 2016
> +KernelVersion: v4.6
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) Identifier indicating the vendor of the NVDIMM.
> +

s/Identifier indicating the vendor/Vendor Id/

> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/dsm_mask
> +Date:          Apr, 2016
> +KernelVersion: v4.6
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) The bitmask indicates the supported device specific control
> +               functions.

s/functions/functions relative to the NVDIMM command family supported
by the device./

> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/family
> +Date:          Apr, 2016
> +KernelVersion: v4.6
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) Displays the NVDIMM family (and the command sets). Values

s/and the command sets/command set/

> +               0, 1, 2 and 3 correspond to NVDIMM_FAMILY_INTEL,
> +               NVDIMM_FAMILY_HPE1, NVDIMM_FAMILY_HPE2 and NVDIMM_FAMILY_MSFT
> +               respectively.

"See the specifications for these command families here:
http://pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf
https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/
https://msdn.microsoft.com/library/windows/hardware/mt604741"

> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/id
> +Date:          Apr, 2016
> +KernelVersion: v4.6
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) ACPI specification 6.2 section 5.2.25.9, defines an
> +               identifier for an NVDIMM, which refelects the id attribute.
> +
> +               If the manufacturing location and manufacturing date fields are
> +               valid, then 'id' is composed of the vendor id (bytes 0-1),
> +               manufacturing location byte, manufacturing date (bytes 0-1) and
> +               the serial number(bytes 0-3), otherwise it is composed of vendor
> +               id (bytes 0-1) and serial number (bytes 0-3)

I'd drop this section, this first sentence that refers to the ACPI
section is enough.

> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/subsystem_vendor
> +Date:          Apr, 2016
> +KernelVersion: v4.6
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) Vendor of the NVDIMM non-volatile memory subsystem
> +               controller.

s/Vendor/Sub-system Vendor Id/

> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/subsystem_rev_id
> +Date:          Apr, 2016
> +KernelVersion: v4.6
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) Revision of the NVDIMM non-volatile memory subsystem
> +               controller, assigned by the non-volatile memory subsystem
> +               controller vendor.

s/Revision/Sub-system Revision Id/

> +
> +
> +What:          /sys/bus/nd/devices/nmemX/nfit/subsystem_device
> +Date:          Apr, 2016
> +KernelVersion: v4.6
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) Identifier for the NVDIMM non-volatile memory subsystem
> +               controller, assigned by the non-volatile memory subsystem
> +               controller vendor.

s/Identifier/Sub-system Device Id/

> +
> +
> +What:          /sys/bus/nd/devices/ndbusX/nfit/revision
> +Date:          Apr, 2015
> +KernelVersion: v4.1
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) ACPI Specification minor version number.

"ACPI NFIT table revision number"

> +
> +
> +What:          /sys/bus/nd/devices/ndbusX/nfit/scrub
> +Date:          Sep, 2016
> +KernelVersion: v4.8
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RW) This shows the number of full Address Range Scrubs (ARS)
> +               that have been completed since driver load time. Userspace can
> +               wait on this using select/poll etc. A '+' at the end indicates
> +               an ARS is in progress
> +
> +               Writing a value of 1 triggers an ARS scan.
> +
> +
> +What:          /sys/bus/nd/devices/ndbusX/nfit/hw_error_scrub
> +Date:          Sep, 2016
> +KernelVersion: v4.8
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RW) Provides a way to toggle the behavior between just adding
> +               the address (cache line) where the MCE happened to the poison
> +               list and doing a full scrub. The former (selective insertion of
> +               the address) is done unconditionally.
> +
> +               This attribute can have the following values written to it:
> +
> +               '0': Switch to the default mode where an exception will only
> +               insert the address of the memory error into the poison and
> +               badblocks lists.
> +               '1': Enable a full scrub to happen if an exception for a memory
> +               error is received.
> +
> +
> +What:          /sys/bus/nd/devices/ndbusX/nfit/dsm_mask
> +Date:          Jun, 2017
> +KernelVersion: v4.12
> +Contact:       linux-nvdimm@lists.01.org
> +Description:
> +               (RO) The bitmask indicates the supported bus specific control
> +               functions.

I'd add:

"See the section named 'NVDIMM Root Device _DSMs' in the ACPI specification."

So, this looks great and is something I've had on my backlog for a
while. That said this is a bit incomplete. These attributes are
relative to the the "nd" bus which is the libnvdimm sub-system sysfs
interface. This document describes that sysfs layout [3]. Ideally that
content would be converted into Documentation/ABI format and merged
with what you have done here into an overall
Documentation/ABI/testing/sysfs-bus-nvdimm file.

I realize that's quite a bit more work, so I'm fine if we start with
the nfit attributes and save that follow on work for a separate patch
in the future.

[3]: https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/tree/Documentation/nvdimm/nvdimm.txt?h=libnvdimm-for-next
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
