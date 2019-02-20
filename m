Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C94C1211CC3C5
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 15:06:27 -0800 (PST)
Date: Wed, 20 Feb 2019 15:06:22 -0800
From: Larry Bassel <larry.bassel@oracle.com>
Subject: question about page tables in DAX/FS/PMEM case
Message-ID: <20190220230622.GI19341@ubuette>
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

I'm working on sharing page tables in the DAX/XFS/PMEM/PMD case.

If multiple processes would use the identical page of PMDs corresponding
to a 1 GiB address range of DAX/XFS/PMEM/PMDs, presumably one can instead
of populating a new PUD, just atomically increment a refcount and point
to the same PUD in the next level above.

i.e.

OLD:
process 1:
VA -> levels of page tables -> PUD1 -> page of PMDs1
process 2:
VA -> levels of page tables -> PUD2 -> page of PMDs2

NEW:
process 1:
VA -> levels of page tables -> PUD1 -> page of PMDs1
process 2:
VA -> levels of page tables -> PUD1 -> page of PMDs1 (refcount 2)

There are several cases to consider:

1. New mapping
OLD:
make a new PUD, populate the associated page of PMDs
(at least partially) with PMD entries.
NEW:
same

2. Mapping by a process same (same VA->PA and size and protections, etc.)
as one that already exists
OLD:
make a new PUD, populate the associated page of PMDs
(at least partially) with PMD entries.
NEW:
use same PUD, increase refcount (potentially even if this mapping is private
in which case there may eventually be a copy-on-write -- see #5 below)

3. Unmapping of a mapping which is the same as that from another process
OLD:
destroy the process's copy of mapping, free PUD, etc.
NEW:
decrease refcount, only if now 0 do we destroy mapping, etc.

4. Unmapping of a mapping which is unique (refcount 1)
OLD:
destroy the process's copy of mapping, free PUD, etc.
NEW:
same

5. Mapping was private (but same as another process), process writes
OLD:
break the PMD into PTEs, destroy PMD mapping, free PUD, etc..
NEW:
decrease refcount, only if now 0 do we destroy mapping, etc.
we still break the PMD into PTEs.

If I have a mmap of a DAX/FS/PMEM file and I take
a page (either pte or PMD sized) fault on access to this file,
the page table(s) are set up in dax_iomap_fault() in fs/dax.c (correct?).

If the process later munmaps this file or exits but there are still
other users of the shared page of PMDs, I would need to
detect that this has happened and act accordingly (#3 above)

Where will these page table entries be torn down?
In the same code where any other page table is torn down?
If this is the case, what would the cleanest way of telling that these
page tables (PMDs, etc.) correspond to a DAX/FS/PMEM mapping
(look at the physical address pointed to?) so that
I could do the right thing here.

I understand that I may have missed something obvious here.

Thanks.

Larry
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
