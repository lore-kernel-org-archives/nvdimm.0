Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B44EE1A1E04
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 11:02:55 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id l203so32720099oib.1
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 11:02:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DM2PR21MB0089A226724184C8539DA669CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
References: <1471547575-14748-1-git-send-email-mawilcox@linuxonhyperv.com>
 <CAPcyv4hXZ7V3Lh44zPw6Q_oGnjK_MOtPKNdeLbpHiRBVqBH3Qw@mail.gmail.com>
 <DM2PR21MB0089A226724184C8539DA669CB150@DM2PR21MB0089.namprd21.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 18 Aug 2016 11:02:54 -0700
Message-ID: <CAPcyv4gBLhgPAHwchctm-DL6hjpNqx4mMpJdyXthR1SxH+5dwA@mail.gmail.com>
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
Cc: X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Wilcox <mawilcox@linuxonhyperv.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 18, 2016 at 10:50 AM, Matthew Wilcox <mawilcox@microsoft.com> wrote:
> This is the memmap= kernel command line option.

The Hyper-V ACPI tables are growing NFIT support, or I believe that
work is already underway.  I'd rather not touch the Linux PCI core to
cover for the fact that Hyper-V disables one of the kernel's debug
command line options when there's a platform standard way to
communicate these resources.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
