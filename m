Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB4C421AE30FD
 for <linux-nvdimm@lists.01.org>; Thu,  1 Jun 2017 22:57:51 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id l18so79798281oig.2
 for <linux-nvdimm@lists.01.org>; Thu, 01 Jun 2017 22:58:54 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 1 Jun 2017 22:58:51 -0700
Message-ID: <CAPcyv4hgj7KUDC5bda-y1wG15SnORZA+kwuQcNNfnrUmjL20Yw@mail.gmail.com>
Subject: Re: [PATCH] device-dax: fix 'dax' device filesystem inode destruction
 crash
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Sasha Levin <alexander.levin@verizon.com>
List-ID: <linux-nvdimm@lists.01.org>

[ adding lkml, dropping 'ndctl prefix ]

On Thu, Jun 1, 2017 at 10:39 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> The inode destruction path for the 'dax' device filesystem incorrectly
> assumes that the inode was initialized through 'alloc_dax()'. However,
> if someone attempts to directly mount the dax filesystem with 'mount -t
> dax dax mnt' that will bypass 'alloc_dax()' and the following failure
> signatures may occur as a result:
>
>  kill_dax() must be called before final iput()
>  WARNING: CPU: 2 PID: 1188 at drivers/dax/super.c:243 dax_destroy_inode+0x48/0x50
>  RIP: 0010:dax_destroy_inode+0x48/0x50
>  Call Trace:
>   destroy_inode+0x3b/0x60
>   evict+0x139/0x1c0
>   iput+0x1f9/0x2d0
>   dentry_unlink_inode+0xc3/0x160
>   __dentry_kill+0xcf/0x180
>   ? dput+0x37/0x3b0
>   dput+0x3a3/0x3b0
>   do_one_tree+0x36/0x40
>   shrink_dcache_for_umount+0x2d/0x90
>   generic_shutdown_super+0x1f/0x120
>   kill_anon_super+0x12/0x20
>   deactivate_locked_super+0x43/0x70
>   deactivate_super+0x4e/0x60
>
>  general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
>  RIP: 0010:kfree+0x6d/0x290
>  Call Trace:
>   <IRQ>
>   dax_i_callback+0x22/0x60
>   ? dax_destroy_inode+0x50/0x50
>   rcu_process_callbacks+0x298/0x740
>
>  ida_remove called for id=0 which is not allocated.
>  WARNING: CPU: 0 PID: 0 at lib/idr.c:383 ida_remove+0x110/0x120
>  [..]
>  Call Trace:
>   <IRQ>
>   ida_simple_remove+0x2b/0x50
>   ? dax_destroy_inode+0x50/0x50
>   dax_i_callback+0x3c/0x60
>   rcu_process_callbacks+0x298/0x740
>
> Add missing initialization of the 'struct dax_device' and inode so that
> the destruction path does not kfree() or ida_simple_remove()
> uninitialized data.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 7b6be8444e0f ("dax: refactor dax-fs into a generic provider of 'struct dax_device' instances")
> Reported-by: Sasha Levin <alexander.levin@verizon.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/super.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 6ed32aac8bbe..922d0823f8ec 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -210,9 +210,12 @@ EXPORT_SYMBOL_GPL(kill_dax);
>  static struct inode *dax_alloc_inode(struct super_block *sb)
>  {
>         struct dax_device *dax_dev;
> +       struct inode *inode;
>
>         dax_dev = kmem_cache_alloc(dax_cache, GFP_KERNEL);
> -       return &dax_dev->inode;
> +       inode = &dax_dev->inode;
> +       inode->i_rdev = 0;
> +       return inode;
>  }
>
>  static struct dax_device *to_dax_dev(struct inode *inode)
> @@ -227,7 +230,8 @@ static void dax_i_callback(struct rcu_head *head)
>
>         kfree(dax_dev->host);
>         dax_dev->host = NULL;
> -       ida_simple_remove(&dax_minor_ida, MINOR(inode->i_rdev));
> +       if (inode->i_rdev)
> +               ida_simple_remove(&dax_minor_ida, MINOR(inode->i_rdev));
>         kmem_cache_free(dax_cache, dax_dev);
>  }
>
> @@ -423,6 +427,7 @@ static void init_once(void *_dax_dev)
>         struct dax_device *dax_dev = _dax_dev;
>         struct inode *inode = &dax_dev->inode;
>
> +       memset(dax_dev, 0, sizeof(*dax_dev));
>         inode_init_once(inode);
>  }
>
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
