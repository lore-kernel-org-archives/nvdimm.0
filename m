Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 19 Feb 2015 11:30:47 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [Linux-nvdimm] [PATCH 0/2] e820: Fix handling of NvDIMM chips
Message-ID: <20150219103046.GB2819@gmail.com>
References: <20150216220302.GF3364@wil.cx>
 <54E2FEF2.8060701@plexistor.com>
 <CAPcyv4if=9Cv__4D0oE9ds1C37TRDkURSVtyB8_k9Nc3WUwbrg@mail.gmail.com>
 <20150218183049.GA7032@gmail.com>
 <CAPcyv4hq0ETPMEuH0RKuy1=bqrnDM4-k+36ESTnS5EuB6d4MJw@mail.gmail.com>
 <20150218185327.GA7828@gmail.com>
 <CAPcyv4jVyk=mTRzGCKhy9P8cjukiuBWE=kfRaZ2DG-QsVgsvYg@mail.gmail.com>
 <20150218192704.GA8441@gmail.com>
 <CAPcyv4inN4Pja9vOpYd8m_RB6kgFmjQXvwJv3CqKwEUaaXpNCw@mail.gmail.com>
 <54E5BA90.3010609@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54E5BA90.3010609@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <linux-nvdimm@lists.01.org>


* Boaz Harrosh <boaz@plexistor.com> wrote:

> Do you require another redundant message who's purpose is to scare
> people off, like:
>
> 	e820: WARN [mem 0x0000000100000000-0x000000017fffffff] is unknown type 12
> 
> Sure I'll add it

That message looks useful (and not very scary), and also 
emit a warning if such a region is then claimed by a 
driver.

This puts some pressure on both the firmware and the kernel 
side to get their act together, without holding 
functionality hostage.

Thanks,

	Ingo
