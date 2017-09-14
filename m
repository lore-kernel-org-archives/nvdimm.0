Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x232.google.com (mail-io0-x232.google.com
 [IPv6:2607:f8b0:4001:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9859821D492F0
 for <linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 18:21:13 -0700 (PDT)
Received: by mail-io0-x232.google.com with SMTP id n69so11381193ioi.5
 for <linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 18:24:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170914004038.GZ10621@dastard>
References: <20170908152805.GA16646@linux.intel.com>
 <20170908212153.14880-1-ross.zwisler@linux.intel.com>
 <20170912064411.GR10621@dastard> <20170912153820.GA5000@linux.intel.com>
 <20170912234729.GW10621@dastard> <20170913144215.GA12395@linux.intel.com>
 <20170913220108.GX10621@dastard>
 <CAPcyv4hGSLQS1GmTYtzMCBDDNNuK1nLRKme6e-Vpx8_pyaJwrg@mail.gmail.com>
 <20170913233438.GY10621@dastard>
 <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
 <20170914004038.GZ10621@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Sep 2017 18:24:10 -0700
Message-ID: <CAPcyv4iNcnq9sJVLeju-3Ua+XYfTscOb9iiWDS5yB768WJTOXQ@mail.gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 13, 2017 at 5:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Sep 13, 2017 at 05:28:39PM -0700, Dan Williams wrote:
>> On Wed, Sep 13, 2017 at 4:34 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > /me shrugs
>> >
>> > I just don't like the concept of using tracepoints to as a
>> > definitive diagnostic test for something working because it'll break
>> > when the kernel implementation and tracepoints change. So while we
>> > can probe for perf being present, we can't probe whether the
>> > tracepoint we need behaves as the test expects it to...
>>
>> That concern makes sense.
>>
>> We handle that it a crude way in the libnvdimm unit tests by hard
>> coding a required minimum kernel version and rolling a test forward to
>> depend on a new kernel when assumptions about the kernel-internals
>> change. The tests also inject out-of-tree kernel modules that let us
>> go after specific kernel internal behavior. With this approach we
>> don't end up creating userspace ABI since the test explicitly loads
>> out-of-tree modules.
>
> That's horrible. OT, but how are distros or anyone backporting
> libnvdimm fixes and features supposed to test their kernels work
> correctly with such a test harness?

The upstream kernel version for the test to assume can be overridden
by an environment variable. It has worked well so far for me when I'm
using it it to test backports, but I don't have much in the way of
third-party feedback.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
