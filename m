Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 24 Feb 2015 09:34:32 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/3] e820: Don't let unknown DIMM type come out BUSY
Message-ID: <20150224083432.GB19398@gmail.com>
References: <54EB1D33.3050107@plexistor.com>
 <54EB1E03.4010306@plexistor.com>
 <1424751767.9050.4.camel@intel.com>
 <54EC2F4E.1080606@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54EC2F4E.1080606@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>


* Boaz Harrosh <boaz@plexistor.com> wrote:

> On 02/24/2015 06:22 AM, Dan Williams wrote:
> <>
> >> By Popular demand An Extra WARNING message is printed if
> >> an "UNKNOWN" is found. It will look like this:
> >>   e820: WARNING [mem 0x100000000-0x1ffffffff] is unknown type 12
> > 
> > I don't think we need to warn that an unknown range was 
> > published, just warn if it is consumed.
> 
> I did not have it at first, Ingo asked for it. I don't 
> mind having it and I don't mind not. I'd say it is Ingo's 
> call.

So at least initially I really would like system operators 
to be informed when the BIOS does something unexpected to 
the kernel, especially when it comes to memory mappings.

Later on, if it turns out to be benign, we can remove the 
warning.

Thanks,

	Ingo
