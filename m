Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55F9E222EDCE0
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jan 2018 12:32:48 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v4 08/18] tools/testing/nvdimm: add 'bio_delay' mechanism
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407700353.38751.17609507477918854876.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180102214450.GU5858@dastard>
 <CAPcyv4iaSnWFd6qt52+TQ_k9Kwf1pXLq8GMHdtd-Hg_mvN6rvg@mail.gmail.com>
 <20180103154613.GL4911@quack2.suse.cz>
Date: Wed, 03 Jan 2018 15:37:50 -0500
In-Reply-To: <20180103154613.GL4911@quack2.suse.cz> (Jan Kara's message of
 "Wed, 3 Jan 2018 16:46:13 +0100")
Message-ID: <x49fu7mel0h.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Jan Kara <jack@suse.cz> writes:

> On Tue 02-01-18 13:51:49, Dan Williams wrote:
>> On Tue, Jan 2, 2018 at 1:44 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sat, Dec 23, 2017 at 04:56:43PM -0800, Dan Williams wrote:
>> >> In support of testing truncate colliding with dma add a mechanism that
>> >> delays the completion of block I/O requests by a programmable number of
>> >> seconds. This allows a truncate operation to be issued while page
>> >> references are held for direct-I/O.
>> >>
>> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> >
>> > Why not put this in the generic bio layer code and then write a
>> > generic fstest to exercise this truncate vs direct IO completion
>> > race condition on all types of storage and filesystems?
>> >
>> > i.e. if it sits in a nvdimm test suite, it's never going to be run
>> > by filesystem developers....
>> 
>> I do want to get it into xfstests eventually. I picked the nvdimm
>> infrastructure for expediency of getting the fix developed. Also, I
>> consider the collision in the non-dax case a solved problem since the
>> core mm will keep the page out of circulation indefinitely.
>
> Yes, but there are different races that could happen even for regular page
> cache pages. So I also think it would be worthwhile to have this inside the
> block layer possibly as part of the generic fault-injection framework which
> is already there for fail_make_request. That already supports various
> filtering, frequency, and other options that could be useful.

Or consider extending the dm-delay target (which delays the queuing of
bios) to support delaying the completions.  I'm not sure I'm a fan of
sticking all sorts of debug code into the generic I/O submission path.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
