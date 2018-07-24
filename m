Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40BEB210C0F60
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 01:53:50 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id
 w6O8rjuX086314
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 04:53:49 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2kdydyn7sf-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 04:53:48 -0400
Received: from localhost
 by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <borntraeger@de.ibm.com>;
 Tue, 24 Jul 2018 09:53:46 +0100
Subject: Re: [PATCH 3/5] s390, dcssblk: Allow a NULL-kaddr to ->direct_access()
References: <20180724084510.6104-1-yehs2007@zoho.com>
 <20180724084510.6104-4-yehs2007@zoho.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Tue, 24 Jul 2018 10:53:39 +0200
MIME-Version: 1.0
In-Reply-To: <20180724084510.6104-4-yehs2007@zoho.com>
Content-Language: en-US
Message-Id: <192a9dac-921f-e222-3a7d-32d43679cd12@de.ibm.com>
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
To: Huaisheng Ye <yehs2007@zoho.com>, linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, chengnt@lenovo.com, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, willy@infradead.org, bart.vanassche@wdc.com, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org, schwidefsky@de.ibm.com, jack@suse.cz
List-ID: <linux-nvdimm@lists.01.org>



On 07/24/2018 10:45 AM, Huaisheng Ye wrote:
> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> dcssblk_direct_access() needs to check the validity of second rank
> pointer kaddr for NULL assignment. If kaddr equals to NULL, it
> doesn't need to calculate the value.
> 
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
> ---
>  drivers/s390/block/dcssblk.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index 0a312e4..9c13dc5 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -915,7 +915,8 @@ static DEVICE_ATTR(save, S_IWUSR | S_IRUSR, dcssblk_save_show,
>  	unsigned long dev_sz;
>  
>  	dev_sz = dev_info->end - dev_info->start + 1;
> -	*kaddr = (void *) dev_info->start + offset;
> +	if (kaddr)
> +		*kaddr = (void *) dev_info->start + offset;

So you are trading of a load + add (dev_info->start should be cache hot) against a
compare+branch . Not sure that this is always a win.


>  	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
>  			PFN_DEV|PFN_SPECIAL);
>  
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
