Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1CEAE21E977FD
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 18:42:01 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id n18so34465739oig.2
 for <linux-nvdimm@lists.01.org>; Tue, 05 Sep 2017 18:44:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170906102805.5B5C.E1E9C6FF@jp.fujitsu.com>
References: <CAPcyv4joECiCkd3+GJ8dWq-MfN=6dg3_+QQ5h6Qg-chgTjfsgQ@mail.gmail.com>
 <CAPcyv4j9UAWwXei9f49G_g-gwRvUvV7xsej1QrMr-XHq5bOP0g@mail.gmail.com>
 <20170906102805.5B5C.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Sep 2017 18:44:49 -0700
Message-ID: <CAPcyv4h8xxNdxAiorypr_qLe9h1_E7oNQzhBETJ=HB8pxVJ9Gw@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/5] ndctl: Introduce libndctl-nfit.h
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

On Tue, Sep 5, 2017 at 6:28 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:

> > Actually, since there's some other fixups needed on this series, I'll let
> > you resend this with the "attribute packed" statements added back in.
> I'll
> > follow on later with kernel and ndctl patches to remove the ones that are
> > not needed.
>
> Hmm, since I may still misunderstand yet, let me confirm it.
>
> In my next patch, "attribute packed" statements should be added
> to ALL of structures again.
>
> (that is, the followings should have "attribute packed" again.
>   - nd_cmd_translate_spa
>   - nd_cmd_ars_err_inj
>   - nd_cmd_ars_err_inj_clear
>   - nd_cmd_ars_err_inj_stat
> )
>
> Is this correct?
>

Yes.

Then I can address all the places where the cleanup can happen in one patch
rather than just doing this one change in isolation. For example, some of
the existing ones in ndctl.h need conversion, as well as some of the
payloads in hpe.h.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
