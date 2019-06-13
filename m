Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate15.nvidia.com (hqemgate15.nvidia.com [216.228.121.64])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E604F21295CA5
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 16:06:53 -0700 (PDT)
Subject: Re: [Nouveau] [PATCH 02/22] mm: remove the struct hmm_device
 infrastructure
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-3-hch@lst.de>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <5a11b5a1-cfb2-f9a1-493e-ed153de7f00b@nvidia.com>
Date: Thu, 13 Jun 2019 16:06:47 -0700
MIME-Version: 1.0
In-Reply-To: <20190613094326.24093-3-hch@lst.de>
Content-Language: en-US
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
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

On 6/13/19 2:43 AM, Christoph Hellwig wrote:
> This code is a trivial wrapper around device model helpers, which
> should have been integrated into the driver device model usage from
> the start.  Assuming it actually had users, which it never had since
> the code was added more than 1 1/2 years ago.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/hmm.h | 20 ------------
>  mm/hmm.c            | 80 ---------------------------------------------
>  2 files changed, 100 deletions(-)
> 

Yes. This code is definitely unnecessary, and it's a good housecleaning here.

(As to the history: I know that there was some early "HMM dummy device" 
testing when the HMM code was much younger, but such testing has long since
been superseded by more elaborate testing with real drivers.)


Reviewed-by: John Hubbard <jhubbard@nvidia.com> 


thanks,
-- 
John Hubbard
NVIDIA

> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
> index 0fa8ea34ccef..4867b9da1b6c 100644
> --- a/include/linux/hmm.h
> +++ b/include/linux/hmm.h
> @@ -717,26 +717,6 @@ static inline unsigned long hmm_devmem_page_get_drvdata(const struct page *page)
>  {
>  	return page->hmm_data;
>  }
> -
> -
> -/*
> - * struct hmm_device - fake device to hang device memory onto
> - *
> - * @device: device struct
> - * @minor: device minor number
> - */
> -struct hmm_device {
> -	struct device		device;
> -	unsigned int		minor;
> -};
> -
> -/*
> - * A device driver that wants to handle multiple devices memory through a
> - * single fake device can use hmm_device to do so. This is purely a helper and
> - * it is not strictly needed, in order to make use of any HMM functionality.
> - */
> -struct hmm_device *hmm_device_new(void *drvdata);
> -void hmm_device_put(struct hmm_device *hmm_device);
>  #endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
>  #else /* IS_ENABLED(CONFIG_HMM) */
>  static inline void hmm_mm_destroy(struct mm_struct *mm) {}
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 886b18695b97..ff2598eb7377 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -1499,84 +1499,4 @@ struct hmm_devmem *hmm_devmem_add_resource(const struct hmm_devmem_ops *ops,
>  	return devmem;
>  }
>  EXPORT_SYMBOL_GPL(hmm_devmem_add_resource);
> -
> -/*
> - * A device driver that wants to handle multiple devices memory through a
> - * single fake device can use hmm_device to do so. This is purely a helper
> - * and it is not needed to make use of any HMM functionality.
> - */
> -#define HMM_DEVICE_MAX 256
> -
> -static DECLARE_BITMAP(hmm_device_mask, HMM_DEVICE_MAX);
> -static DEFINE_SPINLOCK(hmm_device_lock);
> -static struct class *hmm_device_class;
> -static dev_t hmm_device_devt;
> -
> -static void hmm_device_release(struct device *device)
> -{
> -	struct hmm_device *hmm_device;
> -
> -	hmm_device = container_of(device, struct hmm_device, device);
> -	spin_lock(&hmm_device_lock);
> -	clear_bit(hmm_device->minor, hmm_device_mask);
> -	spin_unlock(&hmm_device_lock);
> -
> -	kfree(hmm_device);
> -}
> -
> -struct hmm_device *hmm_device_new(void *drvdata)
> -{
> -	struct hmm_device *hmm_device;
> -
> -	hmm_device = kzalloc(sizeof(*hmm_device), GFP_KERNEL);
> -	if (!hmm_device)
> -		return ERR_PTR(-ENOMEM);
> -
> -	spin_lock(&hmm_device_lock);
> -	hmm_device->minor = find_first_zero_bit(hmm_device_mask, HMM_DEVICE_MAX);
> -	if (hmm_device->minor >= HMM_DEVICE_MAX) {
> -		spin_unlock(&hmm_device_lock);
> -		kfree(hmm_device);
> -		return ERR_PTR(-EBUSY);
> -	}
> -	set_bit(hmm_device->minor, hmm_device_mask);
> -	spin_unlock(&hmm_device_lock);
> -
> -	dev_set_name(&hmm_device->device, "hmm_device%d", hmm_device->minor);
> -	hmm_device->device.devt = MKDEV(MAJOR(hmm_device_devt),
> -					hmm_device->minor);
> -	hmm_device->device.release = hmm_device_release;
> -	dev_set_drvdata(&hmm_device->device, drvdata);
> -	hmm_device->device.class = hmm_device_class;
> -	device_initialize(&hmm_device->device);
> -
> -	return hmm_device;
> -}
> -EXPORT_SYMBOL(hmm_device_new);
> -
> -void hmm_device_put(struct hmm_device *hmm_device)
> -{
> -	put_device(&hmm_device->device);
> -}
> -EXPORT_SYMBOL(hmm_device_put);
> -
> -static int __init hmm_init(void)
> -{
> -	int ret;
> -
> -	ret = alloc_chrdev_region(&hmm_device_devt, 0,
> -				  HMM_DEVICE_MAX,
> -				  "hmm_device");
> -	if (ret)
> -		return ret;
> -
> -	hmm_device_class = class_create(THIS_MODULE, "hmm_device");
> -	if (IS_ERR(hmm_device_class)) {
> -		unregister_chrdev_region(hmm_device_devt, HMM_DEVICE_MAX);
> -		return PTR_ERR(hmm_device_class);
> -	}
> -	return 0;
> -}
> -
> -device_initcall(hmm_init);
>  #endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
