Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id B9E201A1E84
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 14:09:51 -0700 (PDT)
Date: Wed, 23 Mar 2016 15:08:44 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 06/10] dax: Remove redundant inode size checks
Message-ID: <20160323210844.GF5544@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-7-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458566575-28063-7-git-send-email-jack@suse.cz>
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
Cc: linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, Wilcox,
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 21, 2016 at 02:22:51PM +0100, Jan Kara wrote:
> Callers of dax fault handlers must make sure these calls cannot race
> with truncate. Thus it is enough to check inode size when entering the
> function and we don't have to recheck it again later in the handler.
> Note that inode size itself can be decreased while the fault handler
> runs but filesystem locking prevents against any radix tree or block
> mapping information changes resulting from the truncate and that is what
> we really care about.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/dax.c | 59 +----------------------------------------------------------
>  1 file changed, 1 insertion(+), 58 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 50d81172438b..0329ec0bee2e 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -316,20 +316,12 @@ EXPORT_SYMBOL_GPL(dax_do_io);
>  static int dax_load_hole(struct address_space *mapping, struct page *page,
>  							struct vm_fault *vmf)
>  {
> -	unsigned long size;
>  	struct inode *inode = mapping->host;

'inode' is also unused after this patch, and can be removed.

Otherwise the rest of this patch looks good to me, though Matthew might see
more as he was the original author of this code.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
