Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1299C2194EB65
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 16:37:56 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id x184so14774243oia.1
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 16:37:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <58F15A92.3000101@hpe.com>
References: <149220702552.36563.10552898152402020832.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149220706287.36563.2986440928438769021.stgit@dwillia2-desk3.amr.corp.intel.com>
 <58F15A92.3000101@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 16:37:54 -0700
Message-ID: <CAPcyv4iC6y__-QQszBCy3dv6AHs9L+4qsEp6waMU-oj=6EFJ3g@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/nvdimm: fix nfit_test shutdown
 crashes
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 14, 2017 at 4:26 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 04/14/2017 05:57 PM, Dan Williams wrote:
>> Keep the nfit_test instances alive until after nfit_test_teardown(), as
>> we may be doing resource lookups until the final un-registrations have
>> completed. This fixes crashes of the form.
>
> Sorry Dan, it didn't help in my case.

Ok, no worries, the search continues.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
