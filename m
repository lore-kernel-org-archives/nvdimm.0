Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 300E721E0C2F9
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 19:03:42 -0700 (PDT)
Received: from mail-ua0-f182.google.com (mail-ua0-f182.google.com
 [209.85.217.182])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 615D9214C5
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 02:05:46 +0000 (UTC)
Received: by mail-ua0-f182.google.com with SMTP id q25so135204856uah.1
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 19:05:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170727215713.GA22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 27 Jul 2017 19:05:24 -0700
Message-ID: <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 27, 2017 at 2:57 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Thu, Jul 27, 2017 at 10:09:07AM -0400, Jeff Moyer wrote:
>> Jan Kara <jack@suse.cz> writes:
>>
>> Hi, Jan,
>>
>> Thanks for looking into this!
>>
>> > There are couple of open questions with this implementation:
>> >
>> > 1) Is it worth the hassle?
>> > 2) Is S_SYNC good flag to use or should we use a new inode flag?
>> > 3) VM_FAULT_RO and especially passing of resulting 'pfn' from
>> >    dax_iomap_fault() through filesystem fault handler to dax_pfn_mkwrite() in
>> >    vmf->orig_pte is a bit of a hack. So far I'm not sure how to refactor
>> >    things to make this cleaner.
>>
>> 4) How does an application discover that it is safe to flush from
>>    userspace?
>
> I think that we would be best off with a new flag available via
> lsattr(1)/chattr(1).  This would have the following advantages:
>
> 1) We could only set the flag if the inode supported DAX (either via the mount
> option or via the individual DAX flag).  This would give NVML et al. one
> central way to detect whether it was safe to flush from userspace because the
> FS supported synchronous faults.
>
> 2) Defining a new flag prevents any confusion about whether the kernel version
> you have supports sync faults.  Otherwise NVML would have to do something like
> look at the trio of (kernel version, S_SYNC flag, mount/inode option for DAX)
> which is complex and of course breaks for OS kernel versions.
>
> 3) Defining the flag in a generic way via lsattr/chattr opens the door for the
> same API and flag to be used by other filesystems in the future.

I would advocate using a new fcntl() instead of lsattr for the
following reason: ISTM the fact that it's an *inode* flag in this
patchset is a bit of an implementation detail.  I can easily imagine a
future implementation that makes it per-struct-file instead.  A
fcntl() that asks "can I flush from userspace" would still work under
than scenario.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
