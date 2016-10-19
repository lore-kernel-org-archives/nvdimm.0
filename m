Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 626891A1E56
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:50:51 -0700 (PDT)
Subject: [ndctl PATCH 0/8] dimm label space initialization support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:47:48 -0700
Message-ID: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: qemu-devel@nongnu.org
List-ID: <linux-nvdimm@lists.01.org>

The 4.9 kernel added support for sub-dividing PMEM.  With this kernel
patch [1] on top of that baseline, the PMEM-sub-division support can be
enabled for QEMU-KVM and any other platforms that advertise both un-aliased
PMEM regions and support for the label DSM commands [2].

Given this increasing need to perform a label management operation
across a set of DIMMs this update also adds glob(3) support.  For
example you can now write commands like:

    ndctl zero-labels nmem[2-4]

...as a shorthand for:

    ndctl zero-labels nmem2 nmem3 nmem4

This support extends to all the commands that take an undecorated dimm /
nmem device as a parameter:

    disable-dimm
    enable-dimm
    read-labels
    zero-labels
    init-labels
    check-labels

The patch "libndctl: fix error returns for unsigned apis" was something
noticed while developing "init-labels", but is otherwise unrelated to
the rest of the set.

[1]: https://patchwork.kernel.org/patch/9384741/
[2]: http://pmem.io/documents/NVDIMM_DSM_Interface_Example-V1.2.pdf

---

Dan Williams (8):
      libndctl: fix error returns for unsigned apis
      ndctl: consolidate label commands into a single file
      ndctl: glob support for label commands
      ndctl: merge {enable,disable}-dimm with label commands
      libndctl: add ndctl_cmd_cfg_read_get_size()
      ndctl: provide a read_labels() helper
      ndctl: init-labels command
      ndctl: check-labels command


 Documentation/Makefile.am            |    2 
 Documentation/ndctl-check-labels.txt |   25 +
 Documentation/ndctl-init-labels.txt  |   83 +++
 ndctl/Makefile.am                    |    4 
 ndctl/builtin-dimm.c                 |  975 ++++++++++++++++++++++++++++++++++
 ndctl/builtin-read-labels.c          |  412 --------------
 ndctl/builtin-xable-dimm.c           |  115 ----
 ndctl/builtin-zero-labels.c          |   92 ---
 ndctl/builtin.h                      |    2 
 ndctl/lib/libndctl.c                 |   17 -
 ndctl/lib/libndctl.sym               |    1 
 ndctl/libndctl.h.in                  |    1 
 ndctl/ndctl.c                        |    2 
 13 files changed, 1105 insertions(+), 626 deletions(-)
 create mode 100644 Documentation/ndctl-check-labels.txt
 create mode 100644 Documentation/ndctl-init-labels.txt
 create mode 100644 ndctl/builtin-dimm.c
 delete mode 100644 ndctl/builtin-read-labels.c
 delete mode 100644 ndctl/builtin-xable-dimm.c
 delete mode 100644 ndctl/builtin-zero-labels.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
