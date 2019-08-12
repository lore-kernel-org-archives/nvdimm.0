Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13766212FD508
 for <linux-nvdimm@lists.01.org>; Mon, 12 Aug 2019 07:05:50 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [ndctl PATCH] ndctl/test: Add xfs reflink dependency
References: <156531368129.2136155.4247732841095137080.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Mon, 12 Aug 2019 10:03:27 -0400
In-Reply-To: <156531368129.2136155.4247732841095137080.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Thu, 08 Aug 2019 18:21:21 -0700")
Message-ID: <x494l2mjxao.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> Starting with xfsprogs version 5.1.0 it will enable reflink by default.
> Any scripts, like ndctl unit tests, that were doing:
>
>     mkfs.xfs $pmem; mount -o dax $pmem $mnt
>
> ...must now do:
>
>     mkfs.xfs -m reflink=0 $pmem; mount -o dax $pmem $mnt

Agreed.  In the future, the options may not be mutually exclusive, but I
don't see any harm in always testing with reflink=0 for the existing
tests.

Acked-by: Jeff Moyer <jmoyer@redhat.com>

>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  test/dax.sh  |    4 ++--
>  test/mmap.sh |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/test/dax.sh b/test/dax.sh
> index e703e1222dee..3bb44ac0a26c 100755
> --- a/test/dax.sh
> +++ b/test/dax.sh
> @@ -69,7 +69,7 @@ json=$($NDCTL create-namespace -m raw -f -e $dev)
>  eval $(json2var <<< "$json")
>  [ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
>  
> -mkfs.xfs -f /dev/$blockdev
> +mkfs.xfs -f /dev/$blockdev -m reflink=0
>  mount /dev/$blockdev $MNT -o dax
>  fallocate -l 1GiB $MNT/$FILE
>  run_test
> @@ -80,7 +80,7 @@ json=$($NDCTL create-namespace -m fsdax -M dev -f -e $dev)
>  eval $(json2var <<< "$json")
>  [ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
>  
> -mkfs.xfs -f /dev/$blockdev
> +mkfs.xfs -f /dev/$blockdev -m reflink=0
>  mount /dev/$blockdev $MNT -o dax
>  fallocate -l 1GiB $MNT/$FILE
>  run_test
> diff --git a/test/mmap.sh b/test/mmap.sh
> index afe50fd2199b..d072ea289f31 100755
> --- a/test/mmap.sh
> +++ b/test/mmap.sh
> @@ -70,7 +70,7 @@ fallocate -l 1GiB $MNT/$FILE
>  test_mmap
>  umount $MNT
>  
> -mkfs.xfs -f $DEV
> +mkfs.xfs -f $DEV -m reflink=0
>  mount $DEV $MNT -o dax
>  fallocate -l 1GiB $MNT/$FILE
>  test_mmap
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
