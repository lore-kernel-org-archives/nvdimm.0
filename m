Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-x243.google.com (mail-wr0-x243.google.com
 [IPv6:2a00:1450:400c:c0c::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3760C203B8CD0
 for <linux-nvdimm@lists.01.org>; Mon, 14 May 2018 23:49:10 -0700 (PDT)
Received: by mail-wr0-x243.google.com with SMTP id a12-v6so14666958wrn.13
 for <linux-nvdimm@lists.01.org>; Mon, 14 May 2018 23:49:10 -0700 (PDT)
Date: Tue, 15 May 2018 08:49:06 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: use memcpy_mcsafe() for copy_to_iter() (was: Re: [PATCH v3 0/9]
 Series short description)
Message-ID: <20180515064906.GA29231@gmail.com>
References: <CAPcyv4g5p72aiXYh8Tf03tvZq8HNYmTFU95PJGG1iQ4JHcr9PA@mail.gmail.com>
 <20180514072603.GA14099@gmail.com>
 <CAPcyv4j2HQH1wdsGGWUAiXEKXeoMUWN_HeUEMmkv8PG7RUTtfw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j2HQH1wdsGGWUAiXEKXeoMUWN_HeUEMmkv8PG7RUTtfw@mail.gmail.com>
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
Cc: "Luck, Tony" <tony.luck@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> On Mon, May 14, 2018 at 12:26 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Dan Williams <dan.j.williams@intel.com> wrote:
> >
> >> Ingo, Thomas, Al, any concerns with this series?
> >
> > Yeah, so:
> >
> >    "[PATCH v3 0/9] Series short description"
> >
> > ... isn't the catchiest of titles to capture my [all too easily distracted]
> > attention! ;-)
> 
> My bad! After that mistake it became a toss-up between more spam and
> hoping the distraction would not throw you off.
> 
> > I have marked it now for -tip processing. Linus was happy with this and acked the
> > approach, right?
> 
> I think "happy" is a strong word when it comes to x86 machine check
> handling. My interpretation is that he and Andy acquiesced that this
> is about the best we can do with dax+mce as things stand today.

So, how would you like to go about this series?

To help move it forward I applied the first 5 commits to tip:x86/dax, on a
vanilla v4.17-rc5 base, did some minor edits to the changelogs, tested it
superficially (I don't have DAX so this essentially means build tests) and
pushed out the result.

Barring some later generic-x86 regression (unlikely) this looks good to me - feel 
free to cross-pull that branch into your DAX/nvdimm tree.

Or we could apply the remaining changes to -tip too - your call.

Thanks,

	Ingo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
