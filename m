Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2AB05212AAB65
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jun 2019 17:30:02 -0700 (PDT)
Subject: [PATCH] filesystem-dax: Disable PMD support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jun 2019 17:15:45 -0700
Message-ID: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Robert Barror <robert.barror@intel.com>, Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, Seema Pandit <seema.pandit@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Ever since the conversion of DAX to the Xarray a RocksDB benchmark has
been encountering intermittent lockups. The backtraces always include
the filesystem-DAX PMD path, multi-order entries have been a source of
bugs in the past, and disabling the PMD path allows a test that fails in
minutes to run for an hour.

The regression has been bisected to "dax: Convert page fault handlers to
XArray", but little progress has been made on the root cause debug.
Unless / until root cause can be identified mark CONFIG_FS_DAX_PMD
broken to preclude intermittent lockups. Reverting the Xarray conversion
also works, but that change is too big to backport. The implementation
is committed to Xarray at this point.

Link: https://lore.kernel.org/linux-fsdevel/CAPcyv4hwHpX-MkUEqxwdTj7wCCZCN4RV-L4jsnuwLGyL_UEG4A@mail.gmail.com/
Fixes: b15cd800682f ("dax: Convert page fault handlers to XArray")
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Reported-by: Robert Barror <robert.barror@intel.com>
Reported-by: Seema Pandit <seema.pandit@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/Kconfig b/fs/Kconfig
index f1046cf6ad85..85eecd0d4c5d 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -66,6 +66,9 @@ config FS_DAX_PMD
 	depends on FS_DAX
 	depends on ZONE_DEVICE
 	depends on TRANSPARENT_HUGEPAGE
+	# intermittent lockups since commit b15cd800682f "dax: Convert
+	# page fault handlers to XArray"
+	depends on BROKEN
 
 # Selected by DAX drivers that do not expect filesystem DAX to support
 # get_user_pages() of DAX mappings. I.e. "limited" indicates no support

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
