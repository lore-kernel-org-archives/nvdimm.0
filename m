From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 12/12] ext2: use iomap to implement DAX
Date: Wed, 14 Sep 2016 16:51:05 -0600
Message-ID: <20160914225105.GB29323@linux.intel.com>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
 <1473847291-18913-13-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473847291-18913-13-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 14, 2016 at 12:01:31PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Now that ext2 is using IOMAP, we need to select FS_IOMAP when EXT2_FS is
selected else we get a build error:

fs/built-in.o: In function `ext2_dax_fault':
/home/rzwisler/project/review/fs/ext2/file.c:112: undefined reference to `iomap_dax_fault'
fs/built-in.o: In function `ext2_dax_write_iter':
/home/rzwisler/project/review/fs/ext2/file.c:75: undefined reference to `iomap_dax_rw'
fs/built-in.o: In function `ext2_dax_read_iter':
/home/rzwisler/project/review/fs/ext2/file.c:45: undefined reference to `iomap_dax_rw'
Makefile:949: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 1

With the following patch squashed into this commit:

Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

---
>From 9c084641049990339b40bfd52a0aebf300d896ea Mon Sep 17 00:00:00 2001
From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Date: Wed, 14 Sep 2016 16:48:36 -0600
Subject: [PATCH] ext2: build in FS_IOMAP support needed by ext2

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 fs/ext2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext2/Kconfig b/fs/ext2/Kconfig
index c634874e..3391f48 100644
--- a/fs/ext2/Kconfig
+++ b/fs/ext2/Kconfig
@@ -1,5 +1,6 @@
 config EXT2_FS
 	tristate "Second extended fs support"
+	select FS_IOMAP
 	help
 	  Ext2 is a standard Linux file system for hard disks.
 
-- 
2.9.0
