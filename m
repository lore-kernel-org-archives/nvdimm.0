Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-f196.google.com (mail-ot0-f196.google.com
 [74.125.82.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39B8F220D4BEC
 for <linux-nvdimm@lists.01.org>; Thu, 16 Nov 2017 06:25:18 -0800 (PST)
Received: by mail-ot0-f196.google.com with SMTP id s4so13420916ote.4
 for <linux-nvdimm@lists.01.org>; Thu, 16 Nov 2017 06:29:27 -0800 (PST)
Date: Thu, 16 Nov 2017 08:29:26 -0600
From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 2/3] libnvdimm: Add a device-tree interface
Message-ID: <20171116142926.cdvx2st72tnu7gi7@rob-hp-laptop>
References: <20171115175131.23631-1-oohall@gmail.com>
 <20171115175131.23631-2-oohall@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171115175131.23631-2-oohall@gmail.com>
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 16, 2017 at 04:51:30AM +1100, Oliver O'Halloran wrote:
> A fairly bare-bones set of device-tree bindings so libnvdimm can be used
> on powerpc and other device-tree based platforms.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
>  .../devicetree/bindings/nvdimm/nvdimm-bus.txt      |  69 +++++++

Also, please split bindings to a separate patch.

>  MAINTAINERS                                        |   8 +
>  drivers/nvdimm/Kconfig                             |  10 +
>  drivers/nvdimm/Makefile                            |   1 +
>  drivers/nvdimm/of_nvdimm.c                         | 202 +++++++++++++++++++++
>  5 files changed, 290 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/nvdimm/nvdimm-bus.txt
>  create mode 100644 drivers/nvdimm/of_nvdimm.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
