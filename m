From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [LSF/MM TOPIC] Future direction of DAX
Date: Tue, 17 Jan 2017 09:54:27 -0500
Message-ID: <x49mvep4tzw.fsf@segfault.boston.devel.redhat.com>
References: <20170114002008.GA25379@linux.intel.com>
        <20170114082621.GC10498@birch.djwong.org>
        <x49wpduzseu.fsf@dhcp-25-115.bos.redhat.com>
        <20170117015033.GD10498@birch.djwong.org>
        <20170117075735.GB19654@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170117075735.GB19654@infradead.org> (Christoph Hellwig's
        message of "Mon, 16 Jan 2017 23:57:35 -0800")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, linux-block@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-nvdimm@lists.01.org

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Jan 16, 2017 at 05:50:33PM -0800, Darrick J. Wong wrote:
>> I wouldn't consider it a barrier in general (since ext4 also prints
>> EXPERIMENTAL warnings for DAX), merely one for XFS.  I don't even think
>> it's that big of a hurdle -- afaict XFS ought to be able to achieve this
>> by modifying iomap_begin to allocate new pmem blocks, memcpy the
>> contents, and update the memory mappings.  I think.

Ah, I wasn't even thinking about non PMEM_IMMUTABLE usage.

> Yes, and I have a working prototype for that.  I'm just way to busy
> with lots of bugfixing at the moment but I plan to get to it in this
> merge window.  I also agree that we can't mark a feature as fully
> supported until it doesn't conflict with other features.

Fair enough.

> And I'm not going to get start on the PMEM_IMMUTABLE bullshit, please
> don't even go there folks, it's a dead end.

I spoke with Dave before the holidays, and he indicated that
PMEM_IMMUTABLE would be an acceptable solution to allowing applications
to flush data completely from userspace.  I know this subject has been
beaten to death, but would you mind just summarizing your opinion on
this one more time?  I'm guessing this will be something more easily
hashed out at LSF, though.

Thanks,
Jeff
