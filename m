Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa4.dell-outbound.iphmx.com (esa4.dell-outbound.iphmx.com
 [68.232.149.214])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E64221CEB12B
 for <linux-nvdimm@lists.01.org>; Tue,  7 Nov 2017 17:14:07 -0800 (PST)
From: <Lijun.Pan@dell.com>
Subject: RE: [PATCH] acpi/nfit: export read_only attribute of dimms
Date: Wed, 8 Nov 2017 01:18:04 +0000
Message-ID: <5db8706279db4e57b937916e908a571d@AUSX13MPS325.AMER.DELL.COM>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Dan Williams [mailto:dan.j.williams@intel.com]
> Sent: Monday, November 6, 2017 5:32 PM
> To: Pan, Lijun <Lijun_Pan@Dell.com>
> Cc: linux-nvdimm@lists.01.org
> Subject: Re: [PATCH] acpi/nfit: export read_only attribute of dimms
> 
> On Mon, Oct 30, 2017 at 1:41 PM, Lijun Pan <Lijun.Pan@dell.com> wrote:
> > Though flags attribute provides enough information about
> > the dimm, it is nice to export the read_only attribute if
> > bit3 of NVDIMM state flag is set.
> > If error is injected by BIOS, bit3 and bit1 are both set.
> > If DIMM is set to read-only by BIOS, bit3 is set.
> > Hence bit3 is good enough to tell whether the dimm is in
> > read-only mode or not.
> 
> Hmm, can you say about more about why we need this additional attribute?
> 
> Applications don't read and write the DIMM directly, they only
> interface with the DIMM through namespaces of a given region. The
> region device already has a 'read_only' attribute. See
> read_only_show() in drivers/nvdimm/region_devs.c.

redhat's cockpit can show the server's info like dimm, cpu, network,etc.
If the read_only attribute is exported, it is easy for the program to check.
I agree read_only status of the specific dimm can be retrieved via checking
bit3 of nvdimm state flag, but it is not explicit.
If 2 nvdimms are interleaved together, region's read_only only shows that
the region is read only, it does not show the 2 underlying physical dimms comprising
the region are read only.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
