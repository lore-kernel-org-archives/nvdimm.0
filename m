From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 16/17] x86/insn: remove pcommit
Date: Fri, 22 Jul 2016 18:52:46 +0200
Message-ID: <20160722165246.GA24884@gmail.com>
References: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146812115425.32932.3314855641604340233.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160712145757.GV30909@twins.programming.kicks-ass.net>
 <CAPcyv4iEad1WuX6=5KymjQFrsAOkzQJ3E7iKj7F9wwz63WTKug@mail.gmail.com>
 <CAPcyv4gE8owJZOokGJmxH97CZwkD9uBZys=2-VCBgZy8aLkT8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gE8owJZOokGJmxH97CZwkD9uBZys=2-VCBgZy8aLkT8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org


* Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Jul 12, 2016 at 3:12 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > On Tue, Jul 12, 2016 at 7:57 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >> On Sat, Jul 09, 2016 at 08:25:54PM -0700, Dan Williams wrote:
> >>> The pcommit instruction is being deprecated in favor of either ADR
> >>> (asynchronous DRAM refresh: flush-on-power-fail) at the platform level, or
> >>> posted-write-queue flush addresses as defined by the ACPI 6.x NFIT (NVDIMM
> >>> Firmware Interface Table).
> >>
> >>>  arch/x86/include/asm/cpufeatures.h                 |    1
> >>>  arch/x86/include/asm/special_insns.h               |   46 --------------------
> >>>  arch/x86/lib/x86-opcode-map.txt                    |    2 -
> >>>  tools/objtool/arch/x86/insn/x86-opcode-map.txt     |    2 -
> >>>  tools/perf/arch/x86/tests/insn-x86-dat-32.c        |    2 -
> >>>  tools/perf/arch/x86/tests/insn-x86-dat-64.c        |    2 -
> >>>  tools/perf/arch/x86/tests/insn-x86-dat-src.c       |    4 --
> >>
> >> Just deprecated, or is it completely eradicated, removed from history,
> >> will never ever happen and we'll reissue the opcode for something else?
> >>
> >> Because if its only deprecated then removing it from the instruction
> >> decoders seems wrong, old binaries might still contain the opcode.
> >
> > Eradicated.
> >
> > "The new instructions like CLWB and CLFLUSHOPT will be rolled into the
> > SDM but PCOMMIT will be removed from the Extensions doc and not rolled
> > into the SDM." [1]
> >
> > Existing binaries are already gating their usage on the presence of
> > the cpu id flag, that flag and the instruction opcode are reserved
> > going forward.
> >
> > [1]: https://lists.01.org/pipermail/linux-nvdimm/2016-June/005923.html
> 
> x86 maintainers, I have the other patches in this series queued in -next. Please 
> ack this one and I'll add it for v4.8-rc1, or otherwise let me know how you want 
> to handle this patch.

Since it's just a removal AFAICS that the rest of your series should not depend 
on, can you submit it to the x86 tree?

Thanks,

	Ingo
