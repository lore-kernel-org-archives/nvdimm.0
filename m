Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam02on0730.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe44::730])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E71A1A1EDE
 for <linux-nvdimm@lists.01.org>; Wed, 13 Jul 2016 12:47:44 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3] libnvdimm, pmem: use REQ_FUA, REQ_FLUSH for
 nvdimm_flush()
Date: Wed, 13 Jul 2016 19:46:56 +0000
Message-ID: <1468439194.8908.55.camel@hpe.com>
References: <146812112233.32932.5962348391051315694.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146836238217.14676.14154640837011539657.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146836238217.14676.14154640837011539657.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <8D9730C05FEFEA4F845150793B721D1F@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2016-07-12 at 15:26 -0700, Dan Williams wrote:
> Given that nvdimm_flush() has higher overhead than wmb_pmem() (pointer
> chasing through nd_region), and that we otherwise assume a platform has
> ADR capability when flush hints are not present, move nvdimm_flush() to
> REQ_FLUSH context.
> 
> Note that we still arrange for nvdimm_flush() to be called even in the
> ADR case. We need at least once wmb() fence to push buffered writes in
> the cpu out to the ADR protected domain.
> 
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

This looks good to me.

Reviewed-by: Toshi Kani <toshi.kani@hpe.com>

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
