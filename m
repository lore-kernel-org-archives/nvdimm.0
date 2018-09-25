Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C91E02114842B
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 14:10:00 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id y81-v6so2732640oia.6
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 14:10:00 -0700 (PDT)
MIME-Version: 1.0
References: <20180925204801.6182.73167.stgit@localhost.localdomain>
 <20180925205301.6182.58728.stgit@localhost.localdomain>
In-Reply-To: <20180925205301.6182.58728.stgit@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Sep 2018 14:09:48 -0700
Message-ID: <CAPcyv4jP6q3W67ZLCK6jvBuDcQ+F8mWSzYgr_hqUSYndVeeijQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] nvdimm: Hold reference on parent while scheduling
 async init
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
To: alexander.h.duyck@linux.intel.com
Cc: zwisler@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 25, 2018 at 1:53 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> Unlike asynchronous initialization in the core we have not yet associated
> the device with the parent, and as such the device doesn't hold a reference
> to the parent.
>
> In order to resolve that we should be holding a reference on the parent
> until the asynchronous initialization has completed.

Looks good to me. Thanks for splitting this out, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
