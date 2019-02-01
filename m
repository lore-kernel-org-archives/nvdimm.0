Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 03437211BB8B7
 for <linux-nvdimm@lists.01.org>; Thu, 31 Jan 2019 16:47:11 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl: make command be the same as function names for
 security functions
Date: Fri, 1 Feb 2019 00:47:10 +0000
Message-ID: <0524b3c45f9fc9b55f916284da5d84d8dadbd662.camel@intel.com>
References: <154897711044.51306.8448938775272102034.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154897711044.51306.8448938775272102034.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <236454DE4C946747826849D82AA4E2CA@intel.com>
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
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2019-01-31 at 16:25 -0700, Dave Jiang wrote:
> Fix a few inconsistencies in the ndctl command name versus the function name.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/builtin.h |    6 +++---
>  ndctl/dimm.c    |   18 +++++++++---------
>  ndctl/ndctl.c   |    6 +++---
>  3 files changed, 15 insertions(+), 15 deletions(-)

Thanks for the fixups Dave, I'll fold both this and the documentation
update into the original series.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
