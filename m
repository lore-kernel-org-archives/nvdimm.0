Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA813211D56AB
 for <linux-nvdimm@lists.01.org>; Tue,  5 Mar 2019 17:46:38 -0800 (PST)
Subject: [ndctl PATCH 0/5] ndctl: Optimize label operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 05 Mar 2019 17:33:59 -0800
Message-ID: <155183603979.191625.11689546261255336448.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In almost all use cases ndctl was reading more label data than necessary
to carry out tasks like "init-labels" and the auto-label capability of
"create-namespace".

Outside of index-block scoped operations above, there is utility in
being able to specify an extent range smaller than the full capacity to
"{read,write,zero}-labels".

Deploy optimizations to only operate on the index blocks when possible,
and allow for custom extents for the generic operations.

---

Dan Williams (5):
      ndctl/dimm: Support small label reads/writes
      ndctl/dimm: Minimize data-transfer for init-labels
      ndctl/dimm: Add offset and size options to {read,write,zero}-labels
      ndctl/dimm: Limit read-labels with --index option
      ndctl/namespace: Minimize label data transfer for autolabel


 Documentation/ndctl/labels-options.txt |    9 +++
 ndctl/dimm.c                           |   88 ++++++++++++++++++--------
 ndctl/lib/dimm.c                       |   85 +++++++++++++++++++++++--
 ndctl/lib/libndctl.c                   |  107 ++++++++++++++++++++++++++++----
 ndctl/lib/libndctl.sym                 |    5 +
 ndctl/lib/private.h                    |    4 -
 ndctl/libndctl.h                       |    9 +++
 ndctl/namespace.c                      |    2 -
 util/util.h                            |    4 +
 9 files changed, 260 insertions(+), 53 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
