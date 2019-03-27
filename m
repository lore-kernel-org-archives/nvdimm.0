Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECED8211E745D
 for <linux-nvdimm@lists.01.org>; Wed, 27 Mar 2019 10:09:54 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 1/2] ndctl: add warning about overwrite taking a long time
Date: Wed, 27 Mar 2019 17:09:47 +0000
Message-ID: <61e1e7e305884330d7832f1acd7363b8059a2da9.camel@intel.com>
References: <155329861947.65870.13816593912382889728.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <155329861947.65870.13816593912382889728.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <15803F42D70C654EBCB3FD691B6D35AD@intel.com>
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


On Fri, 2019-03-22 at 16:50 -0700, Dave Jiang wrote:
> Add warning note in man page that overwrite may take a long time to
> execute.
> 
> Suggested-by: Robert Elliot <elliott@hpe.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/ndctl-sanitize-dimm.txt |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Both patches look good, applied. Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
