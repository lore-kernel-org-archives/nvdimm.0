Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A4EC211A2DAE
 for <linux-nvdimm@lists.01.org>; Thu,  3 Jan 2019 12:26:50 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: Question on Error Injection
Date: Thu, 3 Jan 2019 20:26:48 +0000
Message-ID: <199cc2d719c01c7099723e3c5f4aaa88060535e1.camel@intel.com>
References: <1351778734.5719210.1546535622423.ref@mail.yahoo.com>
 <1351778734.5719210.1546535622423@mail.yahoo.com>
 <873fd52419a7561f983927597dfb6fb613fc937e.camel@intel.com>
 <69789157.5813313.1546545763506@mail.yahoo.com>
In-Reply-To: <69789157.5813313.1546545763506@mail.yahoo.com>
Content-Language: en-US
Content-ID: <755B34B9654DFC4C974E902ECDD0B816@intel.com>
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
To: "kamalkakri2017@yahoo.com" <kamalkakri2017@yahoo.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2019-01-03 at 20:02 +0000, Kamal Kakri wrote:
> My device has errors injected:
> # ndctl inject-error --status namespace2.0
> {
>   "badblocks":[
>     {
>       "block":35000,
>       "count":10
>     }
>   ]
> }
> 
> No problem reading from the bad offsets:
> # dd if=/dev/pmem2 of=/tmp/pmem_out bs=512 count=10 skip=35000
> 10+0 records in
> 10+0 records out
> 5120 bytes (5.1 kB) copied, 0.000108226 s, 47.3 MB/s

Did you ever read from /dev/pmem2 before injecting the error? There is
a possibility that the page is already present in the page cache and
the read gets serviced from there. You can set iflag=direct to ensure
you're reading from the device.

Other than that, there /should/ have been an MCE/sigbus in this case.
I'd check with your hardware/platform vendor to ensure machine checks
are available, and to ensure that injecting error does result in a
memory error/poison consumption by the CPU.

> 
> Kernel doesn't know of the badblocks yet so this should have resulted
> in sigbus for dd:
> # cat /sys/block/pmem2/badblocks
> #
> 
> I dont have mcelog daemon running but there is no error in
> /var/log/messages for pmem device. Is there some setting/config that
> I am missing ?
> 
> -KK
> 
> 
> On Thursday, January 3, 2019, 1:39:44 PM EST, Verma, Vishal L <
> vishal.l.verma@intel.com> wrote:
> 
> 
> 
> On Thu, 2019-01-03 at 17:13 +0000, Kamal Kakri wrote:
> > I am playing around with ndctl inject-error and have a few
> questions
> > around the behavior of the application when an error occurs.
> > After successfully injecting error with --no-notify, I am able to
> > read and write to the namespace device with no problems. For e.g.:
> > 
> > # ndctl inject-error --block=35000 --count=10 --no-notify
> > namespace2.0{
> >  "dev":"namespace2.0",
> >  "mode":"raw",
> >  "size":17179869184,
> >  "blockdev":"pmem2"
> > }
> > 
> > 
> > # dd  if=/dev/pmem2 of=/tmp/pmem-dump bs=512 count=10 seek=35000
> oflag=direct
> 
> I think you want 'skip=35000' here instead of seek= to read from that
> offset in the input.
> 
> > 10+0 records in
> > 10+0 records out
> > 5120 bytes (5.1 kB) copied, 0.0128088 s, 400 kB/s
> > 
> > # pwd
> > /sys/block/pmem2
> > # cat badblocks
> > #    ----------> empty badblock list
> 
> With --no-notify badblocks is expected to be empty, as ACPI will not
> notify the OS of new errors.
> 
> > 
> > 
> > [Question] Shouldn't my "dd" get a SIGBUS (default machine-check
> > handling) when it encounters badblocks that its not aware of (no-
> > notify) ?
> 
> Yes it should - I'd be curious to see if you still don't get a
> machine
> check with the seek/skip fix above.
> 
> 
> > 
> > 
> > I tried to do both reading and writing to badblocks and things just
> > work. If I scrub my nvdimm's (ndctl start-scrub) and the badblocks
> > show up in device badblock list (/sys/block/pmem/badblocks) but dd
> > can still work and writing the blocks clears out the badblock list:
> > # cat /sys/block/pmem2/badblocks35000 10
> > 
> > # dd if=/dev/zero of=/dev/pmem2 bs=512 count=10 seek=35000
> > oflag=direct
> > 10+0 records in
> > 10+0 records out
> 
> 
> Writing with O_DIRECT is the canonical way to clear errors - what you
> might see here is a corrected machine check notification in your
> kernel
> logs (CMCI), but that is just a notification that the platform has
> handled the error and no action is required.
> 
>     -Vishal
> 
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
