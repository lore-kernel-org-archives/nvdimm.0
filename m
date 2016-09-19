Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8094E1A1E3A
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 14:40:55 -0700 (PDT)
Subject: [ndctl PATCH 3/6] Documentation: update top-level man page with
 latest commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Sep 2016 14:37:52 -0700
Message-ID: <147432107214.39548.16785205401638392821.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147432105652.39548.8883834720654751375.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147432105652.39548.8883834720654751375.stgit@dwillia2-desk3.amr.corp.intel.com>
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

We have grown the following commands since the top-level ndctl man page
was initially created:

    destroy-namespace
    enable-dimm
    disable-dimm
    zero-labels
    read-labels
    list

...add them to the "see also" list.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl.txt |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ndctl.txt b/Documentation/ndctl.txt
index 13a0e36627f3..883a59c096ba 100644
--- a/Documentation/ndctl.txt
+++ b/Documentation/ndctl.txt
@@ -33,10 +33,16 @@ namspaces) associated with an NVDIMM bus.
 SEE ALSO
 --------
 linkndctl:ndctl-create-namespace[1],
+linkndctl:ndctl-destroy-namespace[1],
 linkndctl:ndctl-enable-region[1],
 linkndctl:ndctl-disable-region[1],
+linkndctl:ndctl-enable-dimm[1],
+linkndctl:ndctl-disable-dimm[1],
 linkndctl:ndctl-enable-namespace[1],
 linkndctl:ndctl-disable-namespace[1],
+linkndctl:ndctl-zero-labels[1],
+linkndctl:ndctl-read-labels[1],
+linkndctl:ndctl-list[1],
 https://www.kernel.org/doc/Documentation/nvdimm/nvdimm.txt[LIBNVDIMM
 Overview],
 http://pmem.io/documents/NVDIMM_Driver_Writers_Guide.pdf[NVDIMM Driver

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
