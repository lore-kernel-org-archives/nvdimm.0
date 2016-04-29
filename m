Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 5E6981A1F5B
 for <linux-nvdimm@lists.01.org>; Thu, 28 Apr 2016 19:43:11 -0700 (PDT)
Subject: [PATCH v11 0/5] libnvidmm, nfit: dimm command marshaling
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Apr 2016 19:42:22 -0700
Message-ID: <146189774241.29835.12947278159500915461.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com
List-ID: <linux-nvdimm@lists.01.org>

Jerry and I have been working towards a way to support the ACPI DSM
command set needed by HPE DIMMs.  The HPE command sets differ
from the original Intel-defined command set already upstream.

Ideally the kernel would only implement a single standard command
format, however the standard is not yet available and devices
implementing an alternate command set are already shipping.

This rework of Jerry's initial patches [1] aims to support shipping
devices while encouraging future / follow-on command definitions to wait
for the standardization process to complete by:

1/ Requiring public documentation of commands

2/ Providing a mechanism to disable vendor-specific functionality

See patch 2 for more details.  This patch passes the existing nvdimm
unit tests, but I have yet to extend the tests to target this new
mechanism.


Changes since v10: [1]
1/ Rewrote the commit message for the patch that introduces ND_CMD_CALL

2/ Replace 'nfit_cmd_family_tbl' with nfit_mem->family to clean up some
   lookup code.

3/ Squash and reorganize the 7 patches into a smaller set.  Commit
   8467ba4fc94a from my for-4.7/dsm branch [2] was also squashed.

4/ Add sysfs attributes for the dimm family and DSM function-supported
   mask.

5/ Add a module parameter to disable vendor specific commands

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-April/005484.html
[2]: https://git.kernel.org/cgit/linux/kernel/git/djbw/nvdimm.git/commit/?h=for-4.7/dsm&id=8467ba4fc94a

---

Dan Williams (5):
      nfit, libnvdimm: clarify "commands" vs "_DSMs"
      nfit, libnvdimm: limited/whitelisted dimm command marshaling mechanism
      nfit: disable vendor specific commands
      tools/testing/nvdimm: ND_CMD_CALL support
      nfit: add sysfs dimm 'family' and 'dsm_mask' attributes


 drivers/acpi/nfit.c              |  145 +++++++++++++++++++++++++++++++++-----
 drivers/acpi/nfit.h              |   18 ++++-
 drivers/nvdimm/bus.c             |   47 +++++++++++-
 drivers/nvdimm/core.c            |    2 -
 drivers/nvdimm/dimm_devs.c       |   18 +++--
 drivers/nvdimm/nd-core.h         |    2 -
 include/linux/libnvdimm.h        |    5 +
 include/uapi/linux/ndctl.h       |   42 +++++++++++
 tools/testing/nvdimm/test/nfit.c |   46 ++++++++----
 9 files changed, 275 insertions(+), 50 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
