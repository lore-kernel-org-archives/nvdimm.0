Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 15A502097E271
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 07:41:38 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id s198-v6so11123729oih.11
 for <linux-nvdimm@lists.01.org>; Wed, 04 Jul 2018 07:41:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hPEch02C7UfCGgpXmsCVyT2zwV=4Tr8jv8W1i6_poAJQ@mail.gmail.com>
References: <20180704064058.1344-1-yehs2007@zoho.com>
 <20180704064058.1344-3-yehs2007@zoho.com>
 <20180704113012.trnfzeefao25clri@quack2.suse.cz>
 <1646567c191.ed8ea5b817045.8715756414911693238@zoho.com>
 <CAPcyv4hPEch02C7UfCGgpXmsCVyT2zwV=4Tr8jv8W1i6_poAJQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 4 Jul 2018 07:41:36 -0700
Message-ID: <CAPcyv4hxx9JjJZGRTg1NHgN9k0Brwj5yozSWMuNCKBi88wKQWw@mail.gmail.com>
Subject: Re: [PATCH 3/3] fs/dax: Assigning NULL to gfn of dax_direct_access if
 useless
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
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390 <linux-s390@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <mawilcox@microsoft.com>, NingTing Cheng <chengnt@lenovo.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, colyli <colyli@suse.de>, Bart Van Assche <bart.vanassche@wdc.com>, Al Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 4, 2018 at 7:37 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Jul 4, 2018 at 6:07 AM, Huaisheng Ye <yehs2007@zoho.com> wrote:
>>  ---- On Wed, 04 Jul 2018 19:30:12 +0800 Jan Kara <jack@suse.cz> wrote ----
>>  > On Wed 04-07-18 14:40:58, Huaisheng Ye wrote:
>>  > > From: Huaisheng Ye <yehs1@lenovo.com>
>>  > >
>>  > > Some functions within fs/dax don't need to get gfn from direct_access.
>>  > > Assigning NULL to gfn of dax_direct_access is more intuitive and simple
>>  > > than offering a useless local variable.
>>  > >
>>  > > Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
>>  >
>>  > I like this. You can add:
>>  >
>>  > Reviewed-by: Jan Kara <jack@suse.cz>
>>  >
>>  > for the series.
>>  >
>>  >                                 Honza
>>  >
>> I am so happy you like them, thank you very much.
>
> Yes, I like this too. In fact I have a similar patch in my tree
> already that I have been preparing to send out. I am using it to delay
> when we need to have the 'struct page' memmap for dax initialized.
> Attached is the full patch, but the series is still a work in
> progress.

Btw, I'll drop my version and apply your series since you got it
posted first and it can stand alone as its own cleanup.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
