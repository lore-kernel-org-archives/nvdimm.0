Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4A08021D2E634
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 08:59:13 -0700 (PDT)
Date: Thu, 24 Aug 2017 09:01:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Message-ID: <20170824160144.GA14287@infradead.org>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
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
To: rdodgen@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, Randy Dodgen <dodgen@google.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 23, 2017 at 02:26:52PM -0700, rdodgen@gmail.com wrote:
> From: Randy Dodgen <dodgen@google.com>
> 
> If an ext4 filesystem is mounted with both the DAX and read-only
> options, executables on that filesystem will fail to start (claiming
> 'Segmentation fault') due to the fault handler returning
> VM_FAULT_SIGBUS.
> 
> This is due to the DAX fault handler (see ext4_dax_huge_fault)
> attempting to write to the journal when FAULT_FLAG_WRITE is set. This is
> the wrong behavior for write faults which will lead to a COW page; in
> particular, this fails for readonly mounts.
> 
> This change avoids journal writes for faults that are expected to COW.
> 
> It might be the case that this could be better handled in
> ext4_iomap_begin / ext4_iomap_end (called via iomap_ops inside
> dax_iomap_fault). These is some overlap already (e.g. grabbing journal
> handles).
> 
> Signed-off-by: Randy Dodgen <dodgen@google.com>
> ---
> 
> This version is simplified as suggested by Ross; all fault sizes and fallbacks
> are handled by dax_iomap_fault.

We really need to do the same for ext2 and xfs.  And we really should
be doing that in common VM code instead of the file system.  See
my recent xfs synchronous page fault series on the mess the inconsistent
handling of the FAULT_FLAG_WRITE causes.  I think we just need a new
FAULT_FLAG_ALLOC or similar for those page faults that needs to
allocate space instead of piling hacks over hacks, and make sure
it's only set over the method that will actually do the allocation,
as the DAX and non-DAX path are not consistent on that.

Also any chance you could write an xfstest for this?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
