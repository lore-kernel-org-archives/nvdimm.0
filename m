Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1845202E6113
 for <linux-nvdimm@lists.01.org>; Mon, 16 Oct 2017 12:40:57 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id n82so27010544oig.3
 for <linux-nvdimm@lists.01.org>; Mon, 16 Oct 2017 12:44:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4itbYQqVrHBZ=+BRLH39WwDZ_RGg6sSaodVZ93LRYigNA@mail.gmail.com>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012142319.GA11254@lst.de>
 <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
 <20171013065716.GB26461@lst.de>
 <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com>
 <20171013163822.GA17411@obsidianresearch.com>
 <CAPcyv4jDHp8z2VgVfyRK1WwMzixYVQnh54LZoPD57HB3yqSPPQ@mail.gmail.com>
 <20171013173145.GA18702@obsidianresearch.com> <20171016072644.GB28270@lst.de>
 <CAPcyv4itbYQqVrHBZ=+BRLH39WwDZ_RGg6sSaodVZ93LRYigNA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Oct 2017 12:44:31 -0700
Message-ID: <CAPcyv4gtnZu7obG7UwaBq1-fwRZj06HCa=mjBfDKKgfp97nYaw@mail.gmail.com>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 16, 2017 at 10:43 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Oct 16, 2017 at 12:26 AM, Christoph Hellwig <hch@lst.de> wrote:
>> On Fri, Oct 13, 2017 at 11:31:45AM -0600, Jason Gunthorpe wrote:
>>> I don't think that really represents how lots of apps actually use
>>> RDMA.
>>>
>>> RDMA is often buried down in the software stack (eg in a MPI), and by
>>> the time a mapping gets used for RDMA transfer the link between the
>>> FD, mmap and the MR is totally opaque.
>>>
>>> Having a MR specific notification means the low level RDMA libraries
>>> have a chance to deal with everything for the app.
>>>
>>> Eg consider a HPC app using MPI that uses some DAX aware library to
>>> get DAX backed mmap's. It then passes memory in those mmaps to the
>>> MPI library to do transfers. The MPI creates the MR on demand.
>>>
>>
>> I suspect one of the more interesting use cases might be a file server,
>> for which that's not the case.  But otherwise I agree with the above,
>> and also thing that notifying the MR handle is the only way to go for
>> another very important reason:  fencing.  What if the application/library
>> does not react on the notification?  With a per-MR notification we
>> can unregister the MR in kernel space and have a rock solid fencing
>> mechanism.  And that is the most important bit here.
>
> While I agree with the need for a per-MR notification mechanism, one
> thing we lose by walking away from MAP_DIRECT is a way for a
> hypervisor to coordinate pass through of a DAX mapping to an RDMA
> device in a guest. That will remain a case where we will still need to
> use device-dax. I'm fine if that's the answer, but just want to be
> clear about all the places we need to protect a DAX mapping against
> RDMA from a non-ODP device.

For this specific issue perhaps we promote FL_LAYOUT as a lease-type
that can be set by fcntl().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
