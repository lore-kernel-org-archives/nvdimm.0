Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 770B71A1DE9
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 16:48:40 -0700 (PDT)
Date: Tue, 23 Aug 2016 17:48:03 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 0/3] ndctl: nvdimm notification tests
Message-ID: <20160823234802.GD7799@omniknight.lm.intel.com>
References: <147199350116.5587.2852255825958647760.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147199350116.5587.2852255825958647760.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 08/23, Dan Williams wrote:
> Add a new api, ndctl_dimm_get_health_eventfd(), and test that the kernel
> signals an event on that file descriptor after a smart-threshold
> command. 
> 
> Also, include a new gate for the SMART verification test to await when
> nfit_test is updated to emit the new v1.2 format of the SMART DSM
> payload.
> 
> ---
> 
> Dan Williams (3):
>       test: gate SMART payload verification on v4.9
>       ndctl: add ndctl_dimm_get_health_eventfd() api
>       test: validate ndctl_dimm_get_health_eventfd()
> 
> 
>  ndctl/lib/libndctl.c   |   11 +++++++++
>  ndctl/lib/libndctl.sym |    1 +
>  ndctl/libndctl.h.in    |    1 +
>  test/libndctl.c        |   61 ++++++++++++++++++++++++++++++++++++++++++++----
>  4 files changed, 69 insertions(+), 5 deletions(-)

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
