Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E319F1A1DF1
 for <linux-nvdimm@lists.01.org>; Wed, 10 Aug 2016 22:16:54 -0700 (PDT)
Date: Thu, 11 Aug 2016 06:16:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] fs/char_dev: fix cdev_put() vs f_op->release()
 use-after-free
Message-ID: <20160811051650.GS2356@ZenIV.linux.org.uk>
References: <147089096242.9037.17705831938180576705.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147089096242.9037.17705831938180576705.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 10, 2016 at 09:49:22PM -0700, Dan Williams wrote:

> Where dax_dev_release() is the f_op->release() method, and is
> implemented to simply drop the final references on our driver objects:
> 
>         struct dax_dev *dax_dev = filp->private_data;
>         struct device *dev = dax_dev->dev;
> 
>         dev_dbg(dax_dev->dev, "%s\n", __func__);
>         put_device(dev);
>         dax_dev_put(dax_dev);
> 
> The dax_dev object embeds a 'struct cdev' which means f_op->release()
> may free cdev, so __fput() needs to drop the cdev reference before
> calling f_op->release().

NAK.  You *can't* free a structure that contains kobj with currently
positive refcount.  Ever.  If you embed a struct kobj into something,
you must use the refcount of that kobj (or one of its ancestors) to
control the lifetime of containing object.  If your dax_dev_put() can
trigger freeing of dax_dev despite the still-positive refcount of
embedded cdev.kobj, it is fundamentally broken.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
