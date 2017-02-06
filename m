From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v5 2/2] generic: test mmap io through DAX and non-DAX
Date: Mon, 6 Feb 2017 12:17:17 -0700
Message-ID: <20170206191717.GB12290@linux.intel.com>
References: <1486221472-1007-1-git-send-email-ross.zwisler@linux.intel.com>
 <1486275704-18917-1-git-send-email-xzhou@redhat.com>
 <1486275704-18917-3-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486275704-18917-3-git-send-email-xzhou@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Xiong Zhou <xzhou@redhat.com>
Cc: ross.zwisler@linux.intel.com, fstests@vger.kernel.org, linux-nvdimm@ml01.01.org, jmoyer@redhat.com, eguan@redhat.com
List-Id: linux-nvdimm@lists.01.org

On Sun, Feb 05, 2017 at 02:21:44PM +0800, Xiong Zhou wrote:
> Mount TEST_DEV as non-DAX, SCRATCH_DEV as DAX, then
> do some IO between them. In this case we use mmap
> and dio/buffered IO read/write test programme.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Yep, this is fine.

> Signed-off-by: Xiong Zhou <xzhou@redhat.com>
<>
> diff --git a/tests/generic/407 b/tests/generic/407
<>
> +do_tests()
> +{
> +	# less than page size
> +	t_mmap_dio_dax 1024
> +	# page size
> +	t_mmap_dio_dax `src/feature -s`
> +	# bigger sizes, for PMD faults
> +	t_mmap_dio_dax $((16 * 1024 * 1024))
> +	t_mmap_dio_dax $((64 * 1024 * 1024))
> +}
> +
> +# make fs 2Mb aligned for PMD fault testing
> +if [[ $FSTYP =~ ext ]] ; then
> +	_scratch_mkfs "-E stride=512,stripe_width=1" \
> +		> /dev/null 2>&1
> +elif [[ $FSTYP =~ xfs ]] ; then
> +	_scratch_mkfs "-d su=2m,sw=1" > /dev/null 2>&1
> +fi
> +
> +# mount SCRATCH_DEV with dax option, TEST_DEV not
> +export MOUNT_OPTIONS=""
> +export TEST_FS_MOUNT_OPTS=""
> +_test_cycle_mount
> +_fs_options $TEST_DEV | grep -qw "dax" && \
> +	_notrun "we need $TEST_DEV mount without dax"
> +_scratch_mount "-o dax"
> +
> +tsize=$((64 * 1024 * 1024))

Ugh - for some reason 64 MiB files for me don't get PMDs on ext4 because the
ext4 block allocator gives us misaligned blocks.  I'll follow up with them in
a new thread on the ext4 list and I'll cc you, Xiong.

If we up this to 128 MiB, so

tsize=$((128 * 1024 * 1024))

I get PMDs for both ext4 and XFS.  Can we make this one change before
applying?

The rest looks good to me.  Thanks for the tests!

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
