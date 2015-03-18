Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <54FD901A.3030905@plexistor.com>
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com>
 <54F84420.40209@plexistor.com> <CALCETrXsQsoa0qfzM-o+kz6Af2EtvJR7Er6OwxjZ5JegMYxpFg@mail.gmail.com>
 <54FD901A.3030905@plexistor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Mar 2015 11:06:46 -0700
Message-ID: <CALCETrVt9KiWsT37Z_90gBREK1NoSJ2ruT48uv-7QWumYz+TNg@mail.gmail.com>
Subject: Re: [PATCH 1/8] pmem: Initial version of persistent memory driver
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mar 9, 2015 8:20 AM, "Boaz Harrosh" <boaz@plexistor.com> wrote:
>
> On 03/06/2015 01:03 AM, Andy Lutomirski wrote:
> <>
> >
> > I think it would be nice to have control over the caching mode.
> > Depending on the application, WT or UC could make more sense.
> >
>
> Patches are welcome. say
>         map=sss@aaa:WT,sss@aaa:CA, ...
>
> But for us, with direct_access(), all benchmarks show a slight advantage
> for the cached mode.

I'm sure cached is faster.  The question is: who flushes the cache?

--Andy
