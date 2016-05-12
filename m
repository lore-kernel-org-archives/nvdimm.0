Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 8836D1A1E51
 for <linux-nvdimm@lists.01.org>; Thu, 12 May 2016 11:45:25 -0700 (PDT)
Date: Thu, 12 May 2016 12:45:22 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 3/7] ext2: Avoid DAX zeroing to corrupt data
Message-ID: <20160512184522.GA19851@linux.intel.com>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
 <1462960733-29634-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462960733-29634-4-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 11, 2016 at 11:58:49AM +0200, Jan Kara wrote:
> Currently ext2 zeroes any data blocks allocated for DAX inode however it
> still returns them as BH_New. Thus DAX code zeroes them again in
> dax_insert_mapping() which can possibly overwrite the data that has been
> already stored to those blocks by a racing dax_io(). Avoid marking
> pre-zeroed buffers as new.
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext2/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 6bd58e6ff038..1f07b758b968 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -745,11 +745,11 @@ static int ext2_get_blocks(struct inode *inode,
>  			mutex_unlock(&ei->truncate_mutex);
>  			goto cleanup;
>  		}
> -	}
> +	} else
> +		set_buffer_new(bh_result);
>  
>  	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
>  	mutex_unlock(&ei->truncate_mutex);
> -	set_buffer_new(bh_result);
>  got_it:
>  	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
>  	if (count > blocks_to_boundary)
> -- 
> 2.6.6

Interestingly this change is causing a bunch of xfstests regressions for me
with ext2 + DAX.  All of these tests pass without this one change.

# ./check generic/075 generic/091 generic/112 generic/127 generic/231 generic/263
FSTYP         -- ext2
PLATFORM      -- Linux/x86_64 alara 4.6.0-rc5+
MKFS_OPTIONS  -- /dev/pmem0p2
MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch

generic/075 2s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/075.out.bad)
    --- tests/generic/075.out	2015-10-02 10:19:36.798795839 -0600
    +++ /root/xfstests/results//generic/075.out.bad	2016-05-12 12:40:06.558706982 -0600
    @@ -4,15 +4,5 @@
     -----------------------------------------------
     fsx.0 : -d -N numops -S 0
     -----------------------------------------------
    -
    ------------------------------------------------
    -fsx.1 : -d -N numops -S 0 -x
    ------------------------------------------------
    ...
    (Run 'diff -u tests/generic/075.out /root/xfstests/results//generic/075.out.bad'  to see the entire diff)
generic/091 1s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/091.out.bad)
    --- tests/generic/091.out	2015-10-02 10:19:36.800795853 -0600
    +++ /root/xfstests/results//generic/091.out.bad	2016-05-12 12:40:07.366712217 -0600
    @@ -1,7 +1,110 @@
     QA output created by 091
     fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
    ...
    (Run 'diff -u tests/generic/091.out /root/xfstests/results//generic/091.out.bad'  to see the entire diff)
generic/112 2s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/112.out.bad)
    --- tests/generic/112.out	2015-10-02 10:19:36.802795866 -0600
    +++ /root/xfstests/results//generic/112.out.bad	2016-05-12 12:40:08.601720218 -0600
    @@ -4,15 +4,5 @@
     -----------------------------------------------
     fsx.0 : -A -d -N numops -S 0
     -----------------------------------------------
    -
    ------------------------------------------------
    -fsx.1 : -A -d -N numops -S 0 -x
    ------------------------------------------------
    ...
    (Run 'diff -u tests/generic/112.out /root/xfstests/results//generic/112.out.bad'  to see the entire diff)
generic/127 14s ... - output mismatch (see /root/xfstests/results//generic/127.out.bad)
    --- tests/generic/127.out	2016-02-17 16:02:40.110656181 -0700
    +++ /root/xfstests/results//generic/127.out.bad	2016-05-12 12:40:16.861773730 -0600
    @@ -4,10 +4,905 @@
     === FSX Light Mode, Memory Mapping ===
     All 100000 operations completed A-OK!
     === FSX Standard Mode, No Memory Mapping ===
    -All 100000 operations completed A-OK!
    +ltp/fsx -q -l 262144 -o 65536 -S 191110531 -N 100000 -R -W fsx_std_nommap
    +READ BAD DATA: offset = 0xd72d, size = 0x826b, fname = /mnt/xfstests_test/fsx_std_nommap
    +OFFSET	GOOD	BAD	RANGE
    ...
    (Run 'diff -u tests/generic/127.out /root/xfstests/results//generic/127.out.bad'  to see the entire diff)
generic/231 22s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/231.out.bad)
    --- tests/generic/231.out	2016-02-17 16:02:40.120656239 -0700
    +++ /root/xfstests/results//generic/231.out.bad	2016-05-12 12:40:19.266789311 -0600
    @@ -1,16 +1,1802 @@
     QA output created by 231
     === FSX Standard Mode, Memory Mapping, 1 Tasks ===
    -All 20000 operations completed A-OK!
    -Comparing user usage
    -Comparing group usage
    -=== FSX Standard Mode, Memory Mapping, 4 Tasks ===
    -All 20000 operations completed A-OK!
    ...
    (Run 'diff -u tests/generic/231.out /root/xfstests/results//generic/231.out.bad'  to see the entire diff)
generic/263 1s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/263.out.bad)
    --- tests/generic/263.out	2015-10-02 10:19:36.807795900 -0600
    +++ /root/xfstests/results//generic/263.out.bad	2016-05-12 12:40:19.801792777 -0600
    @@ -1,3 +1,1429 @@
     QA output created by 263
     fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
    -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
    +main: filesystem does not support fallocate mode 0, disabling!
    +main: filesystem does not support fallocate mode FALLOC_FL_KEEP_SIZE, disabling!
    +main: filesystem does not support fallocate mode FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, disabling!
    +main: filesystem does not support fallocate mode FALLOC_FL_ZERO_RANGE, disabling!
    ...
    (Run 'diff -u tests/generic/263.out /root/xfstests/results//generic/263.out.bad'  to see the entire diff)
Ran: generic/075 generic/091 generic/112 generic/127 generic/231 generic/263
Failures: generic/075 generic/091 generic/112 generic/127 generic/231 generic/263
Failed 6 of 6 tests
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
