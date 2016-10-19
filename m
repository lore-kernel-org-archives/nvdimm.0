Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A776F1A1E6F
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 08:57:33 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id t73so35780836oie.1
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 08:57:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476886784-24644-3-git-send-email-toshi.kani@hpe.com>
References: <1476886784-24644-1-git-send-email-toshi.kani@hpe.com>
 <1476886784-24644-3-git-send-email-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 08:57:32 -0700
Message-ID: <CAPcyv4jjyCYkWHFBBooR9crVW_RMCJUZB4wsW95coaLcGRH42Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] libnvdimm: use generic iostat interfaces
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 19, 2016 at 7:19 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> nd_iostat_start() and nd_iostat_end() implement the same functionality
> that generic_start_io_acct() and generic_end_io_acct() already provide.
>
> Change nd_iostat_start() and nd_iostat_end() to call the generic iostat
> interfaces.  There is no change in the nd interfaces.
>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks, applied to for-4.10/libnvdimm.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
