Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 10FDF2128D681
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jun 2019 08:52:54 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id s20so6782869otp.4
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jun 2019 08:52:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190621114518.56321-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20190621114518.56321-1-andriy.shevchenko@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Jun 2019 08:52:42 -0700
Message-ID: <CAPcyv4jtioTHQrSrZhopnKzPe81OYzBxpCeY1yCRLoxS8ULVzA@mail.gmail.com>
Subject: Re: [PATCH v1] libnvdimm, namespace: Drop uuid_t implementation detail
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 21, 2019 at 4:45 AM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> There is no need for caller to know how uuid_t type is constructed. Thus,
> whenever we use it the implementation details are not needed. Drop it for good.

Looks good, tests ok, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
