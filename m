Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3BE52034A8A3
 for <linux-nvdimm@lists.01.org>; Wed, 17 Jan 2018 20:18:24 -0800 (PST)
Date: Thu, 18 Jan 2018 12:23:43 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [fstests PATCH 2/2] generic/347: dm-thin lacks DAX support
Message-ID: <20180118042343.GQ3102@eguan.usersys.redhat.com>
References: <20180117232351.19286-1-ross.zwisler@linux.intel.com>
 <20180117232351.19286-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180117232351.19286-2-ross.zwisler@linux.intel.com>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 17, 2018 at 04:23:51PM -0700, Ross Zwisler wrote:
> generic/347 currently fails when run in cojunction with the DAX mount
> option:
> 
> generic/347 72s ... - output mismatch (see
> /root/project/xfstests/results//generic/347.out.bad)
>     --- tests/generic/347.out	2016-05-12 11:56:32.086618744 -0600
>     +++ /root/project/xfstests/results//generic/347.out.bad	2018-01-17
>     16:04:33.459348448 -0700
>     @@ -1,2 +1,3 @@
>      QA output created by 347
>     +mount: /mnt/xfstests_scratch: can't read superblock on
>     /dev/mapper/thin-vol.
>      === completed
>     ...
>     (Run 'diff -u tests/generic/347.out
>     /root/project/xfstests/results//generic/347.out.bad'  to see the entire
>     diff)
> 
> This is expected because the dm-thin target currently lacks DAX support.
> 
> Just skip this test if we are using DAX.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  tests/generic/347 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/generic/347 b/tests/generic/347
> index 3adc6744..0c2dec98 100755
> --- a/tests/generic/347
> +++ b/tests/generic/347
> @@ -72,6 +72,7 @@ _supported_fs generic
>  _supported_os Linux
>  _require_scratch_nocheck
>  _require_dm_target thin-pool
> +_exclude_scratch_mount_option dax

IMHO, it'd be better to put this in common/dmthin file, as what's done
in common/dmerror or common/dmflakey (we grep for dax directly there,
that's because they've been added before _exclude_scratch_mount_option
was introduced), so all thinp tests are excluded from dax tests.

Thanks,
Eryu

>  
>  _setup_thin
>  _workout
> -- 
> 2.14.3
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
