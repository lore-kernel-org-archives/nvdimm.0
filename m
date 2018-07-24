Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 296C621B02845
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 12:46:27 -0700 (PDT)
Date: Tue, 24 Jul 2018 13:46:29 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH] libnvdimm: fix NULL pointer dereference
Message-ID: <20180724194629.GA13685@localhost.localdomain>
References: <20180724134006.GA2775@embeddedor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180724134006.GA2775@embeddedor.com>
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
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Ross Zwisler <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 24, 2018 at 08:40:06AM -0500, Gustavo A. R. Silva wrote:
> ndd is being dereferenced before it is null checked, hence there is a
> potential null pointer dereference.
> 
> Fix this by moving the pointer dereference after ndd has been properly
> null checked at line 554: if (!ndd)

I'll fold this into v4 of the patch since Vishal found an issue when a
DIMM has multiple regions.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
