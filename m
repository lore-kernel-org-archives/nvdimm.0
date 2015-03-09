Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54FD901A.3030905@plexistor.com>
Date: Mon, 09 Mar 2015 14:20:42 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/8] pmem: Initial version of persistent memory driver
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com> <54F84420.40209@plexistor.com> <CALCETrXsQsoa0qfzM-o+kz6Af2EtvJR7Er6OwxjZ5JegMYxpFg@mail.gmail.com>
In-Reply-To: <CALCETrXsQsoa0qfzM-o+kz6Af2EtvJR7Er6OwxjZ5JegMYxpFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Boaz Harrosh <boaz@plexistor.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>, Dan Williams <dan.j.williams@intel.com>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Ingo Molnar <mingo@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On 03/06/2015 01:03 AM, Andy Lutomirski wrote:
<>
> 
> I think it would be nice to have control over the caching mode.
> Depending on the application, WT or UC could make more sense.
> 

Patches are welcome. say
	map=sss@aaa:WT,sss@aaa:CA, ...

But for us, with direct_access(), all benchmarks show a slight advantage
for the cached mode.

Thanks
Boaz

