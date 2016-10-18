Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com
 [192.185.145.239])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 713421A1E89
 for <linux-nvdimm@lists.01.org>; Tue, 18 Oct 2016 14:42:32 -0700 (PDT)
Received: from cm4.websitewelcome.com (unknown [108.167.139.16])
 by gateway33.websitewelcome.com (Postfix) with ESMTP id 912A3D669BE19
 for <linux-nvdimm@lists.01.org>; Tue, 18 Oct 2016 16:42:31 -0500 (CDT)
From: Stephen Bates <sbates@raithlin.com>
Subject: [PATCH 3/3] iopmem : Add documentation for iopmem driver
Date: Tue, 18 Oct 2016 15:42:17 -0600
Message-Id: <1476826937-20665-4-git-send-email-sbates@raithlin.com>
In-Reply-To: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
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
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Cc: hch@infradead.org, sbates@raithin.com, haggaie@mellanox.com, axboe@fb.com, corbet@lwn.net, jim.macdonald@everspin.com, Stephen Bates <sbates@raithlin.com>, jgunthorpe@obsidianresearch.com
List-ID: <linux-nvdimm@lists.01.org>

Add documentation for the iopmem PCIe device driver.

Signed-off-by: Stephen Bates <sbates@raithlin.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 Documentation/blockdev/00-INDEX   |  2 ++
 Documentation/blockdev/iopmem.txt | 62 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)
 create mode 100644 Documentation/blockdev/iopmem.txt

diff --git a/Documentation/blockdev/00-INDEX b/Documentation/blockdev/00-INDEX
index c08df56..913e500 100644
--- a/Documentation/blockdev/00-INDEX
+++ b/Documentation/blockdev/00-INDEX
@@ -8,6 +8,8 @@ cpqarray.txt
 	- info on using Compaq's SMART2 Intelligent Disk Array Controllers.
 floppy.txt
 	- notes and driver options for the floppy disk driver.
+iopmem.txt
+	- info on the iopmem block driver.
 mflash.txt
 	- info on mGine m(g)flash driver for linux.
 nbd.txt
diff --git a/Documentation/blockdev/iopmem.txt b/Documentation/blockdev/iopmem.txt
new file mode 100644
index 0000000..ba805b8
--- /dev/null
+++ b/Documentation/blockdev/iopmem.txt
@@ -0,0 +1,62 @@
+IOPMEM Block Driver
+===================
+
+Logan Gunthorpe and Stephen Bates - October 2016
+
+Introduction
+------------
+
+The iopmem module creates a DAX capable block device from a BAR on a PCIe
+device. iopmem leverages heavily from the pmem driver although it utilizes IO
+memory rather than system memory as its backing store.
+
+Usage
+-----
+
+To include the iopmem module in your kernel please set CONFIG_BLK_DEV_IOPMEM
+to either y or m. A block device will be created for each PCIe attached device
+that matches the vendor and device ID as specified in the module. Currently an
+unallocated PMC PCIe ID is used as the default. Alternatively this driver can
+be bound to any aribtary PCIe function using the sysfs bind entry.
+
+The main purpose for an iopmem block device is expected to be for peer-2-peer
+PCIe transfers. We DO NOT RECCOMEND accessing a iopmem device using the local
+CPU unless you are doing one of the three following things:
+
+1. Creating a DAX capable filesystem on the iopmem device.
+2. Creating some files on the DAX capable filesystem.
+3. Interogating the files on said filesystem to obtain pointers that can be
+   passed to other PCIe devices for p2p DMA operations.
+
+Issues
+------
+
+1. Address Translation. Suggestions have been made that in certain
+architectures and topologies the dma_addr_t passed to the DMA master
+in a peer-2-peer transfer will not correctly route to the IO memory
+intended. However in our testing to date we have not seen this to be
+an issue, even in systems with IOMMUs and PCIe switches. It is our
+understanding that an IOMMU only maps system memory and would not
+interfere with device memory regions. (It certainly has no opportunity
+to do so if the transfer gets routed through a switch).
+
+2. Memory Segment Spacing. This patch has the same limitations that
+ZONE_DEVICE does in that memory regions must be spaces at least
+SECTION_SIZE bytes part. On x86 this is 128MB and there are cases where
+BARs can be placed closer together than this. Thus ZONE_DEVICE would not
+be usable on neighboring BARs. For our purposes, this is not an issue as
+we'd only be looking at enabling a single BAR in a given PCIe device.
+More exotic use cases may have problems with this.
+
+3. Coherency Issues. When IOMEM is written from both the CPU and a PCIe
+peer there is potential for coherency issues and for writes to occur out
+of order. This is something that users of this feature need to be
+cognizant of and may necessitate the use of CONFIG_EXPERT. Though really,
+this isn't much different than the existing situation with RDMA: if
+userspace sets up an MR for remote use, they need to be careful about
+using that memory region themselves.
+
+4. Architecture. Currently this patch is applicable only to x86
+architectures. The same is true for much of the code pertaining to
+PMEM and ZONE_DEVICE. It is hoped that the work will be extended to other
+ARCH over time.
--
2.1.4
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
