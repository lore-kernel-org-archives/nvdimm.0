Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF343226C7C38
 for <linux-nvdimm@lists.01.org>; Tue,  3 Apr 2018 08:33:59 -0700 (PDT)
Received: by mail-ot0-x233.google.com with SMTP id m22-v6so19820320otf.10
 for <linux-nvdimm@lists.01.org>; Tue, 03 Apr 2018 08:33:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f4c0ca57-3c4a-9805-a66a-6a61aec2b108@intel.com>
References: <152273076087.38372.4803377088477706610.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152273078779.38372.13062348829183334140.stgit@dwillia2-desk3.amr.corp.intel.com>
 <f4c0ca57-3c4a-9805-a66a-6a61aec2b108@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 3 Apr 2018 08:33:58 -0700
Message-ID: <CAPcyv4hbt-YNA_NA6Sic7Uzfg6EVwtPPyztFrGPjoYze9nfT9g@mail.gmail.com>
Subject: Re: [PATCH 5/6] nfit, address-range-scrub: rework and simplify ARS
 state machine
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 3, 2018 at 8:29 AM, Dave Jiang <dave.jiang@intel.com> wrote:
>
[..]
>> +               if (test_and_set_bit(ARS_REQ, &nfit_spa->ars_state))
>> +                       busy++;
>> +               else {
>> +                       if (flags == ND_ARS_RETURN_PREV_DATA)
>
>
> if (flags & ND_ARS_RETURN_PREV_DATA)?
>
> I think the spec allows other bits set in the flag byte.
>

True, and it might be better to pass in the kernel's ARS_SHORT flag
rather than the firmware interface value.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
