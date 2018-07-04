Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D06DB210D93A1
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 06:08:06 -0700 (PDT)
Date: Wed, 04 Jul 2018 21:07:35 +0800
From: Huaisheng Ye <yehs2007@zoho.com>
Message-ID: <1646567c191.ed8ea5b817045.8715756414911693238@zoho.com>
In-Reply-To: <20180704113012.trnfzeefao25clri@quack2.suse.cz>
References: <20180704064058.1344-1-yehs2007@zoho.com>
 <20180704064058.1344-3-yehs2007@zoho.com>
 <20180704113012.trnfzeefao25clri@quack2.suse.cz>
Subject: Re: [PATCH 3/3] fs/dax: Assigning NULL to gfn of dax_direct_access
 if useless
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
To: "\"Jan Kara\"" <jack@suse.cz>
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, mawilcox@microsoft.com, chengnt@lenovo.com, linux-nvdimm@lists.01.org, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, "\"colyli\"" <colyli@suse.de>, bart.vanassche@wdc.com, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org, schwidefsky@de.ibm.com, linux-fsdevel@vger.kernel.org, jack@suse.com
List-ID: <linux-nvdimm@lists.01.org>

 ---- On Wed, 04 Jul 2018 19:30:12 +0800 Jan Kara <jack@suse.cz> wrote ---- 
 > On Wed 04-07-18 14:40:58, Huaisheng Ye wrote: 
 > > From: Huaisheng Ye <yehs1@lenovo.com> 
 > >  
 > > Some functions within fs/dax don't need to get gfn from direct_access. 
 > > Assigning NULL to gfn of dax_direct_access is more intuitive and simple 
 > > than offering a useless local variable. 
 > >  
 > > Signed-off-by: Huaisheng Ye <yehs1@lenovo.com> 
 >  
 > I like this. You can add: 
 >  
 > Reviewed-by: Jan Kara <jack@suse.cz> 
 >  
 > for the series. 
 >  
 >                                 Honza 
 >  
I am so happy you like them, thank you very much.

---
Cheers,
Huaisheng



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
