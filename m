From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Date: Thu, 23 Jun 2016 18:14:47 -0700
Message-ID: <CAPcyv4iWVyJ3vb+_dtehGRxT9WXwAxNXoDMNeNtxO+=njHNAhg@mail.gmail.com>
References: <1466609236-23801-1-git-send-email-hch@lst.de> <20160623232446.GA12670@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160623232446.GA12670@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, XFS Developers <xfs@oss.sgi.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, Jun 23, 2016 at 4:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jun 22, 2016 at 05:27:08PM +0200, Christoph Hellwig wrote:
>> The last patch is what started the series:  XFS currently uses the
>> direct I/O locking strategy for DAX because DAX was overloaded onto
>> the direct I/O path.  For XFS this means that we only take a shared
>> inode lock instead of the normal exclusive one for writes IFF they
>> are properly aligned.  While this is fine for O_DIRECT which requires
>> explicit opt-in from the application it's not fine for DAX where we'll
>> suddenly lose expected and required synchronization of the file system
>> happens to use DAX undeneath.
>
> Except we did that *intentionally* - by definition there is no
> cache to bypass with DAX and so all IO is "direct". That, combined
> with the fact that all Linux filesystems except XFS break the POSIX
> exclusive writer rule you are quoting to begin with, it seemed
> pointless to enforce it for DAX....

If we're going to be strict about POSIX fsync() semantics we should be
strict about this exclusive write semantic.  In other words why is it
ok to loosen one and not the other, if application compatibility is
the concern?

>
> So, before taking any patches to change that behaviour in XFS, a
> wider discussion about the policy needs to be had. I don't think
> we should care about POSIX here - if you have an application that
> needs this serialisation, turn off DAX.

s/needs this serialisation/needs the kernel to flush cpu cache/
