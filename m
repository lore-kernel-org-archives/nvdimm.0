Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D06C211D6729
 for <linux-nvdimm@lists.01.org>; Wed, 27 Mar 2019 09:17:08 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v3 4/5] libndctl: Add a new dimm-op
 cmd_is_supported()
Date: Wed, 27 Mar 2019 16:17:05 +0000
Message-ID: <2e75cba1e02c5ed1701eaf397476a3256130e9b9.camel@intel.com>
References: <20190323042028.4310-1-decui@microsoft.com>
 <20190323042028.4310-5-decui@microsoft.com>
 <072e59f43a276b9daa93c131866fc26fabaad626.camel@intel.com>
 <PU1P153MB0169D3CF9E54018F22C5EB30BF5F0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169D3CF9E54018F22C5EB30BF5F0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-ID: <1EE971AB36F9F04DB65ED65662C0D1C0@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "decui@microsoft.com" <decui@microsoft.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dexuan.cui@gmail.com" <dexuan.cui@gmail.com>, "mikelley@microsoft.com" <mikelley@microsoft.com>
Cc: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2019-03-26 at 23:29 +0000, Dexuan Cui wrote:

> Here ndctl is checking if ND_CMD_SMART is supported in
> dimm->cmd_mask. For all the non-NVDIMM_FAMILY_INTEL families,
> the check is false, including the HPE1 and MSFT families.
> 
> So IMO we need this new dimm-ops to make "ndctl monitor" work
> for Hyper-V. I think the other non-INTEL families can't work with
> "ndctl monitor" either, but I don't have a hardward to test.
> 
Ah ok makes sense - I think with that I don't have any other comments -
I'll queue the patches for the pending branch.

Thanks,
	-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
