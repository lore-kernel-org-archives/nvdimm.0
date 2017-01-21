Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85E2281EB5
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jan 2017 16:38:41 -0800 (PST)
Received: by mail-oi0-x231.google.com with SMTP id w204so52407240oiw.0
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jan 2017 16:38:41 -0800 (PST)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Jan 2017 16:38:40 -0800
Message-ID: <CAPcyv4j7VwY-DX8VGC6wNCQ-ug0ttCgrx4Y_hSG-xRR8f_PU3Q@mail.gmail.com>
Subject: [GIT PULL] libnvdimm fixes for 4.10-rc5
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive:

* A regression fix for the multiple-pmem-namespace-per-region support
added in 4.9. Even if an existing environment is not using that
feature the act of creating and a destroying a single namespace with
the ndctl utility will lead to the proliferation of extra unwanted
namespace devices.

* A fix for the error code returned from the pmem driver when the
memcpy_mcsafe() routine returns -EFAULT. Btrfs seems to be the only
block I/O consumer that tries to parse the meaning of the error code
when it is non-zero.

Neither of these fixes are critical, the namespace leak is awkward in
that it can cause device naming to change and complicates debugging
namespace initialization issues. The error code fix is included out of
caution for what other consumers might be expecting -EIO for block I/O
errors.

---

The following changes since commit a121103c922847ba5010819a3f250f1f7fc84ab8:

  Linux 4.10-rc3 (2017-01-08 14:18:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to 1f19b983a8877f81763fab3e693c6befe212736d:

  libnvdimm, namespace: fix pmem namespace leak, delete when size set
to zero (2017-01-13 09:50:33 -0800)

----------------------------------------------------------------
Dan Williams (1):
      libnvdimm, namespace: fix pmem namespace leak, delete when size
set to zero

Stefan Hajnoczi (1):
      pmem: return EIO on read_pmem() failure

 drivers/nvdimm/namespace_devs.c | 23 ++++++++++-------------
 drivers/nvdimm/pmem.c           |  4 +++-
 2 files changed, 13 insertions(+), 14 deletions(-)

commit d47d1d27fd6206c18806440f6ebddf51a806be4f
Author: Stefan Hajnoczi <stefanha@redhat.com>
Date:   Thu Jan 5 10:05:46 2017 +0000

    pmem: return EIO on read_pmem() failure

    The read_pmem() function uses memcpy_mcsafe() on x86 where an EFAULT
    error code indicates a failed read.  Block I/O should use EIO to
    indicate failure.  Other pmem code paths (like bad blocks) already use
    EIO so let's be consistent.

    This fixes compatibility with consumers like btrfs that try to parse the
    specific error code rather than treat all errors the same.

    Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
    Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1f19b983a8877f81763fab3e693c6befe212736d
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jan 9 17:30:49 2017 -0800

    libnvdimm, namespace: fix pmem namespace leak, delete when size set to zero

    Commit 98a29c39dc68 ("libnvdimm, namespace: allow creation of multiple
    pmem-namespaces per region") added support for establishing additional
    pmem namespace beyond the seed device, similar to blk namespaces.
    However, it neglected to delete the namespace when the size is set to
    zero.

    Fixes: 98a29c39dc68 ("libnvdimm, namespace: allow creation of
multiple pmem-namespaces per region")
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
