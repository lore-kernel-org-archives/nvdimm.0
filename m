Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B4C6220955F0F
 for <linux-nvdimm@lists.01.org>; Mon, 26 Feb 2018 02:02:29 -0800 (PST)
Date: Mon, 26 Feb 2018 11:08:32 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 5/6] dax: short circuit vma_is_fsdax() in the
 CONFIG_FS_DAX=n case
Message-ID: <20180226100832.xidetsf3eoagumqd@quack2.suse.cz>
References: <151943298533.29249.14597996053028346159.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151943301788.29249.13371602951635567379.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151943301788.29249.13371602951635567379.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 23-02-18 16:43:37, Dan Williams wrote:
> Do not bother looking up the file type in the case when Filesystem-DAX
> is disabled at build time.
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/fs.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7418341578a3..c97fc4dbaae1 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3197,6 +3197,8 @@ static inline bool vma_is_fsdax(struct vm_area_struct *vma)
>  
>  	if (!vma->vm_file)
>  		return false;
> +	if (!IS_ENABLED(CONFIG_FS_DAX))
> +		return false;
>  	if (!vma_is_dax(vma))
>  		return false;
>  	inode = file_inode(vma->vm_file);
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
