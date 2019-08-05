Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B2B9B213030A2
 for <linux-nvdimm@lists.01.org>; Mon,  5 Aug 2019 16:45:30 -0700 (PDT)
Subject: [ndctl PATCH v4 0/7] Improvements for namespace creation/interrogation
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 05 Aug 2019 16:28:41 -0700
Message-ID: <156504772175.847544.11368833704527657055.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Changes since v3 [1]:
- Drop the warning suppression for gcc9.1.1 the complains about taking
  the address of packed structure members. This needs a rethink since
  even the kernel's common ioctl payloads are defined to be packed. This
  will require something like the kernel's (get_unaligned()) helpers.
  (Jeff)

- Fix up a static analysis report introduced by "ndctl/dimm: Minimize
  data-transfer for init-labels"

[1]: https://lists.01.org/pipermail/linux-nvdimm/2019-August/022869.html

---

This trimmed version includes the extent support for label operations
which significantly speeds up common label operations like
'init-labels'. It also fixes up some surprising results from
'create-namespace' where it would fail even though available capacity is
present.

---

Dan Williams (7):
      ndctl/dimm: Support small label reads/writes
      ndctl/dimm: Minimize data-transfer for init-labels
      ndctl/dimm: Add offset and size options to {read,write,zero}-labels
      ndctl/dimm: Limit read-labels with --index option
      ndctl/namespace: Minimize label data transfer for autolabel
      ndctl/namespace: Continue region search on 'missing seed' event
      ndctl/namespace: Report ENOSPC when regions are full


 Documentation/ndctl/labels-options.txt    |    9 ++
 Documentation/ndctl/ndctl-read-labels.txt |    7 ++
 ndctl/dimm.c                              |   92 +++++++++++++++++--------
 ndctl/lib/dimm.c                          |   85 +++++++++++++++++++++--
 ndctl/lib/libndctl.c                      |  108 +++++++++++++++++++++++++----
 ndctl/lib/libndctl.sym                    |    9 ++
 ndctl/lib/private.h                       |    4 -
 ndctl/libndctl.h                          |    9 ++
 ndctl/namespace.c                         |   13 +++
 util/util.h                               |    4 +
 10 files changed, 285 insertions(+), 55 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
