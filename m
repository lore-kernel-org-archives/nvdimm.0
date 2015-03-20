Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <550A95B7.9070002@plexistor.com>
References: <54F82CE0.4040502@plexistor.com>
	<54F830D4.7030205@plexistor.com>
	<54F84420.40209@plexistor.com>
	<1426700587.17347.24.camel@theros.lm.intel.com>
	<550A95B7.9070002@plexistor.com>
Date: Thu, 19 Mar 2015 17:11:31 -0700
Message-ID: <CAPcyv4h8yoKC37WYnecpKXjXWNsQfyStBcdw-1gTwHA-pJ+WMA@mail.gmail.com>
Subject: Re: [PATCH 1/8] pmem: Initial version of persistent memory driver
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 19, 2015 at 2:24 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> I apologize. It is not my intention to hijack your project. All but the last
> 2 changes I have posted again and again, even those changes I have said that
> I maintain them in a public tree, and made them available publicly ASAP. I
> stopped sending the (last 2) patches because it felt like I was spamming the
> list, since none of my patches got any comments or have been accepted to your
> tree.

That's not true.  We talked about your "map=" proposal at length back
in September.  You concluded "That the discovery should be elsewhere
in an ARCH/driver LLD and pmem stays generic." [1].  A generic
approach is being specified by the ACPI Working Group and will be
released "Real Soon Now (TM)" (on the order of weeks not months).  My
first choice would be to finish waiting for that specification before
we upstream a pmem driver.  Outside of that, if we need a pmem driver
"now", Ross's version has the nice property of having an easier to
revert resource discovery mechanism.  The kernel command line is
arguably an ABI and the need for "map=" is obviated by a generic
resource discovery mechanism.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2014-September/000043.html
