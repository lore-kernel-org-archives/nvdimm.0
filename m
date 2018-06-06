Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 60ACA21163710
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 10:49:39 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id h79-v6so6032226oig.13
 for <linux-nvdimm@lists.01.org>; Wed, 06 Jun 2018 10:49:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180606164515.25677-1-ross.zwisler@linux.intel.com>
References: <20180606164515.25677-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Jun 2018 10:49:38 -0700
Message-ID: <CAPcyv4i0h2nFnkh7-a3ZLdRz569QUJov3Qkf3nzAmesqzNUSYg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] pmem, libnvdimm: complete REQ_FLUSH => REQ_PREFLUSH
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 6, 2018 at 9:45 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Complete the move from REQ_FLUSH to REQ_PREFLUSH that apparently started
> way back in v4.8.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Yup, long overdue. Applied for 4.18.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
