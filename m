Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com
 [IPv6:2607:f8b0:4864:20::32b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FE6A211EDB56
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 08:41:01 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id g18so13369764otj.11
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 08:41:01 -0700 (PDT)
MIME-Version: 1.0
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
 <CAPcyv4iZZCgcC657ZOysBP9=1ejp3jfFj=VETVBPrgmfg7xUEw@mail.gmail.com>
 <201905170855.8E2E1AC616@keescook>
 <CAPcyv4g9HpMaifC+Qe2RVbgL_qq9vQvjwr-Jw813xhxcviehYQ@mail.gmail.com>
 <201905171225.29F9564BA2@keescook>
 <CAPcyv4iSeUPWFeSZW-dmYz9TnWhqVCx1Y1VjtUv+125_ZSQaYg@mail.gmail.com>
 <20190520075232.GA30972@quack2.suse.cz>
In-Reply-To: <20190520075232.GA30972@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 May 2019 08:40:48 -0700
Message-ID: <CAPcyv4hwiKGDtkT7-r8Ei3kOQBMA3LwDGBNM9H8N6HC5fxi6tw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
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
To: Jan Kara <jack@suse.cz>
Cc: Jeff Smits <jeff.smits@intel.com>, Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 20, 2019 at 12:52 AM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 18-05-19 21:46:03, Dan Williams wrote:
> > On Fri, May 17, 2019 at 12:25 PM Kees Cook <keescook@chromium.org> wrote:
> > > On Fri, May 17, 2019 at 10:28:48AM -0700, Dan Williams wrote:
> > > > It seems dax_iomap_actor() is not a path where we'd be worried about
> > > > needing hardened user copy checks.
> > >
> > > I would agree: I think the proposed patch makes sense. :)
> >
> > Sounds like an acked-by to me.
>
> Yeah, if Kees agrees, I'm fine with skipping the checks as well. I just
> wanted that to be clarified. Also it helped me that you wrote:
>
> That routine (dax_iomap_actor()) validates that the logical file offset is
> within bounds of the file, then it does a sector-to-pfn translation which
> validates that the physical mapping is within bounds of the block device.
>
> That is more specific than "dax_iomap_actor() takes care of necessary
> checks" which was in the changelog. And the above paragraph helped me
> clarify which checks in dax_iomap_actor() you think replace those usercopy
> checks. So I think it would be good to add that paragraph to those
> copy_from_pmem() functions as a comment just in case we are wondering in
> the future why we are skipping the checks... Also feel free to add:
>
> Acked-by: Jan Kara <jack@suse.cz>

Will do, thanks Jan.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
