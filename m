Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E858F21BBC429
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 22:17:22 -0700 (PDT)
Received: from mail-ua0-f180.google.com (mail-ua0-f180.google.com
 [209.85.217.180])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2EF9B23A0B
 for <linux-nvdimm@lists.01.org>; Wed, 21 Jun 2017 05:18:46 +0000 (UTC)
Received: by mail-ua0-f180.google.com with SMTP id j53so87765278uaa.2
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 22:18:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170621014032.GL17542@dastard>
References: <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
 <CALCETrUfv26pvmyQ1gOkKbzfSXK2DnmeBG6VmSWjFy1WBhknTw@mail.gmail.com>
 <CAPcyv4iPb69e+rE3fJUzm9U_P_dLfhantU9mvYmV-R0oQee4rA@mail.gmail.com>
 <CALCETrVY38h2ajpod2U_2pdHSp8zO4mG2p19h=OnnHmhGTairw@mail.gmail.com>
 <20170619132107.GG11993@dastard>
 <CALCETrUe0igzK0RZTSSondkCY3ApYQti89tOh00f0j_APrf_dQ@mail.gmail.com>
 <20170620004653.GI17542@dastard>
 <CALCETrVuoPDRuuhc9X8eVCYiFUzWLSTRkcjbD6jas_2J2GixNQ@mail.gmail.com>
 <20170620101145.GJ17542@dastard>
 <CALCETrVCJkm5SCxAtNMW36eONHsFw1s0dkVnDAs4vAXvEKMsPw@mail.gmail.com>
 <20170621014032.GL17542@dastard>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 20 Jun 2017 22:18:24 -0700
Message-ID: <CALCETrVYmbyNS-btvsN_M-QyWPZA_Y_4JXOM893g7nhZA+WviQ@mail.gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 20, 2017 at 6:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> Your mangling terminology here. We don't "break COW" - we *use*
> copy-on-write to break *extent sharing*. We can break extent sharing
> in page_mkwrite - that's exactly what we do for normal pagecache
> based mmap writes, and it's done in page_mkwrite.

Right, my bad.

>
> It hasn't been enabled it for DAX yet because it simply hasn't been
> robustly tested yet.
>
>> A per-inode
>> count of the number of live DAX mappings or of the number of struct
>> file instances that have requested DAX would work here.
>
> For what purpose does this serve? The reflink invalidates all the
> existing mappings, so the next write access causes a fault and then
> page_mkwrite is called and the shared extent will get COWed....

The same purpose as XFS's FS_XFLAG_DAX (assuming I'm understanding it
right), except that IMO an API that doesn't involve making a change to
an inode that sticks around would be nice.  The inode flag has the
unfortunate property that, if two different programs each try to set
the flag, mmap, write, and clear the flag, they'll stomp on each other
and risk data corruption.

I admit I'm now thoroughly confused as to exactly what XFS does here
-- does FS_XFLAG_DAX persist across unmount/mount?

>
>>  - Trying to use DAX on a file that is already reflinked.  The order
>> of operations doesn't matter hugely, except that breaking COW for the
>> entire range in question all at once would be faster and result in
>> better allocation.
>
> We have COW extent size hints for that. i.e. if you want to COW a
> huge page at a time, set the COW extent size hint to the huge page
> size...

Nifty.

> Apparently it is. There are people telling us that mtime
> updates in page faults introduce too much unpredictable latency and
> that screws over their low latency real time applications.

I was one of those, and I even wrote patches.  I should try to dust them off.

>
> Those same people are telling use that dirty tracking in page faults
> for msync/fsync on DAX is too heavyweight and calling msync is too
> onerous and has unpredictable latencies because it might result in
> having to sync tens of thousands of unrelated dirty objects. Hence
> they want to use userspace data sync primitives to avoid this
> overhead and so filesystems need to make it possible to provide this
> userspace idata sync capability.

If I were using DAX in production, I'd have exactly this issue.  Let
me quote myself:

On Tue, Jun 20, 2017 at 9:14 AM, Andy Lutomirski <luto@kernel.org> wrote:
> 3. (Not strictly related to DAX.) A way to tell the kernel "I have
> this file mmapped for write.  Please go out of your way to avoid
> future page faults."  I've wanted this for ordinary files on ext4.
> The kernel could, but presently does not, use hardware dirty tracking
> instead of software dirty tracking to decide when to write the page
> back.  The kernel could also, in principle, write back dirty pages
> without ever write protecting them.  For DAX, this might change
> behavior to prevent any operation that would relocate blocks or to
> have the kernel go out of its way to only do such operations when
> absolutely necessary and to immediately update and unwriteprotect the
> relevant pages.

I agree that this is a real issue, but it's not limited to DAX.  I've
wanted a mode where I tell the kernel "I'm a high-performance
application mmapping this file and I'm going to write to it a lot.  Do
your best to avoid any page faults, even if it adversely affects the
performance of the system."  This mode could do lots of things.  It
could cause the system to leave the page writable even after writeback
and, if possible, to use hardware dirty tracking.  It could cause the
system to make a copy of the page and write back from the copy if
there is anything in play that could need stable pages during
writeback.  And, for DAX, it could tell the system to keep the page
pinned and disallow moving it and reflinking it.

(Of course, the above requires that we either deal with mtime like my
patches do or that this heavyweight mechanism disable mtime updates.
I prefer the former.)

Here's the overall point I'm trying to make: unprivileged programs
that want to write to DAX files with userspace commit mechanisms
(CLFLUSHOPT;SFENCE, etc) should be able to do so reliably, without
privilege, and with reasonably clean APIs.  Ideally they could do this
to any file they have write access to.  Programs that want to write to
mmapped files, DAX or otherwise, without latency spikes due to
.page_mkwrite should be able to opt in to a heavier weight mechanism.
But these two issues are someone independent, and I think they should
be solved separately.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
