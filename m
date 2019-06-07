Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B48DE21290DE1
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jun 2019 10:39:49 -0700 (PDT)
Date: Fri, 7 Jun 2019 11:39:47 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] Documentation: nvdimm: Fix typo
Message-ID: <20190607113947.604b5ba0@lwn.net>
In-Reply-To: <20190509074049.12192-1-ruansy.fnst@cn.fujitsu.com>
References: <20190509023744.4936-1-ruansy.fnst@cn.fujitsu.com>
 <20190509074049.12192-1-ruansy.fnst@cn.fujitsu.com>
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
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 9 May 2019 15:40:49 +0800
Shiyang Ruan <ruansy.fnst@cn.fujitsu.com> wrote:

> Remove the extra 'we '.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> ---
>  Documentation/nvdimm/nvdimm.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/nvdimm/nvdimm.txt b/Documentation/nvdimm/nvdimm.txt
> index e894de69915a..1669f626b037 100644
> --- a/Documentation/nvdimm/nvdimm.txt
> +++ b/Documentation/nvdimm/nvdimm.txt
> @@ -284,8 +284,8 @@ A bus has a 1:1 relationship with an NFIT.  The current expectation for
>  ACPI based systems is that there is only ever one platform-global NFIT.
>  That said, it is trivial to register multiple NFITs, the specification
>  does not preclude it.  The infrastructure supports multiple busses and
> -we we use this capability to test multiple NFIT configurations in the
> -unit test.
> +we use this capability to test multiple NFIT configurations in the unit
> +test.

Applied, thanks.

I note this has languished for a bit; please don't hesitate to ping after
a week or so if you don't get a response on a patch posting.

jon
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
