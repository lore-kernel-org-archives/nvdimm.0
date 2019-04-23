Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au
 [211.29.132.249])
 by ml01.01.org (Postfix) with ESMTP id 1062321214945
 for <linux-nvdimm@lists.01.org>; Tue, 23 Apr 2019 15:02:27 -0700 (PDT)
Date: Wed, 24 Apr 2019 08:02:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 6/6] xfs: disable map_sync for async flush
Message-ID: <20190423220217.GA29573@dread.disaster.area>
References: <20190423080612.15361-1-pagupta@redhat.com>
 <20190423080612.15361-7-pagupta@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190423080612.15361-7-pagupta@redhat.com>
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
To: Pankaj Gupta <pagupta@redhat.com>
Cc: cohuck@redhat.com, jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger.kernel@dilger.ca, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval.shaia@oracle.com, stefanha@redhat.com, pbonzini@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong.eric@gmail.com, darrick.wong@oracle.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 23, 2019 at 01:36:12PM +0530, Pankaj Gupta wrote:
> Dont support 'MAP_SYNC' with non-DAX files and DAX files
> with asynchronous dax_device. Virtio pmem provides
> asynchronous host page cache flush mechanism. We don't
> support 'MAP_SYNC' with virtio pmem and xfs.
> 
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 1f2e2845eb76..0e59be018511 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1196,11 +1196,13 @@ xfs_file_mmap(
>  	struct file	*filp,
>  	struct vm_area_struct *vma)
>  {
> -	/*
> -	 * We don't support synchronous mappings for non-DAX files. At least
> -	 * until someone comes with a sensible use case.
> +	struct dax_device *dax_dev = xfs_find_daxdev_for_inode
> +						(file_inode(filp));
> +
> +	/* We don't support synchronous mappings for non-DAX files and
> +	 * for DAX files if underneath dax_device is not synchronous.
>  	 */

	/*
	 * This is the correct multi-line comment format. Please
	 * update the patch to maintain the existing comment format.
	 */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
