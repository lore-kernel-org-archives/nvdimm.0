Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D3F5F21F38856
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 11:18:50 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id c202so15434142oih.9
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 11:22:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171013173145.GA18702@obsidianresearch.com>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012142319.GA11254@lst.de>
 <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
 <20171013065716.GB26461@lst.de>
 <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com>
 <20171013163822.GA17411@obsidianresearch.com>
 <CAPcyv4jDHp8z2VgVfyRK1WwMzixYVQnh54LZoPD57HB3yqSPPQ@mail.gmail.com>
 <20171013173145.GA18702@obsidianresearch.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Oct 2017 11:22:21 -0700
Message-ID: <CAPcyv4jZJRto1jwmNU--pqH_6dOVMyj=68ZwEjAmmkgX=mRk7w@mail.gmail.com>
Subject: Re: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
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
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 13, 2017 at 10:31 AM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Fri, Oct 13, 2017 at 10:01:04AM -0700, Dan Williams wrote:
>> On Fri, Oct 13, 2017 at 9:38 AM, Jason Gunthorpe
>> <jgunthorpe@obsidianresearch.com> wrote:
>> > On Fri, Oct 13, 2017 at 08:14:55AM -0700, Dan Williams wrote:
>> >
>> >> scheme specific to RDMA which seems like a waste to me when we can
>> >> generically signal an event on the fd for any event that effects any
>> >> of the vma's on the file. The FL_LAYOUT lease impacts the entire file,
>> >> so as far as I can see delaying the notification until MR-init is too
>> >> late, too granular, and too RDMA specific.
>> >
>> > But for RDMA a FD is not what we care about - we want the MR handle so
>> > the app knows which MR needs fixing.
>>
>> I'd rather put the onus on userspace to remember where it used a
>> MAP_DIRECT mapping and be aware that all the mappings of that file are
>> subject to a lease break. Sure, we could build up a pile of kernel
>> infrastructure to notify on a per-MR basis, but I think that would
>> only be worth it if leases were range based. As it is, the entire file
>> is covered by a lease instance and all MRs that might reference that
>> file get one notification. That said, we can always arrange for a
>> per-driver callback at lease-break time so that it can do something
>> above and beyond the default notification.
>
> I don't think that really represents how lots of apps actually use
> RDMA.
>
> RDMA is often buried down in the software stack (eg in a MPI), and by
> the time a mapping gets used for RDMA transfer the link between the
> FD, mmap and the MR is totally opaque.
>
> Having a MR specific notification means the low level RDMA libraries
> have a chance to deal with everything for the app.
>
> Eg consider a HPC app using MPI that uses some DAX aware library to
> get DAX backed mmap's. It then passes memory in those mmaps to the
> MPI library to do transfers. The MPI creates the MR on demand.
>
> So, who should be responsible for MR coherency? Today we say the MPI
> is responsible. But we can't really expect the MPI
> to hook SIGIO and somehow try to reverse engineer what MRs are
> impacted from a FD that may not even still be open.

Ok, that's good insight that I didn't have. Userspace needs more help
than just an fd notification.

> I think, if you want to build a uAPI for notification of MR lease
> break, then you need show how it fits into the above software model:
>  - How it can be hidden in a RDMA specific library

So, here's a strawman can ibv_poll_cq() start returning ibv_wc_status
== IBV_WC_LOC_PROT_ERR when file coherency is lost. This would make
the solution generic across DAX and non-DAX. What's you're feeling for
how well applications are prepared to deal with that status return?

>  - How lease break can be done hitlessly, so the library user never
>    needs to know it is happening or see failed/missed transfers

iommu redirect should be hit less and behave like the page cache case
where RDMA targets pages that are no longer part of the file.

>  - Whatever fast path checking is needed does not kill performance

What do you consider a fast path? I was assuming that memory
registration is a slow path, and iommu operations are asynchronous so
should not impact performance of ongoing operations beyond typical
iommu overhead.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
