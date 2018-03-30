Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D31B224A9EA9
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 08:05:33 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH 0/4] Adding support to parse BERT for libnvdimm
Date: Fri, 30 Mar 2018 15:04:58 +0000
Message-ID: <1522422276.2693.268.camel@hpe.com>
References: <152236282506.35558.2067249639136170490.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152236282506.35558.2067249639136170490.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <611C14C1B0FB5C43A134DC8BADA16EC5@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "tony.luck@intel.com" <tony.luck@intel.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "lenb@kernel.org" <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-03-29 at 15:37 -0700, Dave Jiang wrote:
> The following series implements support for parsing of the BERT records
> and adding the error memory ranges to nvdimm badblocks in order for the
> kernel to avoid prevent the kernel from accessing those areas. And with
> the addition of this support, we can surface the nd regions instead of waiting
> for ARS to complete. So the ARS handling is reworked to run in the
> background and not block nd region registration.

Hi Dave,

I agree on the problem, and adding an ability to obtain pmem badblocks
records at boot-time without waiting for a new ARS scan to complete is a
good option for users.

However, I do not think using the BERT table is a good approach.  This
requires FW to report pmem badblocks records with a new interface in
addition to ARS records, which FW already implements for pmem.  ACPI 6.2
defines Start ARS with Flags Bit[1] set to report badblocks record
without starting a new ARS scan.  We set this bit after receiving a 0x81
notification at this point.

Can we use ARS with Flags bit[1] set at boot-time so that both OS and FW
can use the same ARS implementation?

Thanks,
-Toshi

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
