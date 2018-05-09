Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DD4320965DC7
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 08:55:32 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v2] acpi: nfit: document sysfs interface
Date: Wed, 9 May 2018 15:54:55 +0000
Message-ID: <AT5PR8401MB116920E461A2489D1DA52CB6AB990@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20180223125448.GA16909@mordor.localdomain>
In-Reply-To: <20180223125448.GA16909@mordor.localdomain>
Content-Language: en-US
MIME-Version: 1.0
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
To: Aishwarya Pant <aishpant@gmail.com>, Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Len" Brown" <lenb@kernel.org>, "linux-nvdimm@lists.01.orglinux-nvdimm@lists.01.org, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Greg KH <gregkh@linuxfoundation.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Aishwarya Pant
> Sent: Friday, February 23, 2018 6:55 AM
> To: Dan Williams <dan.j.williams@intel.com>; Rafael J. Wysocki
> <rjw@rjwysocki.net>; Len Brown <lenb@kernel.org>; linux-
> nvdimm@lists.01.org; linux-acpi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Jonathan Corbet <corbet@lwn.net>; Greg KH
> <gregkh@linuxfoundation.org>
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Subject: [PATCH v2] acpi: nfit: document sysfs interface
> 
> This is an attempt to document the nfit sysfs interface. The
> descriptions have been collected from git commit logs and the ACPI
> specification 6.2.
> 
> Signed-off-by: Aishwarya Pant <aishpant@gmail.com>
> ---
> Changes in v2:
> - Add descriptions for range_index and ecc_unit_size
> - Edit various descriptions as suggested
> 
>  Documentation/ABI/testing/sysfs-bus-nfit | 233
> +++++++++++++++++++++++++++++++
>  1 file changed, 233 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-nfit
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-nfit
> b/Documentation/ABI/testing/sysfs-bus-nfit
> new file mode 100644
> index 000000000000..619eb8ca0f99
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-nfit
> @@ -0,0 +1,233 @@
> +For all of the nmem device attributes under nfit/*, see the 'NVDIMM
> Firmware
> +Interface Table (NFIT)' section in the ACPI specification
> +(http://www.uefi.org/specifications) for more details.
> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/serial
> +Date:		Jun, 2015
> +KernelVersion:	v4.2
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) Serial number of the NVDIMM (non-volatile dual in-line
> +		memory module), assigned by the module vendor.

The endianness should be indicated. 

After some churn, I think it is always presented as big-endian now
(originally printed using the CPU's native endianness).

> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/handle
> +Date:		Apr, 2015
> +KernelVersion:	v4.2
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) The address (given by the _ADR object) of the device on
> its
> +		parent bus of the NVDIMM device containing the NVDIMM region.
> +
> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/device
> +Date:		Apr, 2015
> +KernelVersion:	v4.1
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) Device id for the NVDIMM, assigned by the module vendor.

Since "device" is confusing (a problem with the ACPI field name), this should 
state that it is the "Identifier for the NVDIMM", i.e., the module itself,
not some device on the module.

> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/rev_id
> +Date:		Jun, 2015
> +KernelVersion:	v4.2
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) Revision of the NVDIMM, assigned by the module vendor.
> +
> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/phys_id
> +Date:		Apr, 2015
> +KernelVersion:	v4.2
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) Handle (i.e., instance number) for the SMBIOS (system
> +		management BIOS) Memory Device structure describing the NVDIMM
> +		containing the NVDIMM region.

Perhaps mention "dmidecode" as a tool to see the SMBIOS structures?

> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/flags
> +Date:		Jun, 2015
> +KernelVersion:	v4.2
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) The flags in the NFIT memory device sub-structure
> indicate
> +		the state of the data on the nvdimm relative to its energy
> +		source or last "flush to persistence".

Capitalize nvdimm.

The bits in this field are more varied than that description, though,
and you can't predict what future standards will toss into this field.
A more generic description might be better.

> +
> +		The attribute is a translation of the 'NVDIMM State Flags'
> field
> +		in section 5.2.25.3 'NVDIMM Region Mapping' Structure of the
> +		ACPI specification 6.2.
> +
> +		The health states are "save_fail", "restore_fail", "flush_fail",
> +		"not_armed", "smart_event", "map_fail" and "smart_notify".
> +
> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/format
> +What:		/sys/bus/nd/devices/nmemX/nfit/format1
> +What:		/sys/bus/nd/devices/nmemX/nfit/formats
> +Date:		Apr, 2016
> +KernelVersion:	v4.7
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) The interface codes indicate support for persistent
> memory
> +		mapped directly into system physical address space and / or a
> +		block aperture access mechanism to the NVDIMM media.
> +		The 'formats' attribute displays the number of supported
> +		interfaces.
> +
> +		This layout is compatible with existing libndctl binaries that
> +		only expect one code per-dimm as they will ignore
> +		nmemX/nfit/formats and nmemX/nfit/formatN.
> +
> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/vendor
> +Date:		Apr, 2016
> +KernelVersion:	v4.7
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) Vendor id of the NVDIMM.

Clarify that this is a JEDEC manufacturer ID code from JEP106, not an identifier
assigned by the PCI SIG, IEEE, or other organization.

Clarify that it uses the two-byte format defined in JESD21C Page 4.1.2 (the SPD
standard), and that it includes the parity bit.

Suggestion:
"Identifier indicating the vendor of the NVDIMM. This is a JEDEC manufacturer
ID code assigned in JEP106 and expressed in the two-byte format defined in
JESD21C for Serial Presence Data (SPD)."


> +
> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/dsm_mask
> +Date:		May, 2016
> +KernelVersion:	v4.7
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) The bitmask indicates the supported device specific
> control
> +		functions relative to the NVDIMM command family supported by
> the
> +		device

What is the endianness of this bitmask?

> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/family
> +Date:		Apr, 2016
> +KernelVersion:	v4.7
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) Displays the NVDIMM family command sets. Values
> +		0, 1, 2 and 3 correspond to NVDIMM_FAMILY_INTEL,
> +		NVDIMM_FAMILY_HPE1, NVDIMM_FAMILY_HPE2 and NVDIMM_FAMILY_MSFT
> +		respectively.
> +
> +		See the specifications for these command families here:
> +		http://pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf
> +		https://github.com/HewlettPackard/hpe-
> nvm/blob/master/Documentation/
> +		https://msdn.microsoft.com/library/windows/hardware/mt604741"
> +
> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/id
> +Date:		Apr, 2016
> +KernelVersion:	v4.7
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) ACPI specification 6.2 section 5.2.25.9, defines an
> +		identifier for an NVDIMM, which refelects the id attribute.

reflects is spelled wrong.

As time goes by, it might be hard to find a specific old revision of
the specification, and the section numbers will probably have changed.
Refer to the section name ("NVDIMM Representation Format") and provide
other clues.

Suggestion:

An identifier for the NVDIMM using the NVDIMM Representation Format
specified by ACPI.

If the manufacturing location and manufacturing date fields are valid,
this includes the contents of SPD bytes 320 to 328:
      printf format: %02x%02x-%02x-%02x%02x-%02x%02x%02x%02x
	contents:
		JEDEC manufacturer ID byte 0 (including the parity bit)
		JEDEC manufacturer ID byte 1
		manufacturing location
		manufacturing date byte 0: year 
		manufacturing date byte 1: week
		serial number byte 0
		serial number byte 1
		serial number byte 2
		serial number byte 3

If the manufacturing location and manufacturing date fields are not valid,
those are omitted:
      printf format: %02x%02x-%02x%02x%02x%02x
	contents:
		JEDEC manufacturer ID byte 0 (including the parity bit)
		JEDEC manufacturer ID byte 1
		serial number byte 0
		serial number byte 1
		serial number byte 2
		serial number byte 3


> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/subsystem_vendor
> +Date:		Apr, 2016
> +KernelVersion:	v4.7
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) Sub-system vendor id of the NVDIMM non-volatile memory
> +		subsystem controller.

Use
"Vendor of the NVDIMM non-volatile memory subsystem controller. This is a
JEDEC manufacturer ID code assigned in JEP106 and expressed in the two-byte
format defined in JESD21C for Serial Presence Data (SPD)."

> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/subsystem_rev_id
> +Date:		Apr, 2016
> +KernelVersion:	v4.7
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) Sub-system revision id of the NVDIMM non-volatile memory
> subsystem
> +		controller, assigned by the non-volatile memory subsystem
> +		controller vendor.

Use
"Revision of the NVDIMM non-volatile memory subsystem controller, ...".

> +
> +What:		/sys/bus/nd/devices/nmemX/nfit/subsystem_device
> +Date:		Apr, 2016
> +KernelVersion:	v4.7
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) Sub-system device id for the NVDIMM non-volatile memory
> +		subsystem controller, assigned by the non-volatile memory
> +		subsystem controller vendor.

Use
"Identifier for the NVDIMM non-volatile memory subsystem controller, ...".

The "device" and "subsystem" terms can cause confusion because they are
backwards from PCI:
    NVDIMM: the module contains the subsystem
    PCI card: the subsystem contains the device

ACPI uses "Device ID" for a module ID, adding to the confusion.

The best we can do is to overlook the poorly chosen field names and
ensure the definitions of their content is clear.


> +
> +What:		/sys/bus/nd/devices/ndbusX/nfit/revision
> +Date:		Jun, 2015
> +KernelVersion:	v4.2
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) ACPI NFIT table revision number.
> +
> +
> +What:		/sys/bus/nd/devices/ndbusX/nfit/scrub
> +Date:		Sep, 2016
> +KernelVersion:	v4.9
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RW) This shows the number of full Address Range Scrubs (ARS)
> +		that have been completed since driver load time. Userspace can
> +		wait on this using select/poll etc. A '+' at the end indicates
> +		an ARS is in progress
> +
> +		Writing a value of 1 triggers an ARS scan.
> +
> +
> +What:		/sys/bus/nd/devices/ndbusX/nfit/hw_error_scrub
> +Date:		Sep, 2016
> +KernelVersion:	v4.9
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RW) Provides a way to toggle the behavior between just adding
> +		the address (cache line) where the MCE happened to the poison
> +		list and doing a full scrub. The former (selective insertion
> of
> +		the address) is done unconditionally.
> +
> +		This attribute can have the following values written to it:
> +
> +		'0': Switch to the default mode where an exception will only
> +		insert the address of the memory error into the poison and
> +		badblocks lists.
> +		'1': Enable a full scrub to happen if an exception for a
> memory
> +		error is received.
> +
> +
> +What:		/sys/bus/nd/devices/ndbusX/nfit/dsm_mask
> +Date:		Jun, 2017
> +KernelVersion:	v4.13
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) The bitmask indicates the supported bus specific control
> +		functions. See the section named 'NVDIMM Root Device _DSMs' in
> +		the ACPI specification.

What is the endianness of this bitmask?

> +
> +What:		/sys/bus/nd/devices/regionX/nfit/range_index
> +Date:		Jun, 2015
> +KernelVersion:	v4.2
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) A unique number provided by the BIOS to identify an
> address
> +		range. Used by NVDIMM Region Mapping Structure to uniquely
> refer
> +		to this structure. Value of 0 is reserved and not used as an
> +		index.
> +
> +
> +What:		/sys/bus/nd/devices/regionX/nfit/ecc_unit_size
> +Date:		Aug, 2017
> +KernelVersion:	v4.14
> +Contact:	linux-nvdimm@lists.01.org
> +Description:
> +		(RO) Size of a write request to a DIMM that will not incur a
> +		read-modify-write cycle at the memory controller.
> +
> +		When the nfit driver initializes it runs an ARS (Address Range
> +		Scrub) operation across every pmem range. Part of that process
> +		involves determining the ARS capabilities of a given address
> +		range. One of the capabilities that is reported is the 'Clear
> +		Uncorrectable Error Range Length Unit Size' (see: ACPI 6.2
> +		section 9.20.7.4 Function Index 1 - Query ARS Capabilities).
> +		This property indicates the boundary at which the NVDIMM may
> +		need to perform read-modify-write cycles to maintain ECC
> (Error
> +		Correcting Code) blocks.
> --
> 2.16.2
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
