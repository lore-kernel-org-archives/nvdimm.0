Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69FE520958BE9
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 15:28:15 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id t75so8372529oie.3
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 15:30:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hsSUBHrYSXGiFN16vjHcPBb3Vng2c+H7g24-TnyWsjkg@mail.gmail.com>
References: <20170710183248.2417-1-willy@infradead.org>
 <CAPcyv4ioWUmiHbaGVcpxuK-j0JrcGk-_VcpR6yQtQMUwcRTRcQ@mail.gmail.com>
 <20170710203012.GB22476@bombadil.infradead.org>
 <CAPcyv4h7udHTuf78-_iLid68yMhBqTy9=b7GupJn3ZBLJoAWJA@mail.gmail.com>
 <20170712150401.GA12920@bombadil.infradead.org>
 <CAPcyv4h_=L=F9Gtf9NARH1vV4L0GBtRaUiSjZH-j5OeAdkV5Qg@mail.gmail.com>
 <AD0FC223-2642-42EB-ADF0-A61F5642DEEC@yahoo.com>
 <CAPcyv4jhGSo4RZtiXHKFNwzYwM_YcfoVZx0d4V=iLzdX622rKg@mail.gmail.com>
 <MWHPR21MB014312EE257DAA87046C3EA6A6B50@MWHPR21MB0143.namprd21.prod.outlook.com>
 <CAPcyv4hsSUBHrYSXGiFN16vjHcPBb3Vng2c+H7g24-TnyWsjkg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Aug 2017 15:30:58 -0700
Message-ID: <CAPcyv4iA1ObGd9miPSOCc=YRziAxWXhC9NSL_TDo97g2t=dp_Q@mail.gmail.com>
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
To: "Cheng-mean Liu (SOCCER)" <soccerl@microsoft.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matthew Wilcox <willy@infradead.org>, Matthew Wilcox <mawilcox@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 7, 2017 at 11:13 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Aug 7, 2017 at 11:09 AM, Cheng-mean Liu (SOCCER)
> <soccerl@microsoft.com> wrote:
>> Hi Dan:
>>
>>    I am wondering if failing on those unittests is still an issue for this minimum size requirement change.
>
> Yes, I just haven't had a chance to circle back and get this fixed up.
>
> You can reproduce by running:
>
>     make TESTS=dpa-alloc check
>
> ...in a checkout of the ndctl project: https://github.com/pmem/ndctl
>
> If you attempt that, note the required setup of the nfit_test modules
> documented in README.md in that same repository.

I have not had any time to fix up the unit test for this. Soccer, can
you take a look?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
