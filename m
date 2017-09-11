Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x234.google.com (mail-io0-x234.google.com
 [IPv6:2607:f8b0:4001:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0932D2095BB87
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 08:35:04 -0700 (PDT)
Received: by mail-io0-x234.google.com with SMTP id v36so15771860ioi.1
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 08:37:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170911151610.GA5014@linux.intel.com>
References: <20170908152805.GA16646@linux.intel.com>
 <20170908212153.14880-1-ross.zwisler@linux.intel.com>
 <20170911151610.GA5014@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Sep 2017 08:37:58 -0700
Message-ID: <CAPcyv4gGpAW7kUCgqSoNCPkFZVYzTVQi3C4x6AFm2KHvFrZSfw@mail.gmail.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 11, 2017 at 8:16 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, Sep 08, 2017 at 03:21:53PM -0600, Ross Zwisler wrote:
>> This adds a regression test for the following kernel patch:
>>
>>   xfs: always use DAX if mount option is used
>>
>> This test will also pass with kernel v4.14-rc1 and beyond because the XFS
>> DAX I/O mount option has been disabled (but not removed), so the
>> "chattr -x" to turn off DAX doesn't actually do anything.
>>
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Suggested-by: Christoph Hellwig <hch@infradead.org>
>
> <>
>
>> +# disable tracing, clear the existing trace buffer and turn on dax tracepoints
>> +echo 0 > /sys/kernel/debug/tracing/tracing_on
>> +echo > /sys/kernel/debug/tracing/trace
>> +echo 1 > /sys/kernel/debug/tracing/events/fs_dax/enable
>
> I think I can do a better job of:
>
> a) detecting whether debugfs is present, and if not just bail the test as not
> run
>
> b) recording the current state of the debugfs (tracing_on, fs_dax/enable),
> doing what I need to do, then restoring the previous state.
>
> Before I work on a v2, though, I'd love to get feedback on whether or not
> using tracepoints is okay in fstests.

I think it is more straightforward to use "perf record -e fs_dax
$test". Then you know the events are filtered to your test pid and you
don't need to worry about managing the trace interface.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
