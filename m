Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 30CD021A143EF
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jul 2018 14:15:50 -0700 (PDT)
Date: Tue, 10 Jul 2018 15:15:19 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [fstests PATCH 2/2] generic/999: test DAX DMA vs
 truncate/hole-punch
Message-ID: <20180710211519.GA25279@linux.intel.com>
References: <20180620225147.12151-1-ross.zwisler@linux.intel.com>
 <20180620225147.12151-2-ross.zwisler@linux.intel.com>
 <20180621024033.GK2780@desktop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180621024033.GK2780@desktop>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 21, 2018 at 10:40:33AM +0800, Eryu Guan wrote:
> On Wed, Jun 20, 2018 at 04:51:47PM -0600, Ross Zwisler wrote:
<>

> > diff --git a/tests/generic/999 b/tests/generic/999
> > new file mode 100755
> > index 00000000..8f488cb5
> > --- /dev/null
> > +++ b/tests/generic/999
> > @@ -0,0 +1,50 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Intel Corporation.  All Rights Reserved.
> > +#
> > +# FS QA Test generic/999
> > +#
> > +# This is a regression test for kernel patch:
> > +#   ext4: handle layout changes to pinned DAX mapping
> > +# created by Ross Zwisler <ross.zwisler@linux.intel.com>
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_test
> > +_require_test_program "t_mmap_collision"
> 
> _require_xfs_io_command "fpunch"
> _require_xfs_io_command "fcollapse"
> _require_xfs_io_command "fzero"

I don't think I need these because I don't actually require this functionality
from xfs_io.  I did try and use xfs_io for this test, but the way the
threading needs to work I ended up having to write my own C program.  So,
even if xfs_io happens to be old and without fpunch, for example, as long as
fallocate can use FALLC_FL_PUNCH_HOLE I think the test should do the right
thing.

> > diff --git a/tests/generic/group b/tests/generic/group
> > index 83a6fdab..793f71ed 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -501,3 +501,4 @@
> >  496 auto quick swap
> >  497 auto quick swap collapse
> >  498 auto quick log
> > +999 auto quick dax
> 
> Also need "punch collapse zero" groups.

I'm assuming I should still add my test to these 3 groups, even though I'm not
getting this functionality via xfs_io?

Thank you for the review, I'll address the rest of your comments in v2.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
