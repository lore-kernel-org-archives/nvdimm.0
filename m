Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C494211E2F08
 for <linux-nvdimm@lists.01.org>; Wed, 27 Mar 2019 09:57:06 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2] ndctl: add support to allow zero key for secure erase
Date: Wed, 27 Mar 2019 16:57:04 +0000
Message-ID: <b1b074c9278a626d1b749448e499007a253fb64d.camel@intel.com>
References: <155329809436.64360.3502200842888668766.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <155329809436.64360.3502200842888668766.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <6AA24E171011084EA048E18F9FCB9F15@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2019-03-22 at 16:42 -0700, Dave Jiang wrote:
> Providing a way for crypto-erase to pass in a key that is with 0's as
> payload.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
> v2:
> - Make zero key option explicit with -z parameter. Otherwise we will look
>   for a key. (Dan)
> 
>  Documentation/ndctl/ndctl-sanitize-dimm.txt |    4 ++++
>  ndctl/dimm.c                                |   16 +++++++++++++---
>  ndctl/util/keys.c                           |   12 +++++++-----
>  ndctl/util/keys.h                           |    1 +
>  4 files changed, 25 insertions(+), 8 deletions(-)

Looks good, applied with some commit message tweaking.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
