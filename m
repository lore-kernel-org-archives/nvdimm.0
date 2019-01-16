Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACE08211B76C7
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 10:25:38 -0800 (PST)
Subject: [PATCH 0/4] Allow persistent memory to be used like normal RAM
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 16 Jan 2019 10:18:59 -0800
Message-Id: <20190116181859.D1504459@viggo.jf.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dave@sr71.net
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, tiwai@suse.de, Dave Hansen <dave.hansen@linux.intel.com>, ying.huang@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

I would like to get this queued up to get merged.  Since most of the
churn is in the nvdimm code, and it also depends on some refactoring
that only exists in the nvdimm tree, it seems like putting it in *via*
the nvdimm tree is the best path.

But, this series makes non-trivial changes to the "resource" code and
memory hotplug.  I'd really like to get some acks from folks on the
first three patches which affect those areas.

Borislav and Bjorn, you seem to be the most active in the resource code.

Michal, I'd really appreciate at look at all of this from a mem hotplug
perspective.

Note: these are based on commit d2f33c19644 in:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git libnvdimm-pending

Changes since v1:
 * Now based on git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git
 * Use binding/unbinding from "dax bus" code
 * Move over to a "dax bus" driver from being an nvdimm driver

--

Persistent memory is cool.  But, currently, you have to rewrite
your applications to use it.  Wouldn't it be cool if you could
just have it show up in your system like normal RAM and get to
it like a slow blob of memory?  Well... have I got the patch
series for you!

This series adds a new "driver" to which pmem devices can be
attached.  Once attached, the memory "owned" by the device is
hot-added to the kernel and managed like any other memory.  On
systems with an HMAT (a new ACPI table), each socket (roughly)
will have a separate NUMA node for its persistent memory so
this newly-added memory can be selected by its unique NUMA
node.

Here's how I set up a system to test this thing:

1. Boot qemu with lots of memory: "-m 4096", for instance
2. Reserve 512MB of physical memory.  Reserving a spot a 2GB
   physical seems to work: memmap=512M!0x0000000080000000
   This will end up looking like a pmem device at boot.
3. When booted, convert fsdax device to "device dax":
	ndctl create-namespace -fe namespace0.0 -m dax
4. See patch 4 for instructions on binding the kmem driver
   to a device.
5. Now, online the new memory sections.  Perhaps:

grep ^MemTotal /proc/meminfo
for f in `grep -vl online /sys/devices/system/memory/*/state`; do
	echo $f: `cat $f`
	echo online_movable > $f
	grep ^MemTotal /proc/meminfo
done

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Huang Ying <ying.huang@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Takashi Iwai <tiwai@suse.de>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
