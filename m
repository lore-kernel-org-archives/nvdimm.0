Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 373B92195406D
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 11:16:36 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH 4/5] acpi, nfit: support "map failed" dimms
Date: Mon, 17 Apr 2017 18:16:30 +0000
Message-ID: <1492452970.26622.5.camel@hpe.com>
References: <149218909065.3926.1234846095650907678.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149218911271.3926.4006907031326342869.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149218911271.3926.4006907031326342869.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <DDB63228FC81524FB1BF55DB6576229C@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2017-04-14 at 09:58 -0700, Dan Williams wrote:
> Stop requiring dimms be successfully mapped into a
> system-physical-address range. For provisioning and hardware
> remediation purposes the kernel should account for failed devices in
> sysfs. If possible it should still allow management commands to be
> sent to the device.
> 
> Reported-by: Toshi Kani <toshi.kani@hpe.com>
> Reported-by: Linda Knippers <linda.knippers@hpe.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Tested the "map failed" condition with HPE NVDIMMs. 

Tested-by: Toshi Kani <toshi.kani@hpe.com>

Thanks Dan!
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
