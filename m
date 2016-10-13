Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9E851A1E9E
 for <linux-nvdimm@lists.01.org>; Thu, 13 Oct 2016 09:01:47 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id m72so103774390oik.3
 for <linux-nvdimm@lists.01.org>; Thu, 13 Oct 2016 09:01:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476374061-9080-1-git-send-email-toshi.kani@hpe.com>
References: <1476374061-9080-1-git-send-email-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 13 Oct 2016 09:01:45 -0700
Message-ID: <CAPcyv4jdRhM8r1Ut4Ls4a4_PTroiXXZVcvruJ9TEj_SifenBCw@mail.gmail.com>
Subject: Re: [PATCH] pmem: report error on clear poison failure
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

On Thu, Oct 13, 2016 at 8:54 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> ACPI Clear Uncorrectable Error DSM function may fail or may be
> unsupported on a platform.  pmem_clear_poison() returns without
> clearing badblocks in such cases, which leads to a silent data
> corruption.
>
> Change pmem_do_bvec() and pmem_clear_poison() to return -EIO
> so that filesystem can log an error message.

What's the silent data corruption scenario?  If the clear poison fails
I'm assuming that the poison will still be notified on the next read.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
