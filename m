From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] nd_blk,nd_pmem,nd_btt: add endio blktrace events
Date: Wed, 09 Nov 2016 14:31:30 -0500
Message-ID: <x49mvh8o3fx.fsf@segfault.boston.devel.redhat.com>
References: <x49twbgo4i6.fsf@segfault.boston.devel.redhat.com>
        <20161109191715.GA20314@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161109191715.GA20314@infradead.org> (Christoph Hellwig's
        message of "Wed, 9 Nov 2016 11:17:15 -0800")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Dan J. Williams" <dan.j.williams@intel.com>, linux-nvdimm@ml01.01.org, linux-block@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Nov 09, 2016 at 02:08:33PM -0500, Jeff Moyer wrote:
>> Right now, any of the above three drivers will report Q events in
>> blktrace but no corresponding C events.  Fix it.
>
> It seems like that trace point should simply go into bio_endio
> and be removed from any existing callsite.

bio_endio is still called for request_fn drivers, so you'd see two
completion events for those drivers if we did that, no?

-Jeff
