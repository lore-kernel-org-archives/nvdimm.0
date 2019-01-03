Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com
 [148.163.147.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 92EF02119EBF7
 for <linux-nvdimm@lists.01.org>; Thu,  3 Jan 2019 14:31:01 -0800 (PST)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: Question on Error Injection
Date: Thu, 3 Jan 2019 22:30:34 +0000
Message-ID: <AT5PR8401MB1169B2838F6DB72BC62B308DAB8D0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1351778734.5719210.1546535622423.ref@mail.yahoo.com>
 <1351778734.5719210.1546535622423@mail.yahoo.com>
 <873fd52419a7561f983927597dfb6fb613fc937e.camel@intel.com>
 <69789157.5813313.1546545763506@mail.yahoo.com>
 <199cc2d719c01c7099723e3c5f4aaa88060535e1.camel@intel.com>
In-Reply-To: <199cc2d719c01c7099723e3c5f4aaa88060535e1.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "kamalkakri2017@yahoo.com" <kamalkakri2017@yahoo.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm <linux-nvdimm-bounces@lists.01.org> On Behalf Of Verma,
> Vishal L
> Sent: Thursday, January 3, 2019 3:27 PM
> To: kamalkakri2017@yahoo.com; linux-nvdimm@lists.01.org
> Subject: Re: Question on Error Injection
> 
> 
> On Thu, 2019-01-03 at 20:02 +0000, Kamal Kakri wrote:
> > My device has errors injected:
> > # ndctl inject-error --status namespace2.0
> > {
> >   "badblocks":[
> >     {
> >       "block":35000,
> >       "count":10
> >     }
> >   ]
> > }
> >
> > No problem reading from the bad offsets:
> > # dd if=/dev/pmem2 of=/tmp/pmem_out bs=512 count=10 skip=35000
> > 10+0 records in
> > 10+0 records out
> > 5120 bytes (5.1 kB) copied, 0.000108226 s, 47.3 MB/s
> 
> Did you ever read from /dev/pmem2 before injecting the error? There is
> a possibility that the page is already present in the page cache and
> the read gets serviced from there. You can set iflag=direct to ensure
> you're reading from the device.
> 
> Other than that, there /should/ have been an MCE/sigbus in this case.
> I'd check with your hardware/platform vendor to ensure machine checks
> are available, and to ensure that injecting error does result in a
> memory error/poison consumption by the CPU.

An application like dd making traditional read() calls should see
them fail and report it this:
  dd: error reading '/dev/pmem2': Input/output error

The application itself shouldn't be terminated with SIGBUS - that's
for an application doing memory accesses that cannot be resolved.

---
Robert Elliott, HPE Persistent Memory

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
