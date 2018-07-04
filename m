Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 510662096FAA3
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 09:56:01 -0700 (PDT)
Date: Thu, 05 Jul 2018 00:55:27 +0800
From: Huaisheng Ye <yehs2007@zoho.com>
Message-ID: <16466385fd1.ddcc3b7a51249.6994139134661160061@zoho.com>
In-Reply-To: <CAPcyv4hgk89NKGhmZ1Z3XsGFzJAn1y+46WJn_61r8rj5bmqv6A@mail.gmail.com>
References: <20180704163823.9980-1-yehs2007@zoho.com>
 <CAPcyv4hgk89NKGhmZ1Z3XsGFzJAn1y+46WJn_61r8rj5bmqv6A@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Assigning NULL to gfn of dax_direct_access if
 useless
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: yehs2007@zoho.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "\"Dan Williams\"" <dan.j.williams@intel.com>
Cc: "\"Jens Axboe\"" <axboe@kernel.dk>, "\"linux-s390\"" <linux-s390@vger.kernel.org>, "\"linux-nvdimm\"" <linux-nvdimm@lists.01.org>, "\"NingTing Cheng\"" <chengnt@lenovo.com>, "\"Jan Kara\"" <jack@suse.com>, "\"Heiko Carstens\"" <heiko.carstens@de.ibm.com>, "\"Linux Kernel Mailing List\"" <linux-kernel@vger.kernel.org>, "\"Matthew Wilcox\"" <willy@infradead.org>, "\"colyli\"" <colyli@suse.de>, "\"Bart Van Assche\"" <bart.vanassche@wdc.com>, "\"Al Viro\"" <viro@zeniv.linux.org.uk>, "\"Greg KH\"" <gregkh@linuxfoundation.org>, "\"Martin Schwidefsky\"" <schwidefsky@de.ibm.com>, "\"linux-fsdevel\"" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>





 ---- On Thu, 05 Jul 2018 00:48:40 +0800 Dan Williams <dan.j.williams@intel.com> wrote ---- 
 > On Wed, Jul 4, 2018 at 9:38 AM, Huaisheng Ye <yehs2007@zoho.com> wrote: 
 > > From: Huaisheng Ye <yehs1@lenovo.com> 
 > > 
 > > Changes since v1 [1]: 
 > > * Collect Jan's reviewed-by. 
 > > * According to Dan's suggestion, update the unit test infrastructure 
 > >   tools/testing/nvdimm/pmem-dax.c for checking the validity of gfn. 
 > > 
 > > [1]: https://lkml.org/lkml/2018/7/4/81 
 > > 
 > > --- 
 > > 
 > > Some functions within fs/dax don't need to get gfn from direct_access. 
 >  
 > Any reason you are calling it 'gfn'? I'm assuming that is a typo and 
 > it should be 'pfn'. 

Oh, sorry.
I made a mistake, it is a typo. I will correct it right now.

---
Cheers,
Huaisheng Ye

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
