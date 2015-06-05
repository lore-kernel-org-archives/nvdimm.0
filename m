Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150512144752.GA4003@gmail.com>
References: <20150507191107.GB22952@gmail.com>
	<554CBE17.4070904@redhat.com>
	<20150508140556.GA2185@gmail.com>
	<21836.51957.715473.780762@quad.stoffel.home>
	<CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
	<554CEB5D.90209@redhat.com>
	<20150509084510.GA10587@gmail.com>
	<20150511082536.GP4327@dastard>
	<20150511091836.GA29191@gmail.com>
	<20150512005347.GQ4327@dastard>
	<20150512144752.GA4003@gmail.com>
Date: Thu, 4 Jun 2015 22:43:58 -0700
Message-ID: <CAPcyv4igpeXifpFAVSGwdiMaRftMYuZ0euUDZ0B4xwHu-jQe8Q@mail.gmail.com>
Subject: Re: "Directly mapped persistent memory page cache"
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 12, 2015 at 7:47 AM, Jerome Glisse <j.glisse@gmail.com> wrote:
> On Tue, May 12, 2015 at 10:53:47AM +1000, Dave Chinner wrote:
>> On Mon, May 11, 2015 at 11:18:36AM +0200, Ingo Molnar wrote:
>> IMO, we need to be designing around the concept that the filesytem
>> manages the pmem space, and the MM subsystem simply uses the block
>> mapping information provided to it from the filesystem to decide how
>> it references and maps the regions into the user's address space or
>> for DMA. The mm subsystem does not manage the pmem space, it's
>> alignment or how it is allocated to user files. Hence page mappings
>> can only be - at best - reactive to what the filesystem does with
>> it's free space. The mm subsystem already has to query the block
>> layer to get mappings on page faults, so it's only a small stretch
>> to enhance the DAX mapping request to ask for a large page mapping
>> rather than a 4k mapping.  If the fs can't do a large page mapping,
>> you'll get a 4k aligned mapping back.
>>
>> What I'm trying to say is that the mapping behaviour needs to be
>> designed with the way filesystems and the mm subsystem interact in
>> mind, not from a pre-formed "direct Io is bad, we must use the page
>> cache" point of view. The filesystem and the mm subsystem must
>> co-operate to allow things like large page mappings to be made and
>> hence looking at the problem purely from a mm<->pmem device
>> perspective as you are ignores an important chunk of the system:
>> the part that actually manages the pmem space...
>
> I am all for letting the filesystem manage pmem, but i think having
> struct page expose to mm allow the mm side to stay ignorant of what
> is really behind. Also if i could share more code with other i would
> be happier :)
>

As this thread is directly referencing one of the topics listed for
the Persistent Memory microconference I do not think it is
unreasonable to shamelessly hijack it to promote Linux Plumbers 2015.
Tomorrow is the deadline for earlybird registration and topic
submission tool is now open for submission of this or any other
persistent memory topic.

https://linuxplumbersconf.org/2015/attend/
https://linuxplumbersconf.org/2015/how-to-submit-microconference-discussions-topics/
