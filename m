From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [LSF/MM TOPIC] Future direction of DAX
Date: Mon, 16 Jan 2017 15:00:41 -0500
Message-ID: <x49wpduzseu.fsf@dhcp-25-115.bos.redhat.com>
References: <20170114002008.GA25379@linux.intel.com>
        <20170114082621.GC10498@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170114082621.GC10498@birch.djwong.org> (Darrick J. Wong's
        message of "Sat, 14 Jan 2017 00:26:21 -0800")
Sender: linux-block-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, linux-block@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-nvdimm@lists.01.org

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

>> - Whenever you mount a filesystem with DAX, it spits out a message that says
>>   "DAX enabled. Warning: EXPERIMENTAL, use at your own risk".  What criteria
>>   needs to be met for DAX to no longer be considered experimental?
>
> For XFS I'd like to get reflink working with it, for starters.

What do you mean by this, exactly?  When Dave outlined the requirements
for PMEM_IMMUTABLE, it was very clear that metadata updates would not be
possible.  And would you really cosider this a barrier to marking dax
fully supported?  I wouldn't.

> We probably need a bunch more verification work to show that file IO
> doesn't adopt any bad quirks having turned on the per-inode DAX flag.

Can you be more specific?  We have ltp and xfstests.  If you have some
mkfs/mount options that you think should be tested, speak up.  Beyond
that, if it passes ./check -g auto and ltp, are we good?

-Jeff
