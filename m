Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26E50210E0F83
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 12:13:41 -0700 (PDT)
Date: Thu, 31 May 2018 12:13:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/7] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <20180531191332.GB7825@magnolia>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com>
 <20180529212510.GJ30110@magnolia>
 <20180529220114.GA13948@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180529220114.GA13948@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Dave Jiang <dave.jiang@intel.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 29, 2018 at 04:01:14PM -0600, Ross Zwisler wrote:
> On Tue, May 29, 2018 at 02:25:10PM -0700, Darrick J. Wong wrote:
> > On Tue, May 29, 2018 at 01:51:01PM -0600, Ross Zwisler wrote:
> > > From: Dave Jiang <dave.jiang@intel.com>
> > > 
> > > The function return values are confusing with the way the function is
> > > named. We expect a true or false return value but it actually returns
> > > 0/-errno.  This makes the code very confusing. Changing the return values
> > > to return a bool where if DAX is supported then return true and no DAX
> > > support returns false.
> > > 
> > > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > 
> > Looks ok, do you want me to pull the first two patches through the xfs
> > tree?
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Thanks for the review.
> 
> I'm not sure what's best.  If you do that then Mike will need to have a DM
> branch for the rest of the series based on your stable commits, yea?
> 
> Mike what would you prefer?

I /was/ about to say that I would pull in the first two patches, but now
I can't get xfs to mount with pmem at all, and have no way of testing
this...?

# echo 'file drivers/dax/* +p' > /sys/kernel/debug/dynamic_debug/control
# mount /dev/pmem3 -o rtdev=/dev/pmem4,dax /mnt
# dmesg
<snip>
SGI XFS with ACLs, security attributes, realtime, scrub, debug enabled
XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
pmem3: error: dax support not enabled
pmem4: error: dax support not enabled
XFS (pmem3): DAX unsupported by block device. Turning off DAX.
XFS (pmem3): Mounting V5 Filesystem
XFS (pmem3): Ending clean mount

Evidently the pfn it picks up is missing PFN_MAP in flags because
ND_REGION_PAGEMAP isn't set, and looking at the kernel source, pmem that
comes in via NFIT never gets that set...?

relevant qemu pmem options:

-object memory-backend-file,id=memnvdimm0,prealloc=no,mem-path=/dev/shm/a.img,share=yes,size=13488881664
-device nvdimm,node=0,memdev=memnvdimm0,id=nvdimm0,slot=0
(repeat for five more devices)

<confused>

--D

NFIT table contents:

0000000  4e  46  49  54  78  04  00  00  01  46  42  4f  43  48  53  20
          N   F   I   T   x 004  \0  \0 001   F   B   O   C   H   S    
0000016  42  58  50  43  4e  46  49  54  01  00  00  00  42  58  50  43
          B   X   P   C   N   F   I   T 001  \0  \0  \0   B   X   P   C
0000032  01  00  00  00  00  00  00  00  00  00  38  00  08  00  03  00
        001  \0  \0  \0  \0  \0  \0  \0  \0  \0   8  \0  \b  \0 003  \0
0000048  00  00  00  00  01  00  00  00  79  d3  f0  66  f3  b4  74  40
         \0  \0  \0  \0 001  \0  \0  \0   y 323 360   f 363 264   t   @
0000064  ac  43  0d  33  18  b7  8c  db  00  00  00  6c  0a  00  00  00
        254   C  \r   3 030 267 214 333  \0  \0  \0   l  \n  \0  \0  \0
0000080  00  00  00  24  03  00  00  00  08  80  00  00  00  00  00  00
         \0  \0  \0   $ 003  \0  \0  \0  \b 200  \0  \0  \0  \0  \0  \0
0000096  01  00  30  00  04  00  00  00  00  00  00  00  08  00  09  00
        001  \0   0  \0 004  \0  \0  \0  \0  \0  \0  \0  \b  \0  \t  \0
0000112  00  00  00  24  03  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0   $ 003  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000128  00  00  00  00  00  00  00  00  00  00  01  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0 001  \0  \0  \0  \0  \0
0000144  04  00  50  00  09  00  86  80  01  00  01  00  00  00  00  00
        004  \0   P  \0  \t  \0 206 200 001  \0 001  \0  \0  \0  \0  \0
0000160  00  00  00  00  00  00  00  00  59  34  12  00  01  03  00  00
         \0  \0  \0  \0  \0  \0  \0  \0   Y   4 022  \0 001 003  \0  \0
0000176  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0000224  00  00  38  00  0a  00  03  00  00  00  00  00  00  00  00  00
         \0  \0   8  \0  \n  \0 003  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000240  79  d3  f0  66  f3  b4  74  40  ac  43  0d  33  18  b7  8c  db
          y 323 360   f 363 264   t   @ 254   C  \r   3 030 267 214 333
0000256  00  00  00  90  0d  00  00  00  00  00  00  24  03  00  00  00
         \0  \0  \0 220  \r  \0  \0  \0  \0  \0  \0   $ 003  \0  \0  \0
0000272  08  80  00  00  00  00  00  00  01  00  30  00  05  00  00  00
         \b 200  \0  \0  \0  \0  \0  \0 001  \0   0  \0 005  \0  \0  \0
0000288  00  00  00  00  0a  00  0b  00  00  00  00  24  03  00  00  00
         \0  \0  \0  \0  \n  \0  \v  \0  \0  \0  \0   $ 003  \0  \0  \0
0000304  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000320  00  00  01  00  00  00  00  00  04  00  50  00  0b  00  86  80
         \0  \0 001  \0  \0  \0  \0  \0 004  \0   P  \0  \v  \0 206 200
0000336  01  00  01  00  00  00  00  00  00  00  00  00  00  00  00  00
        001  \0 001  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000352  5a  34  12  00  01  03  00  00  00  00  00  00  00  00  00  00
          Z   4 022  \0 001 003  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000368  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0000400  00  00  00  00  00  00  00  00  00  00  38  00  0c  00  03  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0   8  \0  \f  \0 003  \0
0000416  00  00  00  00  01  00  00  00  79  d3  f0  66  f3  b4  74  40
         \0  \0  \0  \0 001  \0  \0  \0   y 323 360   f 363 264   t   @
0000432  ac  43  0d  33  18  b7  8c  db  00  00  00  b4  10  00  00  00
        254   C  \r   3 030 267 214 333  \0  \0  \0 264 020  \0  \0  \0
0000448  00  00  00  24  03  00  00  00  08  80  00  00  00  00  00  00
         \0  \0  \0   $ 003  \0  \0  \0  \b 200  \0  \0  \0  \0  \0  \0
0000464  01  00  30  00  06  00  00  00  00  00  00  00  0c  00  0d  00
        001  \0   0  \0 006  \0  \0  \0  \0  \0  \0  \0  \f  \0  \r  \0
0000480  00  00  00  24  03  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0   $ 003  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000496  00  00  00  00  00  00  00  00  00  00  01  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0 001  \0  \0  \0  \0  \0
0000512  04  00  50  00  0d  00  86  80  01  00  01  00  00  00  00  00
        004  \0   P  \0  \r  \0 206 200 001  \0 001  \0  \0  \0  \0  \0
0000528  00  00  00  00  00  00  00  00  5b  34  12  00  01  03  00  00
         \0  \0  \0  \0  \0  \0  \0  \0   [   4 022  \0 001 003  \0  \0
0000544  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0000592  00  00  38  00  02  00  03  00  00  00  00  00  00  00  00  00
         \0  \0   8  \0 002  \0 003  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000608  79  d3  f0  66  f3  b4  74  40  ac  43  0d  33  18  b7  8c  db
          y 323 360   f 363 264   t   @ 254   C  \r   3 030 267 214 333
0000624  00  00  00  00  01  00  00  00  00  00  00  24  03  00  00  00
         \0  \0  \0  \0 001  \0  \0  \0  \0  \0  \0   $ 003  \0  \0  \0
0000640  08  80  00  00  00  00  00  00  01  00  30  00  01  00  00  00
         \b 200  \0  \0  \0  \0  \0  \0 001  \0   0  \0 001  \0  \0  \0
0000656  00  00  00  00  02  00  03  00  00  00  00  24  03  00  00  00
         \0  \0  \0  \0 002  \0 003  \0  \0  \0  \0   $ 003  \0  \0  \0
0000672  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000688  00  00  01  00  00  00  00  00  04  00  50  00  03  00  86  80
         \0  \0 001  \0  \0  \0  \0  \0 004  \0   P  \0 003  \0 206 200
0000704  01  00  01  00  00  00  00  00  00  00  00  00  00  00  00  00
        001  \0 001  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000720  56  34  12  00  01  03  00  00  00  00  00  00  00  00  00  00
          V   4 022  \0 001 003  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000736  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0000768  00  00  00  00  00  00  00  00  00  00  38  00  04  00  03  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0   8  \0 004  \0 003  \0
0000784  00  00  00  00  01  00  00  00  79  d3  f0  66  f3  b4  74  40
         \0  \0  \0  \0 001  \0  \0  \0   y 323 360   f 363 264   t   @
0000800  ac  43  0d  33  18  b7  8c  db  00  00  00  24  04  00  00  00
        254   C  \r   3 030 267 214 333  \0  \0  \0   $ 004  \0  \0  \0
0000816  00  00  00  24  03  00  00  00  08  80  00  00  00  00  00  00
         \0  \0  \0   $ 003  \0  \0  \0  \b 200  \0  \0  \0  \0  \0  \0
0000832  01  00  30  00  02  00  00  00  00  00  00  00  04  00  05  00
        001  \0   0  \0 002  \0  \0  \0  \0  \0  \0  \0 004  \0 005  \0
0000848  00  00  00  24  03  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0   $ 003  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000864  00  00  00  00  00  00  00  00  00  00  01  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0 001  \0  \0  \0  \0  \0
0000880  04  00  50  00  05  00  86  80  01  00  01  00  00  00  00  00
        004  \0   P  \0 005  \0 206 200 001  \0 001  \0  \0  \0  \0  \0
0000896  00  00  00  00  00  00  00  00  57  34  12  00  01  03  00  00
         \0  \0  \0  \0  \0  \0  \0  \0   W   4 022  \0 001 003  \0  \0
0000912  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0000960  00  00  38  00  06  00  03  00  00  00  00  00  00  00  00  00
         \0  \0   8  \0 006  \0 003  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000976  79  d3  f0  66  f3  b4  74  40  ac  43  0d  33  18  b7  8c  db
          y 323 360   f 363 264   t   @ 254   C  \r   3 030 267 214 333
0000992  00  00  00  48  07  00  00  00  00  00  00  24  03  00  00  00
         \0  \0  \0   H  \a  \0  \0  \0  \0  \0  \0   $ 003  \0  \0  \0
0001008  08  80  00  00  00  00  00  00  01  00  30  00  03  00  00  00
         \b 200  \0  \0  \0  \0  \0  \0 001  \0   0  \0 003  \0  \0  \0
0001024  00  00  00  00  06  00  07  00  00  00  00  24  03  00  00  00
         \0  \0  \0  \0 006  \0  \a  \0  \0  \0  \0   $ 003  \0  \0  \0
0001040  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0001056  00  00  01  00  00  00  00  00  04  00  50  00  07  00  86  80
         \0  \0 001  \0  \0  \0  \0  \0 004  \0   P  \0  \a  \0 206 200
0001072  01  00  01  00  00  00  00  00  00  00  00  00  00  00  00  00
        001  \0 001  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0001088  58  34  12  00  01  03  00  00  00  00  00  00  00  00  00  00
          X   4 022  \0 001 003  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0001104  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0001136  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0
0001144

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
