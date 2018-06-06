Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63D7F21199555
 for <linux-nvdimm@lists.01.org>; Tue,  5 Jun 2018 19:07:13 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id q1-v6so5269426oth.13
 for <linux-nvdimm@lists.01.org>; Tue, 05 Jun 2018 19:07:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180606000034.12161-1-vishal.l.verma@intel.com>
References: <20180606000034.12161-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Jun 2018 19:07:10 -0700
Message-ID: <CAPcyv4g_1hNzqJA9g3c_TtXCaK72teY6QLH42xcwHx+dwfXb3w@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: add an api for getting ars_status flags
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Jacek Zloch <jacek.zloch@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 5, 2018 at 5:00 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The ARS status command defines a 'flags' field that wasn't being exposed
> via an API yet. Add a new ndctl_cmd_ars_get_flags() helper to retrieve
> this field.
>
> Reported-by: Jacek Zloch <jacek.zloch@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

I'm wondering if we should add a 'get' routine for each flag value as
to not expose the binary representation of the flags in case they ever
change. The hope is that if some other platform added their own
ARS-like facility that we would be able to reuse these routines and
translate between ACPI and a theoretical Open Firmware implementation,
for example.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
