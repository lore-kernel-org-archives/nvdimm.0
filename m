Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150415084500.GB14700@gmail.com>
References: <20150413093309.GA30219@gmail.com>
	<20150413093541.GA5147@lst.de>
	<20150413104531.GB30556@gmail.com>
	<20150413171805.GA14243@lst.de>
	<20150414124157.GA28544@gmail.com>
	<CAPcyv4hwdQr-i2wdyOfzBoz41EvW7orBjPZepjDX6BNHpwhukA@mail.gmail.com>
	<20150415084500.GB14700@gmail.com>
Date: Wed, 15 Apr 2015 21:31:28 -0700
Message-ID: <CAPcyv4jzHMMWuvWnA5kL0BphVrnaC4TwQfSqsSXN-=qjRpwDWQ@mail.gmail.com>
Subject: Re: [GIT PULL] PMEM driver for v4.1
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 15, 2015 at 1:45 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
>> > None of this gives me warm fuzzy feelings...
>> >
>> > ... has anyone explored the possibility of putting 'struct page'
>> > into the pmem device itself, essentially using it as metadata?
>>
>> Yes, the impetus for proposing the pfn conversion of the block layer
>> was the consideration that persistent memory may have less write
>> endurance than DRAM.  The kernel preserving write endurance
>> exclusively for user data and the elimination of struct page
>> overhead motivated the patchset [1].
>>
>> [1]: https://lwn.net/Articles/636968/
>
> (Is there a Git URL where I could take a look at these patches?)

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm
evacuate-struct-page-v1

Note that the bulk of the change is automated via Coccinelle.

For v2, I'm looking at enabling a kmap primitive to operate on a
pfn_t, kmap_pfn().
