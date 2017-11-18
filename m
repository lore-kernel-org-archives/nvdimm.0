Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9654221B00DC1
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 19:46:51 -0800 (PST)
Date: Sat, 18 Nov 2017 11:51:00 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [fstests PATCH v4 2/4] dm-log-writes: only replay log to marks
 that exist
Message-ID: <20171118035100.GC2749@eguan.usersys.redhat.com>
References: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
 <20171117202828.25472-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171117202828.25472-3-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 17, 2017 at 01:28:26PM -0700, Ross Zwisler wrote:
> The 'replay-log' executable will replay the dm-log-writes log until the
> given mark, or until the end of the log if the mark isn't found.
> 
> This means that if the mark you're looking for was never inserted in the
> log or if you give garbage to _log_writes_replay_log() the entire log will
> be replayed.  This can cause unexpected test results.
> 
> Fix this by making sure that the mark we're given actually exists in the
> log before we allow the replay.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  common/dmlogwrites | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/common/dmlogwrites b/common/dmlogwrites
> index 247c744..80ed4fc 100644
> --- a/common/dmlogwrites
> +++ b/common/dmlogwrites
> @@ -72,6 +72,10 @@ _log_writes_replay_log()
>  {
>  	_mark=$1
>  
> +	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --find \
> +		--end-mark $_mark >> $seqres.full 2>&1
> +	[ $? -ne 0 ] && _fail "mark does not exist"

Print out $_mark too?

Thanks,
Eryu

> +
>  	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --replay $SCRATCH_DEV \
>  		--end-mark $_mark >> $seqres.full 2>&1
>  	[ $? -ne 0 ] && _fail "replay failed"
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
