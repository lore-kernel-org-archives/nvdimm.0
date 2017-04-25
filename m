Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C365421951C86
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 15:33:39 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id x184so190408063oia.1
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 15:33:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g+WEYD7RVAekDdBn0+-+GRdKiK1HOG8JrVBAT4h5-CvQ@mail.gmail.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4g+WEYD7RVAekDdBn0+-+GRdKiK1HOG8JrVBAT4h5-CvQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Apr 2017 15:33:38 -0700
Message-ID: <CAPcyv4iZ7A6mOK-p5gVqOgiq9_B0tfV9q0-ouLk5oECZRo4x0A@mail.gmail.com>
Subject: Re: [resend PATCH v2 00/33] dax: introduce dax_operations
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Jens Axboe <axboe@fb.com>, Tony Luck <tony.luck@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 21, 2017 at 6:06 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> [ adding akpm, sfr, and jens ]
>
> I applied this series and pushed it out for the nvdimm.git branch that
> gets auto pulled into -next. The set is still awaiting acks from
> device-mapper, ext4, xfs, and vfs (for the copy_from_iter_ops, patch
> 29/33). If those come next week perhaps this can be merged for 4.12,
> but if not this will need to wait until 4.13.
>
> There are some minor collisions with Al's copy_from_user rework, the
> new dax tracepoints, and the removal of discard support from the brd
> driver. A sample merge is available here:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/log/?h=libnvdimm-for-4.12-merge
>
> If it causes any other problems just drop and I'll retry for 4.13.

Al has nak'd the uaccess related changes, and I'll need to rework
those patches to move the pmem routines into lib/iov_iter.c directly.
That doesn't affect the dax_device and dax_operations work, so I'm
still looking to move forward with that change.  That reduces the set
targeting 4.12 to just the first 18 patches from this series:

Dan Williams (18):
      device-dax: rename 'dax_dev' to 'dev_dax'
      dax: refactor dax-fs into a generic provider of 'struct
dax_device' instances
      dax: add a facility to lookup a dax device by 'host' device name
      dax: introduce dax_operations
      pmem: add dax_operations support
      axon_ram: add dax_operations support
      brd: add dax_operations support
      dcssblk: add dax_operations support
      block: kill bdev_dax_capable()
      dax: introduce dax_direct_access()
      dm: add dax_device and dax_operations support
      dm: teach dm-targets to use a dax_device + dax_operations
      ext2, ext4, xfs: retrieve dax_device for iomap operations
      Revert "block: use DAX for partition table reads"
      filesystem-dax: convert to dax_direct_access()
      block, dax: convert bdev_dax_supported() to dax_direct_access()
      block: remove block_device_operations ->direct_access()
      x86, dax, pmem: remove indirection around memcpy_from_pmem()
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
