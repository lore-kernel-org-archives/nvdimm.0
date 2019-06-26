Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E608B212AAB7C
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jun 2019 14:43:45 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [RESEND PATCH] nvdimm: fix some compilation warnings
Date: Wed, 26 Jun 2019 21:43:43 +0000
Message-ID: <b56d99494ce47a4d4359edce8c9c96443d618cf1.camel@intel.com>
References: <20190514150735.39625-1-cai@lca.pw>
 <CAPcyv4gGwyPf0j4rXRM3JjsjGSHB6bGdZfwg+v2y8NQ6hNVK8g@mail.gmail.com>
 <7ba8164b60be4e41707559ed6623f9462c942735.camel@intel.com>
 <CAPcyv4gLr_WrNOg58C5tfpZTp2wso1C=kHGDkMvH4+sGniLQMQ@mail.gmail.com>
 <cd6db786ff5758914c77add4d7a9391886038c84.camel@intel.com>
 <1561582828.5154.83.camel@lca.pw>
In-Reply-To: <1561582828.5154.83.camel@lca.pw>
Content-Language: en-US
Content-ID: <5EBE85328DA1AA43A3923046448A4135@intel.com>
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
To: "cai@lca.pw" <cai@lca.pw>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-06-26 at 17:00 -0400, Qian Cai wrote:
> 
> Verma, are you still working on this? I can still see this warning in the latest
> linux-next.
> 
> drivers/nvdimm/btt.c: In function 'btt_read_pg':
> drivers/nvdimm/btt.c:1272:8: warning: variable 'rc' set but not used
> [-Wunused-but-set-variable]
> 
Sorry, this fell off the list. I'll take a look soon, but in the
meanwhile, if a patch were to appear, I'd be happy to review it :) 
(i.e. feel free to take a shot at it).

Thanks,
-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
