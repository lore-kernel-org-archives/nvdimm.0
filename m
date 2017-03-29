Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22e.google.com (mail-ot0-x22e.google.com
 [IPv6:2607:f8b0:4003:c0f::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9706A2050AAF6
 for <linux-nvdimm@lists.01.org>; Wed, 29 Mar 2017 11:13:03 -0700 (PDT)
Received: by mail-ot0-x22e.google.com with SMTP id a5so15941187oth.1
 for <linux-nvdimm@lists.01.org>; Wed, 29 Mar 2017 11:13:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170326201753.1522-1-lijunpan2000@gmail.com>
References: <20170326201753.1522-1-lijunpan2000@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Mar 2017 11:13:02 -0700
Message-ID: <CAPcyv4g623k8L11ong4yccSmFFPmtKyieFSdKS0n3KGqGkYRYw@mail.gmail.com>
Subject: Re: [PATCH v2] libndctl: add support for the MSFT family of DSM
 functions
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

On Sun, Mar 26, 2017 at 1:17 PM, Lijun Pan <lijunpan2000@gmail.com> wrote:
> From: Lijun Pan <Lijun.Pan@dell.com>
>
> This patch retrieves the health data from NVDIMM-N via
> the MSFT _DSM function[1], following JESD245A[2] standards.
> Now 'ndctl list --dimms --health --idle' could work
> on MSFT type NVDIMM-N, but limited to health_state,
> temperature_celsius, and life_used_percentage.

Looks good, can you add sample output of:

    ndctl list --dimms --health --idle

...so users know what to expect. With that change and addressing
Linda's comment about the temperature multiplier I think we're good to
go.

Also, if you want to add Microsoft-only health attributes we'll need
to add new "valid" flags beyond the current ND_SMART_*_VALID set. If
this goes beyond the current 32 "valid" flags that that
ndctl_cmd_smart_get_flags() returns we might need a new
ndctl_cmd_smart_get_flags2() call that returns an arbitrary bitmap of
valid flags.

We'd also need to move those definitions to an ndctl local header.
Currently where they are defined now in ndctl.h is owned by the
kernel. We can cross this bridge later in a follow-on patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
