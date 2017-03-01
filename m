Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1571A821CF
 for <linux-nvdimm@lists.01.org>; Wed,  1 Mar 2017 01:16:31 -0800 (PST)
Subject: [PATCH 0/2] nfit, libnvdimm: fix and unit test isetcookie calculation
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 01 Mar 2017 01:11:19 -0800
Message-ID: <148835947931.28806.15339584183213827869.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Nick noticed that his implementation of the isetcookie calculation was
producing different results than the Linux enabling. Linux is broken in
its usage of memcmp() to sort the components of an array that is hashed
by a fletcher64 sum. See patch2 for more details.

Patch1 arranges for the unit test infrastructure to produce data that
sorts differently under the two schemes. The original simulated data was
masking this problem.

This implementation is tested with a new "ndctl write-labels" command.
It allows namespace labels with broken cookie values to be written and
validate that the compatibility code behaves as expected.

---

Dan Williams (2):
      tools/testing/nvdimm: make iset cookie predictable
      nfit, libnvdimm: fix interleave set cookie calculation


 drivers/acpi/nfit/core.c         |   16 +++++++++++++++-
 drivers/nvdimm/namespace_devs.c  |   18 ++++++++++++++----
 drivers/nvdimm/nd.h              |    1 +
 drivers/nvdimm/region_devs.c     |    9 +++++++++
 include/linux/libnvdimm.h        |    2 ++
 tools/testing/nvdimm/test/nfit.c |   14 +++++++-------
 6 files changed, 48 insertions(+), 12 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
