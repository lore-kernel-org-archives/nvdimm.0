Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [RFC PATCH 1/5] efi: Detect UEFI 2.8 Special Purpose Memory
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155440491334.3190322.44013027330479237.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAKv+Gu8ocQGxTAapfjb5WufhL=Qj54LythHcPHsyy+wUnVBnfA@mail.gmail.com>
 <CAPcyv4gUL8j+EaAZ556_NKXLgva++HgPBOeeAUNHN+DAWaewaQ@mail.gmail.com>
From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <766281c0-e770-2a0f-e885-0921e599740f@metux.net>
Date: Mon, 15 Apr 2019 13:43:35 +0200
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gUL8j+EaAZ556_NKXLgva++HgPBOeeAUNHN+DAWaewaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Vishal L Verma <vishal.l.verma@intel.com>, the arch/x86 maintainers <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>, Keith Busch <keith.busch@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 09.04.19 18:43, Dan Williams wrote:

>>> UEFI 2.8 defines an EFI_MEMORY_SP attribute bit to augment the
>>> interpretation of the EFI Memory Types as "reserved for a special
>>> purpose".

What exactly is that suppose to mean ?
Little pacmans might come around and eat the bits ? :o
Who writes specs like that ? What drugs do did take ?


I vote for calling this the lore-ipsum-area ;-)


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
