Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C846A21CA3584
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 14:32:29 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id s3so14832325oia.0
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 14:33:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170612222511.22030-1-toshi.kani@hpe.com>
References: <20170612222511.22030-1-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Jun 2017 14:33:09 -0700
Message-ID: <CAPcyv4i03dU37tgqyRaMugGTqjagWeZ+WAtc7deJyZkkAbO9mA@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm, pmem: Add sysfs notifications to badblocks
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 12, 2017 at 3:25 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> Sysfs "badblocks" information may be updated during run-time that:
>  - MCE, SCI, and sysfs "scrub" may add new bad blocks
>  - Writes and ioctl() may clear bad blocks
>
> Add support to send sysfs notifications to sysfs "badblocks" file
> under region and pmem directories when their badblocks information
> is re-evaluated (but is not necessarily changed) during run-time.
>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Linda Knippers <linda.knippers@hpe.com>
> ---
> v2: Send notifications for the clearing case
> ---

This looks good to me, I've applied it, but I also want to extend the
ndctl unit tests to cover this mechanism.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
