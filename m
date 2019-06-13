Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH 18/22] mm: mark DEVICE_PUBLIC as broken
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-19-hch@lst.de> <20190613194430.GY22062@mellanox.com>
From: Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <a27251ad-a152-f84d-139d-e1a3bf01c153@nvidia.com>
Date: Thu, 13 Jun 2019 12:53:02 -0700
MIME-Version: 1.0
In-Reply-To: <20190613194430.GY22062@mellanox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>


On 6/13/19 12:44 PM, Jason Gunthorpe wrote:
> On Thu, Jun 13, 2019 at 11:43:21AM +0200, Christoph Hellwig wrote:
>> The code hasn't been used since it was added to the tree, and doesn't
>> appear to actually be usable.  Mark it as BROKEN until either a user
>> comes along or we finally give up on it.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>   mm/Kconfig | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 0d2ba7e1f43e..406fa45e9ecc 100644
>> +++ b/mm/Kconfig
>> @@ -721,6 +721,7 @@ config DEVICE_PRIVATE
>>   config DEVICE_PUBLIC
>>   	bool "Addressable device memory (like GPU memory)"
>>   	depends on ARCH_HAS_HMM
>> +	depends on BROKEN
>>   	select HMM
>>   	select DEV_PAGEMAP_OPS
> 
> This seems a bit harsh, we do have another kconfig that selects this
> one today:
> 
> config DRM_NOUVEAU_SVM
>          bool "(EXPERIMENTAL) Enable SVM (Shared Virtual Memory) support"
>          depends on ARCH_HAS_HMM
>          depends on DRM_NOUVEAU
>          depends on STAGING
>          select HMM_MIRROR
>          select DEVICE_PRIVATE
>          default n
>          help
>            Say Y here if you want to enable experimental support for
>            Shared Virtual Memory (SVM).
> 
> Maybe it should be depends on STAGING not broken?
> 
> or maybe nouveau_svm doesn't actually need DEVICE_PRIVATE?
> 
> Jason

I think you are confusing DEVICE_PRIVATE for DEVICE_PUBLIC.
DRM_NOUVEAU_SVM does use DEVICE_PRIVATE but not DEVICE_PUBLIC.
