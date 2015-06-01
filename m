Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20150601085821.GA15014@gmail.com>
References: <1432739944-22633-1-git-send-email-toshi.kani@hp.com>
 <1432739944-22633-13-git-send-email-toshi.kani@hp.com> <20150529091129.GC31435@pd.tnic>
 <CAPcyv4jHbrUP7bDpw2Cja5x0eMQZBLmmzFXbotQWSEkAiL1s7Q@mail.gmail.com>
 <1432911782.23540.55.camel@misato.fc.hp.com> <CAPcyv4g+zYFkEYpa0HCh0Q+2C3wWNr6v3ZU143h52OKf=U=Qvw@mail.gmail.com>
 <CALCETrXXfujebOemesBtgKCkmRTOQFGjdcxjFDF+_P_tv+C0bw@mail.gmail.com>
 <94D0CD8314A33A4D9D801C0FE68B40295A92F392@G9W0745.americas.hpqcorp.net>
 <CALCETrXhNsk9yX=gerxqHCR6+CLdCGrjt9pDk98yeF0L7yyPvg@mail.gmail.com> <20150601085821.GA15014@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 1 Jun 2015 10:10:52 -0700
Message-ID: <CALCETrVNzrz7UCd=VeL1j-1G5yJrokev+JhizhfX-fH_4yovnQ@mail.gmail.com>
Subject: Re: [PATCH v10 12/12] drivers/block/pmem: Map NVDIMM with ioremap_wt()
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Ingo Molnar <mingo@kernel.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Dan Williams <dan.j.williams@intel.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, Borislav Petkov <bp@alien8.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Juergen Gross <jgross@suse.com>, Stefan Bader <stefan.bader@canonical.com>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Yigal Korman <yigal@plexistor.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Luis Rodriguez <mcgrof@suse.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 1, 2015 at 1:58 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andy Lutomirski <luto@amacapital.net> wrote:
>
>> You answered the wrong question. :) I understand the point of the non-temporal
>> stores -- I don't understand the point of using non-temporal stores to *WB
>> memory*.  I think we should be okay with having the kernel mapping use WT
>> instead.
>
> WB memory is write-through, but they are still fully cached for reads.
>
> So non-temporal instructions influence how the CPU will allocate (or not allocate)
> WT cache lines.
>

I'm doing a terrible job of saying what I mean.

Given that we're using non-temporal writes, the kernel code should
work correctly and with similar performance regardless of whether the
mapping is WB or WT.  It would still be correct, if slower, with WC or
UC, and, if we used explicit streaming reads, even that would matter
less.

I think this means that we are free to switch the kernel mapping
between WB and WT as needed to improve DAX behavior.  We could even
plausibly do it at runtime.

--Andy

> Thanks,
>
>         Ingo



-- 
Andy Lutomirski
AMA Capital Management, LLC

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
