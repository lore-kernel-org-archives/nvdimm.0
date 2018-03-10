Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20180227214144.GP7000@dastard>
References: <CAD4SzjvOr_akMXX8JhKCMB_A3KD66v2q0An4ULB9TF8d0Sb4PA@mail.gmail.com>
 <20180227214144.GP7000@dastard>
From: Andiry Xu <jix024@eng.ucsd.edu>
Date: Fri, 9 Mar 2018 21:27:41 -0800
Message-ID: <CAD4SzjsvB6BxXAOZvV6+OnO2QqX11i0B45LA0E47KSBkd0-OaA@mail.gmail.com>
Subject: Re: xfstests 344 deadlock on NOVA
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, jack@suse.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 27, 2018 at 1:41 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Feb 27, 2018 at 11:15:55AM -0800, Andiry Xu wrote:
>> Hi,
>>
>> I encounter a problem when running xfstests on NOVA. I appreciate your
>> help very much.
>>
>> Some background: NOVA adopts a per-inode logging design. Metadata
>> changes are appended to the log and persisted before returning to the
>> user space. For example, a write() in NOVA works like this:
>>
>> Allocate new pmem blocks and fill with user data
>> Append the metadata that describes this write to the end of the inode log
>> Update the log tail pointer atomically to commit the write
>> Update in-DRAM radix tree to point to the metadata (for fast lookup)
>>
>> The log appending and radix tree update are protected by inode_lock().
>>
>> For mmap, nova_dax_get_blocks (similar to ext2_get_blocks)  needs to
>> persist the metadata for new allocations. So it has to append the new
>> allocation metadata to the log, and hence needs to lock the inode.
>> This causes deadlock in xfstests 344 with concurrent pwrite and mmap
>> write:
>>
>> Thread 1:
>> pwrite
>> -> nova_dax_file_write()
>> ---> inode_lock()
>> -----> invalidate_inode_pages2_range()
>> -------> schedule()
>
> Why did this thread schedule here?
>
>> Thread 2:
>> dax_fault
>> -> nova_dax_get_blocks()
>> ---> inode_lock() // deadlock
>
> It's just waiting on an inode_lock() to be released by another
> thread. What resource is it holding locked that the first thread
> needs to make progress?
>
>> If I remove invalidate_inode_pages2_range() in write path, xfstests
>> 344 passed, but 428 will fail.
>>
>> It appears to me that ext2/ext4 does not have this issue because they
>> don't persist metadata immediately and hence do not take inode lock.
>
> Did you realise that you can't take the inode->i_rwsem in the page
> fault path (i.e. under the mmap_sem) because that's a known deadlock
> vector against the read/write IO path?
>
> (i.e. you can use a mmap'd buffer over a range of the same file as
> the data buffer for the IO, then take a page fault when trying to
> copy data into/out of that buffer while holding the inode->i_rwsem)
>
>> But nova_dax_get_blocks() has to persist the metadata and needs to
>> lock the inode to access the log. Is there a way to workaround this?
>> Thank you very much.
>
> I'm pretty sure you don't want to use inode->i_rwsem for internal
> metadata serialisation requirements. XFS uses xfs_inode->i_ilock for
> this, ext4 uses a combination of other locks, etc, and it's done to
> separate internal serialisation requirements from user data access
> and VFS serialisation requirements...
>

Thank you. I have fixed the issue by using a different semaphore.

Thanks,
Andiry

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
