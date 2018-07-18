Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69AE92097E25B
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 05:05:33 -0700 (PDT)
Date: Wed, 18 Jul 2018 14:05:29 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 00/14] mm: Asynchronous + multithreaded memmap init
 for ZONE_DEVICE
Message-ID: <20180718120529.GY7193@dhcp22.suse.cz>
References: <153176041838.12695.3365448145295112857.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAGM2rea9AwQGaf1JiV_SDDKTKyP_n+dG9Z20gtTZEkuZPFnXFQ@mail.gmail.com>
 <CAPcyv4jo91jKjwn-M7cOhG=6vJ3c-QCyp0W+T+CtmiKGyZP1ng@mail.gmail.com>
 <CAGM2reacO1HF91yH8OR5w5AdZwPgwfSFfjDNBsHbP66v1rEg=g@mail.gmail.com>
 <20180717155006.GL7193@dhcp22.suse.cz>
 <CAA9_cmez_vrjBYvcpXT_5ziQ2CqRFzPbEWMO2kdmjW0rWhkaCA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA9_cmez_vrjBYvcpXT_5ziQ2CqRFzPbEWMO2kdmjW0rWhkaCA@mail.gmail.com>
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
Cc: dalias@libc.org, Jan Kara <jack@suse.cz>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-mm <linux-mm@kvack.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Yoshinori Sato <ysato@users.sourceforge.jp>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Michael Ellerman <mpe@ellerman.id.au>, the arch/x86 maintainers <x86@kernel.org>, pasha.tatashin@oracle.com, Matthew Wilcox <willy@infradead.org>, daniel.m.jordan@oracle.com, Ingo Molnar <mingo@redhat.com>, fenghua.yu@intel.com, Jerome Glisse <jglisse@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 17-07-18 10:32:32, Dan Williams wrote:
> On Tue, Jul 17, 2018 at 8:50 AM Michal Hocko <mhocko@kernel.org> wrote:
[...]
> > Is there any reason that this work has to target the next merge window?
> > The changelog is not really specific about that.
> 
> Same reason as any other change in this space, hardware availability
> continues to increase. These patches are a direct response to end user
> reports of unacceptable init latency with current kernels.

Do you have any reference please?

> > There no numbers or
> > anything that would make this sound as a high priority stuff.
> 
> >From the end of the cover letter:
> 
> "With this change an 8 socket system was observed to initialize pmem
> namespaces in ~4 seconds whereas it was previously taking ~4 minutes."

Well, yeah, it sounds like a nice to have thing to me. 4 minutes doesn't
sounds excesive for a single init time operation. Machines are booting
tens of minutes these days...

> My plan if this is merged would be to come back and refactor it with
> the deferred_init_memmap() implementation, my plan if this is not
> merged would be to come back and refactor it with the
> deferred_init_memmap() implementation.

Well, my experience tells me that "refactor later" is rarely done.
Especially when it is not critical thing to do. There are so many other
things to go in the way to put that into back burner... So unless this
is abslutely critical to have fixed in the upcoming merge window then I
would much rather see a (reasonably) good solution from the begining.
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
