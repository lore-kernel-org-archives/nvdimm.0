From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [LSF/MM TOPIC] Future direction of DAX
Date: Mon, 16 Jan 2017 18:42:57 -0800
Message-ID: <CAPcyv4iF5Q6euj5RKiGzHqqVWjQPuOOgtg32FZKactDFW9Oy0Q@mail.gmail.com>
References: <20170114002008.GA25379@linux.intel.com> <20170114082621.GC10498@birch.djwong.org>
 <x49wpduzseu.fsf@dhcp-25-115.bos.redhat.com> <20170117015033.GD10498@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170117015033.GD10498@birch.djwong.org>
Sender: owner-linux-mm@kvack.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-nvdimm <linux-nvdimm@ml01.01.org>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org
List-Id: linux-nvdimm@lists.01.org

On Mon, Jan 16, 2017 at 5:50 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, Jan 16, 2017 at 03:00:41PM -0500, Jeff Moyer wrote:
>> "Darrick J. Wong" <darrick.wong@oracle.com> writes:
>>
>> >> - Whenever you mount a filesystem with DAX, it spits out a message that says
>> >>   "DAX enabled. Warning: EXPERIMENTAL, use at your own risk".  What criteria
>> >>   needs to be met for DAX to no longer be considered experimental?
>> >
>> > For XFS I'd like to get reflink working with it, for starters.
>>
>> What do you mean by this, exactly?  When Dave outlined the requirements
>> for PMEM_IMMUTABLE, it was very clear that metadata updates would not be
>> possible.  And would you really cosider this a barrier to marking dax
>> fully supported?  I wouldn't.
>
> For PMEM_IMMUTABLE files, yes, reflink cannot be supported.
>
> I'm talking about supporting reflink for DAX files that are /not/
> PMEM_IMMUTABLE, where user programs can mmap pmem directly but write
> activity still must use fsync/msync to ensure that everything's on disk.
>
> I wouldn't consider it a barrier in general (since ext4 also prints
> EXPERIMENTAL warnings for DAX), merely one for XFS.  I don't even think
> it's that big of a hurdle -- afaict XFS ought to be able to achieve this
> by modifying iomap_begin to allocate new pmem blocks, memcpy the
> contents, and update the memory mappings.  I think.
>
>> > We probably need a bunch more verification work to show that file IO
>> > doesn't adopt any bad quirks having turned on the per-inode DAX flag.
>>
>> Can you be more specific?  We have ltp and xfstests.  If you have some
>> mkfs/mount options that you think should be tested, speak up.  Beyond
>> that, if it passes ./check -g auto and ltp, are we good?
>
> That's probably good -- I simply wanted to know if we'd at least gotten
> to the point that someone had run both suites with and without DAX and
> not seen any major regressions between the two.

Yes, xfstests is part the dax development flow. The hard part has been
maintaining a blacklist of tests that fail in both the DAX and non-DAX
cases, or false negatives due to DAX disabling delayed allocation

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
