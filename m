Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 119C020945BC0
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 09:57:33 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id c77so15273517oig.0
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 10:01:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171013163822.GA17411@obsidianresearch.com>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012142319.GA11254@lst.de>
 <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
 <20171013065716.GB26461@lst.de>
 <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com>
 <20171013163822.GA17411@obsidianresearch.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Oct 2017 10:01:04 -0700
Message-ID: <CAPcyv4jDHp8z2VgVfyRK1WwMzixYVQnh54LZoPD57HB3yqSPPQ@mail.gmail.com>
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

On Fri, Oct 13, 2017 at 9:38 AM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Fri, Oct 13, 2017 at 08:14:55AM -0700, Dan Williams wrote:
>
>> scheme specific to RDMA which seems like a waste to me when we can
>> generically signal an event on the fd for any event that effects any
>> of the vma's on the file. The FL_LAYOUT lease impacts the entire file,
>> so as far as I can see delaying the notification until MR-init is too
>> late, too granular, and too RDMA specific.
>
> But for RDMA a FD is not what we care about - we want the MR handle so
> the app knows which MR needs fixing.

I'd rather put the onus on userspace to remember where it used a
MAP_DIRECT mapping and be aware that all the mappings of that file are
subject to a lease break. Sure, we could build up a pile of kernel
infrastructure to notify on a per-MR basis, but I think that would
only be worth it if leases were range based. As it is, the entire file
is covered by a lease instance and all MRs that might reference that
file get one notification. That said, we can always arrange for a
per-driver callback at lease-break time so that it can do something
above and beyond the default notification.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
