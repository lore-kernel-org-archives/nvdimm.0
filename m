Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x230.google.com (mail-ua0-x230.google.com
 [IPv6:2607:f8b0:400c:c08::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E65721D49C80
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 17:01:19 -0700 (PDT)
Received: by mail-ua0-x230.google.com with SMTP id 80so13422884uas.0
 for <linux-nvdimm@lists.01.org>; Fri, 04 Aug 2017 17:03:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804181223.27CC.E1E9C6FF@jp.fujitsu.com>
References: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
 <20170804181223.27CC.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Aug 2017 17:03:31 -0700
Message-ID: <CAPcyv4i+vaOitbe5iEqvRG12XNhYiRU3O6_Kmn9v6vtN0Yrg=Q@mail.gmail.com>
Subject: Re: [RFC/Patch 4/5] libndctl Make interfaces to use Translate SPA
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 4, 2017 at 2:12 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> ndctl:libndctl Make interfaces to use Translate SPA.

A process note, please separate kernel patches and ndctl patches into
a different set. The expectation is that all the [PATCH 1/n] to [PATCH
n/n] should apply to the same project.

I have typically been marking my ndctl patches with a prefix like
[ndctl PATCH 1/n], where the kernel patches just say [PATCH].

>
> This patch makes 3 new interfaces :
>   - to ask bus has translate SPA feature.
>   - to call translate SPA.
>   - to find DIMM by SPA address.
>
>
> Note) I'm not sure how many buffer should be prepared, because
>       it depends on max # of mirroring way.
>       This patch assume maxmum # is 4 way.

I think it is ok for now to just reserve space for 1-DIMM. When / if
mirroring support materializes in the kernel you should then be able
to detect how many DIMMs are in the mirror set. Since mirror support
would require changes to the Namespace Label specification I think we
have time to circle back and fix up ndctl for the multiple DIMM per
Translate SPA request case.

Otherwise, the kernel will handle the case where the provided buffer
is too small and return an error.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
