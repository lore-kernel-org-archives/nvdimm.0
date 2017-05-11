Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6EB321A16E5D
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 15:34:53 -0700 (PDT)
Received: from G4W9119.americas.hpqcorp.net (g4w9119.houston.hp.com
 [16.210.20.214])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2354.austin.hpe.com (Postfix) with ESMTPS id 1AA1268
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 22:34:53 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [ndctl PATCH 4/4] ndctl, list: hide badblock_count by default
Date: Thu, 11 May 2017 22:33:51 +0000
Message-ID: <1494542018.30303.101.camel@hpe.com>
References: <149454009049.30857.6643219237076670086.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149454010604.30857.15214297566335127724.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149454010604.30857.15214297566335127724.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <F87C7207690DA444A97FFFFD46047A7F@NAMPRD84.PROD.OUTLOOK.COM>
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
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2017-05-11 at 15:01 -0700, Dan Williams wrote:
> In order to keep the default listing as compact as possible, hide
> badblock_count when it is zero.
> 
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Works as expected.  For the series:

Tested-by: Toshi Kani <toshi.kani@hpe.com>

Thanks!
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
