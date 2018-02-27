Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
From: Andiry Xu <jix024@eng.ucsd.edu>
Date: Tue, 27 Feb 2018 11:15:55 -0800
Message-ID: <CAD4SzjvOr_akMXX8JhKCMB_A3KD66v2q0An4ULB9TF8d0Sb4PA@mail.gmail.com>
Subject: xfstests 344 deadlock on NOVA
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
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, jack@suse.com
List-ID: <linux-nvdimm@lists.01.org>

Hi,

I encounter a problem when running xfstests on NOVA. I appreciate your
help very much.

Some background: NOVA adopts a per-inode logging design. Metadata
changes are appended to the log and persisted before returning to the
user space. For example, a write() in NOVA works like this:

Allocate new pmem blocks and fill with user data
Append the metadata that describes this write to the end of the inode log
Update the log tail pointer atomically to commit the write
Update in-DRAM radix tree to point to the metadata (for fast lookup)

The log appending and radix tree update are protected by inode_lock().

For mmap, nova_dax_get_blocks (similar to ext2_get_blocks)  needs to
persist the metadata for new allocations. So it has to append the new
allocation metadata to the log, and hence needs to lock the inode.
This causes deadlock in xfstests 344 with concurrent pwrite and mmap
write:

Thread 1:
pwrite
-> nova_dax_file_write()
---> inode_lock()
-----> invalidate_inode_pages2_range()
-------> schedule()

Thread 2:
dax_fault
-> nova_dax_get_blocks()
---> inode_lock() // deadlock

If I remove invalidate_inode_pages2_range() in write path, xfstests
344 passed, but 428 will fail.

It appears to me that ext2/ext4 does not have this issue because they
don't persist metadata immediately and hence do not take inode lock.
But nova_dax_get_blocks() has to persist the metadata and needs to
lock the inode to access the log. Is there a way to workaround this?
Thank you very much.

Thanks,
Andiry
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
