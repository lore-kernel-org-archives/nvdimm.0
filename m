Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B4E0A1A1F1D
 for <linux-nvdimm@lists.01.org>; Fri, 25 Mar 2016 13:27:07 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id d205so107877604oia.0
 for <linux-nvdimm@lists.01.org>; Fri, 25 Mar 2016 13:26:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458930183.24753.8.camel@intel.com>
References: <1458930183.24753.8.camel@intel.com>
Date: Fri, 25 Mar 2016 13:26:40 -0700
Message-ID: <CAPcyv4h-U6sxBWFz9EHb05OiC+XRXKK6QGx8qQcMFMHWV4xS8A@mail.gmail.com>
Subject: Re: [GIT PULL] libnvdimm, pmem: hook up memcpy_mcsafe
From: Dan Williams <dan.j.williams@intel.com>
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "mingo@kernel.org" <mingo@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 25, 2016 at 11:22 AM, Williams, Dan J
<dan.j.williams@intel.com> wrote:
> Hi Linus, please pull from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-for-next
>
> Now that mcsafe_memcpy() has landed, and the return value was been
> clarified in commit cbf8b5a2b649 "x86/mm, x86/mce: Fix return
> type/value for memcpy_mcsafe()", let's hook up its primary usage in the
> pmem driver.
>
> ---
>

The kbuild robot just reported an build failure on alpha, I'm investigating...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
