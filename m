Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7BC4021EA15C3
 for <linux-nvdimm@lists.01.org>; Thu,  5 Oct 2017 21:53:40 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id p126so27951295oih.9
 for <linux-nvdimm@lists.01.org>; Thu, 05 Oct 2017 21:57:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170922164440.4A35.E1E9C6FF@jp.fujitsu.com>
References: <20170922164440.4A35.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Oct 2017 21:57:02 -0700
Message-ID: <CAPcyv4iJ2c7850yCH8YJg6CZ5XmoKxpAwF7L0Fk75xrbRWLBvg@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] acpi nfit: make emulation of translate SPA on
 nfit_test
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

On Fri, Sep 22, 2017 at 12:44 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> Hello
>
> I made a v4 patch set to emulate translate SPA by nfit_test.ko module.
> If possible, please merge it.
>
> ----
> This patch set is to emulate translate SPA feature by nfit_test.ko.
>
> Certainly the nfit acpi driver supports translate SPA interface
> via ND_CMD_CALL. But nfit_test does not support it yet.
>
> To test translate SPA with nfit_test, this patch set is needed.
>
> ---
> Change log since v3 [1]:
>   - Rebase current libnvdimm-for-next branch.
>   - Fix over 80 character lines and too much tabs which is pointed
>     by Verma-san. (Thanks!)
>   - Since ndctl became to use the name "nfit_cmd" instead of "passthru",
>     "passthru" is renamed to "nfit_cmd".
>
> Change log since v2 [2]:
>  - Make private defintion just for nfit_test.
>     (NFIT_CMD_TRANSLATE_SPA, struct nd_cmd_translate_spa, and others)
>  - Check region by kobj.name instead of using is_nd_pmem().
>
>
> Change log since v1 [3]:
>  - Separate patch set of kenel from ndctl patch set.
>  - Change interface via ND_CMD_CALL.
>
> [1] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05863.html
> [2] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05582.html
> [3] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05287.html
>

Vishal, since you built on top of these can I add your Tested-by or Reviewed-by?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
