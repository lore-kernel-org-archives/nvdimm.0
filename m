Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A460C21B02822
 for <linux-nvdimm@lists.01.org>; Thu, 13 Sep 2018 11:25:54 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] dax: add missing address_space_operations for device dax
References: <153662150977.27329.9768329787276305204.stgit@djiang5-desk3.ch.intel.com>
Date: Thu, 13 Sep 2018 14:25:52 -0400
In-Reply-To: <153662150977.27329.9768329787276305204.stgit@djiang5-desk3.ch.intel.com>
 (Dave Jiang's message of "Mon, 10 Sep 2018 16:18:29 -0700")
Message-ID: <x49va79p83z.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dave Jiang <dave.jiang@intel.com> writes:

> With address_space_operations missing for device dax, namely the
> .set_page_dirty, we hit a kernel warning when running destructive
> ndctl unit test: make TESTS=device-dax check
>
> WARNING: CPU: 3 PID: 7380 at fs/buffer.c:581 __set_page_dirty+0xb1/0xc0
>
> Setting address_space_operations to noop_set_page_dirty and
> noop_invalidatepage for device dax to prevent fallback to
> __set_page_dirty_buffers() and block_invalidatepage() respectively.
>
> Fixes: 2232c6382a ("device-dax: Enable page_mapping()")
>
> Reported-by: Vishal Verma <vishal.l.verma@intel.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

I looked over the other aops, and I think this covers the fallback
paths.

Acked-by: Jeff Moyer <jmoyer@redhat.com>

> ---
>  drivers/dax/device.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 6fd46083e629..079f6811eca6 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -534,6 +534,11 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
>  	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
>  }
>  
> +static const struct address_space_operations dev_dax_aops = {
> +	.set_page_dirty		= noop_set_page_dirty,
> +	.invalidatepage		= noop_invalidatepage,
> +};
> +
>  static int dax_open(struct inode *inode, struct file *filp)
>  {
>  	struct dax_device *dax_dev = inode_dax(inode);
> @@ -543,6 +548,7 @@ static int dax_open(struct inode *inode, struct file *filp)
>  	dev_dbg(&dev_dax->dev, "trace\n");
>  	inode->i_mapping = __dax_inode->i_mapping;
>  	inode->i_mapping->host = __dax_inode;
> +	inode->i_mapping->a_ops = &dev_dax_aops;
>  	filp->f_mapping = inode->i_mapping;
>  	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
>  	filp->private_data = dev_dax;
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
