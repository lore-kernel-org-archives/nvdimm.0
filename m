From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 16/17] x86/insn: remove pcommit
Date: Fri, 22 Jul 2016 17:54:46 -0700
Message-ID: <CAPcyv4iQn_rR5wEb0PUOVL2tsWT_-H08kgPDsKmq1LRqGkxdZQ@mail.gmail.com>
References: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146812115425.32932.3314855641604340233.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160712145757.GV30909@twins.programming.kicks-ass.net> <CAPcyv4iEad1WuX6=5KymjQFrsAOkzQJ3E7iKj7F9wwz63WTKug@mail.gmail.com>
 <CAPcyv4gE8owJZOokGJmxH97CZwkD9uBZys=2-VCBgZy8aLkT8w@mail.gmail.com> <20160722165246.GA24884@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160722165246.GA24884@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Christoph Hellwig <hch@lst.de>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

On Fri, Jul 22, 2016 at 9:52 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
>> On Tue, Jul 12, 2016 at 3:12 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > On Tue, Jul 12, 2016 at 7:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> On Sat, Jul 09, 2016 at 08:25:54PM -0700, Dan Williams wrote:
>> >>> The pcommit instruction is being deprecated in favor of either ADR
>> >>> (asynchronous DRAM refresh: flush-on-power-fail) at the platform level, or
>> >>> posted-write-queue flush addresses as defined by the ACPI 6.x NFIT (NVDIMM
>> >>> Firmware Interface Table).
>> >>
>> >>>  arch/x86/include/asm/cpufeatures.h                 |    1
>> >>>  arch/x86/include/asm/special_insns.h               |   46 --------------------
>> >>>  arch/x86/lib/x86-opcode-map.txt                    |    2 -
>> >>>  tools/objtool/arch/x86/insn/x86-opcode-map.txt     |    2 -
>> >>>  tools/perf/arch/x86/tests/insn-x86-dat-32.c        |    2 -
>> >>>  tools/perf/arch/x86/tests/insn-x86-dat-64.c        |    2 -
>> >>>  tools/perf/arch/x86/tests/insn-x86-dat-src.c       |    4 --
>> >>
>> >> Just deprecated, or is it completely eradicated, removed from history,
>> >> will never ever happen and we'll reissue the opcode for something else?
>> >>
>> >> Because if its only deprecated then removing it from the instruction
>> >> decoders seems wrong, old binaries might still contain the opcode.
>> >
>> > Eradicated.
>> >
>> > "The new instructions like CLWB and CLFLUSHOPT will be rolled into the
>> > SDM but PCOMMIT will be removed from the Extensions doc and not rolled
>> > into the SDM." [1]
>> >
>> > Existing binaries are already gating their usage on the presence of
>> > the cpu id flag, that flag and the instruction opcode are reserved
>> > going forward.
>> >
>> > [1]: https://lists.01.org/pipermail/linux-nvdimm/2016-June/005923.html
>>
>> x86 maintainers, I have the other patches in this series queued in -next. Please
>> ack this one and I'll add it for v4.8-rc1, or otherwise let me know how you want
>> to handle this patch.
>
> Since it's just a removal AFAICS that the rest of your series should not depend
> on, can you submit it to the x86 tree?

This patch depends on the previous patches in the series removing
calls to pcommit_sfence().
