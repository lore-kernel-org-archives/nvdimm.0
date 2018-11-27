Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1756F2119173C
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 13:16:48 -0800 (PST)
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 0/2] Two DAX fixes for 4.20
Date: Tue, 27 Nov 2018 13:16:32 -0800
Message-Id: <20181127211634.4995-1-willy@infradead.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

These both fix race conditions in dax_lock_mapping_entry().  I've tagged
them both for 4.19 backport, which will fail and I'll do the equivalent
patch for it.  Dan, do you want to take these through your tree?

Matthew Wilcox (2):
  dax: Check page->mapping isn't NULL
  dax: Don't access a freed inode

 fs/dax.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
