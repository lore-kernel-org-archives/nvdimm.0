Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54FD94F6.4040600@plexistor.com>
Date: Mon, 09 Mar 2015 14:41:26 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [RFC 0/8] pmem: Submission of the Persistent memory block device
References: <54F82CE0.4040502@plexistor.com>	 <54F830D4.7030205@plexistor.com> <1425667065.32009.7.camel@theros.lm.intel.com>
In-Reply-To: <1425667065.32009.7.camel@theros.lm.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On 03/06/2015 08:37 PM, Ross Zwisler wrote:
<>
>> I maintain these patches on latest Kernels here:
>> 	git://git.open-osd.org/pmem.git branch pmem
>>
>> Thanks for reviewing
>> Boaz
> 
> Hey Boaz,
> 
> Regarding the PMEM series, my group has been working on an updated
> version of this driver for the past 6 months or so since I initially
> posted the beginnings of this series:
> 
> https://lkml.org/lkml/2014/8/27/674
> 
> That new version should be ready for public viewing sometime in April.
> 
> It's my preference that we wait to try and upstream any form of PMEM
> until we've released our updated version of the driver, and you've had a
> chance to review and add in any changes you need.  I'm cool with
> gathering additional feedback until then, of course.
> 

Dear Ross

We have a very grave problem with you guys. You do not develop an open
source driver in stealth mode, and not release code until some undefined
future. This is called forking. And forking means taking the extra hit
when main stream is advancing.

I've been changing this driver and supporting code, and even if not posting
every change on ML, so not to make noise, I pushed any new version to the
public tree every time. So anyone that monitors the tree can provision for
my changes and see where I'm going with this.

I've been monitoring your tree, and there was not a single change. If you
are making progress you should make them available, as soon as they advance
so we can see and adjust. (And/or maybe not make the same effort twice?)

> Trying to upstream this older version and then merging it with the newer
> stuff in-kernel seems like it'll just end up being more work in the end.
> 

I don't think so. Did you see the latest version of this driver. It is
so small. Any changes you will make, will probably be additions and
enhancements. I do not see how it will make such an extra work.

Show me the code, If I see that you are right I will make changes
accordingly, but for now I cannot see why it can make any kind of
problems.

> Thanks,
> - Ross

Thanks
Boaz

