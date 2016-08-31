Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C5091A1E53
 for <linux-nvdimm@lists.01.org>; Wed, 31 Aug 2016 14:36:09 -0700 (PDT)
Date: Wed, 31 Aug 2016 15:36:07 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 0/9] re-enable DAX PMD support
Message-ID: <20160831213607.GA6921@linux.intel.com>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
 <20160830230150.GA12173@linux.intel.com>
 <1472674799.2092.19.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1472674799.2092.19.camel@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "tytso@mit.edu" <tytso@mit.edu>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jack@suse.com" <jack@suse.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 31, 2016 at 08:20:48PM +0000, Kani, Toshimitsu wrote:
> On Tue, 2016-08-30 at 17:01 -0600, Ross Zwisler wrote:
> > On Tue, Aug 23, 2016 at 04:04:10PM -0600, Ross Zwisler wrote:
> > > =

> > > DAX PMDs have been disabled since Jan Kara introduced DAX radix
> > > tree based locking.=A0=A0This series allows DAX PMDs to participate in
> > > the DAX radix tree based locking scheme so that they can be re-
> > > enabled.
> > > =

> > > Changes since v1:
> > > =A0- PMD entry locking is now done based on the starting offset of
> > > the PMD entry, rather than on the radix tree slot which was
> > > unreliable. (Jan)
> > > =A0- Fixed the one issue I could find with hole punch.=A0=A0As far as=
 I
> > > can tell hole punch now works correctly for both PMD and PTE DAX
> > > entries, 4k zero pages and huge zero pages.
> > > =A0- Fixed the way that ext2 returns the size of holes in
> > > ext2_get_block(). (Jan)
> > > =A0- Made the 'wait_table' global variable static in respnse to a
> > > sparse warning.
> > > =A0- Fixed some more inconsitent usage between the names 'ret' and
> > > 'entry' for radix tree entry variables.
> > > =

> > > Ross Zwisler (9):
> > > =A0 ext4: allow DAX writeback for hole punch
> > > =A0 ext2: tell DAX the size of allocation holes
> > > =A0 ext4: tell DAX the size of allocation holes
> > > =A0 dax: remove buffer_size_valid()
> > > =A0 dax: make 'wait_table' global variable static
> > > =A0 dax: consistent variable naming for DAX entries
> > > =A0 dax: coordinate locking for offsets in PMD range
> > > =A0 dax: re-enable DAX PMD support
> > > =A0 dax: remove "depends on BROKEN" from FS_DAX_PMD
> > > =

> > > =A0fs/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0|=A0=A0=A01 -
> > > =A0fs/dax.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0| 297 ++++++++++++++++=
+++++++++++++-----------
> > > ------------
> > > =A0fs/ext2/inode.c=A0=A0=A0=A0=A0|=A0=A0=A03 +
> > > =A0fs/ext4/inode.c=A0=A0=A0=A0=A0|=A0=A0=A07 +-
> > > =A0include/linux/dax.h |=A0=A029 ++++-
> > > =A0mm/filemap.c=A0=A0=A0=A0=A0=A0=A0=A0|=A0=A0=A06 +-
> > > =A06 files changed, 201 insertions(+), 142 deletions(-)
> > > =

> > > --=A0
> > > 2.9.0
> > =

> > Ping on this series?=A0=A0Any objections or comments?
> =

> Hi Ross,
> =

> I am seeing a major performance loss in fio mmap test with this patch-
> set applied. =A0This happens with or without my patches [1] applied on
> top of yours. =A0Without my patches,=A0dax_pmd_fault() falls back to the
> pte handler since an mmap'ed address is not 2MB-aligned.
> =

> I have attached three test results.
> =A0o rc4.log - 4.8.0-rc4 (base)
> =A0o non-pmd.log - 4.8.0-rc4 + your patchset (fall back to pte)
> =A0o pmd.log - 4.8.0-rc4 + your patchset + my patchset (use pmd maps)
> =

> My test steps are as follows.
> =

> mkfs.ext4 -O bigalloc -C 2M /dev/pmem0
> mount -o dax /dev/pmem0 /mnt/pmem0
> numactl --preferred block:pmem0 --cpunodebind block:pmem0 fio test.fio
> =

> "test.fio"
> ---
> [global]
> bs=3D4k
> size=3D2G
> directory=3D/mnt/pmem0
> ioengine=3Dmmap
> [randrw]
> rw=3Drandrw
> ---
> =

> Can you please take a look?

Yep, thanks for the report.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
