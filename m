Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sandeen.net (sandeen.net [63.231.237.45])
 by ml01.01.org (Postfix) with ESMTP id 0E18121127CBE
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 15:18:50 -0700 (PDT)
Subject: Re: [PATCH v4 0/2] ext4: fix DAX dma vs truncate/hole-punch
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180711081741.lmr44sp4cmt3f6um@quack2.suse.cz>
 <20180725222839.GA28304@linux.intel.com>
 <CAOxpaSWCT+XRtGxGQT_PVMcn79csMxbqb+cf4yycbV3eqjjnkQ@mail.gmail.com>
 <20180807084545.6gzxrtrvb34hyhdq@quack2.suse.cz>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8c70d61a-fc5c-b928-334a-fbb2567b8dea@sandeen.net>
Date: Mon, 10 Sep 2018 17:18:49 -0500
MIME-Version: 1.0
In-Reply-To: <20180807084545.6gzxrtrvb34hyhdq@quack2.suse.cz>
Content-Language: en-US
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
To: Jan Kara <jack@suse.cz>, Ross Zwisler <zwisler@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, darrick.wong@oracle.com, linux-nvdimm@lists.01.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lczerner@redhat.com, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 8/7/18 3:45 AM, Jan Kara wrote:
> On Fri 27-07-18 10:28:51, Ross Zwisler wrote:
>> + fsdevel and the xfs list.
>>
>> On Wed, Jul 25, 2018 at 4:28 PM Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>>> On Wed, Jul 11, 2018 at 10:17:41AM +0200, Jan Kara wrote:
>>>> On Tue 10-07-18 13:10:29, Ross Zwisler wrote:
>>>>> Changes since v3:
>>>>>  * Added an ext4_break_layouts() call to ext4_insert_range() to ensure
>>>>>    that the {ext4,xfs}_break_layouts() calls have the same meaning.
>>>>>    (Dave, Darrick and Jan)
>>>>
>>>> How about the occasional WARN_ON_ONCE you mention below. Were you able to
>>>> hunt them down?
>>>
>>> The root cause of this issue is that while the ei->i_mmap_sem provides
>>> synchronization between ext4_break_layouts() and page faults, it doesn't
>>> provide synchronize us with the direct I/O path.  This exact same issue exists
>>> in XFS AFAICT, with the synchronization tool there being the XFS_MMAPLOCK.
>>>
>>> This allows the direct I/O path to do I/O and raise & lower page->_refcount
>>> while we're executing a truncate/hole punch.  This leads to us trying to free
>>> a page with an elevated refcount.
>>>
>>> Here's one instance of the race:
>>>
>>> CPU 0                                   CPU 1
>>> -----                                   -----
>>> ext4_punch_hole()
>>>   ext4_break_layouts() # all pages have refcount=1
>>>
>>>                                         ext4_direct_IO()
>>>                                           ... lots of layers ...
>>>                                           follow_page_pte()
>>>                                             get_page() # elevates refcount
>>>
>>>   truncate_pagecache_range()
>>>    ... a few layers ...
>>>    dax_disassociate_entry() # sees elevated refcount, WARN_ON_ONCE()
>>>
> 
> So this is a very different race from the one below. And it should be
> impossible to happen. This race is exactly the reason why
> dax_layout_busy_page() has unmap_mapping_range() call to force GUP to fault
> which blocks on ei->i_mmap_sem / XFS_MMAPLOCK and thus avoids the race.
> 
>>> A similar race occurs when the refcount is being dropped while we're running
>>> ext4_break_layouts(), and this is the one that my test was actually hitting:
>>>
>>> CPU 0                                   CPU 1
>>> -----                                   -----
>>>                                         ext4_direct_IO()
>>>                                           ... lots of layers ...
>>>                                           follow_page_pte()
>>>                                             get_page()
>>>                                             # elevates refcount of page X
>>> ext4_punch_hole()
>>>   ext4_break_layouts() # two pages, X & Y, have refcount == 2
>>>     __wait_var_event() # called for page X
>>>
>>>                                           __put_devmap_managed_page()
>>>                                           # drops refcount of X to 1
>>>
>>>    # __wait_var_events() checks X's refcount in "if (condition)", and breaks.
>>>    # We never actually called ext4_wait_dax_page(), so 'retry' in
>>>    # ext4_break_layouts() is still false.  Exit do/while loop in
>>>    # ext4_break_layouts, never attempting to wait on page Y which still has an
>>>    # elevated refcount of 2.
>>>
>>>   truncate_pagecache_range()
>>>    ... a few layers ...
>>>    dax_disassociate_entry() # sees elevated refcount for Y, WARN_ON_ONCE()
>>>
>>> This second race can be fixed with the patch at the end of this function,
>>> which I think should go in, unless there is a benfit to the current retry
>>> scheme which relies on the 'retry' variable in {ext4,xfs}_break_layouts()?
>>> With this patch applied I've been able to run my unit test through
>>> thousands of iterations, where it used to failed consistently within 10 or
>>> so.
>>>
>>> Even so, I wonder if the real solution is to add synchronization between
>>> the direct I/O path and {ext4,xfs}_break_layouts()?  Other ideas on how
>>> this should be handled?
>>>
>>> --- >8 ---
>>>
>>> From a4519b0f40362f0a63ae96acaf986092aff0f0d3 Mon Sep 17 00:00:00 2001
>>> From: Ross Zwisler <zwisler@kernel.org>
>>> Date: Wed, 25 Jul 2018 16:16:05 -0600
>>> Subject: [PATCH] ext4: Close race between direct IO and ext4_break_layouts()
>>>
>>> If the refcount of a page is lowered between the time that it is returned
>>> by dax_busy_page() and when the refcount is again checked in
>>> ext4_break_layouts() => ___wait_var_event(), the waiting function
>>> ext4_wait_dax_page() will never be called.  This means that
>>> ext4_break_layouts() will still have 'retry' set to false, so we'll stop
>>> looping and never check the refcount of other pages in this inode.
>>>
>>> Instead, always continue looping as long as dax_layout_busy_page() gives us
>>> a page which it found with an elevated refcount.
>>>
>>> Note that this works around the race exposed by my unit test, but I think
>>> that there is another race that needs to be addressed, probably with
>>> additional synchronization added between direct I/O and
>>> {ext4,xfs}_break_layouts().
>>>
>>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> OK, this is a good catch and the patch looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Also please post this fix officially to Ted to include it in his tree (I
> can see that he has all your other patches queued for the merge window).

Did these ever get on Ted's radar?  I don't see it upstream yet.

Thanks,
-Eric
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
