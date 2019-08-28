Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E2F220218C29
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 08:51:48 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch] libnvdimm/pfn: Fix namespace creation on misaligned addresses
Date: Wed, 28 Aug 2019 11:49:46 -0400
Message-ID: <x49ftll8f39.fsf@segfault.boston.devel.redhat.com>
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
To: dan.j.williams@intel.com
Cc: yi.zhang@redhat.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Yi reported[1] that after commit a3619190d62e ("libnvdimm/pfn: stop
padding pmem namespaces to section alignment"), it was no longer
possible to create a device dax namespace with a 1G alignment.  The
reason was that the pmem region was not itself 1G-aligned.  The code
happily skips past the first 512M, but fails to account for a now
misaligned end offset (since space was allocated starting at that
misaligned address, and extending for size GBs).  Reintroduce
end_trunc, so that the code correctly handles the misaligned end
address.  This results in the same behavior as before the introduction
of the offending commit.

[1] https://lists.01.org/pipermail/linux-nvdimm/2019-July/022813.html

Fixes: commit a3619190d62e ("libnvdimm/pfn: stop padding pmem namespaces ...")
Reported-and-tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 3e7b11c..cb98b8f 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -655,6 +655,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	resource_size_t start, size;
 	struct nd_region *nd_region;
 	unsigned long npfns, align;
+	u32 end_trunc;
 	struct nd_pfn_sb *pfn_sb;
 	phys_addr_t offset;
 	const char *sig;
@@ -696,6 +697,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	size = resource_size(&nsio->res);
 	npfns = PHYS_PFN(size - SZ_8K);
 	align = max(nd_pfn->align, (1UL << SUBSECTION_SHIFT));
+	end_trunc = start + size - ALIGN_DOWN(start + size, align);
 	if (nd_pfn->mode == PFN_MODE_PMEM) {
 		/*
 		 * The altmap should be padded out to the block size used
@@ -714,7 +716,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		return -ENXIO;
 	}
 
-	npfns = PHYS_PFN(size - offset);
+	npfns = PHYS_PFN(size - offset - end_trunc);
 	pfn_sb->mode = cpu_to_le32(nd_pfn->mode);
 	pfn_sb->dataoff = cpu_to_le64(offset);
 	pfn_sb->npfns = cpu_to_le64(npfns);
@@ -723,6 +725,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
 	pfn_sb->version_major = cpu_to_le16(1);
 	pfn_sb->version_minor = cpu_to_le16(3);
+	pfn_sb->end_trunc = cpu_to_le32(end_trunc);
 	pfn_sb->align = cpu_to_le32(nd_pfn->align);
 	checksum = nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
 	pfn_sb->checksum = cpu_to_le64(checksum);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
