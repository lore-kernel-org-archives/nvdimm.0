Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtprelay.hostedemail.com (smtprelay0222.hostedemail.com
 [216.40.44.222])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9197521A0480F
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 14:49:08 -0700 (PDT)
Message-ID: <1493416143.1873.13.camel@perches.com>
Subject: Re: [PATCH 0/3] dynamic_hex_dump cleanup
From: Joe Perches <joe@perches.com>
Date: Fri, 28 Apr 2017 14:49:03 -0700
In-Reply-To: <149341493336.35578.13631055553267152302.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149341493336.35578.13631055553267152302.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-acpi@vger.kernel.org, Jason Baron <jbaron@akamai.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2017-04-28 at 14:28 -0700, Dan Williams wrote:
> More than one driver has worked around the fact that
> print_hex_dump_debug() requires CONFIG_DYNAMIC_DEBUG=y to build.

No it doesn't.  builds work fine.  Output is restricted.

> Provide a dynamic_hex_dump() so that drivers that want the extra debugging to be
> turned off in the CONFIG_DYNAMIC_DEBUG=n can use dynamic_hex_dump()
> directly.

I think the concept is unnecessary
.
Just use print_hex_dump with KERN_DEBUG.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
