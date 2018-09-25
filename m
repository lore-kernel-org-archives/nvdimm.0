Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6407621AE30DB
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 12:36:13 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL v2] libnvdimm/dax fixes for 4.19-rc6
Date: Tue, 25 Sep 2018 19:36:03 +0000
Message-ID: <1537904158.7585.65.camel@intel.com>
Content-Language: en-US
Content-ID: <5DCFF9D4061504428054504D696DB72D@intel.com>
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
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Greg, please pull from...

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-4.19-rc6

...to receive a regression fix and 2 other fixes. Details are in the
tag message. Arguably only the 'address_space_operations' fix is urgent
for -rc6, the others can reasonably wait, but I see no reason to hold
them back. This has all appeared in -next with no reported issues.

---

The following changes since commit 11da3a7f84f19c26da6f86af878298694ede0804:

  Linux 4.19-rc3 (2018-09-09 17:26:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-4.19-rc6

for you to fetch changes up to 41c9b1be335b5afc3b5fb71c5d16f9d5939cd13f:

  device-dax: Add missing address_space_operations (2018-09-22 09:07:33 -0700)

----------------------------------------------------------------
libnvdimm/dax for 4.19-rc6

* (2) fixes for the dax error handling updates that were merged for
v4.19-rc1. My mails to Al have been bouncing recently, so I do not have
his ack but the uaccess change is of the trivial / obviously correct
variety. The address_space_operations fixes a regression.

* A filesystem-dax fix to correct the zero page lookup to be compatible
 with non-x86 (mips and s390) architectures.

----------------------------------------------------------------
Dave Jiang (2):
      uaccess: Fix is_source param for check_copy_size() in copy_to_iter_mcsafe()
      device-dax: Add missing address_space_operations

Matthew Wilcox (1):
      filesystem-dax: Fix use of zero page

 drivers/dax/device.c |  6 ++++++
 fs/dax.c             | 13 ++-----------
 include/linux/uio.h  |  2 +-
 3 files changed, 9 insertions(+), 12 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
