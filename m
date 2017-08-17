Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F01E21E1452B
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 09:06:02 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/13] dax: Fix comment describing dax_iomap_fault()
Date: Thu, 17 Aug 2017 18:08:10 +0200
Message-Id: <20170817160815.30466-9-jack@suse.cz>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add missing argument description.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 54d2a9161f71..85ea49bbbdbf 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1414,7 +1414,8 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 /**
  * dax_iomap_fault - handle a page fault on a DAX file
  * @vmf: The description of the fault
- * @ops: iomap ops passed from the file system
+ * @pe_size: Size of the page to fault in
+ * @ops: Iomap ops passed from the file system
  *
  * When a page fault occurs, filesystems may call this helper in
  * their fault handler for DAX files. dax_iomap_fault() assumes the caller
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
