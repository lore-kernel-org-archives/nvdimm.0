Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 25F0F2113DA1D
 for <linux-nvdimm@lists.01.org>; Mon, 17 Sep 2018 23:01:20 -0700 (PDT)
Subject: [ndctl PATCH 0/3] ndctl: Remove udev rule for latch and
 dirty-shutdown-count
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Sep 2018 22:49:11 -0700
Message-ID: <153724975102.55312.9664009456306267501.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

The latch needs to be coordinated with writes to the namespace and that
makes it not suitable as a dimm-add-event udev rule.

Additionally, the dirty-shutdown-count is something that can live in
sysfs alongside the other health state flags in /sys/.../nmemX/nfit.
Otherwise, calling any of the libndctl apis from a udev script means the
entire udev queue can get blocked behind a ndctl_bus_wait_probe() call.
That's too much overhead for a non-default policy.

In other words, while the latch event remains in userspace as close as
possible to the application that wants to manage dimm-flush-failed
policy as anything other than fatal, dirty-shutdown-count caching should
move to sysfs where it is cheap to implement and compliments the
flush-failed health state flag.

---

Dan Williams (3):
      ndctl: Introduce dirty-dimm command
      ndctl: Revert "ndctl, intel: Fallback to smart cached shutdown_count"
      ndctl: Revert "ndctl: Create ndctl udev rules for dirty shutdown"


 .gitignore                               |    1 
 Documentation/ndctl/Makefile.am          |    1 
 Documentation/ndctl/ndctl-dirty-dimm.txt |   29 ++++++
 Makefile.am                              |    3 -
 builtin.h                                |    1 
 configure.ac                             |   10 --
 contrib/80-ndctl.rules                   |    3 -
 ndctl.spec.in                            |    3 -
 ndctl/Makefile.am                        |    5 -
 ndctl/dimm.c                             |   28 ++++++
 ndctl/lib/intel.c                        |   41 --------
 ndctl/lib/libndctl.c                     |    6 -
 ndctl/lib/private.h                      |    3 -
 ndctl/ndctl-udev.c                       |  150 ------------------------------
 ndctl/ndctl.c                            |    1 
 15 files changed, 61 insertions(+), 224 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-dirty-dimm.txt
 delete mode 100644 contrib/80-ndctl.rules
 delete mode 100644 ndctl/ndctl-udev.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
