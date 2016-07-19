Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 5E3181A1E24
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jul 2016 17:46:25 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 0/3] ARS rescanning triggered by latent errors or userspace
Date: Mon, 18 Jul 2016 18:44:57 -0600
Message-Id: <1468889100-30698-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Tony Luck <tony.luck@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

This series adds on-demand ARS scanning on both, discovery of
latent media errors, and a sysfs trigger from userspace.

The rescanning part is easy to test using the nfit_test framework
- create a namespace (this will by default have bad sectors in
the middle), clear the bad sectors by writing to them, trigger
the rescan through sysfs, and the bad sectors will reappear in
/sys/block/<pmemX>/badblocks.

For the mce handling, I've tested the notifier chain callback
being called with a mock struct mce (called via another sysfs
trigger - this isn't included in the patch obviously), which
has the address field set to a known address in a SPA range,
and the status field with the MCACOD flag set.

What I haven't easily been able to test is the same callback
path with a 'real world' mce, being called as part of the
x86_mce_decoder_chain notifier. I'd therefore appreciate a
closer look at the initial filtering done in nfit_handle_mce
(patch 3/3) from Tony or anyone more familiar with mce handling.

The series is based on v4.7-rc7, and a tree is available at
https://git.kernel.org/cgit/linux/kernel/git/vishal/nvdimm.git/log/?h=ars-ondemand


Vishal Verma (3):
  pmem: clarify a debug print in pmem_clear_poison
  nfit, libnvdimm: allow an ARS rescan to be triggered on demand
  nfit: do an ARS rescan on hitting a latent media error

 drivers/acpi/nfit.c       | 138 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/acpi/nfit.h       |   2 +
 drivers/nvdimm/core.c     |  17 ++++++
 drivers/nvdimm/pmem.c     |   2 +-
 include/linux/libnvdimm.h |   1 +
 5 files changed, 155 insertions(+), 5 deletions(-)

-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
