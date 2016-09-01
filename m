Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 49BD41A1E6E
 for <linux-nvdimm@lists.01.org>; Thu,  1 Sep 2016 09:21:40 -0700 (PDT)
Date: Thu, 1 Sep 2016 10:21:39 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 0/9] re-enable DAX PMD support
Message-ID: <20160901162139.GA6687@linux.intel.com>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
 <20160830230150.GA12173@linux.intel.com>
 <1472674799.2092.19.camel@hpe.com>
 <20160831213607.GA6921@linux.intel.com>
 <1472681284.2092.30.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1472681284.2092.30.camel@hpe.com>
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

On Wed, Aug 31, 2016 at 10:08:59PM +0000, Kani, Toshimitsu wrote:
> On Wed, 2016-08-31 at 15:36 -0600, Ross Zwisler wrote:
> > On Wed, Aug 31, 2016 at 08:20:48PM +0000, Kani, Toshimitsu wrote:
> > > =

> > > On Tue, 2016-08-30 at 17:01 -0600, Ross Zwisler wrote:
> > > > =

> > > > On Tue, Aug 23, 2016 at 04:04:10PM -0600, Ross Zwisler wrote:
> =A0:
> > > > =

> > > > Ping on this series?=A0=A0Any objections or comments?
> > > =

> > > Hi Ross,
> > > =

> > > I am seeing a major performance loss in fio mmap test with this
> > > patch-set applied. =A0This happens with or without my patches [1]
> > > applied on top of yours. =A0Without my patches,=A0dax_pmd_fault() fal=
ls
> > > back to the pte handler since an mmap'ed address is not 2MB-
> > > aligned.
> > > =

> > > I have attached three test results.
> > > =A0o rc4.log - 4.8.0-rc4 (base)
> > > =A0o non-pmd.log - 4.8.0-rc4 + your patchset (fall back to pte)
> > > =A0o pmd.log - 4.8.0-rc4 + your patchset + my patchset (use pmd maps)
> > > =

> > > My test steps are as follows.
> > > =

> > > mkfs.ext4 -O bigalloc -C 2M /dev/pmem0
> > > mount -o dax /dev/pmem0 /mnt/pmem0
> > > numactl --preferred block:pmem0 --cpunodebind block:pmem0 fio
> > > test.fio
> > > =

> > > "test.fio"
> > > ---
> > > [global]
> > > bs=3D4k
> > > size=3D2G
> > > directory=3D/mnt/pmem0
> > > ioengine=3Dmmap
> > > [randrw]
> > > rw=3Drandrw
> > > ---
> > > =

> > > Can you please take a look?
> > =

> > Yep, thanks for the report.
> =

> I have some more observations. =A0It seems this issue is related with pmd
> mappings after all. =A0fio creates "randrw.0.0" file. =A0In my setup, an
> initial test run creates pmd mappings and hits this issue. =A0Subsequent
> test runs (i.e. randrw.0.0 exists), without my patches, fall back to
> pte mappings and do not hit this issue. =A0With my patches applied,
> subsequent runs still create pmd mappings and hit this issue.

I've been able to reproduce this on my test setup, and I agree that it appe=
ars
to be related to the PMD mappings.  Here's my performance with 4k mappings,
either before my set or without your patches:

 READ: io=3D1022.7MB, aggrb=3D590299KB/s, minb=3D590299KB/s, maxb=3D590299K=
B/s, mint=3D1774msec, maxt=3D1774msec
WRITE: io=3D1025.4MB, aggrb=3D591860KB/s, minb=3D591860KB/s, maxb=3D591860K=
B/s, mint=3D1774msec, maxt=3D1774msec

And with 2 MiB pages:

 READ: io=3D1022.7MB, aggrb=3D17931KB/s, minb=3D17931KB/s, maxb=3D17931KB/s=
, mint=3D58401msec, maxt=3D58401msec
WRITE: io=3D1025.4MB, aggrb=3D17978KB/s, minb=3D17978KB/s, maxb=3D17978KB/s=
, mint=3D58401msec, maxt=3D58401msec

Dan is seeing something similar with his device DAX code with 2MiB pages, so
our best guess right now is that it must be in the PMD MM code, since that's
really the only thing that the fs/dax and device/dax implementations share.

Interestingly, I'm getting the opposite results when testing in my VM.  Her=
e's
the performance with 4k pages:

 READ: io=3D1022.7MB, aggrb=3D251728KB/s, minb=3D251728KB/s, maxb=3D251728K=
B/s, mint=3D4160msec, maxt=3D4160msec
WRITE: io=3D1025.4MB, aggrb=3D252394KB/s, minb=3D252394KB/s, maxb=3D252394K=
B/s, mint=3D4160msec, maxt=3D4160msec

And with 2MiB pages:

 READ: io=3D1022.7MB, aggrb=3D902751KB/s, minb=3D902751KB/s, maxb=3D902751K=
B/s, mint=3D1160msec, maxt=3D1160msec
WRITE: io=3D1025.4MB, aggrb=3D905137KB/s, minb=3D905137KB/s, maxb=3D905137K=
B/s, mint=3D1160msec, maxt=3D1160msec

This is a totally different system, so the halved 4k performance in the VM
isn't comparable to my bare metal system, but it's interesting that the use=
 of
PMDs over tripled the performance in my VM.  Hmm...

We'll keep digging into this.  Thanks again for the report. :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
