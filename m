Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <550A95B7.9070002@plexistor.com>
Date: Thu, 19 Mar 2015 11:24:07 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/8] pmem: Initial version of persistent memory driver
References: <54F82CE0.4040502@plexistor.com>	 <54F830D4.7030205@plexistor.com> <54F84420.40209@plexistor.com> <1426700587.17347.24.camel@theros.lm.intel.com>
In-Reply-To: <1426700587.17347.24.camel@theros.lm.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On 03/18/2015 07:43 PM, Ross Zwisler wrote:
> On Thu, 2015-03-05 at 13:55 +0200, Boaz Harrosh wrote:
>> From: Ross Zwisler <ross.zwisler@linux.intel.com>
>>
>> PMEM is a new driver That supports any physical contiguous iomem range
>> as a single block device. The driver has support for as many as needed
>> iomem ranges each as its own device.
>>
>> The driver is not only good for NvDIMMs, It is good for any flat memory
>> mapped device. We've used it with NvDIMMs, Kernel reserved DRAM
>> (memmap= on command line), PCIE Battery backed memory cards, VM shared
>> memory, and so on.
>>
>> The API to pmem module a single string parameter named "map"
>> of the form:
>> 		 map=mapS[,mapS...]
>>
>> 		 where mapS=nn[KMG]$ss[KMG],
>> 		 or    mapS=nn[KMG]@ss[KMG],
>>
>> 		 nn=size, ss=offset
>>
>> Just like the Kernel command line map && memmap parameters,
>> so anything you did at grub just copy/paste to here.
>>
>> The "@" form is exactly the same as the "$" form only that
>> at bash prompt we need to escape the "$" with \$ so also
>> support the '@' char for convenience.
>>
>> For each specified mapS there will be a device created.
>>
>> [This is the accumulated version of the driver developed by
>>  multiple programmers. To see the real history of these
>>  patches see:
>> 	git://git.open-osd.org/pmem.git
>> 	https://github.com/01org/prd
>>  This patch is based on (git://git.open-osd.org/pmem.git):
>> 	[5ccf703] SQUASHME: Don't clobber the map module param
>>
>> <list-of-changes>
>> [boaz]
>> SQUASHME: pmem: Remove unused #include headers
>> SQUASHME: pmem: Request from fdisk 4k alignment
>> SQUASHME: pmem: Let each device manage private memory region
>> SQUASHME: pmem: Support of multiple memory regions
>> SQUASHME: pmem: Micro optimization the hotpath 001
>> SQUASHME: pmem: no need to copy a page at a time
>> SQUASHME: pmem that 4k sector thing
>> SQUASHME: pmem: Cleanliness is neat
>> SQUASHME: Don't clobber the map module param
>> SQUASHME: pmem: Few changes to Initial version of pmem
>> SQUASHME: Changes to copyright text (trivial)
>> </list-of-changes>
>>
>> TODO: Add Documentation/blockdev/pmem.txt
>>
>> Need-signed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> 
> I wrote the initial version of the PMEM driver (then called PRD for Persistent
> RAM Driver) in late 2013/early 2014, and posted it on GitHub.  Here's a link
> to my first version:
> 
> https://github.com/01org/prd/tree/prd_3.13
> 
> Matthew Wilcox pointed Boaz to it in June of 2014, and he cloned my tree and
> went off and made a bunch of changes.  A few of those changes he sent back to
> me, like the one I included in the patch series I recently sent for upstream
> inclusion:
> 
> https://lkml.org/lkml/2015/3/16/1102
> 
> Many of the changes he did not submit back to me for review or inclusion in my
> tree.
> 
> With the first patch in this series Boaz is squashing all of our changes
> together, adding his copyright and trying to install himself as maintainer.  I
> believe this to be unacceptable.  
> 
> Boaz, if you have contributions that you would like to make to PMEM, please
> submit them to our mailing list (linux-nvdimm@lists.01.org) and we will be
> happy to review them.  But please don't try and steal control of my driver.
> 

I apologize. It is not my intention to hijack your project. All but the last
2 changes I have posted again and again, even those changes I have said that
I maintain them in a public tree, and made them available publicly ASAP. I
stopped sending the (last 2) patches because it felt like I was spamming the
list, since none of my patches got any comments or have been accepted to your
tree.

It was my notion that you do not want to bother with farther development, your
tree was stuck on 3.17, while I was rebasing on every major Linux release, adding
my changes as they accumulated over time.

For example That patch that you mentioned that you accepted in the tree, that
same patch was just a staging patch, to the more important change that
throws away the toy Kconfig and 3 module params, and puts in a real world
actually usable API, for long term. You did not take that patch, why?

So I was in the notion that you don't want to maintain this driver, and I was
forced to fork the project and move on. What other choice did I have?

About the added copyright, diffing your original driver without any of my
changes including all the partition bugs, the changed API the IO path cleanup,
it comes out less then 30% similarity, as a courtesy to my employer I think he
is entitled to an added copyright.

But let us not fight. You want to maintain this thing, start by squashing all
my changes + all the other added patches and publish them on an your tree. I
need this driver usable.

> - Ross
> 
> 

Thanks
Boaz

