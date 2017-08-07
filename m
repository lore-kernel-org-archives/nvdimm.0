Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 45BF021DF37A6
 for <linux-nvdimm@lists.01.org>; Mon,  7 Aug 2017 11:31:54 -0700 (PDT)
Date: Mon, 7 Aug 2017 19:34:12 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/6] arm64 pmem support
Message-ID: <20170807183411.GD29632@arm.com>
References: <cover.1500397441.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1500397441.git.robin.murphy@arm.com>
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
To: Robin Murphy <robin.murphy@arm.com>
Cc: mark.rutland@arm.com, linux-nvdimm@lists.01.org, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 25, 2017 at 11:55:37AM +0100, Robin Murphy wrote:
> With the latest updates to the pmem API, the arch code contribution
> becomes very straightforward to wire up - I think there's about as
> much code here to just cope with the existence of our new instruction
> as there is to actually make use of it. I don't have access to any
> NVDIMMs nor suitable hardware to put them in, so this is written purely
> to spec - the extent of testing has been the feature detection on a
> v8.2 Fast Model vs. v8.0 systems.
> 
> Patch #1 could go in as a fix ahead of the rest; it just needs to come
> before patch #5 to prevent that blowing up the build.

Modulo my two comments:

Reviewed-by: Will Deacon <will.deacon@arm.com>

Will
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
