Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F64F2096F344
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 14:25:32 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id s198-v6so19590452oih.11
 for <linux-nvdimm@lists.01.org>; Thu, 05 Jul 2018 14:25:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <df891d44-5b43-3aef-da9a-df63a4b46aae@gmail.com>
References: <20180705112304.2656-1-qi.fuli@jp.fujitsu.com>
 <df891d44-5b43-3aef-da9a-df63a4b46aae@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Jul 2018 14:25:31 -0700
Message-ID: <CAPcyv4iW-oZ+BGzfb8L5pB2+BvD6fG6jB5ibSOt5a9XeuazxhA@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, test: add a new unit test for monitor
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
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 5, 2018 at 2:06 PM, Masayoshi Mizuma <msys.mizuma@gmail.com> wrote:
> Hi Qi,
>
> I tried this test after I applied your latest monitor patches [1].
> I found some points. Could you check the following?
>
> [1] https://lists.01.org/pipermail/linux-nvdimm/2018-June/016562.html
>
> On 07/05/2018 07:23 AM, QI Fuli wrote:
[..]
> Is this "nmem0:nmem1:nmem2:nmem3"?
> Or why don't you getting the dimms by ndctl list command instead of hard-cording?

Yes, this is needed. The test fails for me because I have an e820
defined bus and a typical ACPI NFIT bus along with the nfit_test buses
on my test system.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
