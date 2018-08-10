Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37BFB210ED0F1
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 16:27:00 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCHv4] ndctl: Add 'list' verbose options
Date: Fri, 10 Aug 2018 23:25:42 +0000
Message-ID: <1533943540.6054.33.camel@intel.com>
References: <20180808224152.16781-1-keith.busch@intel.com>
In-Reply-To: <20180808224152.16781-1-keith.busch@intel.com>
Content-Language: en-US
Content-ID: <F0A244E489EBCE48B2552D7665E80691@intel.com>
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
To: "Busch, Keith" <keith.busch@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2018-08-08 at 16:41 -0600, Keith Busch wrote:
> The informational and miscellaneous flag options are becoming more
> numerous, and can be difficult to remember what can be listed. This
> patch adds a 'verbose' option that increases the detail listed by
> automatically enabling options and less essential information.
> 
> The verbose option can be repeated multiple times to increase the
> detail. There are currently three levels of verbose with output detail
> documented in the ndctl list manpage.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
> v3 -> v4:
> 
>   Added the verbose check for namespace numa node (per Ross)
> 
>  Documentation/ndctl/ndctl-list.txt | 14 ++++++++++++++
>  ndctl/list.c                       | 25 ++++++++++++++++++++++++-
>  ndctl/namespace.c                  |  2 +-
>  util/json.c                        | 32 ++++++++++++++++++++------
> ------
>  util/json.h                        |  1 +
>  5 files changed, 60 insertions(+), 14 deletions(-)

Looks good, applied
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
