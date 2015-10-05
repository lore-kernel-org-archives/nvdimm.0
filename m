Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CACVXFVNRzR0339Zq7TG32Z1WboehAvGuaPeijW1t9AjRvLZrBQ@mail.gmail.com>
References: <20150930002927.37133.331.stgit@dwillia2-desk3.jf.intel.com>
	<20150930004130.37133.73852.stgit@dwillia2-desk3.jf.intel.com>
	<CACVXFVNRzR0339Zq7TG32Z1WboehAvGuaPeijW1t9AjRvLZrBQ@mail.gmail.com>
Date: Mon, 5 Oct 2015 16:23:39 -0700
Message-ID: <CAPcyv4gbE74iO3EsdXjdDS6jtdwsojYs8KJxYgnbKnuY0VNQUg@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: generic request_queue reference counting
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Oct 4, 2015 at 12:52 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Wed, Sep 30, 2015 at 8:41 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> Allow pmem, and other synchronous/bio-based block drivers, to fallback
>
> Just a bit curious, why not extend it for all(both synchronous and
> asynchrounous) bio-based drivers? As you mentioned in introductory
> message, all bio based drivers may have this kind of problem.
>
> One idea I thought of is to hold the usage counter in bio life time,
> instead of request's life time like in blk-mq.
>
>> on a per-cpu reference count managed by the core for tracking queue
>> live/dead state.
>>
>> The existing per-cpu reference count for the blk_mq case is promoted to
>> be used in all block i/o scenarios.  This involves initializing it by
>> default, waiting for it to drop to zero at exit, and holding a live
>> reference over the invocation of q->make_request_fn() in
>
> It isn't enough for asynchrounous bio drivers.

True, but I think that support is a follow on extension of the
mechanism.  It seems to me not as straightforward as holding a
per-request reference or a reference over the submission path.
