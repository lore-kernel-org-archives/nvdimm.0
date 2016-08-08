Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on0712.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe40::712])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E8CBF1A1E18
 for <linux-nvdimm@lists.01.org>; Mon,  8 Aug 2016 05:30:22 -0700 (PDT)
From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: Subtle races between DAX mmap fault and write path
Date: Mon, 8 Aug 2016 12:30:18 +0000
Message-ID: <CS1PR84MB0119ACB424699154BDA197B28E1B0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
References: <20160727221949.GU16044@dastard>
 <20160728081033.GC4094@quack2.suse.cz> <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
 <20160802002144.GL16044@dastard> <1470335997.8908.128.camel@hpe.com>
 <20160805112739.GG16044@dastard>
 <CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <20160808092655.GA29128@quack2.suse.cz>
In-Reply-To: <20160808092655.GA29128@quack2.suse.cz>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Kara <jack@suse.cz>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Jan Kara wrote on 2016-08-08:
> On Fri 05-08-16 19:58:33, Boylston, Brian wrote:
>> Dave Chinner wrote on 2016-08-05:
>>> [ cut to just the important points ]
>>> On Thu, Aug 04, 2016 at 06:40:42PM +0000, Kani, Toshimitsu wrote:
>>>> On Tue, 2016-08-02 at 10:21 +1000, Dave Chinner wrote:
>>>>> If I drop the fsync from the
>>>>> buffered IO path, bandwidth remains the same but runtime drops to
>>>>> 0.55-0.57s, so again the buffered IO write path is faster than DAX
>>>>> while doing more work.
>>>> =

>>>> I do not think the test results are relevant on this point because both
>>>> buffered and dax write() paths use uncached copy to avoid clflush. =A0=
The
>>>> buffered path uses cached copy to the page cache and then use uncached=
 copy to
>>>> PMEM via writeback. =A0Therefore, the buffered IO path also benefits f=
rom using
>>>> uncached copy to avoid clflush.
>>> =

>>> Except that I tested without the writeback path for buffered IO, so
>>> there was a direct comparison for single cached copy vs single
>>> uncached copy.
>>> =

>>> The undenial fact is that a write() with a single cached copy with
>>> all the overhead of dirty page tracking is /faster/ than a much
>>> shorter, simpler IO path that uses an uncached copy. That's what the
>>> numbers say....
>>> =

>>>> Cached copy (req movq) is slightly faster than uncached copy,
>>> =

>>> Not according to Boaz - he claims that uncached is 20% faster than
>>> cached. How about you two get together, do some benchmarking and get
>>> your story straight, eh?
>>> =

>>>> and should be
>>>> used for writing to the page cache. =A0For writing to PMEM, however, a=
dditional
>>>> clflush can be expensive, and allocating cachelines for PMEM leads to =
evict
>>>> application's cachelines.
>>> =

>>> I keep hearing people tell me why cached copies are slower, but
>>> no-one is providing numbers to back up their statements. The only
>>> numbers we have are the ones I've published showing cached copies w/
>>> full dirty tracking is faster than uncached copy w/o dirty tracking.
>>> =

>>> Show me the numbers that back up your statements, then I'll listen
>>> to you.
>> =

>> Here are some numbers for a particular scenario, and the code is below.
>> =

>> Time (in seconds) to copy a 16KiB buffer 1M times to a 4MiB NVDIMM buffer
>> (1M total memcpy()s).  For the cached+clflush case, the flushes are done
>> every 4MiB (which seems slightly faster than flushing every 16KiB):
>> =

>>                   NUMA local    NUMA remote
>> Cached+clflush      13.5           37.1
>> movnt                1.0            1.3
> =

> Thanks for the test Brian. But looking at the current source of libpmem
> this seems to be comparing apples to oranges. Let me explain the details
> below:
> =

>> In the code below, pmem_persist() does the CLFLUSH(es) on the given rang=
e,
>> and pmem_memcpy_persist() does non-temporal MOVs with an SFENCE:
> =

> Yes. libpmem does what you describe above and the name
> pmem_memcpy_persist() is thus currently misleading because it is not
> guaranteed to be persistent with the current implementation of DAX in
> the kernel.
> =

> It is important to know which kernel version and what filesystem have you
> used for the test to be able judge the details but generally pmem_persist=
()
> does properly tell the filesystem to flush all metadata associated with t=
he
> file, commit open transactions etc. That's the full cost of persistence.

I used NVML 1.1 for the measurements.  In this version and with the hardware
that I used, the pmem_persist() flow is:

  pmem_persist()
    pmem_flush()
      Func_flush() =3D=3D flush_clflush
        CLFLUSH
    pmem_drain()
      Func_predrain_fence() =3D=3D predrain_fence_empty
        no-op

So, I don't think that pmem_persist() does anything to cause the filesystem
to flush metadata as it doesn't make any system calls?

> pmem_memcpy_persist() makes sure the data writes have reached persistent
> storage but nothing guarantees associated metadata changes have reached
> persistent storage as well.

While metadata is certainly important, my goal with this specific test was
to measure the "raw" performance of cached+flush vs uncached, without
anything else in the way.

> To assure that, fsync() (or pmem_persist()
> if you wish) is currently the only way from userspace.

Perhaps you mean pmem_msync() here?  pmem_msync() calls msync(), but
pmem_persist() does not.

> At which point
> you've lost most of the advantages using movnt. Ross researches into
> possibilities of allowing more efficient userspace implementation but
> currently there are none.

Apart from the current performance discussion, if the metadata for a file
is already established (file created, space allocated by explicit writes(),
and everything synced), then if I map it and do pmem_memcpy_persist(),
are there any "ongoing" metadata updates that would need to be flushed
(besides timestamps)?


Brian

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
