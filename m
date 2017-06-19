Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF35821962334
 for <linux-nvdimm@lists.01.org>; Mon, 19 Jun 2017 05:44:20 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] dax: Fix inefficiency in dax_writeback_mapping_range()
Date: Mon, 19 Jun 2017 14:45:31 +0200
Message-Id: <20170619124531.21491-1-jack@suse.cz>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

dax_writeback_mapping_range() fails to update iteration index when
searching radix tree for entries needing cache flushing. Thus each
pagevec worth of entries is searched starting from the start which is
inefficient and prone to livelocks. Update index properly.

CC: stable@vger.kernel.org
Fixes: 9973c98ecfda3a1dfcab981665b5f1e39bcde64a
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dax.c b/fs/dax.c
index 2a6889b3585f..9187f3b07f3e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -859,6 +859,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 			if (ret < 0)
 				goto out;
 		}
+		start_index = indices[pvec.nr - 1] + 1;
 	}
 out:
 	put_dax(dax_dev);
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
