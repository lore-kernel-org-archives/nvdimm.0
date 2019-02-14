Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27E7220886FCD
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 12:22:43 -0800 (PST)
Subject: [PATCH 0/6] nfit/ars: Improve polling and short-ARS execution
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Feb 2019 12:10:04 -0800
Message-ID: <155017500427.944049.2254497897075714747.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Erwin Tsaur <erwin.tsaur@oracle.com>, Krzysztof Rusocki <krzysztof.rusocki@intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Here is a small pile of updates to better coordinate the Linux ARS state
machine with platform-BIOS implementations. Specifically, take advantage
of opportunities to run short-ARS whenever the ARS interface is found to
be idle at init, always run short-ARS even if no_init_ars is specified,
allow root to reset the exponential backoff polling interval for ARS
completion, and protect the kernel against the consumption of stale ARS
results.

---

Dan Williams (6):
      nfit/ars: Attempt a short-ARS whenever the ARS state is idle at boot
      nfit/ars: Attempt short-ARS even in the no_init_ars case
      nfit/ars: Allow root to busy-poll the ARS state machine
      nfit/ars: Remove ars_start_flags
      nfit/ars: Introduce scrub_flags
      nfit/ars: Avoid stale ARS results


 drivers/acpi/nfit/core.c |   67 ++++++++++++++++++++++++++++++++--------------
 drivers/acpi/nfit/nfit.h |   10 +++++--
 2 files changed, 53 insertions(+), 24 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
