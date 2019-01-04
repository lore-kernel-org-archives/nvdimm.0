Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
 [148.163.143.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE551211ADA58
 for <linux-nvdimm@lists.01.org>; Thu,  3 Jan 2019 18:04:07 -0800 (PST)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: Question on Error Injection
Date: Fri, 4 Jan 2019 02:04:03 +0000
Message-ID: <AT5PR8401MB11699659E6B9E6EF513248C1AB8E0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1351778734.5719210.1546535622423.ref@mail.yahoo.com>
 <1351778734.5719210.1546535622423@mail.yahoo.com>
 <873fd52419a7561f983927597dfb6fb613fc937e.camel@intel.com>
 <69789157.5813313.1546545763506@mail.yahoo.com>
 <199cc2d719c01c7099723e3c5f4aaa88060535e1.camel@intel.com>
 <AT5PR8401MB1169B2838F6DB72BC62B308DAB8D0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <985533328.5906467.1546556529562@mail.yahoo.com>
In-Reply-To: <985533328.5906467.1546556529562@mail.yahoo.com>
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
To: Kamal Kakri <kamalkakri2017@yahoo.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Kamal Kakri wrote:
> What do you mean by:
> 
> "The application itself shouldn't be terminated with SIGBUS - that's
> for an application doing memory accesses that cannot be resolved."
> 
> Can you elaborate with an example ?

DAX (direct access).  If the application uses mmap() of a file or
device so it can do loads directly from persistent memory addresses
and it tries to load from an address with an uncorrectable error,
the CPU cannot complete that instruction without causing data 
corruption.  There's no data value that means "this is bad data."
So, the only remedy to unhang that thread is for the kernel to send
a signal to the application; it might decide it doesn't really need
that data after all and do something else, or might terminate if it
doesn't know how to recover.

---
Robert Elliott, HPE Persistent Memory



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
