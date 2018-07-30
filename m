Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB4B3210C1B9A
 for <linux-nvdimm@lists.01.org>; Sun, 29 Jul 2018 22:15:12 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id
 w6U5Dmn6064670
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 01:15:11 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2khv5f0eaq-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 01:15:11 -0400
Received: from localhost
 by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <schwidefsky@de.ibm.com>;
 Mon, 30 Jul 2018 06:15:09 +0100
Date: Mon, 30 Jul 2018 07:14:58 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [External]  [PATCH v2 2/6] s390, dcssblk: kaddr and pfn can be
 NULL to ->direct_access()
In-Reply-To: <TY2PR03MB334328133134A67C87E5CC5C92290@TY2PR03MB3343.apcprd03.prod.outlook.com>
References: <20180725162849.8320-1-yehs2007@zoho.com>
 <20180725162849.8320-3-yehs2007@zoho.com>
 <TY2PR03MB334328133134A67C87E5CC5C92290@TY2PR03MB3343.apcprd03.prod.outlook.com>
MIME-Version: 1.0
Message-Id: <20180730071458.42e3c5a1@mschwideX1>
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
To: Huaisheng HS1 Ye <yehs1@lenovo.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "snitzer@redhat.com" <snitzer@redhat.com>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@infradead.org" <willy@infradead.org>, "bart.vanassche@wdc.com" <bart.vanassche@wdc.com>, "keescook@chromium.org" <keescook@chromium.org>, NingTing Cheng <chengnt@lenovo.com>, "colyli@suse.de" <colyli@suse.de>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "axboe@kernel.dk" <axboe@kernel.dk>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, 28 Jul 2018 04:07:25 +0000
Huaisheng HS1 Ye <yehs1@lenovo.com> wrote:

> May I have your ack's for this patch? The whole series would be applied
> to libnvdimm if it could get your approval.
> And any suggestion is welcome.

Sure, it is just two additional ifs. I did not think that this needed an
ack, but here you go:

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

> 
> Cheers,
> Huaisheng Ye
> 
> > From: Huaisheng Ye <yehs2007@zoho.com>
> > Sent: Thursday, July 26, 2018 12:29 AM
> > 
> > From: Huaisheng Ye <yehs1@lenovo.com>
> > 
> > dcssblk_direct_access() needs to check the validity of pointers kaddr
> > and pfn for NULL assignment. If anyone equals to NULL, it doesn't need
> > to calculate the value.
> > 
> > If either of them is equal to NULL, that is to say callers may
> > have no need for kaddr or pfn, so this patch is prepared for allowing
> > them to pass in NULL instead of having to pass in a pointer or local
> > variable that they then just throw away.
> > 
> > Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
> > ---
> >  drivers/s390/block/dcssblk.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> > index ed60728..23e526c 100644
> > --- a/drivers/s390/block/dcssblk.c
> > +++ b/drivers/s390/block/dcssblk.c
> > @@ -922,9 +922,11 @@ static DEVICE_ATTR(save, S_IWUSR | S_IRUSR, dcssblk_save_show,
> >  	unsigned long dev_sz;
> > 
> >  	dev_sz = dev_info->end - dev_info->start + 1;
> > -	*kaddr = (void *) dev_info->start + offset;
> > -	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
> > -			PFN_DEV|PFN_SPECIAL);
> > +	if (kaddr)
> > +		*kaddr = (void *) dev_info->start + offset;
> > +	if (pfn)
> > +		*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
> > +				PFN_DEV|PFN_SPECIAL);
> > 
> >  	return (dev_sz - offset) / PAGE_SIZE;
> >  }
> > --
> > 1.8.3.1  
> 


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
