Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 0/2] Expose known poison in SPA ranges to the block
 layer
Date: Wed, 30 Dec 2015 21:13:40 +0000
Message-ID: <D2A994BA.2903A%vishal.l.verma@intel.com>
References: <1451010103-11462-1-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1451010103-11462-1-git-send-email-vishal.l.verma@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F6E938A9A47C214CA8F596932200488B@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, Linda Knippers <linda.knippers@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

On 12/24/15, 19:21, "Verma, Vishal L" <vishal.l.verma@intel.com> wrote:

>v2:
>  - Move poison list walking from pmem to core (Dan)
>  - If the pmem namespace starts at an offset, account for that (Dan)
>  - Fix a bug in extended status checking for ars_status
>  - Remove a duplicate include in pmem.c (only introduced in v1)
>  - When doing an ars_status, don't error out if an ARS has not yet
>    been performed.
>  - When checking if ARS is supported, also check the extended status
>    and make sure ARS for persistent memory is supported (as opposed to
>    just volatile memory)
>  - Print a dev_err message if find_poison fails
>  - Collapse patches 2 and 3 into a single patch
>
>This series does a few things:
>- Retrieve all known poison in the system physical address (SPA) space
>  using ARS (Address Range Scrub) commands to firmware
>- Store this poison in a new 'nd_poison' structure
>- In pmem, consume the poison list and expose the ranges as bad sectors
>
>This depends on the badblocks series sent out previously.
>A tree with the latest revisions of both the badblocks patchset and this
>can be found at:
>https://git.kernel.org/cgit/linux/kernel/git/vishal/nvdimm.git/log/?h=err_
>handling_latest
>
>
>Vishal Verma (2):
>  nfit_test: Enable DSMs for all test NFITs
>  libnvdimm: Add a poison list and export badblocks
>
> drivers/acpi/nfit.c              | 203
>+++++++++++++++++++++++++++++++++++++++
> drivers/nvdimm/core.c            | 187
>++++++++++++++++++++++++++++++++++++
> drivers/nvdimm/nd-core.h         |   3 +
> drivers/nvdimm/nd.h              |   6 ++
> drivers/nvdimm/pmem.c            |   6 ++
> include/linux/libnvdimm.h        |   1 +
> tools/testing/nvdimm/test/nfit.c |   9 ++
> 7 files changed, 415 insertions(+)
>
>-- 
>2.5.0
>
>

Dan reported that these patches fail the nfit_test unit tests, and it
turns out that I had missed setting the ars_status 'address' and 'length'
fields in these patches, causing the nfit driver to fail initialization.
I didn't catch this in my testing as I have a patch to nfit test to
add error records in the ars_status reply for testing, and that does this
correctly.

The following patch (can be squashed into patch 1, or be left by itself as
a new patch 2) fixes this:

I've also updated the tree at:
https://git.kernel.org/cgit/linux/kernel/git/vishal/nvdimm.git/log/?h=err_h
andling_latest


8<-----

>From e46d46f5da9913da180da6553bf744fe6a7d9ecb Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 30 Dec 2015 13:49:55 -0700
Subject: [PATCH] nfit_test: fix ars_status replies from nfit_test

ars_status needs to reply with a valid address and length if the test
module advertises ARS as supported. Without these fields populated, the
nfit driver would fail initialization.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 tools/testing/nvdimm/test/nfit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/nvdimm/test/nfit.c
b/tools/testing/nvdimm/test/nfit.c
index 298805a..90bd2ea 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -248,6 +248,8 @@ static int nfit_test_cmd_ars_status(struct
nd_cmd_ars_status *nd_cmd,
 

	nd_cmd->out_length = 256;
	nd_cmd->num_records = 0;
+	nd_cmd->address = 0;
+	nd_cmd->length = -1ULL;
	nd_cmd->status = 0;

 
	return 0;
-- 
2.5.0


