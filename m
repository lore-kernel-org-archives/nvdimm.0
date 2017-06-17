Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5570C2095D208
 for <linux-nvdimm@lists.01.org>; Sat, 17 Jun 2017 16:49:51 -0700 (PDT)
Received: from mail-ua0-f180.google.com (mail-ua0-f180.google.com
 [209.85.217.180])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id ECAF6239C4
 for <linux-nvdimm@lists.01.org>; Sat, 17 Jun 2017 23:51:10 +0000 (UTC)
Received: by mail-ua0-f180.google.com with SMTP id 68so42478929uas.0
 for <linux-nvdimm@lists.01.org>; Sat, 17 Jun 2017 16:51:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrU1Hg=q4cdQDex--3nVBfwRC1o=9pC6Ss77Z8Lxg7ZJLg@mail.gmail.com>
 <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Sat, 17 Jun 2017 16:50:49 -0700
Message-ID: <CALCETrUfv26pvmyQ1gOkKbzfSXK2DnmeBG6VmSWjFy1WBhknTw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 17, 2017 at 2:52 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sat, Jun 17, 2017 at 9:25 AM, Andy Lutomirski <luto@kernel.org> wrote:
>>
>> Can you remind those of us who haven't played with DAX in a while what
>> the problem is with mmapping a DAX file without this patchset?  If
>> there's some bookkkeeping needed to make sure that the filesystem will
>> invalidate all the mappings if it decides to move the file, maybe that
>> should be the default rather than needing a new syscall.
>
> The bookkeeping to invalidate mappings when the filesystem moves a
> block is already there.
>
> Without this patchset an application needs to call fsync/msync after
> any write to a DAX mapping otherwise there is no guarantee the
> filesystem has written the metadata to find the updated block after a
> crash or power loss event. Even if the sync operation is reduced to a
> minimal cmpxchg in userspace to check if the filesystem-metadata is
> dirty, that mechanism doesn't translate to a virtualized environment,
> as requiring guests to trigger host fsync()s is not feasible. It's a
> half-step solution when you can instead just ask the filesystem to
> never move blocks, as Dave proposed many months back.
>
> We stepped back from that proposal when it looked like a significant
> amount of per-filesystem work to introduce the capability and it was
> not clear that application developers would tolerate the side effects
> of this 'immutable' semantic. However, the implementation is dead
> simple since ext4 and xfs already need to make
> block-allocation-immutable semantics available for swapfiles. We also
> have application developers telling us they are ok with the semantics,
> especially because it catches Linux up to other operating environments
> that are already on board with allowing this type of access to pmem
> through a filesystem. This patchset gives pmem application developers
> what they want without any additional burden on filesystem
> implementations.

I see.

I have a couple of minor-ish issues with the current proposal, then.
One is that I think the terminology should be changed to still make
sense if filesystems or VFS improves to make this approach
unnecessary.  Rather than saying "this file is now static", perhaps
users should set a flag with the explicit semantics that "mmaps of
this file are guaranteed not to lose data due to the kernel's
activities", IOW that mmaps will be at least as durable as a direct
mapping of DAX memory.  Then the kernel has the flexibility to add a
future implementation in which, instead of pinning the file, the
filesystem just knows to keep metadata synced before allowing
page_mkwrite to re-enable writes to an mmapped DAX file.

My other objection is that the syscall intentionally leaks a reference
to the file.  This means it needs overflow protection and it probably
shouldn't ever be allowed to use it without privilege.

Why can't the underlying issue be easily fixed, though?  Could
.page_mkwrite just make sure that metadata is synced when the FS uses
DAX?  On a DAX fs, syncing metadata should be extremely fast.  This
could be conditioned on an madvise or mmap flag if performance might
be an issue.  As far as I know, this change alone should be
sufficient.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
