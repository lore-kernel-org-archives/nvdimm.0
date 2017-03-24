Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E336803B1
 for <linux-nvdimm@lists.01.org>; Thu, 23 Mar 2017 17:34:53 -0700 (PDT)
Received: by mail-ot0-x233.google.com with SMTP id a5so6882630oth.1
 for <linux-nvdimm@lists.01.org>; Thu, 23 Mar 2017 17:34:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170323234751.1468-2-lijunpan2000@gmail.com>
References: <20170323234751.1468-1-lijunpan2000@gmail.com>
 <20170323234751.1468-2-lijunpan2000@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 23 Mar 2017 17:34:52 -0700
Message-ID: <CAPcyv4hnjWcuF6eB0YZSsNaRqTfKTNZxVg=3qK-vqiYSAYnGJg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ndctl: add msft-dsm command
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
To: Lijun Pan <lijunpan2000@gmail.com>
Cc: Lijun Pan <Lijun.Pan@dell.com>, Stuart Hayes <Stuart.Hayes@dell.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 23, 2017 at 4:47 PM, Lijun Pan <lijunpan2000@gmail.com> wrote:
> From: Lijun Pan <Lijun.Pan@dell.com>
>
> "ndctl msft-dsm" shows more generic NVDIMM info (except health)
> via calling _DSM functions.
>
> Cc: Stuart Hayes <Stuart.Hayes@dell.com>
> Signed-off-by: Lijun Pan <Lijun.Pan@dell.com>
> ---
>  Documentation/Makefile.am        |   1 +
>  Documentation/ndctl-msft-dsm.txt |  83 ++++++++++++++++++
>  builtin.h                        |   1 +
>  ndctl/Makefile.am                |   1 +
>  ndctl/builtin-msft-dsm.c         | 173 +++++++++++++++++++++++++++++++++++++
>  ndctl/ndctl.c                    |   1 +
>  ndctl/util/json-msft.c           | 179 +++++++++++++++++++++++++++++++++++++++
>  util/json.h                      |   1 +
>  8 files changed, 440 insertions(+)
>  create mode 100644 Documentation/ndctl-msft-dsm.txt
>  create mode 100644 ndctl/builtin-msft-dsm.c

Hi Lijun.

This is great, thank you for extending ndctl support for the Microsoft
family of DIMMs!

However, I'll give the same feedback I gave to the initial HPE support
implementation. As much as possible I want to avoid having DIMM family
specific enabling in the ndctl utility itself. It should all live
behind an abstraction provided by libndctl. That way other
applications that might use libndctl directly can get the benefit of
the enabling. The approach we took in the HPE case is to introduce
ndctl_smart_ops and merge the smart payloads into a common json
format. While the current enabling only exposes the SMART health
fields that are similar between Intel and HPE, it need not be that way
going forward and I'm open to having json fields that are DIMM-family
exclusive.

Have a look at extending the existing "ndctl list --dimms --health"
output with Microsoft-specific fields, but otherwise reuse existing
fields where they are common across other DIMM families.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
