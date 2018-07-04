Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta24.messagelabs.com (mail1.bemta24.messagelabs.com
 [67.219.250.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52FB3210BFF63
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 08:36:08 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External]  Re: [PATCH 3/3] fs/dax: Assigning NULL to gfn of
 dax_direct_access if useless
Date: Wed, 4 Jul 2018 15:35:44 +0000
Message-ID: <HK0PR03MB387664A02F65C1FDF73155E792410@HK0PR03MB3876.apcprd03.prod.outlook.com>
References: <20180704064058.1344-1-yehs2007@zoho.com>
 <20180704064058.1344-3-yehs2007@zoho.com>
 <20180704113012.trnfzeefao25clri@quack2.suse.cz>
 <1646567c191.ed8ea5b817045.8715756414911693238@zoho.com>
 <CAPcyv4hPEch02C7UfCGgpXmsCVyT2zwV=4Tr8jv8W1i6_poAJQ@mail.gmail.com>
 <CAPcyv4hxx9JjJZGRTg1NHgN9k0Brwj5yozSWMuNCKBi88wKQWw@mail.gmail.com>
In-Reply-To: <CAPcyv4hxx9JjJZGRTg1NHgN9k0Brwj5yozSWMuNCKBi88wKQWw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390 <linux-s390@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <mawilcox@microsoft.com>, NingTing Cheng <chengnt@lenovo.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, colyli <colyli@suse.de>, Bart Van Assche <bart.vanassche@wdc.com>, Al Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Dan Williams [mailto:dan.j.williams@intel.com]
Sent: Wednesday, July 04, 2018 10:42 PM
> 
> On Wed, Jul 4, 2018 at 7:37 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Wed, Jul 4, 2018 at 6:07 AM, Huaisheng Ye <yehs2007@zoho.com> wrote:
> >>  ---- On Wed, 04 Jul 2018 19:30:12 +0800 Jan Kara <jack@suse.cz> wrote ----
> >>  > On Wed 04-07-18 14:40:58, Huaisheng Ye wrote:
> >>  > > From: Huaisheng Ye <yehs1@lenovo.com>
> >>  > >
> >>  > > Some functions within fs/dax don't need to get gfn from direct_access.
> >>  > > Assigning NULL to gfn of dax_direct_access is more intuitive and simple
> >>  > > than offering a useless local variable.
> >>  > >
> >>  > > Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
> >>  >
> >>  > I like this. You can add:
> >>  >
> >>  > Reviewed-by: Jan Kara <jack@suse.cz>
> >>  >
> >>  > for the series.
> >>  >
> >>  >                                 Honza
> >>  >
> >> I am so happy you like them, thank you very much.
> >
> > Yes, I like this too. In fact I have a similar patch in my tree
> > already that I have been preparing to send out. I am using it to delay
> > when we need to have the 'struct page' memmap for dax initialized.
> > Attached is the full patch, but the series is still a work in
> > progress.
> 
> Btw, I'll drop my version and apply your series since you got it
> posted first and it can stand alone as its own cleanup.

Hi Dan,

I will resend the series later, and thanks for your help.

Cheers,
Huaisheng Ye
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
