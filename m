Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F085E12E63
	for <nvdimm@lists.linux.dev>; Thu, 14 Dec 2023 07:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iw0XTlS8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702539494; x=1734075494;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=s2pn4yZl0XYTp65Nn5lvuI7n/QI1GItpUEXHrwpjM9A=;
  b=iw0XTlS8y86AZMKD2fwozFSItYGV8p2bq7tehboyNkQNfKobPgKyLyH/
   /amxPkt1epQO76UX8MnswoEcdHoqysiaQjHNnWeszIInBa2A0aHKAiehX
   eGGPOx3ZqOX7bTYghdfy6Lfwf3zsmZcC3J5SH7YMXgVmzU5L+iHb9+rNE
   zTPjtqQvzBD6Q0JJRosef9m5RE6jK4uKkijuZ8nLGfx1sSO41aJZuC2Bv
   vLa6HORUvBYWnAnuiD7xiSjzXw4NMgkWSr2V0qSwbyE+ryZW5NZCA2OSr
   WS5MZ4FqAvYTNEFO+yd6NiJdLcvFHTmnfg5mVQp/HT830hOVmwFMoHS0Z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="481275508"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="481275508"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 23:38:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="723972059"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="723972059"
Received: from llblake-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.191.124])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 23:38:11 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 14 Dec 2023 00:37:54 -0700
Subject: [PATCH v5 1/4] Documentatiion/ABI: Add ABI documentation for
 sys-bus-dax
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231214-vv-dax_abi-v5-1-3f7b006960b4@intel.com>
References: <20231214-vv-dax_abi-v5-0-3f7b006960b4@intel.com>
In-Reply-To: <20231214-vv-dax_abi-v5-0-3f7b006960b4@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Huang Ying <ying.huang@intel.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org
X-Mailer: b4 0.13-dev-433a8
X-Developer-Signature: v=1; a=openpgp-sha256; l=5934;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=s2pn4yZl0XYTp65Nn5lvuI7n/QI1GItpUEXHrwpjM9A=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKlVGx4VxXeVLzrzw/Rzevi5Y9KH3GbOf7RvZum9o3Ouq
 E1sv6TV21HKwiDGxSArpsjyd89HxmNy2/N5AhMcYeawMoEMYeDiFICJ2Isx/OHn+2U8ea3O/vwu
 Tesphzmq5lYYaJ1peJkQ9+FcOvPT7GhGhs2HTzq8qm+IF3kimLko9v/0y/bhllrfTy0IN5ZJ/lB
 7hQsA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Add the missing sysfs ABI documentation for the device DAX subsystem.
Various ABI attributes under this have been present since v5.1, and more
have been added over time. In preparation for adding a new attribute,
add this file with the historical details.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-dax | 136 ++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
new file mode 100644
index 000000000000..6359f7bc9bf4
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -0,0 +1,136 @@
+What:		/sys/bus/dax/devices/daxX.Y/align
+Date:		October, 2020
+KernelVersion:	v5.10
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Provides a way to specify an alignment for a dax device.
+		Values allowed are constrained by the physical address ranges
+		that back the dax device, and also by arch requirements.
+
+What:		/sys/bus/dax/devices/daxX.Y/mapping
+Date:		October, 2020
+KernelVersion:	v5.10
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(WO) Provides a way to allocate a mapping range under a dax
+		device. Specified in the format <start>-<end>.
+
+What:		/sys/bus/dax/devices/daxX.Y/mapping[0..N]/start
+What:		/sys/bus/dax/devices/daxX.Y/mapping[0..N]/end
+What:		/sys/bus/dax/devices/daxX.Y/mapping[0..N]/page_offset
+Date:		October, 2020
+KernelVersion:	v5.10
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RO) A dax device may have multiple constituent discontiguous
+		address ranges. These are represented by the different
+		'mappingX' subdirectories. The 'start' attribute indicates the
+		start physical address for the given range. The 'end' attribute
+		indicates the end physical address for the given range. The
+		'page_offset' attribute indicates the offset of the current
+		range in the dax device.
+
+What:		/sys/bus/dax/devices/daxX.Y/resource
+Date:		June, 2019
+KernelVersion:	v5.3
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RO) The resource attribute indicates the starting physical
+		address of a dax device. In case of a device with multiple
+		constituent ranges, it indicates the starting address of the
+		first range.
+
+What:		/sys/bus/dax/devices/daxX.Y/size
+Date:		October, 2020
+KernelVersion:	v5.10
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) The size attribute indicates the total size of a dax
+		device. For creating subdivided dax devices, or for resizing
+		an existing device, the new size can be written to this as
+		part of the reconfiguration process.
+
+What:		/sys/bus/dax/devices/daxX.Y/numa_node
+Date:		November, 2019
+KernelVersion:	v5.5
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RO) If NUMA is enabled and the platform has affinitized the
+		backing device for this dax device, emit the CPU node
+		affinity for this device.
+
+What:		/sys/bus/dax/devices/daxX.Y/target_node
+Date:		February, 2019
+KernelVersion:	v5.1
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RO) The target-node attribute is the Linux numa-node that a
+		device-dax instance may create when it is online. Prior to
+		being online the device's 'numa_node' property reflects the
+		closest online cpu node which is the typical expectation of a
+		device 'numa_node'. Once it is online it becomes its own
+		distinct numa node.
+
+What:		$(readlink -f /sys/bus/dax/devices/daxX.Y)/../dax_region/available_size
+Date:		October, 2020
+KernelVersion:	v5.10
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RO) The available_size attribute tracks available dax region
+		capacity. This only applies to volatile hmem devices, not pmem
+		devices, since pmem devices are defined by nvdimm namespace
+		boundaries.
+
+What:		$(readlink -f /sys/bus/dax/devices/daxX.Y)/../dax_region/size
+Date:		July, 2017
+KernelVersion:	v5.1
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RO) The size attribute indicates the size of a given dax region
+		in bytes.
+
+What:		$(readlink -f /sys/bus/dax/devices/daxX.Y)/../dax_region/align
+Date:		October, 2020
+KernelVersion:	v5.10
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RO) The align attribute indicates alignment of the dax region.
+		Changes on align may not always be valid, when say certain
+		mappings were created with 2M and then we switch to 1G. This
+		validates all ranges against the new value being attempted, post
+		resizing.
+
+What:		$(readlink -f /sys/bus/dax/devices/daxX.Y)/../dax_region/seed
+Date:		October, 2020
+KernelVersion:	v5.10
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RO) The seed device is a concept for dynamic dax regions to be
+		able to split the region amongst multiple sub-instances.  The
+		seed device, similar to libnvdimm seed devices, is a device
+		that starts with zero capacity allocated and unbound to a
+		driver.
+
+What:		$(readlink -f /sys/bus/dax/devices/daxX.Y)/../dax_region/create
+Date:		October, 2020
+KernelVersion:	v5.10
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) The create interface to the dax region provides a way to
+		create a new unconfigured dax device under the given region, which
+		can then be configured (with a size etc.) and then probed.
+
+What:		$(readlink -f /sys/bus/dax/devices/daxX.Y)/../dax_region/delete
+Date:		October, 2020
+KernelVersion:	v5.10
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(WO) The delete interface for a dax region provides for deletion
+		of any 0-sized and idle dax devices.
+
+What:		$(readlink -f /sys/bus/dax/devices/daxX.Y)/../dax_region/id
+Date:		July, 2017
+KernelVersion:	v5.1
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RO) The id attribute indicates the region id of a dax region.

-- 
2.41.0

