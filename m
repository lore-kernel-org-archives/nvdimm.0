Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7FF6F2194EB70
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 08:54:05 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id b3so11637288otp.4
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 08:54:05 -0800 (PST)
MIME-Version: 1.0
References: <20190214163422.15221-1-elliott@hpe.com>
In-Reply-To: <20190214163422.15221-1-elliott@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Feb 2019 08:53:52 -0800
Message-ID: <CAPcyv4hWy-w2UVYzi=8BNnm24Ts4A6QPU9qrDOVw9UP4OPsG5A@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/2] autoconf: Check for MAP_SHARED_VALIDATE
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
To: Robert Elliott <elliott@hpe.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 14, 2019 at 8:29 AM Robert Elliott <elliott@hpe.com> wrote:
>
> Some ndctl tests use two new mmap() flags named MAP_SHARED_VALIDATE
> and MAP_SYNC that were added by linux kernel-4.15, intended to be
> defined for applications by sys/mman.h. However, these do not exist
> unless the distro has glibc-2.28.
>
> In addition to the existing check for MAP_SYNC, check that
> MAP_SHARED_VALIDATE is provided.
>
> Fixes: 94679e6b78aa ("ndctl, test: check availability of MAP_SYNC for poison test")
> Signed-off-by: Robert Elliott <elliott@hpe.com>

Does this really fix anything? How can a system have MAP_SYNC without
MAP_SHARED_VALIDATE?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
