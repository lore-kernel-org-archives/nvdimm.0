From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5] DAX: enable iostat for read/write
Date: Wed, 25 Jan 2017 10:15:50 -0500
Message-ID: <x498tpznpax.fsf@segfault.boston.devel.redhat.com>
References: <20170112183848.23159-1-toshi.kani@hpe.com>
        <20170125111952.GA11978@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170125111952.GA11978@infradead.org> (Christoph Hellwig's
        message of "Wed, 25 Jan 2017 03:19:52 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Toshi Kani <toshi.kani@hpe.com>, akpm@linux-foundation.org, dan.j.williams@intel.com, linux-nvdimm@ml01.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Jan 12, 2017 at 11:38:48AM -0700, Toshi Kani wrote:
>> DAX IO path does not support iostat, but its metadata IO path does.
>> Therefore, iostat shows metadata IO statistics only, which has been
>> confusing to users.
>> 
>> Add iostat support to the DAX read/write path.
>> 
>> Note, iostat still does not support the DAX mmap path as it allows
>> user applications to access directly.
>
> NAK.  DAX I/O should not be accounted for block device statistics.

Agreed, this is a layering violation.

Cheers,
Jeff
