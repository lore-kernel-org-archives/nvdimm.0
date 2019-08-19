Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43B8320214B26
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 13:28:10 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl/dimm: Add support for separate
 security-frozen attribute
Date: Mon, 19 Aug 2019 20:26:43 +0000
Message-ID: <84f53b69683feec6d0cca8003522a51d22a53fbd.camel@intel.com>
References: <156583219134.2816070.2537582454969393648.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156583219134.2816070.2537582454969393648.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <9C9B37EAB23C6D43B4B56A961DEBA574@intel.com>
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

On Wed, 2019-08-14 at 18:23 -0700, Dan Williams wrote:
> Given the discovery that the original libnvdimm-security implementation
> is unable to communicate both the 'freeze' status and the 'lock' status
> simultaneously, newer kernels deploy a new 'frozen' attribute for this
> purpose.
> 
> Add a new api and update the tests for this new capability. The old test
> will fail on newer kernels, but hopefully there were no other
> applications depending on the 'security' attribute to communicate the
> 'freeze' status. It was likely only ever a debug / enumeration aid, not
> an application dependency.
> 
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Documentation/ndctl/ndctl-freeze-security.txt |    8 +++++---
>  ndctl/dimm.c                                  |    2 +-
>  ndctl/lib/dimm.c                              |   25 +++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym                        |    4 ++++
>  ndctl/libndctl.h                              |    1 +
>  test/security.sh                              |   18 ++++++++++++------
>  util/json.c                                   |    6 ++++++
>  7 files changed, 54 insertions(+), 10 deletions(-)
> 
[..]

> @@ -262,6 +267,7 @@ test_4_security_unlock
>  # not impact any key management testing via libkeyctl.
>  echo "Test 5, freeze security"
>  test_5_security_freeze
> +exit 1

Is this a leftover from local development/testing?
Otherwise the patch looks good to me.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
