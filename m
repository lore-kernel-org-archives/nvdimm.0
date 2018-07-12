Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9149B202E5483
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jul 2018 08:43:24 -0700 (PDT)
Date: Thu, 12 Jul 2018 09:43:20 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [ndctl PATCH 1/2] ndctl, test: fix tests for the array vs object
 listing fix
Message-ID: <20180712154320.GA31326@linux.intel.com>
References: <20180711235644.26998-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180711235644.26998-1-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 11, 2018 at 05:56:43PM -0600, Vishal Verma wrote:
> The commit below updated json listings to always be arrays unless,
> potentially, --human was specified. As a fallout of the change, some
> unit tests that used jq to look for certain elements, or the json2var
> conversion broke in certain cases. Fix the jq query in sector-mode.sh,
> and fix json2var in test/common. The 'destructive' class of unit tests
> still need to be converted to the test/common scheme, and subsequently
> have their own local json2var instances. These will be fixed in a future
> commit by simply performing the test/common conversion.
> 
> Fixes: 72c46ab194d9 ("ndctl list: always output array without --human")
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Nice, thanks for the fixes.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
