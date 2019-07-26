Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA506212B5F06
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jul 2019 20:45:59 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id s184so39298986oie.9
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jul 2019 20:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190724215741.18556-1-vishal.l.verma@intel.com>
 <20190724215741.18556-14-vishal.l.verma@intel.com>
In-Reply-To: <20190724215741.18556-14-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jul 2019 20:43:20 -0700
Message-ID: <CAPcyv4hpxYM4z45-eUhjUA-USq6p+d4GQZ=D1wt4H=_=4rCUCQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v7 13/13] test: Add a unit test for
 daxctl-reconfigure-device and friends
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 24, 2019 at 2:58 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a new unit test to test dax device reconfiguration and memory
> operations. This teaches test/common about daxctl, and adds an ACPI.NFIT
> bus variable. Since we have to operate on the ACPI.NFIT bus, the test is
> marked as destructive.
>

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
