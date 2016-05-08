Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id D16A61A1E37
 for <linux-nvdimm@lists.01.org>; Sun,  8 May 2016 15:40:33 -0700 (PDT)
Subject: [ndctl PATCH 0/2] ndctl: dax device support
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 08 May 2016 15:39:46 -0700
Message-ID: <146274718628.12219.9049769475511391374.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Enable the "dax" mode of a pfn device to allow persistent memory to be
accessed through /dev/daxX.Y rather than /dev/pmemX.

---

Dan Williams (2):
      ndctl: add library support for 'dax' devices
      ndctl: utility support for dax devices


 Documentation/ndctl-create-namespace.txt |   12 +
 builtin-xaction-namespace.c              |   33 ++-
 configure.ac                             |   26 ++
 lib/libndctl.c                           |  367 ++++++++++++++++++++++++++++--
 lib/libndctl.sym                         |   25 ++
 lib/ndctl/libndctl.h.in                  |   38 +++
 util/json.c                              |   17 +
 7 files changed, 494 insertions(+), 24 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
