Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145])
 by ml01.01.org (Postfix) with ESMTP id 1C353211C7F1B
 for <linux-nvdimm@lists.01.org>; Wed, 20 Jun 2018 19:18:44 -0700 (PDT)
Date: Thu, 21 Jun 2018 12:18:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [fstests PATCH 2/2] generic/999: test DAX DMA vs
 truncate/hole-punch
Message-ID: <20180621021842.GB13748@dastard>
References: <20180620225147.12151-1-ross.zwisler@linux.intel.com>
 <20180620225147.12151-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180620225147.12151-2-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-nvdimm@lists.01.org, fstests@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 20, 2018 at 04:51:47PM -0600, Ross Zwisler wrote:
> diff --git a/src/t_mmap_collision.c b/src/t_mmap_collision.c
> new file mode 100644
> index 00000000..f652e913
> --- /dev/null
> +++ b/src/t_mmap_collision.c
> @@ -0,0 +1,208 @@
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <unistd.h>

No license (SPDX), no copyright, no comments explaining what the
code is for, what bug/API it is trying to exercise how it works,
command line usage, etc.

> +++ b/tests/generic/999
> @@ -0,0 +1,50 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Intel Corporation.  All Rights Reserved.
> +#
> +# FS QA Test generic/999
> +#
> +# This is a regression test for kernel patch:
> +#   ext4: handle layout changes to pinned DAX mapping
> +# created by Ross Zwisler <ross.zwisler@linux.intel.com>

Author information is stored in the git tree, not the code.

> +rm -f $seqres.full
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_test
> +_require_test_program "t_mmap_collision"
> +
> +# turn off DAX on our scratch device so we can get normal O_DIRECT behavior
> +export MOUNT_OPTIONS=""
> +_scratch_unmount >> $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1

_exclude_scratch_mount_option "dax"

i.e. we skip the test if "-o dax" is in the mount options. We try
not to turn off all mount options, because then we never exercise
any filesystem configuration other than mount defaults, regardless of
what other mount options the tester has specified on the CLI or
in config files...

> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 83a6fdab..793f71ed 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -501,3 +501,4 @@
>  496 auto quick swap
>  497 auto quick swap collapse
>  498 auto quick log
> +999 auto quick dax

Why should this be in a "dax" group when the test explicitly turns
off the the DAX mount option?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
