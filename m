Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D51C2211B818D
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 13:07:33 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, rpm: Mark monitor.conf as a configuration
 file
Date: Wed, 16 Jan 2019 21:07:31 +0000
Message-ID: <a695e10b3ef2a2cba1d9c8da57fe84c402ac4c2d.camel@intel.com>
References: <154752453130.1624444.5980546681656304647.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154752453130.1624444.5980546681656304647.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <DFE1778A31F90E44BCE186B55F93A765@intel.com>
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


On Mon, 2019-01-14 at 19:55 -0800, Dan Williams wrote:
> In case a user has made local modifications to
> /etc/ndctl/monitor.conf,
> instrument the spec file to not clobber those changes.
> 
> Cc: Qi Fuli <qi.fuli@jp.fujitsu.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  ndctl.spec.in |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
Thanks, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
