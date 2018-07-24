Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta23.messagelabs.com (mail1.bemta23.messagelabs.com
 [67.219.246.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E01620945D80
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 02:47:05 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External]  Re: [PATCH 3/5] s390, dcssblk: Allow a NULL-kaddr to
 ->direct_access()
Date: Tue, 24 Jul 2018 09:46:43 +0000
Message-ID: <TY2PR03MB3343901A038D3E3D836C438992550@TY2PR03MB3343.apcprd03.prod.outlook.com>
References: <20180724084510.6104-1-yehs2007@zoho.com>
 <20180724084510.6104-4-yehs2007@zoho.com>
 <192a9dac-921f-e222-3a7d-32d43679cd12@de.ibm.com>
In-Reply-To: <192a9dac-921f-e222-3a7d-32d43679cd12@de.ibm.com>
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
To: Christian Borntraeger <borntraeger@de.ibm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, NingTing Cheng <chengnt@lenovo.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "bart.vanassche@wdc.com" <bart.vanassche@wdc.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "jack@suse.cz" <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

From: Christian Borntraeger <borntraeger@de.ibm.com>
Sent: Tuesday, July 24, 2018 4:54 PM
> On 07/24/2018 10:45 AM, Huaisheng Ye wrote:
> > From: Huaisheng Ye <yehs1@lenovo.com>
> >
> > dcssblk_direct_access() needs to check the validity of second rank
> > pointer kaddr for NULL assignment. If kaddr equals to NULL, it
> > doesn't need to calculate the value.
> >
> > Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
> > ---
> >  drivers/s390/block/dcssblk.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> > index 0a312e4..9c13dc5 100644
> > --- a/drivers/s390/block/dcssblk.c
> > +++ b/drivers/s390/block/dcssblk.c
> > @@ -915,7 +915,8 @@ static DEVICE_ATTR(save, S_IWUSR | S_IRUSR, dcssblk_save_show,
> >  	unsigned long dev_sz;
> >
> >  	dev_sz = dev_info->end - dev_info->start + 1;
> > -	*kaddr = (void *) dev_info->start + offset;
> > +	if (kaddr)
> > +		*kaddr = (void *) dev_info->start + offset;
> 
> So you are trading of a load + add (dev_info->start should be cache hot) against a
> compare+branch . Not sure that this is always a win.

Hmm...the calculation process of pfn is more complicated than kaddr. I think you agree to check pfn but not sure kaddr, right?
>From the logical consistency of code, I think it shall be better to give pfn and kaddr similar treatment.

Cheers,
Huaisheng Ye
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
