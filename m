Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F155A21A143F0
 for <linux-nvdimm@lists.01.org>; Sat, 10 Jun 2017 14:54:42 -0700 (PDT)
Subject: [PATCH 0/2] mm: force enable thp for dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Jun 2017 14:49:26 -0700
Message-ID: <149713136649.17377.3742583729924020371.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Andrew,

Please consider taking these 2 patches for 4.13. I spent some time
debugging why a user's device-dax configuration was always failing and
it turned out that their thp policy was set to 'never'. DAX should be
exempt from the policy since it is statically allocated and does not
suffer from any of the potentially negative side effects of thp. More
details in patch 2.

---

Dan Williams (2):
      mm: improve readability of transparent_hugepage_enabled()
      mm: always enable thp for dax mappings


 include/linux/dax.h     |    5 -----
 include/linux/fs.h      |    6 ++++++
 include/linux/huge_mm.h |   40 +++++++++++++++++++++++++++++-----------
 3 files changed, 35 insertions(+), 16 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
