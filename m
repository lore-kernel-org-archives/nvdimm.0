Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
 [150.101.137.129])
 by ml01.01.org (Postfix) with ESMTP id BB2822117AE6D
 for <linux-nvdimm@lists.01.org>; Thu, 18 Oct 2018 20:01:06 -0700 (PDT)
Date: Fri, 19 Oct 2018 14:01:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181019030103.GG18822@dastard>
References: <20181002150123.GD4963@linux-x5ow.site>
 <20181002150634.GA22209@infradead.org>
 <20181004100949.GF6682@linux-x5ow.site>
 <20181005062524.GA30582@infradead.org>
 <20181005063519.GA5491@linux-x5ow.site>
 <CAPcyv4jD4VgRaKDQF9eMmjhMEHjUJqRU8i6OC+-=0domCc9u3A@mail.gmail.com>
 <CAPcyv4i7WJsq3BMASozjjbpMmEiS4AqmRS0kt3=rHdGfb5YvLA@mail.gmail.com>
 <CAPcyv4jt_w-89+m4w=FcN0oF3axiGqPBTHfEcWwdhnr12_=17Q@mail.gmail.com>
 <20181018174300.GT23493@quack2.suse.cz>
 <CAPcyv4gEmCt3OwQ_AoFCmpX5fmmBppvaxtQ+uPT=_f2MXezcGg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gEmCt3OwQ_AoFCmpX5fmmBppvaxtQ+uPT=_f2MXezcGg@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 18, 2018 at 12:10:13PM -0700, Dan Williams wrote:
> The only caveat to address all the use cases for applications making
> decisions based on the presence of DAX

And that's how we've got into this mess.

Applications need to focus on the functionality they require, not
the technology that provides it. That's the root of the we are
trying to solve here and really I don't care if we have to break
existing applications to do it. i.e. we've made no promises about
API/ABI stability and the functionality is still experimental.

Fundamentally, DAX is a technology, not an API property. The two
"DAX" API properties that matter to applications are:

	1. does mmap allow us to use CPU flush instructions for data
	integrity operations safely? And
	2. can mmap directly access the backing store without
	incurring any additional overhead?

MAP_SYNC provides #1, MAP_DIRECT provides #2, and DAX provides both.
However, they do not define DAX, nor does DAX define them. e.g.

	MAP_SYNC can be provided by a persistent memory page cache.
	But a persistent memory page cache does not provide
	MAP_DIRECT.

	MAP_SYNC can be provided by filesystem DAX, but *only* when
	direct access is used. i.e. MAP_SYNC | MAP_DIRECT

	MAP_DIRECT can be provided by filesystem DAX, but it does
	not imply or require MAP_SYNC behaviour.

IOWs, using MAP_SYNC and/or MAP_DIRECT to answering an "is DAX
present" question ties the API to a technology rather than to the
functionality the technology provides applications.

i.e. If the requested behaviour/property is not available from the
underlying technology, then the app needs to handle that error and
use a different access method.

> applications making
> decisions based on the presence of DAX
> is to make MADV_DIRECT_ACCESS
> fail if the mapping was not established with MAP_SYNC.

And so this is wrong - MADV_DIRECT_ACCESS does not require MAP_SYNC.

It is perfectly legal for MADV_DIRECT_ACCESS to be used without
MAP_SYNC - the app just needs to use msync/fsync instead.

Wanting to enable full userspace CPU data sync semantics via
madvise() implies we also need MADV_SYNC in addition to
MADV_DIRECT_ACCESS.

i.e. Apps that are currently testing for dax should use
mmap(MAP_SYNC|MAP_DIRECT) or madvise(MADV_SYNC|MADV_DIRECT) and they
will fail if the underlying storage is not DAX capable. The app
doesn't need to poke at anything else to see if DAX is enabled - if
the functionality is there then it will work, otherwise they need to
handle the error and do something else.

> That way we
> have both a way to assert that page cache resources are not being
> consumed, and that the kernel is handling metadata synchronization for
> any write-faults.

Yes, we need to do that, but not at the cost of having the API
prevent apps from ever being able to use direct access + msync/fsync
data integrity operations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
