Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22a.google.com (mail-yb0-x22a.google.com
 [IPv6:2607:f8b0:4002:c09::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 66A2D21D0B663
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jul 2017 17:12:03 -0700 (PDT)
Received: by mail-yb0-x22a.google.com with SMTP id f194so27943428yba.3
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jul 2017 17:13:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AD0FC223-2642-42EB-ADF0-A61F5642DEEC@yahoo.com>
References: <20170710183248.2417-1-willy@infradead.org>
 <CAPcyv4ioWUmiHbaGVcpxuK-j0JrcGk-_VcpR6yQtQMUwcRTRcQ@mail.gmail.com>
 <20170710203012.GB22476@bombadil.infradead.org>
 <CAPcyv4h7udHTuf78-_iLid68yMhBqTy9=b7GupJn3ZBLJoAWJA@mail.gmail.com>
 <20170712150401.GA12920@bombadil.infradead.org>
 <CAPcyv4h_=L=F9Gtf9NARH1vV4L0GBtRaUiSjZH-j5OeAdkV5Qg@mail.gmail.com>
 <AD0FC223-2642-42EB-ADF0-A61F5642DEEC@yahoo.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 13 Jul 2017 17:13:50 -0700
Message-ID: <CAPcyv4jhGSo4RZtiXHKFNwzYwM_YcfoVZx0d4V=iLzdX622rKg@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: Remove minimum size requirement
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
To: Socer Liu <soccer_liu@yahoo.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matthew Wilcox <mawilcox@microsoft.com>, Matthew Wilcox <willy@infradead.org>, Cheng-mean Liu <soccerl@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 12, 2017 at 10:49 PM, Socer Liu <soccer_liu@yahoo.com> wrote:
> Thanks great to hear.
>
> Dan,
>    Could you share the patch you ran though the unittests?

That patch is still failing the unit tests, so I have some more work
to do to fix the test to understand the new minimum.

> I would like to give the new patch a try in my scenario.

I'll share it when I have the tests running again.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
