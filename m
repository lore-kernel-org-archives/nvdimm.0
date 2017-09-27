Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D4BDF20945BAC
 for <linux-nvdimm@lists.01.org>; Wed, 27 Sep 2017 06:57:43 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id l74so16850973oih.1
 for <linux-nvdimm@lists.01.org>; Wed, 27 Sep 2017 07:00:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170927113527.GD25746@quack2.suse.cz>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-7-ross.zwisler@linux.intel.com>
 <CAPcyv4jtO028KeZK7SdkOUsgMLGqgttLzBCYgH0M+RP3eAXf4A@mail.gmail.com>
 <20170926185751.GB31146@linux.intel.com>
 <CAPcyv4iVc9y8PE24ZvkiBYdp4Die0Q-K5S6QexW_6YQ_M0F4QA@mail.gmail.com>
 <20170926210645.GA7798@linux.intel.com>
 <CAPcyv4iDTNteQAt1bBHCGijwsk45rJWHfdr+e_rOwK39jpC2Og@mail.gmail.com>
 <20170927113527.GD25746@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Sep 2017 07:00:53 -0700
Message-ID: <CAPcyv4jwGCSaPt17FEbbvbfmurJp5c1S6hPj4K9i3uv_LRKoNg@mail.gmail.com>
Subject: Re: [PATCH 6/7] mm, fs: introduce file_operations->post_mmap()
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
Cc: Jeff Layton <jlayton@poochiereds.net>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 27, 2017 at 4:35 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 26-09-17 14:41:53, Dan Williams wrote:
>> On Tue, Sep 26, 2017 at 2:06 PM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>> > On Tue, Sep 26, 2017 at 12:19:21PM -0700, Dan Williams wrote:
>> >> On Tue, Sep 26, 2017 at 11:57 AM, Ross Zwisler
>> > <>
>> >> > This decision can only be made (in this
>> >> > proposed scheme) *after* the inode->i_mapping->i_mmap  tree has been
>> >> > populated, which means we need another call into the filesystem after this
>> >> > insertion has happened.
>> >>
>> >> I get that, but it seems over-engineered and something that can also
>> >> be safely cleaned up after the fact by the code path that is disabling
>> >> DAX.
>> >
>> > I don't think you can safely clean it up after the fact because some thread
>> > might have already called ->mmap() to set up the vma->vm_flags for their new
>> > mapping, but they haven't added it to inode->i_mapping->i_mmap.
>>
>> If madvise(MADV_NOHUGEPAGE) can dynamically change vm_flags, then the
>> DAX disable path can as well. VM_MIXEDMAP looks to be a nop for normal
>> memory mappings.
>>
>> > The inode->i_mapping->i_mmap tree is the only way (that I know of at least)
>> > that the filesystem has any idea about about the mapping.  This is the method
>> > by which we would try and clean up mapping flags, if we were to do so, and
>> > it's the only way that the filesystem can know whether or not mappings exist.
>> >
>> > The only way that I could think of to make this safely work is to have the
>> > insertion into the inode->i_mapping->i_mmap tree be our sync point.  After
>> > that the filesystem and the mapping code can communicate on the state of DAX,
>> > but before that I think it's basically indeterminate.
>>
>> If we lose the race and leak VM_HUGEPAGE to a non-DAX mapping what
>> breaks? I'd rather be in favor of not setting VM_HUGEPAGE at all in
>> the ->mmap() handler and let the default THP policy take over. In
>> fact, see transparent_hugepage_enabled() we already auto-enable huge
>> page support for dax mappings regardless of VM_HUGEPAGE.
>
> Hum, this is an interesting option. So do you suggest that filesystems
> supporting DAX would always setup mappings with VM_MIXEDMAP and without
> VM_HUGEPAGE and thus we'd get rid of dependency on S_DAX flag in ->mmap?
> That could actually work. The only possible issue I can see is that
> VM_MIXEDMAP is still slightly different from normal page mappings and it
> could have some performance implications - e.g. copy_page_range() does more
> work on VM_MIXEDMAP mappings but not on normal page mappings.

We can also get rid of VM_MIXEDMAP if we disable DAX in the
!pfn_t_has_page() case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
