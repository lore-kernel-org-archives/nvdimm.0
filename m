Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145])
 by ml01.01.org (Postfix) with ESMTP id 2170520986AA8
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 18:41:09 -0700 (PDT)
Date: Sat, 14 Jul 2018 11:41:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [fstests PATCH v2 2/2] generic/999: test DAX DMA vs
 truncate/hole-punch
Message-ID: <20180714014105.GY2234@dastard>
References: <20180710220942.21074-1-ross.zwisler@linux.intel.com>
 <20180710220942.21074-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180710220942.21074-3-ross.zwisler@linux.intel.com>
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

On Tue, Jul 10, 2018 at 04:09:42PM -0600, Ross Zwisler wrote:
> This adds a regression test for the following series:
> 
> https://lists.01.org/pipermail/linux-nvdimm/2018-July/016842.html
> 
> which adds synchronization between DAX DMA in ext4 and truncate/hole-punch.
> The intention of the test is to test those specific changes, but it runs
> fine both with XFS and without DAX so I've put it in the generic tests
> instead of ext4 and not restricted it to only DAX configurations.
> 
> When run with v4.18-rc4 + DAX + ext4, this test will hit the following
> WARN_ON_ONCE() in dax_disassociate_entry():
> 
> 	WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
> 
> If you change this to a WARN_ON() instead, you can see that each of the
> four paths being exercised in this test hits that condition many times in
> the one second that the subtest is being run.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

just a FWIW:

> +int main(int argc, char *argv[])
> +{
> +	int err;
> +
> +	if (argc != 3) {
> +		printf("Usage: %s <dax file> <non-dax file>\n",
> +				basename(argv[0]));
> +		exit(0);
> +	}

This is an example of why we should be supporting per-inode DAX
enablement in all filesystems, not a global mount option....

> +_supported_fs generic
> +_supported_os Linux
> +_require_test
> +_require_test_program "t_mmap_collision"
> +
> +# To get the failure we turn off DAX on our SCRATCH_MNT so we can get O_DIRECT
> +# behavior.  We will continue to use unmodified mount options for the test
> +# TEST_DIR.  The failures fixed by the above mentioned kernel patch trigger
> +# when those mount options include "-o dax", but the test runs fine without
> +# that option so we don't require it.
> +export MOUNT_OPTIONS=""
> +_scratch_unmount >> $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1

And then all this crap would go away....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
