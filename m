Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D9292034EE0F
 for <linux-nvdimm@lists.01.org>; Mon,  6 Nov 2017 18:47:02 -0800 (PST)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] acpi/nfit: export read_only attribute of dimms
Date: Tue, 7 Nov 2017 02:50:58 +0000
Message-ID: <AT5PR84MB008261397FEA00F43F7DCEC6AB510@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <20171030204127.4779-1-Lijun.Pan@dell.com>
 <CAPcyv4gxRuMBb2cCnONg5Hq2PgzirHwOULjOfspOezkeBrmfGw@mail.gmail.com>
In-Reply-To: <CAPcyv4gxRuMBb2cCnONg5Hq2PgzirHwOULjOfspOezkeBrmfGw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Lijun Pan <Lijun.Pan@dell.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On
> Behalf Of Dan Williams
> Sent: Monday, November 06, 2017 5:32 PM
> To: Lijun Pan <Lijun.Pan@dell.com>
> Cc: linux-nvdimm@lists.01.org
> Subject: Re: [PATCH] acpi/nfit: export read_only attribute of dimms
> 
> On Mon, Oct 30, 2017 at 1:41 PM, Lijun Pan <Lijun.Pan@dell.com>
> wrote:
> > Though flags attribute provides enough information about
> > the dimm, it is nice to export the read_only attribute if
> > bit3 of NVDIMM state flag is set.
> > If error is injected by BIOS, bit3 and bit1 are both set.
> > If DIMM is set to read-only by BIOS, bit3 is set.
> > Hence bit3 is good enough to tell whether the dimm is in
> > read-only mode or not.
> 
> Hmm, can you say about more about why we need this additional
> attribute?
> 
> Applications don't read and write the DIMM directly, they only
> interface with the DIMM through namespaces of a given region. The
> region device already has a 'read_only' attribute. See
> read_only_show() in drivers/nvdimm/region_devs.c.

A few more points:

1. The full NVDIMM State Flags value is already reported for
the nmem device, so reporting bit 3 separately as "read_only"
would be redundant.

2. For NVDIMM-Ns, the system is not preventing writing to memory;
system firmware is just warning that any writes will not be
persistent across power loss.

3. Considering the different layers:
* the pmem and btt drivers blocks writes themselves, so it makes
sense for them to report ro at the pmem device layer.
* the nmem layer doesn't block writes, so shouldn't report anything
about them being restricted.
* the region layer doesn't block writes, so shouldn't report anything
about them being restricted.
* the region layer does need to pass along the NVDIMM state flags
to the pmem and btt drivers; read_only might not be the best name
as a user-visible attribute with that information.

Some driver or software might find temporarily writing to those
locations in-place would be useful (e.g. run fsck before copying
the repaired filesystem content to another storage device), so we
shouldn't cut them off unnecessarily.

4. The ACPI definition is a bit open:
"Bit [3] set to 1 indicates that the NVDIMM containing the NVDIMM
region is not able to accept persistent writes. For an
energy-source backed NVDIMM device, Bit [3] is set if it is not
armed or the previous ERASE operation did not complete."

Perhaps NFIT needs to distinguish between these situations:
* writes result in errors
  - this would require special support from the CPU, memory
    controller, and memory bus
* writes are accepted but ignored
  - e.g., an NVDIMM-P type device made from SCM
  - ignored writes create cache coherency problems
* writes are accepted, but not persistent across power loss
  - e.g., an NVDIMM-N

---
Robert Elliott, HPE Persistent Memory





_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
