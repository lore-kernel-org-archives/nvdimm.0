Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 8 Jan 2016 11:16:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/4] xfs: unmap dax at shutdown (force_failure)
Message-ID: <20160108001639.GR21461@dastard>
References: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160106045632.38788.84927.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160106045632.38788.84927.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 05, 2016 at 08:56:32PM -0800, Dan Williams wrote:
> When an exceptional event triggers xfs_force_shutdown() tear down dax
> mappings.  Quoting Dave,
> 
>     "The simple fact is that a /filesystem/ shutdown needs to do DAX
>     mapping invalidation regardless of whether the block device has
>     been unplugged or not. This is not a case of "this only happens
>     when we unplug the device", this is a user data protection
>     mechanism that we use to prevent corruption propagation once it
>     has been detected. A device unplug is just one type of
>     "corruption" that can occur."
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/xfs/xfs_fsops.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index ee3aaa0a5317..0c6a52809dcc 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -828,6 +828,15 @@ xfs_do_force_shutdown(
>  	if (xfs_log_force_umount(mp, logerror))
>  		return;
>  
> +	/*
> +	 * If DAX is in use, we have to unmap all direct access virtual
> +	 * mappings to ensure nothing more gets written directly from
> +	 * userspace. This will force them to refault and that will
> +	 * result in them detecting the shutdown condition and hence
> +	 * will fail appropriately.
> +	 */
> +	unmap_dax_inodes(mp->m_super);
> +
>  	if (flags & SHUTDOWN_CORRUPT_INCORE) {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
>      "Corruption of in-memory data detected.  Shutting down filesystem");

Looks fine.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
