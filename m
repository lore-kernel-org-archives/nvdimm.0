Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECC2A209574FA
 for <linux-nvdimm@lists.01.org>; Mon, 26 Feb 2018 01:37:51 -0800 (PST)
Date: Mon, 26 Feb 2018 10:43:54 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 3/5] dax: fix S_DAX definition
Message-ID: <20180226094354.puos4owvd5s5pxtv@quack2.suse.cz>
References: <151937026001.18973.12034171121582300402.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151937027614.18973.7636331271085629639.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151937027614.18973.7636331271085629639.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 22-02-18 23:17:56, Dan Williams wrote:
> Make sure S_DAX is defined in the CONFIG_FS_DAX=n + CONFIG_DEV_DAX=y
> case. Otherwise vma_is_dax() may incorrectly return false in the
> Device-DAX case.
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jan Kara <jack@suse.cz>
> Cc: <stable@vger.kernel.org>
> Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/fs.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 79c413985305..b2fa9b4c1e51 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1859,7 +1859,7 @@ struct super_operations {
>  #define S_IMA		1024	/* Inode has an associated IMA struct */
>  #define S_AUTOMOUNT	2048	/* Automount/referral quasi-directory */
>  #define S_NOSEC		4096	/* no suid or xattr security attributes */
> -#ifdef CONFIG_FS_DAX
> +#if IS_ENABLED(CONFIG_FS_DAX) || IS_ENABLED(CONFIG_DEV_DAX)
>  #define S_DAX		8192	/* Direct Access, avoiding the page cache */
>  #else
>  #define S_DAX		0	/* Make all the DAX code disappear */
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
