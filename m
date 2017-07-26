Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22a.google.com (mail-yw0-x22a.google.com
 [IPv6:2607:f8b0:4002:c05::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C33C62095DBAB
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 12:44:00 -0700 (PDT)
Received: by mail-yw0-x22a.google.com with SMTP id l82so36035474ywc.2
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 12:46:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5978E3D3.5020307@hpe.com>
References: <5978E3D3.5020307@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 12:46:02 -0700
Message-ID: <CAPcyv4j1PgEqTeHH4eo0eLqidwEzwOetFfVrMw6BUMPiGjMaWw@mail.gmail.com>
Subject: Re: ndctl: 10G not a multiple of 2M?
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 26, 2017 at 11:47 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> Hi Dan,
>
> I was creating a namespace on a 4-way interleave set and got an error
> I didn't expect:
>
> $ sudo ndctl create-namespace -m sector -s 10G -n number2
>   Error: '--size=' must align to interleave-width: 4 and alignment: 2097152
>   did you intend --size=12G?
>
> I think there's a bug in validate_namespace_options().
>
> What's happening is that since I specified my size in units of G,
> the function wants the namespace to be 1G * 4 aligned rather than
> 2M * 4 aligned.  I suspect if I specified my size in M, it would
> have worked but I can't test that at the moment.
>
>>  size_align = max(units, size_align) * ways;
>
> Why is units part of the equation?

Good question, looks like a blatant thinko to me. I think we're good to just do:

    size_align *= ways;

However, I still want to make the recommendation in terms of the units
specified for --size, but that calculation should come after the base
alignment check.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
