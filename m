Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com
 [IPv6:2607:f8b0:4864:20::832])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D4A7212017C8
 for <linux-nvdimm@lists.01.org>; Sat, 20 Apr 2019 08:31:52 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id s15so8190839qtn.3
 for <linux-nvdimm@lists.01.org>; Sat, 20 Apr 2019 08:31:52 -0700 (PDT)
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: [v1 0/2] "Hotremove" persistent memory
Date: Sat, 20 Apr 2019 11:31:46 -0400
Message-Id: <20190420153148.21548-1-pasha.tatashin@soleen.com>
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
To: pasha.tatashin@soleen.com, jmorris@namei.org, sashal@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, akpm@linux-foundation.org, mhocko@suse.com, dave.hansen@linux.intel.com, dan.j.williams@intel.com, keith.busch@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, zwisler@kernel.org, thomas.lendacky@amd.com, ying.huang@intel.com, fengguang.wu@intel.com, bp@suse.de, bhelgaas@google.com, baiyaowei@cmss.chinamobile.com, tiwai@suse.de, jglisse@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Recently, adding a persistent memory to be used like a regular RAM was
added to Linux. This work extends this functionality to also allow hot
removing persistent memory.

We (Microsoft) have a very important use case for this functionality.

The requirement is for physical machines with small amount of RAM (~8G)
to be able to reboot in a very short period of time (<1s). Yet, there is
a userland state that is expensive to recreate (~2G).

The solution is to boot machines with 2G preserved for persistent
memory.

Copy the state, and hotadd the persistent memory so machine still has all
8G for runtime. Before reboot, hotremove device-dax 2G, copy the memory
that is needed to be preserved to pmem0 device, and reboot.

The series of operations look like this:

	1. After boot restore /dev/pmem0 to boot
	2. Convert raw pmem0 to devdax
	ndctl create-namespace --mode devdax --map mem -e namespace0.0 -f
	3. Hotadd to System RAM 
	echo dax0.0 > /sys/bus/dax/drivers/device_dax/unbind
	echo dax0.0 > /sys/bus/dax/drivers/kmem/new_id
	4. Before reboot hotremove device-dax memory from System RAM
	echo dax0.0 > /sys/bus/dax/drivers/kmem/unbind
	5. Create raw pmem0 device
	ndctl create-namespace --mode raw  -e namespace0.0 -f
	6. Copy the state to this device
	7. Do kexec reboot, or reboot through firmware, is firmware does not
	zero memory in pmem region.

Pavel Tatashin (2):
  device-dax: fix memory and resource leak if hotplug fails
  device-dax: "Hotremove" persistent memory that is used like normal RAM

 drivers/dax/dax-private.h |  2 +
 drivers/dax/kmem.c        | 82 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 79 insertions(+), 5 deletions(-)

-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
