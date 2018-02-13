Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DE1821CF1CE3
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 12:38:00 -0800 (PST)
Date: Tue, 13 Feb 2018 13:43:49 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 2/3] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <20180213204349.GC13682@linux.intel.com>
References: <151813659955.15926.8922476613392258086.stgit@djiang5-desk3.ch.intel.com>
 <151813669915.15926.5489252461577531.stgit@djiang5-desk3.ch.intel.com>
 <20180213203148.GB13682@linux.intel.com>
 <2e99d401-04f5-5a1c-1b7a-6c0fb6054beb@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2e99d401-04f5-5a1c-1b7a-6c0fb6054beb@intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org, darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 13, 2018 at 01:35:19PM -0700, Dave Jiang wrote:
> 
> 
> On 02/13/2018 01:31 PM, Ross Zwisler wrote:
> > On Thu, Feb 08, 2018 at 05:38:19PM -0700, Dave Jiang wrote:
> >> The function return values are confusing with the way the function is
> >> named. We expect a true or false return value but it actually returns
> >> 0/-errno.  This makes the code very confusing. Changing the return values
> >> to return a bool where if DAX is supported then return true and no DAX
> >> support returns false.
> >>
> >> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >> ---
> > 
> >> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> >> index 655699321c45..636b9c5e1bff 100644
> >> --- a/fs/ext2/super.c
> >> +++ b/fs/ext2/super.c
> >> @@ -958,9 +958,10 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
> >>  	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
> >>  
> >>  	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
> >> -		err = sb_dax_supported(sb, blocksize);
> >> -		if (err)
> >> +		if(!sb_dax_supported(sb, blocksize)) {
> >> +			err = -EIO;
> > 
> > No need to set 'err' here.  This is just a temporary variable used for some
> > local checks later in the function.  'ret' is the value that will be returned,
> > and that is already initialized to -EINVAL which should be fine.
> 
> Change ret to -EIO instead to set the correct error return code?

I'm not sure that -EIO is the 'correct' return code.  The old
sb_dax_supported() code could have returned -EINVAL, -EOPNOTSUPP or -EIO,
based on what went wrong.  All the other error cases in this function just
goto failed_mount without messing with 'ret', and we should probably do the
same.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
