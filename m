Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A294E20954CA2
 for <linux-nvdimm@lists.01.org>; Mon, 19 Feb 2018 10:02:04 -0800 (PST)
Received: by mail-pg0-x242.google.com with SMTP id g12so6165080pgs.0
 for <linux-nvdimm@lists.01.org>; Mon, 19 Feb 2018 10:08:01 -0800 (PST)
Date: Mon, 19 Feb 2018 23:37:54 +0530
From: Aishwarya Pant <aishpant@gmail.com>
Subject: [PATCH] acpi: nfit: document sysfs interface
Message-ID: <20180219180754.GA31007@mordor.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Greg KH <gregkh@linuxfoundation.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>
List-ID: <linux-nvdimm@lists.01.org>

This is an attempt to document the nfit sysfs interface. The
descriptions have been collected from git commit logs and the ACPI
specification 6.2. There are still two undocumented attributes-
range_index and ecc_unit_size, for which I couldn't collect complete
information.

Signed-off-by: Aishwarya Pant <aishpant@gmail.com>
---
 Documentation/ABI/testing/sysfs-bus-nfit | 202 +++++++++++++++++++++++++++++++
 1 file changed, 202 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-nfit

diff --git a/Documentation/ABI/testing/sysfs-bus-nfit b/Documentation/ABI/testing/sysfs-bus-nfit
new file mode 100644
index 000000000000..758d8d0d4c37
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-nfit
@@ -0,0 +1,202 @@
+What:		/sys/bus/nd/devices/nmemX/nfit/serial
+Date:		Apr, 2015
+KernelVersion:	v4.1
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Serial number of the NVDIMM (non-volatile dual in-line
+		memory module), assigned by the module vendor.
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/handle
+Date:		Apr, 2015
+KernelVersion:	v4.1
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) The address (given by the _ADR object) of the device on its
+		parent bus of the NVDIMM device containing the NVDIMM region.
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/device
+Date:		Apr, 2015
+KernelVersion:	v4.1
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Identifier for the NVDIMM, assigned by the module vendor.
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/rev_id
+Date:		Apr, 2015
+KernelVersion:	v4.1
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Revision of the NVDIMM, assigned by the module vendor.
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/phys_id
+Date:		Apr, 2015
+KernelVersion:	v4.1
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Handle (i.e., instance number) for the SMBIOS (system
+		management BIOS) Memory Device structure describing the NVDIMM
+		containing the NVDIMM region.
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/flags
+Date:		Jun, 2015
+KernelVersion:	v4.1
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) The flags in the NFIT memory device sub-structure indicate
+		the state of the data on the nvdimm relative to its energy
+		source or last "flush to persistence".
+
+		The attribute is a translation of the 'NVDIMM State Flags' field
+		in section 5.2.25.3 'NVDIMM Region Mapping' Structure of the
+		ACPI specification 6.2.
+
+		The health states are "save_fail", "restore_fail", "flush_fail",
+		"not_armed", "smart_event", "map_fail" and "smart_notify".
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/format
+What:		/sys/bus/nd/devices/nmemX/nfit/format1
+What:		/sys/bus/nd/devices/nmemX/nfit/formats
+Date:		Apr, 2016
+KernelVersion:	v4.6
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Identifiers for the programming interface. Starting with
+		ACPI 6.1 an NFIT table reports multiple 'NVDIMM Control Region
+		Structure' instances per-dimm, one for each supported format
+		interface. That code is represented in the sysfs as follows:
+		nmemX/nfit/formats, nmemX/nfit/format, nmemX/nfit/format1,
+		nmemX/nfit/format2 ... nmemX/nfit/formatN, where format2 -
+		formatN are theoretical as there are no known DIMMs with support
+		for more than two interface formats. The 'formats' attribute
+		displays the number of supported interfaces.
+
+		This layout is compatible with existing libndctl binaries that
+		only expect one code per-dimm as they will ignore
+		nmemX/nfit/formats and nmemX/nfit/formatN.
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/vendor
+Date:		Apr, 2016
+KernelVersion:	v4.6
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Identifier indicating the vendor of the NVDIMM.
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/dsm_mask
+Date:		Apr, 2016
+KernelVersion:	v4.6
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) The bitmask indicates the supported device specific control
+		functions.
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/family
+Date:		Apr, 2016
+KernelVersion:	v4.6
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Displays the NVDIMM family (and the command sets). Values
+		0, 1, 2 and 3 correspond to NVDIMM_FAMILY_INTEL,
+		NVDIMM_FAMILY_HPE1, NVDIMM_FAMILY_HPE2 and NVDIMM_FAMILY_MSFT
+		respectively.
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/id
+Date:		Apr, 2016
+KernelVersion:	v4.6
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) ACPI specification 6.2 section 5.2.25.9, defines an
+		identifier for an NVDIMM, which refelects the id attribute.
+
+		If the manufacturing location and manufacturing date fields are
+		valid, then 'id' is composed of the vendor id (bytes 0-1),
+		manufacturing location byte, manufacturing date (bytes 0-1) and
+		the serial number(bytes 0-3), otherwise it is composed of vendor
+		id (bytes 0-1) and serial number (bytes 0-3)
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/subsystem_vendor
+Date:		Apr, 2016
+KernelVersion:	v4.6
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Vendor of the NVDIMM non-volatile memory subsystem
+		controller.
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/subsystem_rev_id
+Date:		Apr, 2016
+KernelVersion:	v4.6
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Revision of the NVDIMM non-volatile memory subsystem
+		controller, assigned by the non-volatile memory subsystem
+		controller vendor.
+
+
+What:		/sys/bus/nd/devices/nmemX/nfit/subsystem_device
+Date:		Apr, 2016
+KernelVersion:	v4.6
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Identifier for the NVDIMM non-volatile memory subsystem
+		controller, assigned by the non-volatile memory subsystem
+		controller vendor.
+
+
+What:		/sys/bus/nd/devices/ndbusX/nfit/revision
+Date:		Apr, 2015
+KernelVersion:	v4.1
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) ACPI Specification minor version number.
+
+
+What:		/sys/bus/nd/devices/ndbusX/nfit/scrub
+Date:		Sep, 2016
+KernelVersion:	v4.8
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RW) This shows the number of full Address Range Scrubs (ARS)
+		that have been completed since driver load time. Userspace can
+		wait on this using select/poll etc. A '+' at the end indicates
+		an ARS is in progress
+
+		Writing a value of 1 triggers an ARS scan.
+
+
+What:		/sys/bus/nd/devices/ndbusX/nfit/hw_error_scrub
+Date:		Sep, 2016
+KernelVersion:	v4.8
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RW) Provides a way to toggle the behavior between just adding
+		the address (cache line) where the MCE happened to the poison
+		list and doing a full scrub. The former (selective insertion of
+		the address) is done unconditionally.
+
+		This attribute can have the following values written to it:
+
+		'0': Switch to the default mode where an exception will only
+		insert the address of the memory error into the poison and
+		badblocks lists.
+		'1': Enable a full scrub to happen if an exception for a memory
+		error is received.
+
+
+What:		/sys/bus/nd/devices/ndbusX/nfit/dsm_mask
+Date:		Jun, 2017
+KernelVersion:	v4.12
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) The bitmask indicates the supported bus specific control
+		functions.
-- 
2.16.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
