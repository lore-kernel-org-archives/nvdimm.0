Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta24.messagelabs.com (mail1.bemta24.messagelabs.com
 [67.219.250.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F2B8209831C6
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 21:07:49 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External]  [PATCH v2 2/6] s390, dcssblk: kaddr and pfn can be
 NULL to ->direct_access()
Date: Sat, 28 Jul 2018 04:07:25 +0000
Message-ID: <TY2PR03MB334328133134A67C87E5CC5C92290@TY2PR03MB3343.apcprd03.prod.outlook.com>
References: <20180725162849.8320-1-yehs2007@zoho.com>
 <20180725162849.8320-3-yehs2007@zoho.com>
In-Reply-To: <20180725162849.8320-3-yehs2007@zoho.com>
Content-Language: zh-CN
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
To: "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "bart.vanassche@wdc.com" <bart.vanassche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "keescook@chromium.org" <keescook@chromium.org>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, NingTing Cheng <chengnt@lenovo.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "colyli@suse.de" <colyli@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "agk@redhat.com" <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Dear Maintainers of Linux-s390,

Greetings.

May I have your ack's for this patch? The whole series would be applied
to libnvdimm if it could get your approval.
And any suggestion is welcome.

Cheers,
Huaisheng Ye

> From: Huaisheng Ye <yehs2007@zoho.com>
> Sent: Thursday, July 26, 2018 12:29 AM
> 
> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> dcssblk_direct_access() needs to check the validity of pointers kaddr
> and pfn for NULL assignment. If anyone equals to NULL, it doesn't need
> to calculate the value.
> 
> If either of them is equal to NULL, that is to say callers may
> have no need for kaddr or pfn, so this patch is prepared for allowing
> them to pass in NULL instead of having to pass in a pointer or local
> variable that they then just throw away.
> 
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
> ---
>  drivers/s390/block/dcssblk.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index ed60728..23e526c 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -922,9 +922,11 @@ static DEVICE_ATTR(save, S_IWUSR | S_IRUSR, dcssblk_save_show,
>  	unsigned long dev_sz;
> 
>  	dev_sz = dev_info->end - dev_info->start + 1;
> -	*kaddr = (void *) dev_info->start + offset;
> -	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
> -			PFN_DEV|PFN_SPECIAL);
> +	if (kaddr)
> +		*kaddr = (void *) dev_info->start + offset;
> +	if (pfn)
> +		*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
> +				PFN_DEV|PFN_SPECIAL);
> 
>  	return (dev_sz - offset) / PAGE_SIZE;
>  }
> --
> 1.8.3.1
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
