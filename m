Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0BA71A1DFB
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 12:12:19 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id c15so35295563oig.0
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 12:12:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DM2PR21MB00890E4AE41C24D9ACCEF56ACB150@DM2PR21MB0089.namprd21.prod.outlook.com>
References: <1471547575-14748-1-git-send-email-mawilcox@linuxonhyperv.com>
 <CAPcyv4hXZ7V3Lh44zPw6Q_oGnjK_MOtPKNdeLbpHiRBVqBH3Qw@mail.gmail.com>
 <DM2PR21MB0089A226724184C8539DA669CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4gBLhgPAHwchctm-DL6hjpNqx4mMpJdyXthR1SxH+5dwA@mail.gmail.com>
 <DM2PR21MB00898300C1E6F6761AC2ECD1CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4gYODEgH+CjdL1JssVhCHf+-tTrxUxVSjd2inPcrisEKQ@mail.gmail.com>
 <DM2PR21MB00890E4AE41C24D9ACCEF56ACB150@DM2PR21MB0089.namprd21.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 18 Aug 2016 12:12:10 -0700
Message-ID: <CAPcyv4hiUXFMQExYODQHD-gnAjDm27a2=Uh8N=HoNEiPoam5=A@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation
 2
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
To: Matthew Wilcox <mawilcox@microsoft.com>
Cc: X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 18, 2016 at 11:26 AM, Matthew Wilcox <mawilcox@microsoft.com> wrote:
> *Until* such a mechanism is in, I see no reason to not keep feature parity for all platforms.  This is the exact "You should boil the ocean" response that Arjan famously complained about at Kernel Summit a few years ago.

Feature parity for all platforms is the NFIT which Hyper-V is already
implementing.

Setting that aside, if we want to fix memmap= for the general case,
implementing a table like mBFT does not amount to ocean boiling in my
opinion.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
