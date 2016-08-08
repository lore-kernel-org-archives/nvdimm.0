Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam03on0730.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe49::730])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B9411A1DF9
 for <linux-nvdimm@lists.01.org>; Mon,  8 Aug 2016 12:32:50 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: RE: Subtle races between DAX mmap fault and write path
Date: Mon, 8 Aug 2016 19:32:47 +0000
Message-ID: <CS1PR84MB0005ADA0CDED56A9E5FF64A5821B0@CS1PR84MB0005.NAMPRD84.PROD.OUTLOOK.COM>
References: <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
 <20160802002144.GL16044@dastard> <1470335997.8908.128.camel@hpe.com>
 <20160805112739.GG16044@dastard>
 <CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <20160808092655.GA29128@quack2.suse.cz>
 <CS1PR84MB0119ACB424699154BDA197B28E1B0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <20160808182827.GI29128@quack2.suse.cz>
In-Reply-To: <20160808182827.GI29128@quack2.suse.cz>
Content-Language: en-US
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
To: Jan Kara <jack@suse.cz>, "Boylston, Brian" <brian.boylston@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

> > Jan Kara wrote on 2016-08-08:
> > > On Fri 05-08-16 19:58:33, Boylston, Brian wrote:
> >
> > I used NVML 1.1 for the measurements.  In this version and with the
> > hardware that I used, the pmem_persist() flow is:
> >
> >   pmem_persist()
> >     pmem_flush()
> >       Func_flush() == flush_clflush
> >         CLFLUSH
> >     pmem_drain()
> >       Func_predrain_fence() == predrain_fence_empty
> >         no-op
> >
> > So, I don't think that pmem_persist() does anything to cause the filesystem
> > to flush metadata as it doesn't make any system calls?
> 
> Ah, you are right. I somehow misread what is in NVML sources. I agree with
> Christoph that _persist suffix is then misleading for the reasons he stated
> but that's irrelevant to the test you did.
> 
> So it indeed seems that in your test movnt + sfence is an order of
> magnitude faster than cached memcpy + cflush + sfence. I'm surprised I have
> to say.

movnt is posted to WC buffer, which is asynchronously evicted to memory
when each line is filled.

clflush, on the other hand, must be serialized.  So, it has to synchronously evict
line-by-line.  clflushopt, when supported by new CPUs, should be a lot faster as
it can execute simultaneously and does not have to wait line-by-line.  It'd be still
slower than uncached copy, though. 

-Toshi 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
