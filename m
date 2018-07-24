Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta23.messagelabs.com (mail1.bemta23.messagelabs.com
 [67.219.246.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C440F21B02845
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 07:28:43 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External] Re: [PATCH 3/5] s390, dcssblk: Allow a NULL-kaddr to
 ->direct_access()
Date: Tue, 24 Jul 2018 14:28:23 +0000
Message-ID: <TY2PR03MB3343CC5CD32DBD527DABFDE592550@TY2PR03MB3343.apcprd03.prod.outlook.com>
References: <20180724084510.6104-1-yehs2007@zoho.com>
 <20180724084510.6104-4-yehs2007@zoho.com>
 <192a9dac-921f-e222-3a7d-32d43679cd12@de.ibm.com>
 <TY2PR03MB3343901A038D3E3D836C438992550@TY2PR03MB3343.apcprd03.prod.outlook.com>
 <814b615b-fc5d-627a-a11e-c54796b1b08d@de.ibm.com>
In-Reply-To: <814b615b-fc5d-627a-a11e-c54796b1b08d@de.ibm.com>
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
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, NingTing Cheng <chengnt@lenovo.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "bart.vanassche@wdc.com" <bart.vanassche@wdc.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "jack@suse.cz" <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

From: Christian Borntraeger <borntraeger@de.ibm.com>
Sent: Tuesday, July 24, 2018 7:16 PM
> >> So you are trading of a load + add (dev_info->start should be cache hot) against a
> >> compare+branch . Not sure that this is always a win.
> >
> > Hmm...the calculation process of pfn is more complicated than kaddr. I think you agree to
> check pfn but not sure kaddr, right?
> > From the logical consistency of code, I think it shall be better to give pfn and kaddr similar
> treatment.
> 
> Reading it again, its more that I do not like the patch description. It reads
> like an optimization, (and I think it is not) but it should rather read more
> like "with an upcoming change kaddr can be NULL" or so.

Thanks for suggestion, I will reword the patch description during next submission.
Does the patch itself need to be modified? If has, any suggestion is welcome.

Cheers,
Huaisheng Ye
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
