Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3C4A1A1E14
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jul 2016 14:38:44 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id l72so36898234oig.2
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jul 2016 14:38:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160727120745.GI6860@quack2.suse.cz>
References: <20160727120745.GI6860@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Jul 2016 14:38:43 -0700
Message-ID: <CAPcyv4js0WpqwF8rE3P7bXVzb9M3y5dCjVx6BCO21+-Rxf7n8w@mail.gmail.com>
Subject: Re: Subtle races between DAX mmap fault and write path
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
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

[ Adding Eric ]

On Wed, Jul 27, 2016 at 5:07 AM, Jan Kara <jack@suse.cz> wrote:
> Hi,
>
> when testing my latest changes to DXA fault handling code I have hit the
> following interesting race between the fault and write path (I'll show
> function names for ext4 but xfs has the same issue AFAICT).
>
> We have a file 'f' which has a hole at offset 0.
>
> Process 0                               Process 1
>
> data = mmap('f');
> read data[0]
>   -> fault, we map a hole page
>
>                                         pwrite('f', buf, len, 0)
>                                           -> ext4_file_write_iter
>                                             inode_lock(inode);
>                                             __generic_file_write_iter()
>                                               generic_file_direct_write()
>                                                 invalidate_inode_pages2_range()
>                                                   - drops hole page from
>                                                     the radix tree
>                                                 ext4_direct_IO()
>                                                   dax_do_io()
>                                                     - allocates block for
>                                                       offset 0
> data[0] = 1
>   -> page_mkwrite fault
>     -> ext4_dax_fault()
>       down_read(&EXT4_I(inode)->i_mmap_sem);
>       __dax_fault()
>         grab_mapping_entry()
>           - creates locked radix tree entry
>         - maps block into PTE
>         put_locked_mapping_entry()
>
>                                                 invalidate_inode_pages2_range()
>                                                   - removes dax entry from
>                                                     the radix tree
>
> So we have just lost information that block 0 is mapped and needs flushing
> caches.
>
> Also the fact that the consistency of data as viewed by mmap and
> dax_do_io() relies on invalidate_inode_pages2_range() is somewhat
> unexpected to me and we should document it somewhere.
>
> The question is how to best fix this. I see three options:
>
> 1) Lock out faults during writes via exclusive i_mmap_sem. That is rather
> harsh but should work - we call filemap_write_and_wait() in
> generic_file_direct_write() so we flush out all caches for the relevant
> area before dropping radix tree entries.
>
> 2) Call filemap_write_and_wait() after we return from ->direct_IO before we
> call invalidate_inode_pages2_range() and hold i_mmap_sem exclusively only
> for those two calls. Lock hold time will be shorter than 1) but it will
> require additional flush and we'd probably have to stop using
> generic_file_direct_write() for DAX writes to allow for all this special
> hackery.
>
> 3) Remodel dax_do_io() to work more like buffered IO and use radix tree
> entry locks to protect against similar races. That has likely better
> scalability than 1) but may be actually slower in the uncontended case (due
> to all the radix tree operations).

In general, re-modeling dax_do_io() has come up before in the context
of error handling [1] and code readability [2].  I think there are
benefits outside of this immediate bug fix to make dax_do_io() less
special.

[1]: "PATCH v2 5/5] dax: handle media errors in dax_do_io" where we
debated direct-I/O writes triggering error clearing
[2]: commit "023954351fae dax: fix offset overflow in dax_io" where we
found an off by one bug was hiding in the range checking
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
