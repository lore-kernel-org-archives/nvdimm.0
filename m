Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 160ED2115C33D
 for <linux-nvdimm@lists.01.org>; Mon, 15 Oct 2018 15:59:53 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] test, dsm-fail: Cleanup leftover debug
Date: Mon, 15 Oct 2018 22:59:51 +0000
Message-ID: <116504592e5cbba92d1cb70f8d79a3704335a188.camel@intel.com>
References: <153940497765.1425803.8798243923079683083.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153940497765.1425803.8798243923079683083.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <9695D34C12E3A9428A1B2249DEEBE275@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-10-12 at 21:29 -0700, Dan Williams wrote:
> Prints from a debug session got committed, delete them.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  test/dsm-fail.c |   11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 

Looks good, applied.

> 
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
