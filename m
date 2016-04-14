Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 13 Apr 2016 23:22:07 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 error
Message-ID: <20160414032207.GC16656@thunk.org>
References: <0255994B402DE243B1DFC1057A00655201AC6F@ZXSHMBX02.zhaoxin.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0255994B402DE243B1DFC1057A00655201AC6F@ZXSHMBX02.zhaoxin.com>
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
To: Eric Shang <EricShang@zhaoxin.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 13, 2016 at 01:44:55PM +0000, Eric Shang wrote:
> HI All:
>   I meet an ext4 error, following is the error log. After panic, I check the emmc by the tool debufs, the inode 69878 i_nlink is not zero. And this inode don't belong to parent dir 6987, it belong to other file(this inode belong to two files when check by debugfs ncheck), I guess than this inode has beed deleted in memory and already used by other file. But the parent dentry buff_head not flush to emmc. But when lookup this dentry can't find it' in dentry cache, and then lookup_real, read the dentry from emmc, get the file inode which already be deleted. 
>   Can any give me some help how to check this issue. My kernel version is 3.18 form Android . I thinks something wrong with dentry cache flush and dirty buff_head flush to emmc. Thanks all!

If I had to guess, this was caused starting with a corrupted file
system, where the inode allocation bitmap showed that an inode which
was in use by the file system, was erroneously showing it as free.
This allowed it to be allocated for use in a second file (which would
have wiped out the contents for the original file stored at that
inode).  Later on, the file was deleted via either the older or newer
pathname, which dropped the ref count to zero, and then an access via
the other pathname would have resulted in this error.

After the panic, the on-disk data structures wouldn't have been
updated from whatever the in-memory data structures might have been
("Kernel panic - not syncing").  So what you see from using debugfs
after the crash might not be represenatative of what you saw before
the crash.

I'm not sure there's much debugging that can be done, because there
are any number of sources for the original corruption.  It could be
caused by a hardware issue in the flash or the memory, or it could be
caused by a wild pointer corrupting a disk buffer, etc. etc.  The
panic won't result in a useful stack trace because that's when the
problem was *noticed*.  But that's very different from where the file
system corruption was *introduced*.

If you can reliably reproduce this sort of failure, then it becomes
possible to try to track it down.  But if it's a one-off event,
there's not much anyone can do.

Best regards,

						- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
