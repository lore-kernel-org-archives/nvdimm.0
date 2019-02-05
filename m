Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D7D6211BD5E8
 for <linux-nvdimm@lists.01.org>; Tue,  5 Feb 2019 10:32:10 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl: Fixes for building without keyutils
Date: Tue, 5 Feb 2019 18:32:09 +0000
Message-ID: <ca040de12ad6ff0a4df0d0aeb3b228ab7e69b721.camel@intel.com>
References: <20190205081652.29600-1-oohall@gmail.com>
In-Reply-To: <20190205081652.29600-1-oohall@gmail.com>
Content-Language: en-US
Content-ID: <805317B68985C14D9C6CE6FDBC2E8074@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "oohall@gmail.com" <oohall@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2019-02-05 at 19:16 +1100, Oliver O'Halloran wrote:
> Fixes for some build errors when ndctl is configured without
> keyutils support.
> 
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> Ran into this when making a test buildroot image. This is
> probably not going to be an issue if you're compiling on
> a real OS.
> ---
>  ndctl/ndctl.c     | 2 ++
>  ndctl/util/keys.h | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)

Thanks Oliver, applied.



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
