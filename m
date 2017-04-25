Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64D512195408B
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 18:18:33 -0700 (PDT)
Date: Tue, 25 Apr 2017 09:18:25 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
Message-ID: <20170425011825.GA4622@x1>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170419133630.GA2311@x1>
 <CAJcbSZEbrOfnMQhr2dA0HBqogo0dYsEGCGsEbPMh1kM9tX4tEA@mail.gmail.com>
 <20170420132632.GD2311@x1>
 <CAJcbSZEOOZZnuD3nftkzpcthGdT-6f6DDZ=VtdBKuHbC+0LdFw@mail.gmail.com>
 <CAPcyv4gzdwDmtxoz7O5=1zGow+6zx2YqQqjRu1=kBX087MLx2Q@mail.gmail.com>
 <20170424230738.GA11734@x1>
 <CAJcbSZEWB27HHtP6zVQA+qJJ7uvWqZz+Y-kYFE0aTM2-jj72iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJcbSZEWB27HHtP6zVQA+qJJ7uvWqZz+Y-kYFE0aTM2-jj72iQ@mail.gmail.com>
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
To: Thomas Garnier <thgarnie@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 04/24/17 at 05:41pm, Thomas Garnier wrote:
> On Mon, Apr 24, 2017 at 4:07 PM, Baoquan He <bhe@redhat.com> wrote:
> > Yeah, according to my debugging tracking, it goes as Dan said. And the
> > is_ram is REGION_DISJOINT. And till arch_add_memory, the parameters
> > passed to arch_add_memory are "arch_add_memory, align_start:0x10000000000, align_size:0x3000000000",
> > seems it's going well.
> 
> Hum ok, I hope it was another path given it seems the page table is
> correctly setup on this one.
> 
> Maybe looking at the PTEs with and without crash might help? (setting
> this if statement to 1:
> http://lxr.free-electrons.com/source/arch/x86/mm/init_64.c#L360)

The page_size_mask is PG_LEVEL_1G, it should only enter into
phys_pud_init and return.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
