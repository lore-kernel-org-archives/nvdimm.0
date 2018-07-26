Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta24.messagelabs.com (mail1.bemta24.messagelabs.com
 [67.219.250.114])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3EEC2210C2791
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jul 2018 18:29:41 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External]  Re: [PATCH v2 0/6] kaddr and pfn can be NULL to
 ->direct_access()
Date: Thu, 26 Jul 2018 01:29:19 +0000
Message-ID: <TY2PR03MB3343365E80CCBC374C0EFDD4922B0@TY2PR03MB3343.apcprd03.prod.outlook.com>
References: <20180725162849.8320-1-yehs2007@zoho.com>
 <3689520a-4a49-4e1f-6ee9-2ff4a9796b9f@intel.com>
In-Reply-To: <3689520a-4a49-4e1f-6ee9-2ff4a9796b9f@intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "jack@suse.cz" <jack@suse.cz>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, NingTing Cheng <chengnt@lenovo.com>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "colyli@suse.de" <colyli@suse.de>, "bart.vanassche@wdc.com" <bart.vanassche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "agk@redhat.com" <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

> From: Dave Jiang <dave.jiang@intel.com>
> Sent: Thursday, July 26, 2018 5:36 AM
> Subject: [External] Re: [PATCH v2 0/6] kaddr and pfn can be NULL to ->direct_access()
> 
> Pretty straight forward series. Huaisheng, I can apply the whole series
> to libnvdimm if we can get ack's from maintainer of dcssblk and
> dm-writecache for the respective bits.

Thanks Dave and Ross.

Hi Jan an Dan,

The previous patch series for NULL-pfn had got your Reviewed-by or Signed-off-by.
Now I have expanded them to local pointer kaddr, can I get your Reviewed-by for current
patch series? Your acks are very important to me.

Cheers,
Huaisheng Ye
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
