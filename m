Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F38E211D0C8A
 for <linux-nvdimm@lists.01.org>; Sun, 10 Mar 2019 12:54:14 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id z19so2178183otm.2
 for <linux-nvdimm@lists.01.org>; Sun, 10 Mar 2019 12:54:14 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 10 Mar 2019 12:54:01 -0700
Message-ID: <CAPcyv4he0q_FdqqiXarp0bXjcggs8QZX8Od560E2iFxzCU3Qag@mail.gmail.com>
Subject: [GIT PULL] device-dax for 5.1: PMEM as RAM
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/devdax-for-5.1

...to receive new device-dax infrastructure to allow persistent memory
and other "reserved" / performance differentiated memories, to be
assigned to the core-mm as "System RAM".

While it has soaked in -next with only a simple conflict reported, and
Michal looked at this and said "overall design of this feature makes a
lot of sense to me" [1], it's lacking non-Intel review/ack tags. For
that reason, here's some more commentary on the motivation and
implications:

[1]: https://lore.kernel.org/lkml/20190123170518.GC4087@dhcp22.suse.cz/

Some users want to use persistent memory as additional volatile
memory. They are willing to cope with potential performance
differences, for example between DRAM and 3D Xpoint, and want to use
typical Linux memory management apis rather than a userspace memory
allocator layered over an mmap() of a dax file. The administration
model is to decide how much Persistent Memory (pmem) to use as System
RAM, create a device-dax-mode namespace of that size, and then assign
it to the core-mm. The rationale for device-dax is that it is a
generic memory-mapping driver that can be layered over any "special
purpose" memory, not just pmem. On subsequent boots udev rules can be
used to restore the memory assignment.

One implication of using pmem as RAM is that mlock() no longer keeps
data off persistent media. For this reason it is recommended to enable
NVDIMM Security (previously merged for 5.0) to encrypt pmem contents
at rest. We considered making this recommendation an actively enforced
requirement, but in the end decided to leave it as a distribution /
administrator policy to allow for emulation and test environments that
lack security capable NVDIMMs.

Here is the resolution for the aforementioned conflict:

diff --cc mm/memory_hotplug.c
index a9d5787044e1,b37f3a5c4833..c4f59ac21014
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@@ -102,28 -99,21 +102,24 @@@ u64 max_mem_size = U64_MAX
  /* add this memory to iomem resource */
  static struct resource *register_memory_resource(u64 start, u64 size)
  {
-       struct resource *res, *conflict;
+       struct resource *res;
+       unsigned long flags =  IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
+       char *resource_name = "System RAM";

 +      if (start + size > max_mem_size)
 +              return ERR_PTR(-E2BIG);
 +
-       res = kzalloc(sizeof(struct resource), GFP_KERNEL);
-       if (!res)
-               return ERR_PTR(-ENOMEM);
-
-       res->name = "System RAM";
-       res->start = start;
-       res->end = start + size - 1;
-       res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
-       conflict =  request_resource_conflict(&iomem_resource, res);
-       if (conflict) {
-               if (conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
-                       pr_debug("Device unaddressable memory block "
-                                "memory hotplug at %#010llx !\n",
-                                (unsigned long long)start);
-               }
-               pr_debug("System RAM resource %pR cannot be added\n", res);
-               kfree(res);
+       /*
+        * Request ownership of the new memory range.  This might be
+        * a child of an existing resource that was present but
+        * not marked as busy.
+        */
+       res = __request_region(&iomem_resource, start, size,
+                              resource_name, flags);
+
+       if (!res) {
+               pr_debug("Unable to reserve System RAM region:
%016llx->%016llx\n",
+                               start, start + size);
                return ERR_PTR(-EEXIST);
        }
        return res;


* Note, I'm sending this with Gmail rather than Evolution (which goes
through my local Exchange server) as the latter mangles the message
into something the pr-tracker-bot decides to ignore. As a result,
please forgive white-space damage.

---

The following changes since commit bfeffd155283772bbe78c6a05dec7c0128ee500c:

  Linux 5.0-rc1 (2019-01-06 17:08:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/devdax-for-5.1

for you to fetch changes up to c221c0b0308fd01d9fb33a16f64d2fd95f8830a4:

  device-dax: "Hotplug" persistent memory for use like normal RAM
(2019-02-28 10:41:23 -0800)

----------------------------------------------------------------
device-dax for 5.1
* Replace the /sys/class/dax device model with /sys/bus/dax, and include
  a compat driver so distributions can opt-in to the new ABI.

* Allow for an alternative driver for the device-dax address-range

* Introduce the 'kmem' driver to hotplug / assign a device-dax
  address-range to the core-mm.

* Arrange for the device-dax target-node to be onlined so that the newly
  added memory range can be uniquely referenced by numa apis.

----------------------------------------------------------------
Dan Williams (11):
      device-dax: Kill dax_region ida
      device-dax: Kill dax_region base
      device-dax: Remove multi-resource infrastructure
      device-dax: Start defining a dax bus model
      device-dax: Introduce bus + driver model
      device-dax: Move resource pinning+mapping into the common driver
      device-dax: Add support for a dax override driver
      device-dax: Add /sys/class/dax backwards compatibility
      acpi/nfit, device-dax: Identify differentiated memory with a
unique numa-node
      device-dax: Auto-bind device after successful new_id
      device-dax: Add a 'target_node' attribute

Dave Hansen (5):
      mm/resource: Return real error codes from walk failures
      mm/resource: Move HMM pr_debug() deeper into resource code
      mm/memory-hotplug: Allow memory resources to be children
      mm/resource: Let walk_system_ram_range() search child resources
      device-dax: "Hotplug" persistent memory for use like normal RAM

Vishal Verma (1):
      device-dax: Add a 'modalias' attribute to DAX 'bus' devices

 Documentation/ABI/obsolete/sysfs-class-dax |  22 ++
 arch/powerpc/platforms/pseries/papr_scm.c  |   1 +
 drivers/acpi/nfit/core.c                   |   8 +-
 drivers/acpi/numa.c                        |   1 +
 drivers/base/memory.c                      |   1 +
 drivers/dax/Kconfig                        |  28 +-
 drivers/dax/Makefile                       |   6 +-
 drivers/dax/bus.c                          | 503 +++++++++++++++++++++++++++++
 drivers/dax/bus.h                          |  61 ++++
 drivers/dax/dax-private.h                  |  34 +-
 drivers/dax/dax.h                          |  18 --
 drivers/dax/device-dax.h                   |  25 --
 drivers/dax/device.c                       | 363 +++++----------------
 drivers/dax/kmem.c                         | 108 +++++++
 drivers/dax/pmem.c                         | 153 ---------
 drivers/dax/pmem/Makefile                  |   7 +
 drivers/dax/pmem/compat.c                  |  73 +++++
 drivers/dax/pmem/core.c                    |  71 ++++
 drivers/dax/pmem/pmem.c                    |  40 +++
 drivers/dax/super.c                        |  41 ++-
 drivers/nvdimm/e820.c                      |   1 +
 drivers/nvdimm/nd.h                        |   2 +-
 drivers/nvdimm/of_pmem.c                   |   1 +
 drivers/nvdimm/region_devs.c               |   1 +
 include/linux/acpi.h                       |   5 +
 include/linux/libnvdimm.h                  |   1 +
 kernel/resource.c                          |  18 +-
 mm/memory_hotplug.c                        |  33 +-
 tools/testing/nvdimm/Kbuild                |   7 +-
 tools/testing/nvdimm/dax-dev.c             |  16 +-
 30 files changed, 1112 insertions(+), 537 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-class-dax
 create mode 100644 drivers/dax/bus.c
 create mode 100644 drivers/dax/bus.h
 delete mode 100644 drivers/dax/dax.h
 delete mode 100644 drivers/dax/device-dax.h
 create mode 100644 drivers/dax/kmem.c
 delete mode 100644 drivers/dax/pmem.c
 create mode 100644 drivers/dax/pmem/Makefile
 create mode 100644 drivers/dax/pmem/compat.c
 create mode 100644 drivers/dax/pmem/core.c
 create mode 100644 drivers/dax/pmem/pmem.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
