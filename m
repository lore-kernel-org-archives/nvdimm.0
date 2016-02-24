Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20160224141931.8d72d389a5c969d12e6e9216@linux-foundation.org>
References: <20160224184242.GA2858@linux.intel.com>
	<CA+55aFx=g1cUoSDB4CYC4GuskqbsBvTefbYNwc2-oL1un_EhhA@mail.gmail.com>
	<20160224141931.8d72d389a5c969d12e6e9216@linux-foundation.org>
Date: Wed, 24 Feb 2016 14:57:25 -0800
Message-ID: <CAPcyv4j=ofEJ_RGOCbseUwUTGD=9pwP_M5QaChYzUAWpi1qjGA@mail.gmail.com>
Subject: Re: [GIT PULL] dax-fixes for 4.5-rc6
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 24, 2016 at 2:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 24 Feb 2016 14:03:22 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Wed, Feb 24, 2016 at 10:42 AM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>> >
>> > I know DAX fixes have historically gone up through Andrew Morton's -mm tree,
>> > but for some reason he's been silent on this series for the last few weeks.  I
>> > think that the problems being fixed are important enough that we really
>> > shouldn't wait until v4.6.
>>
>> Andrew, can you comment?
>>
>
> It's been a bit confusing because Dan has been merging DAX stuff as
> well, mainly on the fs side.  I had assumed that these patches were
> aimed at that route also.

I've merged some fs/dax.c bits in the past, but if it has mm
implications (like the struct page for pmem work) or cross tree impact
touching multiple filesystems like this set I've considered that akpm
material.
